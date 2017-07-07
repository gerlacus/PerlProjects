#!/usr/bin/perl

# Max Messenger Bouricius
# July 2017
# Perl program to figure out whether or not an input positive integer is 'happy' -- that is, the
# sum of its digits each squared (and then repeated with the new sum) will eventually equal 1.
# For example, 19 is a happy number:
#   1^2 + 9^2 = 82
#   8^2 + 2^2 = 68
#   6^2 + 8^2 = 100
#   1^2 + 0^2 + 0^2 = 1.
# This program takes in an integer and prints to the console the steps until either the number
# reaches 1 (happy) or it falls into a non-1 cycle (sad).

use strict;
use warnings;
use v5.18.0;

# General idea: take in number, check if happy, print to console as progress is made
sub checkIfHappy {
    my $inStr = $_[0];                                      # Input number; for next call, this will be sum found at end of this iteration
    my $origNum = $_[1];                                    # Original number put into first call; does not change from call to call
    my $totalSum = 0;                                       # Sum of all digits squared; tallied within main loop of function
    my @badCycle = (4, 16, 37, 58, 89, 145, 42, 20, 4);     # The 'cycle of doom' that all sad numbers eventually fall into
    my $currentIteration = $_[2];                           # Which iteration of the check this call is working through

    # Gets rid of warning message about smartmatch (~~)
    no if $] >= 5.017011, warnings => "experimental::smartmatch";
    
    # Header info: iteration number, current number being checked
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

    # If sum is 1 (happy)
    if ($totalSum == 1) {
        print "Success! $origNum is a happy number!\n";
        return;
    }
    # Else if sum is part of non-one cycle (sad)
    elsif ($totalSum ~~ @badCycle) {
        print "$origNum falls into cycle (";
        foreach my $i (0..@badCycle - 1) {
            print "$badCycle[$i], ";
        }
        print "...), and therefore is not a happy number.\n";
        return;
    }
    # Else (if proven neither happy nor sad yet) continue iterating
    else {
        print "\n";
        checkIfHappy($totalSum, $origNum, $currentIteration + 1);
    }
}

# Check if input is valid before running
my $inputString = $ARGV[0];
# If no arguments passed in
if (!$inputString) {
    die "Usage: $0 POSITIVE_INTEGER\n";
}
# If arg passed in but invalid (not positive, nonzero integer)
if (($inputString <= 0) || ($inputString =~ /\D/)) {
    die "ERROR: input must be a positive, nonzero integer.\n";
}

# Else input is valid; begin recursive calls to checkIfHappy
print "Your input: $inputString\n";
checkIfHappy($ARGV[0], $ARGV[0], 1);
