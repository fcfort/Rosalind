#!perl
use strict;
use warnings;
use lib '../common';
use Common;

my $orig_str = Common::read_line();
my $dest_str = Common::read_line();

# make into arrays
my $orig = [ split / /, $orig_str ];
my $dest = [ split / /, $dest_str ];

# translate to alphabetical strings
$orig = [ map { chr($_ + 64) } @$orig ];
$dest = [ map { chr($_ + 64) } @$dest ];

my $len = @$orig;
print "Length is $len\n";
rev_search($dest, 0);

# The basic approach is to enumerate all possible
# reversals and only pursue those in which the hamming
# distance is less than the previous string
sub rev_search {
    my ($current, $depth) = @_;
    print "Calling with ".join(" ",@$orig).", ".join(" ",@$dest) .
        ", " . join(" ",@$current),"\n";
    if ( join("", @$current) eq join("", @$orig) ) {
        print "Found match at depth $depth\n";
        return;
    }
    for(my $i = 0; $i < $len - 1; $i++) {
        for(my $j = $i + 1; $j < $len; $j++) {
            my @proposal = @$current;
            @proposal[$i..$j] = reverse @proposal[$i..$j];
            print "Flipping $i to $j\n";
            print join(" ", @proposal), "\n";
            if ( Common::hamming_distance(
                    join("", @proposal), join("",@$orig) )
                <
                 Common::hamming_distance(
                    join("", @$current), join("", @$orig) )
                 ) {
                print "Must go deeper, recursing with " .
                    join("", @proposal), "\n";

                rev_search(\@proposal, $depth++);
            }
        }
    }
}
