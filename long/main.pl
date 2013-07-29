#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my @dna;
while( defined ( my $line = Common::read_line() ) ) {
    push(@dna, $line);
}


# print Dumper(\@dna);
for(@dna) {
    
}
lc_substr

# To record a pair, we need to know 
my @joins;
for ( my $i = 0; $i < @dna; $i++ ) {
    for ( my $j = $i + 1; $j < @dna; $j++ ) {
        print "Comparing $dna[$i] and $dna[$j] at $i, $j\n";
        my ($a, $b) = ($dna[$i], $dna[$j]);
        my $front_b = get_front($b);

        if ( $a =~ /$front_b/ ) {
            # now we have to go to the end of the first string to see if we can add b to a
            if ( substr($a, $-[0]) eq substr($b, 0, length($b) - $-[0]) ) {
                push(@joins, {
                    'head' => $i,
                    'tail' => $j,
                    'position' => $-[0],
                });
            }
        }   
        # Check pairing the other way
        my ($a, $b) = ($dna[$j], $dna[$i]);
        my $front_b = get_front($b);
        if ( $a =~ /$front_b/ ) {
            # now we have to go to the end of the first string to see if we can add b to a
            if ( substr($a, $-[0]) eq substr($b, 0, length($b) - $-[0]) ) {
                push(@joins, {
                    'head' => $j,
                    'tail' => $i,
                    'position' => $-[0],
                });
            }
        }   
    }
}

print Dumper(\@joins);


sub get_front {
    my $str = shift;
    my $half_len = length($str) / 2;
    return substr($str, 0, $half_len);
}

sub get_back {
    my $str = shift;
    my $half_len = length($str) / 2;
    return substr($str, -$half_len, $half_len);
}
# compares end of a to front of b
sub half_length_match {
    my ($a, $b) = @_;

    my $half_len = length($a) / 2;
    my $front = substr($a, 0, $half_len);
    my $back = substr($b, -$half_len, $half_len);
    
    print "Front $a ($front) equal to back $b ($back)\n";
    return $front eq $back;
}

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
