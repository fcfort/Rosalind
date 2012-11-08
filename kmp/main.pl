#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my @str = split //, Common::read_line();

print "Finding failure array for " . join("", @str), "\n";

my @failure_array = map { 0 } @str;

# Iterate through the characters of the string
for ( my $i = 1; $i < @str; $i++ ) {
    # Search backwards from the current position
    # The for loop has two conditions, the first one being that we must stop at the second character,
    # so that we don't include the exact string we're trying to match against.
    # The second is an optimization. It states that we need look only one index past the previous value
    # for the failure array. So if the previous failure was 2, we need only examine at most three characters
    # back from our current position. 
    #
    # The reason for this is that the previous failure value states how many characters back have already
    # matched. This means that the current position can have a failure array value of the previous value plus one
    # (if it matches the next character in the prefix) or zero, if it doesn't match the next character in the
    # prefix.
   for ( my $j = $i; $j > 0 && $i - $j <= $failure_array[$i - 1]; $j-- ) {
       # print "Comparing substring " . join("",@str[$j..$i]) . " and prefix " . join("", @str[0..($i-$j)]), "\n"; 
       if ( join("", @str[$j..$i]) eq join("", @str[0 .. ($i - $j)]) ) {
           # print "Found match at $i with length " . ($i - $j + 1), "\n";
           $failure_array[$i] = $i - $j + 1;
       }
   }
}

print join(" ", @failure_array), "\n";
