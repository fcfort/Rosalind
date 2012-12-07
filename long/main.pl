#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my @dna;
while( defined ( my $line = Common::read_line() ) ) {
    push(@dna, $line);
}

# print Dumper(\@dna);

# To record a pair, we need to know 
my @joins;
for ( my $i = 0; $i < @dna; $i++ ) {
    for ( my $j = $i + 1; $j < @dna; $j++ ) {
        print "Comparing $dna[$i] and $dna[$j] at $i, $j\n";
        my ($a, $b) = ($dna[$i], $dna[$j]);
        my $front_b = get_front($b);

        if ( $a =~ /$front_b/ ) {
            # now we have to go to the end of the first string to see if we can add b to a
            if ( substr($a, $-[0]) eq substr($b, 0, length($b) - $-[0]) ) {
                push(@joins, {
                    'head' => $i,
                    'tail' => $j,
                    'position' => $-[0],
                });
            }
        }   
        # Check pairing the other way
        my ($a, $b) = ($dna[$j], $dna[$i]);
        my $front_b = get_front($b);
        if ( $a =~ /$front_b/ ) {
            # now we have to go to the end of the first string to see if we can add b to a
            if ( substr($a, $-[0]) eq substr($b, 0, length($b) - $-[0]) ) {
                push(@joins, {
                    'head' => $j,
                    'tail' => $i,
                    'position' => $-[0],
                });
            }
        }   
    }
}

print Dumper(\@joins);


sub get_front {
    my $str = shift;
    my $half_len = length($str) / 2;
    return substr($str, 0, $half_len);
}

sub get_back {
    my $str = shift;
    my $half_len = length($str) / 2;
    return substr($str, -$half_len, $half_len);
}
# compares end of a to front of b
sub half_length_match {
    my ($a, $b) = @_;

    my $half_len = length($a) / 2;
    my $front = substr($a, 0, $half_len);
    my $back = substr($b, -$half_len, $half_len);
    
    print "Front $a ($front) equal to back $b ($back)\n";
    return $front eq $back;
}
