#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my @dna = split //, Common::read_line;
my @probs = split / /, Common::read_line;

my $gc_count = gc_count(@dna);
my $at_count = scalar(@dna) - $gc_count;

my @answers;
for my $gc_prob ( @probs ) {
    # The chance of matching any particular string like GCATACT is equal to
    # P(match) = prob(G) * prob(C) * prob(A) * ... * prob(T);
    # Because prob(G) = prob(C) and prob(A) = prob(T) and that multiplication is
    # commutative, we can simply count the number of As or Ts and Gs or Cs.
    # p(G) = p(GC)/2 and p(A) = p(AT)/2 as P(G) + p(C) + p(T) + p(A) = p(GC) + p(TA) = 1
    my $at_prob = 1 - $gc_prob;
    # Let A = number of As or Ts
    # Let G = number of Gs or Cs
    # P(match) = ( p(GC)/2 ** G )*( p(AT)/2 ** A )
    my $total_prob = ($at_prob/2)**$at_count * ($gc_prob/2)**$gc_count;
    # Then to turn it into a base 10 logarithm
    # Answer = log(P(match))/log(10)
    my $log_prob = log($total_prob)/log(10);

    # print "For gc prob $gc_prob, $at_prob, $gc_count, $at_count, chance is $total_prob, answer is $log_prob\n";

    push(@answers, sprintf("%.3f",$log_prob));
}

print join(" ", @answers) . "\n";

# Returns number of Gs or Cs in array in scalar context;
sub gc_count {
    grep { $_ eq "G" || $_ eq "C" } @_ ;
}