#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Text::Levenshtein::Damerau::XS qw/xs_edistance/;
use Text::Fuzzy;
use Data::Dumper; 


# Call tree:
# main
#   sort_search()
#       rev_search()
#           rev_search_helper()
#               helper functions               
while(defined(my $line1 = Common::read_line()) and defined(my $line2 = Common::read_line())) {
    # Create char arrays
    my @orig = get_int_string(split / /, $line1);
    my @dest = get_int_string(split / /, $line2);

    print "Got $line1, $line2 as initial input\n";

    my ($min_depth, $reversal_list) = sort_search(\@orig, \@dest);

    print "Got min $min_depth and " . Dumper($reversal_list) . "\n";
}

sub sort_search {
    my ($orig, $dest) = @_;

    my $line1 = join_array(@$orig);
    my $line2 = join_array(@$dest);
    # These are the different functions we can use to determine if 
    # we are getting closer to the destination function
    # They are Hamming distance, Text::Fuzzy distance and 
    # Levenstein distance
    my @closeness_functions = ( 
        { name => 'hd', ref => \&is_closer_hd, }, 
        { name => 'tf', ref => \&is_closer_tf, }, 
        { name => 'lh', ref => \&is_closer_lh, }, 
    );

    # iterate through direction and closeness functions till we get a depth that is less than our
    # sentinel value
    $G::max_depth = 999;
    my $min_reversals = $G::max_depth;
    # zero means normal, 1 means (orig, dest) = (dest, orig) the strings (tac gnol)
    MAIN: for my $direction ( 0, 1 ) {
        if ( $direction ) {
            my $temp = $orig;
            $orig = $dest;
            $dest = $temp;
        }
        for my $is_closer ( @closeness_functions ) { 
            my $num_reversals = rev_search($orig, $dest, $is_closer->{ref});
            if ( $num_reversals == $G::max_depth ) {
                print "Failed with dir $direction and closeness function $is_closer->{name}\n";
            } else {
                print "Found match for $line1,$line2 at $num_reversals reversals with dir $direction and closeness function $is_closer->{name}\n";
                if ( $num_reversals < $min_reversals ) {
                    $min_reversals = $num_reversals;
                }
            }
        }
    }
}

sub rev_search { 
    my ($orig, $dest, $is_closer_handle) = @_;

    # make into strings
    # global for ease of use
    my $orig_str = join_array(@$orig);
    my $dest_str = join_array(@$dest);

    # Get len
    my $len = @$orig;
    # print "Length is $len\n";
    
    return rev_search_helper($dest, $orig_str, 0, $G::max_depth, $is_closer_handle, []);
}

# The basic approach is to enumerate all possible
# reversals and only pursue those in which the hamming
# distance is less than the previous string
sub rev_search_helper {
    my ($current, $target, $cur_depth, $min_depth, $is_closer_handle, $reversal_list) = @_;
    # print "Calling at depth $cur_depth with string " .
    #    join_array(@$current) . " and target $target","\n";
    if ( join_array(@$current) eq $target ) {
        print "Found match at depth $cur_depth with revlist " .Dumper($reversal_list). "\n";
        return $cur_depth;
    }

    # Iterate through all possible reversals
    for(my $i = 0; $i < length($target) - 1; $i++) {
        for(my $j = $i + 1; $j < length($target); $j++) {
            my @proposal = @$current;
            @proposal[$i..$j] = reverse @$current[$i..$j];
            # use closer handle to evaluate if proposal is closer than the current to the target
            if ( $is_closer_handle->( join_array(@proposal), join_array(@$current), $target)) {
                if ( $cur_depth < $min_depth ) {
                    # print "Recursing, flipping $i to $j: " .
                    #    join_array(@$current) . " -> " . join_array(@proposal) . "\n";
                    # push(@$reversal_list, [$i + 1, $j + 1]);
                    # Now remove matching leading/trailing characters
                    my ($trimmed_proposal, $trimmed_target) = trim_matching_characters(join_array(@proposal), $target);
                    my $depth_reached = rev_search_helper(
                        [split //, $trimmed_proposal], 
                        $trimmed_target, $cur_depth + 1, 
                        $min_depth, 
                        $is_closer_handle,
                        [@$reversal_list, [$i+1,$j+1]] # append reversal to current list
                    );
                    # my $depth_reached = rev_search_helper(\@proposal, $target, $cur_depth + 1, $min_depth);
                    if ( $depth_reached < $min_depth ) {
                        $min_depth = $depth_reached;
                    }
                }
            }
        }
    }

    return $min_depth;
}

# Given two strings of equal length, removes leading and trailing characters
# that are in the right posns
sub trim_matching_characters {
    my ($str1, $str2) = @_;

    my @str1 = split //, $str1;
    my @str2 = split //, $str2;

    # front
    for(my $i = 0; $i < @str1; $i++) {
        if ( $str1[$i] eq $str2[$i] ) {
            ($str1[$i], $str2[$i]) = (undef, undef);
        } else { last; }
    }

    #back
    for(my $i = @str1 - 1; $i >= 0; $i--) {
        next if not defined $str1[$i] and not defined $str2[$i];
        if ( $str1[$i] eq $str2[$i] ) {
            ($str1[$i], $str2[$i]) = (undef, undef);
        } else { last; } 
    }

    # remove undefs
    @str1 = grep { defined $_ } @str1;
    @str2 = grep { defined $_ } @str2;

    # joins
    my $new_str1 = join_array(@str1); 
    my $new_str2 = join_array(@str2);

    # print "Trimming $str1, $str2 to $new_str1, $new_str2\n";
    return $new_str1, $new_str2;
}

# text fuzzy dist
sub is_closer_tf {
    my ($proposal, $current, $original) = @_;

    my $tf = Text::Fuzzy->new($original); 
    return $tf->distance($proposal) < $tf->distance($current);
}

# hamming dist
sub is_closer_hd {
    my ($proposal, $current, $original) = @_;

    return ( 
            Common::hamming_distance($proposal, $original) < 
            Common::hamming_distance($current, $original)
    );
}

# Lev Ham dist
sub is_closer_lh {
    my ($proposal, $current, $original) = @_;

    return ( 
            xs_edistance($proposal, $original) <
            xs_edistance($current, $original)
    );
}

# Convert numbers to strings
sub get_int_string {
    return map { chr($_ + 64) } @_;
}

# joins an array w/ no spaces
sub join_array {
    return join("", @_);
}
