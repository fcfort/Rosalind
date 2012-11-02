#!perl
use strict;
use warnings;
use lib '../common';
use Common;

use Algorithm::Permute;

# read number
my $n = Common::read_line();

print num_permutations($n, $n) * 2**$n, "\n";

# Perm
my $p = new Algorithm::Permute([1 .. $n]);

while(my @res = $p->next) {
    # Each sign permutation can be thought of as mapping the binary representation
    # of a number to either -1 or 1 and multiplying each element of your permutation
    # by that number.
    #
    # Therefore we'll get our perm, then enumerate all possible binary strings for that
    # $n. So for $n == 2, we will permute {1,2} and for each permutation, multiply that
    # permutation by each binary number from 0 .. 2**n - 1, e.g.:
    #
    # { 00, 01, 10, 11 }
    for my $bin_num ( 0 .. 2**$n - 1) {
        my $bin_str = sprintf('%.'.$n.'b', $bin_num);
        
        my $i = -1;
            
        print join(" ", map { $i++; $_ ? $res[$i] : -1 * $res[$i] } split //, $bin_str), "\n";
    }
}

sub num_permutations {
    my ($n, $r) = @_;
    return Common::factorial($n) / Common::factorial($n - $r);
}

