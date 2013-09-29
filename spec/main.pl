#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my %amino_acid_mass = (
    'A' => 71.03711,
    'C' => 103.00919,
    'D' => 115.02694,
    'E' => 129.04259,
    'F' => 147.06841,
    'G' => 57.02146,
    'H' => 137.05891,
    'I' => 113.08406,
    'K' => 128.09496,
    'L' => 113.08406,
    'M' => 131.04049,
    'N' => 114.04293,
    'P' => 97.05276,
    'Q' => 128.05858,
    'R' => 156.10111,
    'S' => 87.03203,
    'T' => 101.04768,
    'V' => 99.06841,
    'W' => 186.07931,
    'Y' => 163.06333
);

# for use in closest match func
my @inverse_order_masses;
for( sort {$amino_acid_mass{$a} <=> $amino_acid_mass{$b} } keys %amino_acid_mass ) {
    push(@inverse_order_masses,{'weight' => $amino_acid_mass{$_}, 'letter' => $_ });   
}

# print Dumper(\%amino_acid_mass);

my @prefix_spectrum;
while ( defined(my $prefix_weight = Common::read_line()) ) {
    push(@prefix_spectrum, $prefix_weight);
}

# print Dumper(\@prefix_spectrum);

my $protein = '';
for (my $i=1; $i < @prefix_spectrum; $i++) {
    my $diff = $prefix_spectrum[$i] - $prefix_spectrum[$i - 1];
    my $match = closest_match($diff);
    # print "Got diff from $i to " . ($i - 1) . " of $diff with match $match\n";
    $protein .= $match;
}

print "Answer:\n$protein\n";

# Test should give WMQS

# Given a residue weight, will return the letter corresponding
# to the closest match in weight
# O(n) out of laziness
sub closest_match {
    my $weight = shift;
    my $closest_match_diff = 1000;
    my $closest_match_letter;
    for(my $i = 0; $i < @inverse_order_masses; $i++) {
            if(abs($weight - $inverse_order_masses[$i]{weight}) < $closest_match_diff) {
                $closest_match_diff = abs($weight - $inverse_order_masses[$i]{weight});
                $closest_match_letter =  $inverse_order_masses[$i]{letter};
            }
    }
    return $closest_match_letter;
}

sub sum {
    my $sum = 0;
    for(@_) { $sum += $_ };
    return $sum;
}
