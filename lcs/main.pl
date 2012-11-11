#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;
use Algorithm::ChooseSubsets;
use String::Substrings;
use String::Splitter;

my @dnas;
while(defined(my $dna = Common::read_line)) {
     push(@dnas, $dna);
}

# push(@dnas, Common::generate_dna(rand(1000) + 200)) for (0 .. 100);

# sort so min length array is first
@dnas = sort { length($a) <=> length($b) } @dnas;

# print Dumper(\@dnas);

# Iterate through all substrings of min string
# and search for matches in all other strings
#
my $min_string = shift @dnas;
print "Smallest string is $min_string\n";
my $i = Algorithm::ChooseSubsets->new([split //, $min_string]);

my $ss = String::Splitter->new();
my $all_substrings = $ss->all_substrings($min_string);

# Find all strings sorted from longest to shortest
my @substrings = sort { length($b) <=> length($a) } @{ String::Splitter->new->all_substrings($min_string) };
print "There are " . scalar(@substrings) . " unique substrings\n";

my $longest_substring = '';
my %string_cache;
SUBSTRING: for my $dna ( @substrings ) {
    # TODO: Once you have failed to find a particular substring
    # anywhere you will then fail to find any other substring
    # which contains that substring.
    # Create substr to test
    # print "Examining $dna\n";
    for my $string (@dnas) {
        next SUBSTRING unless $string =~ /$dna/;
    }
    # if we're here we have a new longest substring;
    if ( length($dna) > length($longest_substring) ) {
        $longest_substring = $dna;
        # Because we've sorted from longest to shortest
        last;
    }
}

print $longest_substring, "\n";


