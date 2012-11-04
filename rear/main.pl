#!perl
use strict;
use warnings;
use lib '../common';
use Common;

# Create char arrays
my @orig = get_int_string(split / /, Common::read_line());
my @dest = get_int_string(split / /, Common::read_line());

rev_search(\@orig, \@dest, 0);

sub rev_search { 
    my ($orig, $dest) = @_;

    # make into strings
    # global for ease of use
    $G::orig_str = join_array(@$orig);
    $G::dest_str = join_array(@$dest);

    # Get len
    $G::len = @orig;
    print "Length is $G::len\n";
    
    return rev_search_helper($dest, 0, 999);
}

# The basic approach is to enumerate all possible
# reversals and only pursue those in which the hamming
# distance is less than the previous string
sub rev_search_helper {
    my ($current, $cur_depth, $min_depth) = @_;
    print "Calling with $G::orig_str, $G::dest_str, " .
        join_array(@$current),"\n";
    if ( join_array(@$current) eq $G::orig_str ) {
        print "Found match at depth $cur_depth\n";
        return $cur_depth;
    }

    # Iterate through all possible reversals
    for(my $i = 0; $i < $G::len - 1; $i++) {
        for(my $j = $i + 1; $j < $G::len; $j++) {
            my @proposal = @$current;
            @proposal[$i..$j] = reverse @proposal[$i..$j];
            print "Flipping $i to $j: " .
                join_array(@$current) . " -> " . join_array(@proposal) . "\n";
            if ( Common::hamming_distance(
                    join_array(@proposal), $G::orig_str )
                <
                 Common::hamming_distance(
                    join_array(@$current), $G::orig_str )
                 ) {
                if ( $depth < $min_depth ) {
                print "Must go deeper, recursing with " .
                    join_array(@proposal), "\n";
                
                rev_search_helper(\@proposal, $depth + 1);
            }
        }
    }
}

# Convert numbers to strings
sub get_int_string {
    return map { chr($_ + 64) } @_;
}

# joins an array w/ no spaces
sub join_array {
    return join("", @_);
}
