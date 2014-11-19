#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;

my $fasta = Common::fasta_reader();

my ($str_a, $str_b) = values %$fasta;

my @str_a = split //, $str_a;
my @str_b = split //, $str_b;

# print @str_a,"\n", @str_b;

my $transitions = 0;
my $transversions = 0;

for(my $i = 0; $i < @str_a; $i++) {
    my ($a, $b) = ($str_a[$i], $str_b[$i]);
    
    next if $a eq $b;

    # print "$a $b " . is_transition($a, $b) . " " . is_transition($b, $a) . " \n";
    
    # Transitions
    if(is_transition($a, $b) or is_transition($b, $a)) {
        $transitions++;
    }
        
    # Transversions
    elsif(is_transversion($a, $b)) {
        $transversions++;   
    }
}

print $transitions/$transversions . "\n";

sub is_transition {
    my ($a, $b) = @_;
    
    if($a eq 'A' and $b eq 'G' or $a eq 'C' and $b eq 'T') {
        return 1;        
    }
    
    return 0;
}

sub is_transversion {
    my ($a, $b) = @_;
    
    if(
        $a eq 'A' and ($b eq 'T' or $b eq 'C') or
        $a eq 'C' and ($b eq 'G' or $b eq 'A') or 
        $a eq 'T' and ($b eq 'A' or $b eq 'G') or 
        $a eq 'G' and ($b eq 'C' or $b eq 'T')
    ) { 
        return 1;
    }
    return 0;
}