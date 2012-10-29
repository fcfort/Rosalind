#! perl
use warnings;
use strict;

my %hist;

while (<>) {
    map { 
        $hist{$_}++;
    } split(//,$_);
}

print join(" ",( $hist{A}, $hist{C}, $hist{G}, $hist{T} ) );
