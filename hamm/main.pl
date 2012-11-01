#!perl
use strict;
use warnings;
use lib '../common';

use Common;

my $str_a = Common::read_line();
my $str_b = Common::read_line();

print hamming_distance($str_a, $str_b);

sub hamming_distance {
    my ($str_a, $str_b) = @_;

    my @a = split(//, $str_a);
    my @b = split(//, $str_b);

    my $distance = 0;
    for (my $i = 0; $i < @a; $i++) {
        $distance++ if ($a[$i] ne $b[$i]);
    }

    return $distance;
}
