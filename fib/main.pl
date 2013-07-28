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

my %f = (
    1 => 1,
    2 => 1,
);

for(3..$n) {
    $f{$_} = $f{$_-1} + $k*$f{$_-2};
    print "F($_) = $f{$_}\n"; 
}

print "Answer is $f{$n}\n";
