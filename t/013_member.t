use strict;
use warnings;
use utf8;

BEGIN {
    $ENV{PLACK_ENV} = 'test';
};

use Test::More;
use Tomalino::M::Member;

my $row = Tomalino::M::Member->create(name => 'ytnobody'));
isa_ok $row, 'HASH';

done_testing;
