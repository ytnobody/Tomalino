package Tomalino::DB;
use strict;
use warnings;

use DBIx::Sunny;
use Tomalino::Config;

our $AUTOLOAD;
my $dbh = DBIx::Sunny->connect(@{ config->{DB} });

sub AUTOLOAD {
    my $class = shift;
    my ($method) = $AUTOLOAD =~ /$class\:\:(.+)$/;
    return if $method =~ /^[A-Z]/;
    $dbh->$method(@_);
}

sub dbh { $dbh };

1;
