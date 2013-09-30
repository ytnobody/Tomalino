use strict;
use warnings;
use Test::More;
use Tomalino::Config;

my $config = config(env => 'test');
isa_ok $config, 'HASH';
isa_ok $config->{DB}, 'ARRAY';

done_testing;
