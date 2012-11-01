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

1;
