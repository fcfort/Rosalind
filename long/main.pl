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
    for my $substr ( lc_substr($dna_a, $dna_b) ) {
        if ( length($substr) >= $min_match_len ) {
            # Add pair to list of matches
            # a pair object holds the indexes and offset of the match

            # If the match from the end of the first string to the beginning of the second
            # we will consider that positive offset
            # Positive offset: AAABBB to BBBCCC has +3 offset
            # Negative offset: BBBCCC to AAABB has -3 offset
            # We will order the pairs such that the offset is always positive
            # This will ensure that we have the strings in the correct order for
            # overlapping
            my $pair;
            my $offset = ($len - length($substr));
            if ( $dna_a =~ /$substr$/) {
                $pair = [ $first_index, $second_index, $offset ];
            } else {
                $pair = [ $second_index, $first_index, $offset ];
            }
            push(@pairs, $pair);

            print "Found match [$first_index,$second_index] $substr for $dna_a, $dna_b with offset " . $offset ."\n";

        }
        # Only care about the first match
        last;
    }
}

# Now match pairs together into a list of order pairs such that
# for all such pairs, the index of the right pair is equal to the
# the index of the left pair for the next item of the list.
# E.g. ([0,3],[3,1],[1,2])

print "Pairs: " . Dumper(\@pairs) ."\n";
#die;

# Initialize the pairing list with any old pair
my @pairing_list = (pop @pairs);
while ( @pairs > 0 ) {
    my $pair = pop @pairs;
    # New pairs can only be added to the ends of the paired list

    print "Pair: " . Dumper($pair) . " Pairs: " . Dumper(\@pairs) . " Pairing list: " . Dumper(\@pairing_list) . "\n";

    # Case 1: Pair fits front of pair list in its original order
    # E.g. [2,3] matches [3,1], [], [], ...
    if ( $pair->[1] == $pairing_list[0][0] ) {
        unshift(@pairing_list, $pair);
    }
    # Case 2: Pair fits front of list in reverse order
    # E.g. [3,2] matches [3,1], [], [], ...
    #elsif ( $pair->[1] == $pairing_list[0][0] ) {
        # add pair in reverse order
    #    unshift(@pairing_list, [$pair->[1], $pair->[0], $pair->[2]]);
    #}
    # Case 3: Pair fits end in orig order
    elsif ( $pair->[0] == $pairing_list[@pairing_list - 1][1] ) {
        push(@pairing_list, $pair);
    }
    # Case 4: Pair fits end in reverse order
    #elsif ( $pair->[1] == $pairing_list[@pairing_list - 1][1] ) {
    #    push(@pairing_list, [$pair->[1], $pair->[0], $pair->[2]]);
    #}
    # Case 5: No match, add back in
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
    print "To $matched_string adding $overlapped_end\n";
    $matched_string .= $overlapped_end;
}

print "Answer is $matched_string\n";

# Returns the longest substrings that matches the end of the first string
# and the beginning of the second string
# Modified to reference a min match length to return
# From http://en.wikibooks.org/wiki/Algorithm_implementation/Strings/Longest_common_substring#Perl
sub lc_end_substr {
    my ($str1, $str2) = @_;
    my $len = length $str1;
    my $l_length = ceil($len/2); # min length of longest common substring

    for my $offset ( 0 .. $l_length ) {
        my $begin = substr($str1, $offset);
        my $end = substr($str2, 0, $len - $offset - 1);

        if ( $begin eq $end ) {
            return $begin;
        }
    }
    return "";
}

# Returns a list of substrings that match among both strings
# From http://en.wikibooks.org/wiki/Algorithm_implementation/Strings/Longest_common_substring#Perl
sub lc_substr {
  my ($str1, $str2) = @_;
  my $l_length = 0; # length of longest common substring
  my $len1 = length $str1;
  my $len2 = length $str2;
  my @char1 = (undef, split(//, $str1)); # $str1 as array of chars, indexed from 1
  my @char2 = (undef, split(//, $str2)); # $str2 as array of chars, indexed from 1
  my @lc_suffix; # "longest common suffix" table
  my @substrings; # list of common substrings of length $l_length

  for my $n1 ( 1 .. $len1 ) {
    for my $n2 ( 1 .. $len2 ) {
      if ($char1[$n1] eq $char2[$n2]) {
        # We have found a matching character. Is this the first matching character, or a
        # continuation of previous matching characters? If the former, then the length of
        # the previous matching portion is undefined; set to zero.
        $lc_suffix[$n1-1][$n2-1] ||= 0;
        # In either case, declare the match to be one character longer than the match of
        # characters preceding this character.
        $lc_suffix[$n1][$n2] = $lc_suffix[$n1-1][$n2-1] + 1;
        # If the resulting substring is longer than our previously recorded max length ...
        if ($lc_suffix[$n1][$n2] > $l_length) {
          # ... we record its length as our new max length ...
          $l_length = $lc_suffix[$n1][$n2];
          # ... and clear our result list of shorter substrings.
          @substrings = ();
        }
        # If this substring is equal to our longest ...
        if ($lc_suffix[$n1][$n2] == $l_length) {
          # ... add it to our list of solutions.
          push @substrings, substr($str1, ($n1-$l_length), $l_length);
        }
      }
    }
  }

  return @substrings;
}
