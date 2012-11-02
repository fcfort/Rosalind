#!perl -n
use strict;
use warnings;
use lib '../common';
use Common;

# Chomp
$_ =~ s/[\r\n]//g;

my $i = 0;

# Count bps
for my $base (split //) {
    $G::strings[$i++]{$base}++;
}

END {
    # Consensus string
    my @consensus = map { (sort { $_->{$b} <=> $_->{$a}  } keys %$_)[0]  } @G::strings;
    print join("", @consensus), "\n";

    # Positional count
    for my $base ( 'A', 'C', 'G', 'T' ) {
        print $base . ": " . join(" ", map { exists $_->{$base} ? $_->{$base} : 0 } @G::strings), "\n"; 
    }
}
