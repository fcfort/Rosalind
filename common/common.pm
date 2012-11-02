#!perl
use strict;
use warnings;

package Common;

# Stupid function to get by problems with unix/dos files
sub read_line {
    my $str = <>;
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

1;
