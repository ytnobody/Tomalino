package Tomalino;
use strict;
use warnings;
use File::Spec;

our $VERSION = 0.01;

use Nephia plugins => [
    'JSON',
    'View::MicroTemplate' => {
        include_path => [File::Spec->catdir('view')],
    },
    'ResponseHandler',
    'Dispatch',
];

app {
    get '/' => sub {
        {template => 'index.html', appname => 'Tomalino'};
    };

    get '/simple' => sub { 
        [200, [], 'Hello, World!']; 
    };

    get '/json' => sub { 
        {message => 'Hello, JSON World'};
    };
};

1;

=encoding utf-8

=head1 NAME

Tomalino - Web Application that powered by Nephia

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

