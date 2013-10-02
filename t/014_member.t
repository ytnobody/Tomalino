use strict;
use warnings;
use utf8;

BEGIN {
    $ENV{PLACK_ENV} = 'test';
};

use Test::More;
use Tomalino::M::Member;
use Tomalino::M::Event;

my $event = Tomalino::M::Event->create(
    name        => 'Underground Perl Beginners',
    begin_time  => '2013-11-13 19:00',
    end_time    => '2013-11-13 21:00',
    location    => 'ボーノ相模大野',
    description => 'UndergroundなPerl Beginnersです。',
);

my $row = Tomalino::M::Member->create(name => 'ytnobody');
isa_ok $row, 'HASH';

Tomalino::M::Member->join_event(
    member_id => $row->{id}, 
    event_id  => $event->{id},
);

diag explain(Tomalino::M::Member->fetch($row->{id}));

done_testing;
