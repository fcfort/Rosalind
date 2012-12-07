#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my ($n, $k) = split / /, Common::read_line();

# Number of perms = 
# $n! / ($n - $k)!

my $denominator = $n - $k;

# now we need to multiply the numbers from
# $denominator + 1 to $n
#
# e.g. if our input is 21 7, we need to do 
# 21 * 20 * 19 * 18 * 17 * 16 * 15
# and doing mod 1_000_000 each time

my $modded_total = 1;

map { 
    $modded_total *= $_;
    $modded_total %= 1_000_000;
} $denominator + 1 .. $n;

print $modded_total, "\n";
