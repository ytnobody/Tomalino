use strict;
use File::Spec;
use File::Basename 'dirname';

my $dbfile  = path_to(qw/var db.sqlite3/);
my $dbdir   = dirname($dbfile);
my $sqlfile = path_to(qw/sql sqlite.sql/);

sub path_to {
    File::Spec->catdir(dirname(__FILE__), '..', @_);
}


# create database file if isn't exists.
mkdir $dbdir unless -d $dbdir;
system("sqlite3 $dbfile < $sqlfile") unless -f $dbfile;

{
    DB => ["dbi:SQLite:dbname=$dbfile","",""],
};
