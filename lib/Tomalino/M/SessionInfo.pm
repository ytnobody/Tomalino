package Tomalino::M::SessionInfo;
use strict;
use warnings;
use Tomalino::DB;

sub set {
    my ($class, %opts) = @_;
    $opts{updated_at} = time;
    my @keys  = keys %opts;
    my $cols  = join(',', map{'"'. $_. '"'} @keys);
    my $binds = join(',', map{'?'} @keys);
    my @vals  = map {$opts{$_}} @keys;
    Tomalino::DB->query(
        sprintf('REPLACE INTO session_info (%s) VALUES (%s)', $cols, $binds), 
        @vals
    );
}

sub fetch {
    my ($class, $session_id) = @_;
    Tomalino::DB->select_row('SELECT * FROM session_info WHERE session_id=?', $session_id);
}

1;
