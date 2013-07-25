#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my ($k, $m, $n) = split / /, Common::read_line();

print "got k $k m $m n $n\n";

my $t = $k + $m + $n;

my $denom = 1/($t * ($t - 1));

# So we have a number of different cases depending on which two organisms are selected
# Each of these will be multiplied by a factor for producing an offspring
# with the dominant factor, i.e.
# k DD (homo dominant)
# m Dd (hetero dominant)
# n dd (homo recessive)
# P(kk) = 1
# P(km) = 1
# P(kn) = 1
# P(mm) = 3/4
# P(mn) = 2/4
# P(nn) = 0

my $kk = $k * ($k - 1) * $denom * 1 * 1;
my $km = $k * $m * $denom * 1 * 2;
my $kn = $k * $n * $denom * 1 * 2;
my $mm = $m * ($m - 1) * $denom * (3/4);
my $mn = $m * $n * $denom * (2/4) * 2;
# $nn = 0

my $answer = $kk + $km + $kn + $mm + $mn;

print "Answer is $answer\n";

