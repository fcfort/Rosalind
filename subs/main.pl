#!perl
use strict;
use warnings;
use lib '../common';
use Common;

my $main_string = Common::read_line();
my $sub_string = Common::read_line();

use Data::Dumper;

my $len = length $sub_string;

# print "Got $main_string and $sub_string with len $len\n";

my @match_posns;
my $i = 1;
for my $part ( map { 
        substr($main_string, $_, $len) 
        } 0 .. (length($main_string) - $len)) 
{
    # print $part, "\n";
    if ( $part eq $sub_string ) {
        # print "match at $i\n";
        push(@match_posns, $i);
    }
    $i++;
}

# print Dumper(\@match_posns);
print join(" ", @match_posns);
