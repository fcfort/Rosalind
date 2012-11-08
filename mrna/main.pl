#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my %codon_map = (
    F => 2, L => 6,
    S => 6, Y => 2,
    C => 2, W => 1,
    P => 4, H => 2,
    Q => 2, R => 6,
    I => 3, M => 1,
    T => 4, N => 2,
    K => 2, V => 4,
    A => 4, D => 2,
    E => 2, G => 4,
); 

my $protein = Common::read_line();

my $total = 3; # For stop codons
my $modulus = 1_000_000;
for my $aa ( split //, $protein ) {
    $total *= $codon_map{$aa}; 
    while ( $total >= $modulus ) {
        $total -= $modulus;
    }
}

print $total;

