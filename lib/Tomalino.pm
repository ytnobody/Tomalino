package Tomalino;
use strict;
use warnings;
use File::Spec;
use Tomalino::M::Member;
use Tomalino::M::Event;
use Tomalino::M::SessionInfo;
use Time::Piece;
use Plack::Session;

our $VERSION = 0.01;

use Nephia plugins => [
    'JSON',
    'View::MicroTemplate' => {
        include_path => [File::Spec->catdir('view')],
    },
    'ResponseHandler',
    'Dispatch',
];

use Data::Dumper;

app {
    my $session = Plack::Session->new(req->env);
    my $session_data = Tomalino::M::SessionInfo->fetch($session->id);

warn Dumper({ $session->id => $session_data });

    get '/' => sub {
        $session_data ? 
            redirect '/home' : 
            {template => 'index.html', appname => 'Tomalino'}
        ;
    };

    get '/home' => sub {
        return redirect('/') unless $session_data;
        { session => $session->id };
    };

    get '/home/logout' => sub {
        Tomalino::M::SessionInfo->delete($session->id);
        redirect '/';
    };

    get '/api/events' => sub { 
        my $begin_time = localtime->strftime('%Y-%m-%d %H:%M:%S');
        my $end_time   = localtime(time + (86400*14))->strftime('%Y-%m-%d %H:%M:%S');
        my $events     = Tomalino::M::Event->search_by_date_range(
            begin_time => $begin_time,
            end_time   => $end_time,
        );
        {events => $events};
    };
};

1;

=encoding utf-8

=head1 NAME

Tomalino - ATND beta like Web Application

=head1 DESCRIPTION

An web application

=head1 SYNOPSIS

    use Tomalino;
    Tomalino->run;

=head1 AUTHOR

clever people

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Nephia>

=cut

