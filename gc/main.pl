#!perl -nl

use List::Util qw(sum);

BEGIN {
    my %strings;
    my $current_id = '';
}

chomp;
if( $_ =~ /^>(Rosalind_\d{4})/ ) {
     $current_id = $1;
    # print "Setting cur id to $current_id\n";
} else {
    map { $strings{$current_id}{$_}++ } split (//, $_);
}

END {
    my @sorted_keys = sort { 
        ($strings{$b}{G} + $strings{$b}{C}) <=> ($strings{$a}{G} + $strings{$a}{C})
        
        } keys %strings;

    my $max_id = $sorted_keys[0];
    print $max_id . "\n" . 100 * (($strings{$max_id}{G} + $strings{$max_id}{C}) / sum(values $strings{$max_id}) ) . "%";
}
