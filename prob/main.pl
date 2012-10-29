#!perl -n

print join(" ", map { 
    my $p = $_ / 2;
    my $q = (1 - $_) / 2;

    sprintf("%.6f", (2*$p**2 + 2*$q**2));
    
    } split(/ /, $_ ) 
) 
