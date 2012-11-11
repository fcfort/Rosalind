#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my $dna = Common::read_line();

my @introns;
while ( defined(my $intron = Common::read_line()) ) {
    push(@introns, $intron);
    $dna =~ s/$intron//g;
}

# print "Got DNA $dna and introns " . join(",", @introns) . "\n";

print Common::dna_to_protein($dna), "\n";

