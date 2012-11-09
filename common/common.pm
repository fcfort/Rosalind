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

1;
