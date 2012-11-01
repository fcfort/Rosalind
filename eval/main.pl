#! perl
use strict;
use warnings;

# The total probability of all random strings is 1.
# This is made of up terms for each possible combination
# of A, C, G, T. If we express the GC-content probability Pgc
# in terms of p = Pgc/2, and q = (1 - Pgc/2), we see that the
# the probability for {A, C, G, T} = {q, p, p, q} with a total sum
# of 2p + 2q = 1.
#
# In our case we need the probability that we draw a particular letter
# and that the letter is found in our destination string. This means that 
# each probability needs to be multiplied by itself to represent the odds
# of drawing that string essentially twice. So we square each term of our 
# individual letter probabilities. We end with:
#
# p**2 + p**2 + q**2 + q**2 or 2p**2 + 2q**2 (formula 1)
#
# This represents the expected number of substring matches for our base case of m = n = 1.
#
# Now let us extend this to m, n > 1. Each additional letter in our substring (m > 1)
# represents another letter that must appear twice, once in our substring and another
# in our destination string.
#
# So for m = 2, we need to find the total probability for the following strings:
#
# { AA, AG, AC, AT,
#   GA, GG, GC, GT,
#   CA, CG, CC, CT,
#   TA, TG, TC, TT }
# 
# You'll notice that this set is essentially { A, G, C, T} x {A, G, C, T}.
# This implies that for each probability of A, we will need 4 additional 
# terms, one for each base letter (A, G, C, T).
#
# So to get our probabilities for this set, we multiply each probability in # our 
# first formula by itself. Which is the same as squaring it:
#
# (2p^2 + 2q^2)^2 (formula 2).
#
# This leads us to a generic formula for any m:
#
# (2p^2 + 2q^2)^m (formula 3)
#
# The other major part to this problem is our destination string of length 
# n. It is easy to see from hint #2, that our string can match at any 
# position along the destination string with equal probability. This means
# that a destination string of length 5 (n = 5) and a substring of
# length 3 ( m = 3 ) can match 3 times, from position 0 to 2, 1 to 3, 
# 2 to 4, and 3 to 5. The general formula is:
#
# n - m + 1 (formula 4)
#
# So we have to multiply our expected occurences formula (formula 3) by the
# number of times the string can fit (formula 4). We end up with a final formula of:
#
# (n - m + 1)( 2(Pgc/2)^2 + 2*(1-Pgc/2)^2 )^m (formula 5)
#
# QED

# Read in then lengths from the first line
my $length_string = read_line();
my ($m, $n) = split(/ /, $length_string);

# Read in GC-content array
my $gc_content_string = read_line();
my @gc_contents = split(/ /, $gc_content_string);

print "Got m = $m, n = $n, and Pgcs of " . join(",", @gc_contents) . "\n";

my @results;
for my $Pgc (@gc_contents) {
   my $result = ($n - $m + 1) * ( 2 * ( $Pgc/2 )**2 + 2 * ((1-$Pgc)/2)**2 )**$m;
   push(@results, sprintf("%.6f", $result));
}

print join(" ", @results);

sub read_line {
    my $str = <>;
    $str =~ s/[\r\n]//g;
    return $str;
}

