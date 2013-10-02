use strict;
use warnings;

use constant CONSUMER_KEY    => 'wvHmoU8QaYSDyToWjPRTg';
use constant CONSUMER_SECRET => 'BcNPiFos6C7AzQ6ZigTaeF5h6QiUP9UvB7y4qVTJOo';

use Plack::Builder;
use Plack::Session::Store::Cache;
use Cache::SharedMemoryCache;
use File::Spec;
use File::Basename 'dirname';
use lib (
    File::Spec->catdir(dirname(__FILE__), 'lib'), 
);
use NephiaX::Auth::Twitter;
use Tomalino;
use Tomalino::M::SessionInfo;
use Data::Dumper;

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
    mount '/login' => NephiaX::Auth::Twitter->run(
        consumer_key    => CONSUMER_KEY,
        consumer_secret => CONSUMER_SECRET,
        handler => sub {
            my ($c, $twitter_id) = @_;
            my $session_id = $c->{cookies}{plack_session};
            Tomalino::M::SessionInfo->set(
                provider   => 'twitter',
                account    => $twitter_id,
                session_id => $session_id,
            );
            [302, [Location => '/home'], []];
        },
    );
    mount '/' => $app;
};

