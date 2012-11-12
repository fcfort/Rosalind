#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my @alphabet = split / /, Common::read_line();
my $len = Common::read_line();
my $alphabet_length = scalar(@alphabet);
# print "Got ". join(",", @alphabet) . " of len $len\n";
my $j = 0;
my %alpha_map = map { ++$j => $_ } @alphabet;
my @posns = split //, '0'x$len;

while ( 1 ) {
    print array_to_str(\@posns), "\n";
    #short case
    if ( array_length(\@posns) != $len ) {
        # add one to the first non-zero pos
        for(my $i=0;$i<@posns;$i++) {
            if($posns[$i] == 0) {
                $posns[$i]++;
                last;
            }
        }
    } else {
        # else increment last posn
        $posns[$len - 1]++;
    }
    # now check for overflow posns
    my $carry = 0;
    for(my $i=@posns - 1; $i >= 0; $i--) {
        if ( $carry == 1) {
            $posns[$i]++;
            $carry = 0;
        }
        if($posns[$i] > $alphabet_length) {
           $posns[$i] = 0;
           $carry = 1;
        }
    }
    # exit if we've carried off the first posn
    last if $carry == 1;
}

# Takes in an array of posns and 
# gives the length
sub array_length { 
    my $array = shift;
    return length(array_to_str($array));
}

# Converts an array of posns to a string
sub array_to_str {
    my $array = shift;
    # print Dumper($array);
    my $str = '';
    for ( @$array ) {
        last if $_ == 0;
        $str .= $alpha_map{$_};
    }
    return $str;
}
