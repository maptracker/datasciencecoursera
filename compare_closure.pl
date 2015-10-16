#!/usr/bin/perl -w

# Comparing closure behavior in R and Perl

use strict;
my $z = 10;

# Prints 16
print &f(3);

sub f {
    my $x = shift;
    my $g = sub {
        my $y = shift;
        # This closure has not encountered the local $z below
        # So the closure "holds on to" the global value of $z defined above
        return $y + $z;
    };
    my $z = 4;
    return $x + &{$g}($x);
}
