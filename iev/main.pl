#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my ($k, $m, $n, $o, $p, $q) = split / /, Common::read_line();

# Each pair has two children
my $num_children = 2;

# Each genotype pairing will produce a dominant offspring with differing probability
my $k_prob = 1; # AA AA
my $m_prob = 1; # AA Aa
my $n_prob = 1; # AA aa
my $o_prob = 3/4; # Aa Aa
my $p_prob = 1/2; # Aa aa
# my $q_prob = 0; # aa aa

my $dominant_offspring = 
    $k * $num_children * $k_prob + 
    $m * $num_children * $m_prob + 
    $n * $num_children * $n_prob + 
    $o * $num_children * $o_prob + 
    $p * $num_children * $p_prob
;

my $answer = $dominant_offspring;

print "Answer is $answer\n";
    
