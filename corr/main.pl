#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

# TODO: The main defect is that there are a number of incorrect reads that are
# not being paired with a correct read.

# Read data in
my $fasta = Common::fasta_reader();

# print Dumper($fasta);

my %inverse_fasta = map { $fasta->{$_} => $_ } keys %$fasta;

print "Got " . scalar(keys %$fasta) . " reads\n";
# print Dumper(\%inverse_fasta);

# Canonicalize and count reads
my %reads;
for my $k ( keys %$fasta ) {
    my $v = $fasta->{$k};

    if ( $v gt Common::reverse_complement($v) ) {
        $reads{$v}++;
    } else {
        $reads{Common::reverse_complement($v)}++;
    }


}

print "Reads " .  Dumper(\%reads);

my @correct_reads = grep { $reads{$_} > 2 } keys %reads;

print "Got " . scalar(@correct_reads) . " correct reads\n";

# print "Correct reads: " . join("\n",@correct_reads) . "\n";

my @incorrect_reads = grep { $reads{$_} == 2 } keys %reads;

print "Got " . scalar(@incorrect_reads) . " incorrect reads\n";
# print "Incorrect reads: " . join("\n",@incorrect_reads) . "\n";

# Maps reverse complement reads to original reads
my %read_map = map { Common::reverse_complement($_) => $_ } values %$fasta;

my @unsolved_incorrect_reads;

for my $incorrect ( @incorrect_reads ) {
    my $solved = 0;
    for my $correct ( @correct_reads ) {
        if ( Common::hamming_distance($incorrect, $correct) == 1 ) {
            $solved = 1;
            # Found the incorrect
            # Map to the actual original read
            if ( defined $read_map{$incorrect} ) {
                print $inverse_fasta{$read_map{$incorrect}} . " ";
                print "$read_map{$incorrect}->".Common::reverse_complement($correct)."\n";
            } else {
                print $inverse_fasta{$incorrect} . " ";
                print "$incorrect->$correct\n";
            }
            last;
        }
    }
    push(@unsolved_incorrect_reads, $incorrect) if not $solved;
}

print "Could not find matches for " . Dumper([sort @unsolved_incorrect_reads]) . "\n";