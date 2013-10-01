use strict;
use warnings;

BEGIN {
    $ENV{PLACK_ENV} = 'test';
}

use Test::More;
use Tomalino::DB;

my $dbh = Tomalino::DB->dbh;
isa_ok $dbh,'DBIx::Sunny::db';

ok( Tomalino::DB->query('INSERT INTO member ("name") VALUES (?)', 'ytnobody') );

my $member = Tomalino::DB->select_row('SELECT * FROM member WHERE name=?', 'ytnobody');

isa_ok $member, 'HASH';
is $member->{name}, 'ytnobody';

ok( Tomalino::DB->query('DELETE from member WHERE name=?', 'ytnobody') );

done_testing;
