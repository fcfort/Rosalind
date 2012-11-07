#!perl
use strict;
use warnings;
use lib '../common';
use Common;

for ( 0..10000 ) {
    print ">Rosalind_" . sprintf("%04d", $_), "\n";   
    print create_random_dna_string(10), "\n";
}

# size
sub create_random_dna_string {
    my $n = shift;

    my $dna;
    my @bases = ("G","T","C","A");
    for(my $i = 0; $i < $n; $i++) {
        $dna .= $bases[rand(4)];
    }

    return $dna;
}
