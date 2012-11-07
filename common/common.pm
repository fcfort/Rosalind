#!perl
use strict;
use warnings;

package Common;

# Stupid function to get by problems with unix/dos files
sub read_line {
    my $str = <>;
    return undef if not defined $str;
    $str =~ s/[\r\n]//g;
    return $str;
}

# Recursive factorial
sub factorial {
    my $n = shift;
    if ( $n <= 1 ) {
        return 1;
    } else {
        return $n * factorial($n - 1);
    }
}

# Copied from http://www.perlmonks.org/?node_id=500235
sub hamming_distance {
   return ($_[0] ^ $_[1]) =~ tr/\001-\255//;
}

1;
