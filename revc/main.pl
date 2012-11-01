#!perl -pl

$_ =~ tr/ATCG/TAGC/;

$_ = join("", reverse split(//, $_));
