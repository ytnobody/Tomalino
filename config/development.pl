use strict;
use warnings;
use File::Spec;
use File::Basename 'dirname';

my $common_file = File::Spec->catfile(dirname(__FILE__), 'common.pl');
require($common_file);
