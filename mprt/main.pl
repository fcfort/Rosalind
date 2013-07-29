#!perl
use strict;
use warnings;
use lib '../common';
use Common;
use Data::Dumper;
use LWP::Simple;


while(defined(my $uniprot_id = Common::read_line)) {
    my $url = "http://www.uniprot.org/uniprot/$uniprot_id.fasta";
    
    # print "URL $url\n";
    
    my $content = get($url);
    die "Couldn't get $url!" unless defined $content;
    
    my $fasta = Common::parse_fasta($content);
   
    #print Dumper($fasta);

    # Motif of interest is N{P}[ST]{P}.
    my $motif_re = qr/N[^P][ST][^P]/;

    for (values %$fasta) {
        my @posns = Common::get_match_positions($motif_re, $_);
        next if @posns == 0;
        # Add 1 as function returns based on 0-index
        map { $_++ } @posns;
        print "$uniprot_id\n" . join(" ", @posns) . "\n";
    }
}

