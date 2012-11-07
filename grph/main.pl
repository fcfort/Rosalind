#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

# Read DNA in FASTA format
my $dna_map = Common::fasta_reader();


# Creates a cache of string prefixes and suffixes so we don't
# have to call substr repeatedly
my %dna_map_cache;
my %affixes;
for my $id ( keys %{$dna_map} ) {
   my $prefix = substr($dna_map->{$id}, 0, 3);
   my $suffix = substr($dna_map->{$id}, -3,3);
   $dna_map_cache{$id} = {
        prefix => $prefix,
        suffix => $suffix,
   };
}
# print Dumper(\%comparison_cache);

# print Dumper($dna_map);

# Iterate through all unique pairs of strings
# and add an edge if the prefix or suffix of one
# matches the suffix or prefix of another
my @overlap_pairs;
my @id_array = keys %{$dna_map};
# print Dumper(\@id_array);
# print "We have ".scalar(@id_array)." ids\n";
for(my $i = 0; $i < @id_array; $i++) {
    # print "On $i\n";
    map {
        my ($id1, $id2) = @id_array[$i,$_];
        if ( $dna_map_cache{$id1}{prefix} eq $dna_map_cache{$id2}{suffix} ) {
            push(@overlap_pairs, [$id2, $id1]);
        }
        if ( $dna_map_cache{$id2}{prefix} eq $dna_map_cache{$id1}{suffix} ) {
            push(@overlap_pairs, [$id1, $id2]);
        }
    } $i + 1 .. @id_array - 1;
}

for my $pairs (@overlap_pairs) {
    print join (" ", @$pairs), "\n";
}
