#!/usr/bin/perl

# Max Messenger Bouricius
# July 2017
# Perl program that takes file as input

use strict;
use warnings;

my $filename = $ARGV[0];
my $searchString = lc $ARGV[1];
# 
my $accuracyThreshold = $ARGV[2];               # All accuracies >= this value will be searched


# TODO: remove test eventually
my %fuzzKeys = ( a => 'aqwsz',
    b => ['b', 'g', 'h', 'v', 'n'],
    c => ['c', 'd', 'f', 'x', 'v'],
    d => ['d', 'w', 'e', 'r', 's', 'f', 'x', 'c'],
    e => ['e', '3', '4', 'w', 'r', 's', 'd', 'f'],
    f => ['f', 'e', 'r', 't', 'd', 'g', 'c', 'v'],
    g => ['g', 'r', 't', 'y', 'f', 'h', 'v', 'b'],
    h => ['h', 't', 'y', 'u', 'g', 'j', 'b', 'n'],
    i => ['i', '8', '9', 'u', 'o', 'j', 'k', 'l'],
    j => ['j', 'y', 'u', 'i', 'h', 'k', 'n', 'm'],
    k => ['k', 'u', 'i', 'o', 'j', 'l', 'm', ','],
    l => ['l', 'i', 'o', 'p', 'k', ';', ',', '.'],
    m => ['m', 'j', 'k', 'n', ','],
    n => ['n', 'h', 'j', 'b', 'm'],
    o => ['o', '9', '0', 'i', 'p', 'k', 'l', ';'],
    p => ['p', '0', '-', 'o', '[', 'l', ';', "'"],
    q => ['q', '1', '2', 'w', 'a', 's'],
    r => ['r', '4', '5', 'e', 't', 'd', 'f', 'g'],
    s => ['s', 'q', 'w', 'e', 'a', 'd', 'z', 'x'],
    t => ['t', '5', '6', 'r', 'y', 'f', 'g', 'h'],
    u => ['u', '7', '8', 'y', 'i', 'h', 'j', 'k'],
    v => ['v', 'f', 'g', 'c', 'b'],
    w => ['w', '2', '3', 'q', 'e', 'a', 's', 'd'],
    x => ['x', 's', 'd', 'z', 'c'],
    y => ['y', '6', '7', 't', 'u', 'g', 'h', 'j'],
    z => ['z', 'a', 's', 'x'] );

=begin
for (keys %fuzzKeys) {

    print "$_: $fuzzKeys{$_}\n";
}
=cut

print "String to search: $searchString\n";

open (MYFILE, '<', $filename) or die "Can't open $filename: $!";
while (<MYFILE>) {
    chomp;
    #print "$_\n";
}

# Takes in original %fuzzKeys and converts the values from strings to arrays
# Input: %fuzzKeys
# Output: %newFuzzKeys
sub convertFuzzStringsToArrays {
    my %newHash = ();
    #my %inputHash = $_[0];
    my %inputHash = %{$_[0]};
    my @hashesSplitFull = ();
    my @hashString = ();
    my $inc = 0;
    for (keys %inputHash) {
        print "\$inputHash{$_} = $inputHash{$_}\n";
        @hashString = split('', $inputHash{$_}, length($inputHash{$_}));
        #print "FWEF1 $inc\n";
        print "\@hashString = @hashString\n";
        $newHash{$_} = @hashString;
        my $testLen = length($newHash{$_});
        print "length(\$newHash{\$_}: $testLen\n";
        #foreach my $i (0..length($newHash{$_})) {
        #   print "$i and $newHash{$_}";
        #   print "$i\n";
            #print "$newHash{$_}[$i] ";
            #}
        $inc ++;
    }

    for my $family (keys %newHash) {
        print "$family: @{$newHash{$family}}\n";
        #foreach my $i (0..$newHash{$family}) {
            #print "     $family: $newHash{$family}[0]\n";
        #}
    }
}

sub generateFuzzes {
    # Output: array of strings, each being a permutation of 
}

sub testRecurse {
    # Inputs: current string 
    # Output: array with all perms up from that point onward

    # First fetch arrays to right of it
    # Then loop through that array, appending current letters onto it (nested fors)
    # Needs to know what's to right of it, though...
    # Also needs to know current array (passed in as string, then split)

    my $inputString = lc $_[0];
    my $trailingString;
    print "inputString: $inputString\n";
    # First character of array
    my $firstChar = $1 if ($inputString =~ /(^.)/);
    print "firstChar: $firstChar\n";

    # Main array that will be returned (if not last character)
    my @fullArray = ();

    # Array of adjacent characters to first character
    my @firstCharArray = @{$fuzzKeys{$firstChar}};

    if ($inputString =~ /^.(.+)/) {
        $trailingString = $1;
        print "trailingString: $trailingString\n";
        my @trailingArray = testRecurse($trailingString);
        for my $i (0..@firstCharArray - 1) {
            for my $j (0..@trailingArray - 1) {
                push (@fullArray, $firstCharArray[$i] . $trailingArray[$j]);
            }
        }
        return @fullArray;
    }
    else {
        print "NO MORE CHARACTERS LEFT OH NO\n";
        return @firstCharArray;
    }



    # TODO: iterate through array without indeces
    foreach my $nextItem (@{$fuzzKeys{$firstChar}}) {
        print "without indeces: $nextItem\n";
    }

    # TODO: iterate through array with indeces
    foreach my $i (0..@{$fuzzKeys{$firstChar}} - 1) {
        print "with index $i: ";
        print "$fuzzKeys{$firstChar}[$i]\n";
    }

    print "\@firstCharArray: @firstCharArray\n";


    #my @appendArray = testRecurse() # args: inputString without current member, index ++ ?
    # Base case: last char in inputString
    #   In which case, return array of chars in string
    # If not base case, for loops:
    #   for $i in currentArray:
    #       for $j in appendArray:
    #           add i + j to mainArray as perm
    #   return mainArray

}

sub getAccuracy {
    # Return the accuracy of a given permutation (from 0 to 1)
    # 1 = perfect match, 0 = no match
    # Input: permutation <str>, output accuracy <float>
    my @searchStringChars = split('', $searchString, length($searchString));
    my @inputStringChars = split('', lc $_[0], length($_[0]));

    # Iterators for overall accuracy
    my $totalSize = @searchStringChars;
    my $numberCorrect = 0;

    # Final verdict, also return variable
    my $accuracy = 0;

    #print "\@searchStringChars: @searchStringChars\n";
    #print "\@inputStringChars: @inputStringChars\n";

    foreach my $i (0..@searchStringChars - 1) {
        #print "$i: $searchStringChars[$i]\n";
        #print "   $inputStringChars[$i]\n";
        if ($searchStringChars[$i] ~~ $inputStringChars[$i]) {
            $numberCorrect += 1;
            #print "Match! current correct matches = $numberCorrect\n";
        }
    }

    $accuracy = $numberCorrect / $totalSize;
    print "Total accuracy = $numberCorrect / $totalSize = $accuracy\n";
    return $accuracy;
}

sub getAllAccuratePerms {
    my $threshold = $_[0];                  # All accuracies >= this value will be added to array
    my $inputPerms = $_[1];                 # Input array of permutations (reference)
    my $totalPerms = @_ - 2;                # Total number of permutations in input array
    my $placeHolderAccuracy = 0;            # Used to determine accuracies to add to return array
    my @returnArray = ();                   # Return array with permutations that are of acceptable accuracy

    print "********GETALLACCURATES********\n";
    print "threshold = $threshold\n";
    print "inputPerms $inputPerms\n";
    print "totalPerms $totalPerms\n";

    foreach my $i (0..$totalPerms - 1) {
        #print "$inputPerms->[$i], ";
        print "   ITERATION $i:  ";
        $placeHolderAccuracy = getAccuracy($inputPerms->[$i]);
        if ($placeHolderAccuracy >= $threshold) {
            push (@returnArray, $inputPerms->[$i]);
            print "Adding $inputPerms->[$i] to return array\n";
        }
    }
    return @returnArray;
}

# convertFuzzStringsToArrays(\%fuzzKeys);

# Given %fuzzKeys, can I directly create all relevant permutations?
    # answer: hell yeah you can.


#my @recurse = testRecurse("b", $fuzzKeys{'b'});
my @recurse = testRecurse($searchString);
print "                     @recurse\n";

# TODO: check all accuracies that are greater than given value (in this case, 0.5)
#getAccuracy($searchString);
my @accurates = getAllAccuratePerms(0.5, \@recurse, @recurse);
print "                     @accurates\n";
