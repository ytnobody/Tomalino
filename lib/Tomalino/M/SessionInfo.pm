package Tomalino::M::SessionInfo;
use strict;
use warnings;
use Tomalino::DB;
use Tomalino::M::Member;

sub set {
    my ($class, %opts) = @_;
    $opts{updated_at} = time;
    my @keys  = keys %opts;
    my $member = Tomalino::M::Member->fetch_or_create(
        provider => $opts{provider},
        account  => $opts{account},
    );
    Tomalino::DB->query(
        'REPLACE INTO session_info (session_id, member_id, updated_at) VALUES (?, ?, ?)',
        $opts{session_id}, $member->{id}, time
    );
}

sub fetch {
    my ($class, $session_id) = @_;
    Tomalino::DB->select_row('SELECT * FROM session_info WHERE session_id=?', $session_id);
}

sub delete {
    my ($class, $session_id) = @_;
    Tomalino::DB->query('DELETE FROM session_info WHERE session_id=?', $session_id);
}

1;
