use strict;
use warnings;
use utf8;
use t::Util;

use Test::More;
use Tomalino::M::Member;
use Tomalino::M::Event;

my $member = Tomalino::M::Member->create(name => 'ytnobody');
isa_ok $member, 'HASH';

my $event = Tomalino::M::Event->create(
    name        => 'Underground Perl Beginners',
    owner       => $member->{id},
    begin_time  => '2013-11-13 19:00',
    end_time    => '2013-11-13 21:00',
    location    => 'ボーノ相模大野',
    description => 'UndergroundなPerl Beginnersです。',
);

$member = Tomalino::M::Member->fetch($member->{id});
is_deeply( $member->{events}, [$event->{id}] );

done_testing;
