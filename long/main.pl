#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;
use POSIX;
use Math::Combinatorics;

$Data::Dumper::Indent = 0;

my $dna = Common::fasta_reader();
my @dna = values %$dna;
my $len = length($dna[0]);
my $min_match_len = ceil($len/2);

print "Examining " . scalar(@dna) . " strings with length $len, must match at least $min_match_len\n";

# Iterate over all pairs of reads to produce pairs of reads that overlap
my @pairs;
for my $combo ( combine(2,(0..@dna-1)) ) {
    my ($first_index, $second_index) = @$combo;
    my ($dna_a, $dna_b) = ($dna[$first_index], $dna[$second_index]);
    # print "Looking at $dna_a, $dna_b\n";

    # Produce list of matching pairs
    # Add pair to list of matches
    # a pair object holds the indexes and offset of the match
    # If the match from the end of the first string to the beginning of the second
    # we will consider that positive offset
    # Positive offset: AAABBB to BBBCCC has +3 offset
    # Negative offset: BBBCCC to AAABB has -3 offset
    # We will order the pairs such that the offset is always positive
    # This will ensure that we have the strings in the correct order for
    # overlapping

    # Case 1: first string front matches second string end
    # E.g. AAABBB and BBBCCC
    if ( length(my $substr = lc_end_substr($dna_a, $dna_b)) != 0 ) {
        # print "Found match [$first_index,$second_index] $substr for $dna_a, $dna_b with offset " . $offset ."\n";
        push(@pairs, [$first_index, $second_index, ($len - length($substr))]);
    }

    # Case 2: first string front matches second string end
    # E.g. AAABBB and CCCAAA
    elsif ( length($substr = lc_end_substr($dna_b, $dna_a)) != 0 ) {
        # print "Found match [$first_index,$second_index] $substr for $dna_a, $dna_b with offset " . $offset ."\n";
        push(@pairs, [$second_index, $first_index, ($len - length($substr))]);
    }
}

# Now match pairs together into a list of order pairs such that
# for all such pairs, the index of the right pair is equal to the
# the index of the left pair for the next item of the list.
# E.g. ([0,3],[3,1],[1,2])

print "Pairs: " . Dumper(\@pairs) ."\n";

# Initialize the pairing list with any old pair
my @pairing_list = (pop @pairs);
while ( @pairs > 0 ) {
    my $pair = pop @pairs;
    # New pairs can only be added to the ends of the paired list

    # print "Pair: " . Dumper($pair) . " Pairs: " . Dumper(\@pairs) . " Pairing list: " . Dumper(\@pairing_list) . "\n";

    # Case 1: Pair fits front of pair list in its original order
    # E.g. [2,3] matches [3,1], [], [], ...
    if ( $pair->[1] == $pairing_list[0][0] ) {
        unshift(@pairing_list, $pair);
    }
    # Case 2: Pair fits end in orig order
    elsif ( $pair->[0] == $pairing_list[@pairing_list - 1][1] ) {
        push(@pairing_list, $pair);
    }
    # Case 3: No match, add back in
    else {
        unshift(@pairs, $pair);
    }
}

# Now we have a list of pairs of strings matched up in the right order with their offsets

print "Pairing list: " . Dumper(\@pairing_list) . "\n";
# We start with the complete left string of the beginning of the pairing list
my $pair = $pairing_list[0];
my $matched_string = $dna[$pair->[0]];
# Then for each pair, we only add on the offset of the second string
for my $pair ( @pairing_list ) {
    my $overlapped_end = substr($dna[$pair->[1]], $len - $pair->[2]);
    # print "To $matched_string adding $overlapped_end\n";
    $matched_string .= $overlapped_end;
}

print "Answer is\n$matched_string\n";

# Returns the longest substrings that matches the end of the first string
# and the beginning of the second string
sub lc_end_substr {
    my ($str1, $str2) = @_;
    my $len = length $str1;
    my $l_length = ceil($len/2); # min length of longest common substring

    for my $offset ( 0 .. $l_length ) {
        my $begin = substr($str1, $offset);
        my $end = substr($str2, 0, $len - $offset);

        # print "Comparing $begin and $end\n";

        if ( $begin eq $end ) {
            return $begin;
        }
    }
    return "";
}
