#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

# n months
# m rabbit lifespan
my ($n, $m) = split / /, Common::read_line();

# The number of rabbits after any generation F(n)) is the
# sum of the number of young rabbits (G(n)) and old 
# rabbits (H(n)).
# F(n) = G(n) + H(n)

my %g = (
    1 => 1,
    2 => 0,   
);
my %h = (
    1 => 0,
    2 => 1,
);
my %f = (
    1 => $g{1} + $h{1},
    2 => $g{2} + $h{2},
);
# print Dumper(\%f);
# YOUNG : Each old rabbit produces 1 young rabbit
# G(n) = H(n-1)

# OLD : Each old rabbit alive in the previous generation lives on
# Each young rabbit becomes and old rabbit
# ago die out
# H(n) = H(n-1) + G(n-1) - G(n-m+1)
# m = 3 : H(n) = H(n-1) + G(n-1) - G(n-2)

for(3..$n) {
    $g{$_} = h($_-1);
    $h{$_} = h($_-1) + g($_-1) - g($_-$m);
    $f{$_} = g($_) + h($_);
    print "n = $_ : F = $f{$_}, G = $g{$_}, H = $h{$_} \n";
}

print "Answer is $f{$n}\n";

# shortcut functions
sub h { return $h{$_[0]} // 0; }
sub g { return $g{$_[0]} // 0; }