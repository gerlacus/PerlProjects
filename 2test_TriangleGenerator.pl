#!/usr/bin/perl

# Max Messenger Bouricius
# July 2017
# Simple program that takes input size / string from user and creates a pyramid of said string as tall as
# the size specified. Whipped up in a few minutes, this was more or less a way to familiarize myself with
# the conventions of Perl (including $scalars and foreach loop syntax).

use strict;
use warnings;

print "Please enter a size: ";
chomp(my $size = <>);
print "Please choose a character/string to make the tree out of: ";
chomp(my $string = <>);
foreach my $i (1..$size) {
    print " " x ((length($string))*(($size - $i) / 2)) . "$string" x $i . "\n";
}
print "What a wonderful pile of $string.\n";
