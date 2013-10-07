package Tomalino::M::Member;
use strict;
use warnings;
use utf8;
use Tomalino::DB;
use Tomalino::M::Event;

sub create {
    my ($class, %opts) = @_;
    my $name = $opts{name};
    my $time = time();
    my $ok = Tomalino::DB->query(
        'INSERT INTO member ("name", "created_at", "updated_at") VALUES (?, ?, ?)',
        $name, $time, $time
    );
    return Tomalino::DB->select_row('SELECT * FROM member WHERE name=?', ($name));
}

sub join_event {
    my ($class, %opts) = @_;
    my $event_id = $opts{event_id};
    my $member_id = $opts{member_id};
    if ( Tomalino::M::Event->fetch($event_id) ) {
        Tomalino::DB->query(
            'INSERT INTO event_member ("event_id", "member_id", "created_at") VALUES (?, ?, ?)',
            $event_id, $member_id, time()
        );
    }
}

sub cancel_event {
    my ($class, %opts) = @_;
    my $event_id = $opts{event_id};
    my $member_id = $opts{member_id};
    if ( Tomalino::M::Event->fetch($event_id) ) {
        Tomalino::DB->query(
            'UPDATE event_member SET canceled = ? WHERE event_id=? AND member_id=?',
            time(), $event_id, $member_id,
        );
    }
}

sub fetch {
    my ($class, $id) = @_;
    my $member = Tomalino::DB->select_row('SELECT * FROM member WHERE id=?', $id);
    my $events = Tomalino::DB->select_all('SELECT event_id FROM event_member WHERE member_id=?', $id);
    $member->{events} = $events ? [ map {$_->{event_id}} @$events ] : [];
    return $member;
}

sub delete {
    my ($class, $id) = @_;
    do {
        my $txn = Tomalino::DB->txn_scope;
        Tomalino::DB->query('DELETE FROM event_member WHERE member_id=?', $id);
        Tomalino::DB->query('DELETE FROM member WHERE id=?', $id);
        $txn->commit;
    };
}

sub retrieve_member_service {
    my ($class, %opts) = @_;
    my $provider = $opts{provider};
    my $account  = $opts{account};
    Tomalino::DB->select_row(
        'SELECT * FROM member_service WHERE service=? AND account_on_service=?',
        $provider, $account
    );
}

sub fetch_or_create {
    my ($class, %opts) = @_;
    my $provider = $opts{provider};
    my $account  = $opts{account};
    my $service  = $class->retrieve_member_service(%opts);
    return $class->fetch($service->{member_id}) if $service;
    do {
        my $txn    = Tomalino::DB->txn_scope;
        my $member = $class->create(name => $account);
        if ($member) {
            my $now = time;
            Tomalino::DB->query(
                'INSERT INTO member_service (member_id, service, account_on_service, created_at, updated_at) VALUES (?, ?, ?, ?, ?)',
                $member->{id}, $provider, $account, $now, $now
            );
            if ( $class->retrieve_member_service(%opts) ) {
                $txn->commit;
                $member;
            }
        }
    };
}

1;
