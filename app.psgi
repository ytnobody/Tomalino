use strict;
use warnings;
use Plack::Builder;
use Plack::Session::Store::Cache;
use Cache::SharedMemoryCache;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), 'lib'), 
);
use Tomalino;

my $app           = Tomalino->run;
my $root          = File::Spec->rel2abs(File::Spec->catdir(dirname(__FILE__)));
my $session_cache = Cache::SharedMemoryCache->new({
    namespace          => 'Tomalino',
    default_expires_in => 600,
});

builder {
    enable_if { $ENV{PLACK_ENV} =~ /^dev/ } 'StackTrace', force => 1;
    enable 'Static', (
        root => $root,
        path => qr{^/static/},
    );
    enable 'Session', (
        store => Plack::Session::Store::Cache->new(
            cache => $session_cache,
        ),
    );
    enable 'CSRFBlock';
    $app;
};

