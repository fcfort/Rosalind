#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my @symbols = split / /, Common::read_line();
my $len = Common::read_line();

use Algorithm::Combinatorics qw(combinations_with_repetition variations_with_repetition);

# my $iter = combinations_with_repetition(\@symbols, $len);
my $iter = variations_with_repetition(\@symbols, $len);

while ( my $p = $iter->next) {
    print join("", @$p), "\n";
}
