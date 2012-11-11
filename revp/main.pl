#!perl
use strict;
use warnings;
use lib '../common';
use Common;

my $dna = Common::read_line();

for my $match_len ( 4, 6, 8 ) {
    for(my $i = 0; $i <= length($dna) - $match_len; $i++) {
        my $substr = substr($dna, $i, $match_len);
            if ( Common::reverse_complement($substr) eq $substr ) {
                print scalar($i+1)." $match_len\n";
        }
    }
}
