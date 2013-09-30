package Tomalino::Config;
use strict;
use warnings;
use utf8;
use parent 'Exporter';
use Config::Micro;
use File::Spec;
use File::Basename qw(dirname);

our @EXPORT = qw/config/;

my %config = ();

sub config (;%) {
    my (%opts) = @_;
    $ENV{PLACK_ENV} ||= 'common';
    $opts{env} ||= $ENV{PLACK_ENV};
    $opts{dir} ||= File::Spec->catdir(dirname(__FILE__), qw/.. .. config/);
    my $file = $config{$opts{env}};
    unless ( $file ) {
        $file = Config::Micro->file( %opts );
        $config{$opts{env}} = $file;
    };
    require( $file );
}

1;
