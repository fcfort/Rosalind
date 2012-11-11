#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;
use Algorithm::Permute;

my $fasta = Common::fasta_reader();
# print Dumper($fasta);
my $dna = $fasta->{(keys %{$fasta})[0]};

my $k = 4; # k-mers of len 4

# print "$dna\n";

my @kmer_array;

# init
@kmer_array = map { 0 } 0 .. $k**$k - 1;

for ( my $i = 0; $i <= length($dna) - $k; $i++ ) {
    my $kmer = substr($dna, $i, $k);
    $kmer_array[get_kmer_position($kmer)]++; 
}

print join(" ", @kmer_array);

sub get_kmer_position {
    my $string = shift;
    my $len = length($string);
    my %posn_map = ( A => 0, C => 1, G => 2, T => 3 );
    my $i = $len - 1;
    my $posn = 0;
    map { $posn += $posn_map{$_} * $len**$i-- } split //, $string;
    return $posn;
}
