package Tomalino::M::Event;
use strict;
use warnings;
use utf8;
use Tomalino::DB;
use Time::Piece;

sub create {
    my ($class, %opts) = @_;
    $opts{created_at} = $opts{updated_at} = time;
    $opts{$_} = Time::Piece->strptime($opts{$_}, '%Y-%m-%d %H:%M:%S')->epoch for qw/begin_time end_time/;
    my @keys  = keys %opts;
    my $cols  = join(',', map { '"'. $_ . '"' } @keys);
    my $binds = join(',', map { '?' } @keys);
    my @vals  = map { $opts{$_} } @keys;
    my $query = sprintf('INSERT INTO event (%s) VALUES (%s)', $cols, $binds);
    my $event;
    do {
        my $txn = Tomalino::DB->txn_scope;
        Tomalino::DB->query($query, @vals);
        my $where = join(' AND ', map { sprintf('%s=?', $_) } @keys);
        $event = Tomalino::DB->select_row(sprintf('SELECT * FROM event WHERE %s', $where), @vals);
        Tomalino::DB->query(
            'INSERT INTO event_member (event_id, member_id) VALUES (?,?)', 
            $event->{id}, $event->{owner}
        );
        $txn->commit;
        $event->{members} = [$event->{owners}];
    };
    return $event;
}

sub fetch {
    my ($class, $id) = @_;
    my $event = Tomalino::DB->select_row('SELECT * FROM event WHERE id=?', $id);
    $event->{members} = Tomalino::DB->select_all('SELECT * FROM event_member WHERE event_id=?', $id) || [];
    return $event;
}

sub delete {
    my ($class, $id) = @_;
    Tomalino::DB->query('DELETE FROM event WHERE id=?', $id);
}

sub update {
    my ($class, %opts) = @_;
    my $id = delete $opts{id};
    my @keys = keys %opts;
    my $set  = join(',', map {"$_ = ?"} @keys);
    my @bind = map {$opts{$_}} @keys;
    Tomalino::DB->query(
        sprintf('UPDATE event SET %s WHERE id=?', $set),
        @bind, $id
    );
}

sub search_by_date_range {
    my ($class, %opts) = @_;
    my $begin_time = Time::Piece->strptime($opts{begin_time}, '%Y-%m-%d %H:%M:%S')->epoch;
    my $end_time   = Time::Piece->strptime($opts{end_time}, '%Y-%m-%d %H:%M:%S')->epoch;
    my $events = Tomalino::DB->select_all(
        'SELECT * FROM event WHERE begin_time BETWEEN ? AND ?',
        $begin_time, $end_time
    );
    return [] unless $events;
    my $members = Tomalino::DB->select_all(
        sprintf('SELECT * FROM event_member WHERE event_id IN (%s)', join(',', map {'?'} @$events)),
        map {$_->{id}} @$events
    );
    for my $event (@$events) {
        $event->{members} = [ map {$_->{id}} grep {$_->{event_id} == $event->{id}} @$members ];
    }
    return $events;
}

1;
