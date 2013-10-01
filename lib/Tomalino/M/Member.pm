package Tomalino::M::Member;
use strict;
use warnings;
use utf8;
use Tomalino::DB;

sub create {
    my ($class, %opts) = @_;
    my $name = $opts{name};
    my $time = time();
    my $ok = Tomalino::DB->query(
        'INSERT INTO member ("name", "created_at", "updated_at") VALUES (?, ?, ?)',
        $name, $time, $time
    );
    return Tomalino::DB->search_row('SELECT * FROM member WHERE name=?', ($name));
}

sub fetch {
    my ($class, $id) = @_;
    my $member = Tomalino::DB->search_row('SELECT * FROM member WHERE id=?', $id);
    return $member;
}

1;
