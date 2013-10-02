use strict;
use warnings;
use utf8;
use t::Util;

use Test::More;
use Time::Piece;
use Tomalino::M::Event;

my $row = Tomalino::M::Event->create(
    name        => 'ジャイアンリサイタル',
    begin_time  => '2013-10-05 13:00:00',
    end_time    => '2013-10-05 17:00:00',
    owner       => 1,
    location    => '空き地',
    hashtag     => '#jaianrecital',
    description => <<'EOF',
# ジャイアンリサイタル

みんなお待ちかね、ジャイアンリサイタルだ！

来ないヤツはぶん殴る！
EOF
);

isa_ok $row, 'HASH';
is $row->{name}, 'ジャイアンリサイタル';

my $events = Tomalino::M::Event->search_by_date_range(
    begin_time => '2013-10-01 00:00:00', 
    end_time   => '2013-10-31 00:00:00',
);

is_deeply($events, [$row]);

done_testing;
