#!perl
use strict;
use warnings;

package Common;

use Data::Dumper;

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

# Reads DNA in FASTA format and returns a hash map mapping
# ID to DNA string
sub fasta_reader { 
	my %fasta;
    my $key = '';
	while(defined(my $line = read_line()) ) {
        if ( $line =~ /^>/ ) { 
            $key = $line; 
            $key =~ s/^>//;
        } else {
		    $fasta{$key} .= $line;	
            }
	}
	return \%fasta;
}

# Creates random DNA strings of length n
sub generate_dna {
    my $n = shift;
    return join("", map { (qw/G T C A/)[rand(4)] } 0 .. $n - 1);
}

# returns complement of a dna string
sub complement {
    my $dna = shift;
    $dna =~ tr/ATCG/TAGC/;
    return $dna;

}

# Given a string returns rev compl of the string
sub reverse_complement {
    my $dna = shift;
    return join("", reverse split //, complement($dna));
}

# Encodes a given DNA string to RNA
sub dna_to_rna {
    my $dna = shift;
    $dna =~ s/T/U/g;
    return $dna;
}

# Given an RNA string returns all start codon posns
sub start_codon_positions {
    my $rna = shift;

    my @start_codon_posns;

    my $posn = 0;
    for my $codon ( $rna =~ /.../g ) {
        push(@start_codon_posns, $posn) if $codon eq 'AUG';
        $posn += 3;
    }

    return @start_codon_posns;
}

# Converts RNA to AA strand
# or a candidate protein string
sub rna_to_protein {
    my $rna = shift;

    my %rna_codon_table = (
        UUU => 'F', UUC => 'F', UUA => 'L', UUG => 'L',
        UCU => 'S', UCC => 'S', UCA => 'S', UCG => 'S',
        UAU => 'Y', UAC => 'Y', UAA => 'Stop', UAG => 'Stop',
        UGU => 'C', UGC => 'C', UGA => 'Stop', UGG => 'W',
        CUU => 'L', CUC => 'L', CUA => 'L', CUG => 'L',
        CCU => 'P', CCC => 'P', CCA => 'P', CCG => 'P',
        CAU => 'H', CAC => 'H', CAA => 'Q', CAG => 'Q',
        CGU => 'R', CGC => 'R', CGA => 'R', CGG => 'R',
        AUU => 'I', AUC => 'I', AUA => 'I', AUG => 'M',
        ACU => 'T', ACC => 'T', ACA => 'T', ACG => 'T',
        AAU => 'N', AAC => 'N', AAA => 'K', AAG => 'K',
        AGU => 'S', AGC => 'S', AGA => 'R', AGG => 'R',
        GUU => 'V', GUC => 'V', GUA => 'V', GUG => 'V',
        GCU => 'A', GCC => 'A', GCA => 'A', GCG => 'A',
        GAU => 'D', GAC => 'D', GAA => 'E', GAG => 'E',
        GGU => 'G', GGC => 'G', GGA => 'G', GGG => 'G',
    );

    # print Dumper(\%rna_codon_table);
    
    my $protein = '';

    # print "Reading $rna\n";
    my $starting_pos = 0;
    my $start_flag = 0; # Have we seen the start codon AUG?
    my $end_flag = 0; # Have we seen a stop codon
    while ( $starting_pos <= length($rna) - 3 ) {
        my $codon = substr($rna, $starting_pos, 3);
        # print "Examining $codon => $rna_codon_table{$codon}\n";
        $starting_pos += 3; 
        if ($codon eq 'AUG') {
            $start_flag = 1;
            # print "Found start codon $codon\n";
        }
        next unless $start_flag;
        # End if there aren't enough bases
        # last unless length($codon) == 3;
        # End if we've hit a stop codon
        if ( $rna_codon_table{$codon} eq 'Stop' ) {
            $end_flag = 1;
            # print "Found stop codon $codon\n";
            last;
        }
        # print "Cannot find '$codon'\n" if not exists $rna_codon_table{$codon};
        $protein .= $rna_codon_table{$codon};
    }
    
    # Only return protein if we've found an end flag
    return $end_flag ? $protein : '';
}

sub dna_to_protein {
    my $dna = shift;

    return rna_to_protein(dna_to_rna($dna));
}

sub permute {
    my $last = pop @_;
    unless (@_) {
        return map [$_], @$last;
    }
    return map { my $left = $_; map [@$left, $_], @$last } permute(@_);
}

1;
