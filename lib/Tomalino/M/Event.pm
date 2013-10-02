package Tomalino::M::Event;
use strict;
use warnings;
use utf8;
use Tomalino::DB;
use Time::Piece;

sub create {
    my ($class, %opts) = @_;
    $opts{created_at} = $opts{updated_at} = time;
    $opts{$_} = Time::Piece->strptime($opts{$_}, '%Y-%m-%d %H:%M:%S') for qw/begin_time end_time/;
    my @keys  = keys %opts;
    my $cols  = join(',', map { '"'. $_ . '"' } @keys);
    my $binds = join(',', map { '?' } @keys);
    my @vals  = map { $opts{$_} } @keys;
    my $query = sprintf('INSERT INTO event (%s) VALUES (%s)', $cols, $binds);
    if ( Tomalino::DB->query($query, @vals) ) {
        my $where = join(' AND ', map { sprintf('%s=?', $_) } @keys);
        Tomalino::DB->select_row(sprintf('SELECT * FROM event WHERE %s', $where), @vals);
    }
}

sub fetch {
    my ($class, $id) = @_;
    Tomalino::DB->select_row('SELECT * FROM event WHERE id=?', $id);
}

sub delete {
    my ($class, $id) = @_;
    Tomalino::DB->query('DELETE FROM event WHERE id=?', $id);
}

1;
