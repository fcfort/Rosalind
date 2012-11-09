#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;
use Algorithm::ChooseSubsets;

my @dnas;
while(defined(my $dna = Common::read_line)) {
#     push(@dnas, $dna);
}

push(@dnas, Common::generate_dna(rand(1000) + 100)) for (0 .. 100);

# sort so min length array is first
@dnas = sort { length($a) <=> length($b) } @dnas;

# print Dumper(\@dnas);

# Iterate through all substrings of min string
# and search for matches in all other strings
#
my $min_string = shift @dnas;
print "Smallest string is $min_string\n";
my $i = Algorithm::ChooseSubsets->new([split //, $min_string]);

my $longest_substring = '';
my %string_cache;
SUBSTRING: while(my $dna = $i->next) {
    # Once you have failed to find a particular substring
    # anywhere you will then fail to find any other substring
    # which contains that substring.
    # Create substr to test
    my $substring = join("", @$dna);
    # Skip substrings we've seen before
    next if exists $string_cache{$substring};
    $string_cache{$substring} = 1;
    print "Examining $substring\n";
    for my $string (@dnas) {
        next SUBSTRING unless $string =~ /$substring/;
    }
    # if we're here we have a new longest substring;
    if ( length($substring) > length($longest_substring) ) {
        $longest_substring = $substring;
    }
}

print $longest_substring, "\n";


