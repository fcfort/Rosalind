#!perl
use strict;
use warnings;
use lib '../common';
use Common;

my $main_string = Common::read_line();
my $sub_string = Common::read_line();

use Data::Dumper;

my $len = length($sub_string);

map { } 0 .. length($main_string)
