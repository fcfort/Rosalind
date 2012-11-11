#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my $dna = Common::read_line();

# print $dna, $/;
# print Common::reverse_complement($dna) . ".\n";

my %possible_proteins;
for my $start_posn ( 0 .. 2 ) {
    for my $reverse_complement ( 0, 1 ) {
        my $frame = $reverse_complement ? substr(Common::reverse_complement($dna), $start_posn) : substr($dna, $start_posn);        
        
        my $rna = Common::dna_to_rna($frame);

        # Transcription can begin anywhere so we have to look at 
        # all possible places a start codon can be
        my @start_codon_posns = Common::start_codon_positions($rna);
        for my $start_codon_posn ( @start_codon_posns ) {
            my $rna_substring = substr($rna, $start_codon_posn);
            print "Translating " . join(",",($rna_substring =~ m/.../g)) . " using offset $start_posn,  rev? $reverse_complement, and start codon pos $start_codon_posn\n";

            my $protein = Common::rna_to_protein($rna_substring);
            print "Got protein $protein\n";
            $possible_proteins{$protein} = 1;
        }
    }
}

print "The official answer is:\n";
map { print $_,$/ } grep { length($_) } keys %possible_proteins;
