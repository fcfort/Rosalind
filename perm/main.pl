#!perl
use strict;
use warnings;

use lib '../common';
use Common;
use Algorithm::Permute;

# read number
my $n = Common::read_line();

print Common::factorial($n), "\n";

# create perm
my $p = new Algorithm::Permute([1 .. $n]);

while(my @res = $p->next) {
    print join(" ", @res), "\n";
}
