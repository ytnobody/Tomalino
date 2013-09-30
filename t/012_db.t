use strict;
use warnings;

BEGIN {
    $ENV{PLACK_ENV} = 'test';
}

use Test::More;
use Tomalino::DB;

my $dbh = Tomalino::DB->dbh;
isa_ok $dbh,'DBIx::Sunny::db';

ok( Tomalino::DB->do('INSERT INTO member ("name") VALUES ("ytnobody")') );

diag explain( Tomalino::DB->select_row('SELECT * FROM member WHERE name=?', 'ytnobody') );

done_testing;
