use strict;
use warnings;
use utf8;

BEGIN {
    $ENV{PLACK_ENV} = 'test';
}

use Test::More;
use Time::Piece;
use Tomalino::M::Event;

my $row = Tomalino::M::Event->create(
    name        => 'ジャイアンリサイタル',
    begin_time  => '2013-10-05 13:00:00',
    end_time    => '2013-10-05 17:00:00',
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

done_testing;
