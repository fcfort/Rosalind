#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

# n months
# k rabbit offspring
my ($n, $k) = split / /, Common::read_line();

# Recurrence relation for k offspring
# F(n) = F(n-1)  + F(n-2)*k


my %g = (
    0 => 1,
    1 => 0,   
);
my %h = (
    0 => 0,
    1 => 1,
);
my %f = (
    0 => 1,
    1 => 1,
);

print Dumper(\%g);


for(2..$n) {
    $g{$_} = $h{$_-1};
    $h{$_} = $g{$_-1} + $g{$_-2};
    $f{$_} = $g{$_} + $h{$_};
    print "@ $n : F = $f{$_}, G = $g{$_}, H = $h{$_} \n";
}

print "Answer is $f{$n}\n";

