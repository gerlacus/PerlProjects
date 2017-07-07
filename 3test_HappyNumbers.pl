#!/usr/bin/perl

# Max Messenger Bouricius
# July 2017
# Perl program to figure out whether or not an input positive integer is 'happy' -- that is, the sum of its digits each
# squared and then repeated with the new sum will eventually equal 1.
# For example, 19 is a happy number:
#   1^2 + 9^2 = 82
#   8^2 + 2^2 = 68
#   6^2 + 8^2 = 100
#   1^2 + 0^2 + 0^2 = 1.
# This program takes in an integer and prints to the console the steps until either the number reaches 1 or it falls into a non-1 cycle.

use strict;
use warnings;
use v5.18.0;

# General idea: take in number, check if happy, print process to console
sub checkIfHappy {
    my $inStr = $_[0];
    my $origNum = $_[1];
    my $totalSum = 0;
    my @badCycle = (4, 16, 37, 58, 89, 145, 42, 20, 4);
    my $currentIteration = $_[2];

    # Gets rid of warning message about smartmatch (~~)
    no if $] >= 5.017011, warnings => "experimental::smartmatch";
    
    print "ITERATION $currentIteration: checking if $inStr is happy...\n";
    my @charArray = split('', $inStr, length($inStr));
    # Print each individual piece of equation while also keeping track of final sum
    foreach my $i (0..length($inStr) - 1) {
        $totalSum += $charArray[$i] ** 2;
        print "$charArray[$i]^2";
        if ($i < length($inStr) - 1) {
            print " + ";
        }
    }
    print " = $totalSum\n";

    # Check whether $totalSum = 1 or if it's non-one
    if ($totalSum == 1) {
        print "Success! $origNum is a happy number!\n";
        return;
    }
    elsif ($totalSum ~~ @badCycle) {
        print "$origNum falls into cycle (";
        foreach my $i (0..@badCycle - 1) {
            print "$badCycle[$i], ";
        }
        print "...), and therefore is not a happy number.\n";
        return;
    }
    else {
        print "\n";
        checkIfHappy($totalSum, $origNum, $currentIteration + 1);
    }
}

# Check if input is valid
my $inputString = $ARGV[0];
my $unparsed = $inputString;
# For second conditional, (_ + 2) % (_ + 1)) in order to account for floats between 0 and 0.5 (since _ % 0 throws error)
if (($inputString <= 0) || (($inputString + 2) % ($inputString + 1) != 1)) {
    die "ERROR: input must be a positive, nonzero integer.\n";
}
print "Your input: $inputString\n";
checkIfHappy($ARGV[0], $ARGV[0], 1);
