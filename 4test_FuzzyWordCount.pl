#!/usr/bin/perl

# Max Messenger Bouricius
# July 2017
# Perl program that takes file as input

use strict;
use warnings;
use v5.18.0;

# Get rid of pesky smartmatch warnings
no if $] >= 5.017011, warnings => "experimental::smartmatch";

die "Usage: $0 <file> <word> <threshold (optional)>\n" if ((@ARGV < 2) || (@ARGV > 3));
#my $filename = shift or die "Usage: $0 <file> <word> <threshold>\n";
my $filename = $ARGV[0];
my $searchString = lc $ARGV[1];
my $accuracyThreshold = 0.5;
$accuracyThreshold = $ARGV[2] if (@ARGV == 3);

my %accurateCounts = ();
my $totalAccuratesInFile = 0;                   # Total word count tally of all variations within file
my @uniqueFoundPerms = ();                      # 


# Check to see if valid search string (single word of alpha characters)
if (($searchString =~ /\W/) || ($searchString =~ /\d+/)) {
    die "Invalid search string (must be single word, with no spaces or numbers).\n";
}

# Make sure accuracy threshold is in proper bounds (between 0 and 1)
if ( (@ARGV != 3) || ($accuracyThreshold =~ /\D/) || ($accuracyThreshold < 0) || ($accuracyThreshold > 1)) {
    print "Accuracy threshold missing or invalid (0 <= threshold <= 1). Continuing with default threshold of 0.5.\n";
    $accuracyThreshold = 0.5;
}

my %fuzzKeys = ( a => ['a', 'q', 'w', 's', 'z'],
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

print "String to search: '$searchString'\n";

# Grab filename from command line, attempt to open
open my $fh, '<', $filename or die "Could not open '$filename' $!";

sub createInitialPermsRecursive {
    # Inputs: current string 
    # Output: array with all perms up from that point onward

    # First fetch arrays to right of it
    # Then loop through that array, appending current letters onto it (nested fors)
    # Needs to know what's to right of it, though...
    # Also needs to know current array (passed in as string, then split)

    my $inputString = lc $_[0];
    my $trailingString;
    my $firstChar = $1 if ($inputString =~ /(^.)/);

    # Main array that will be returned (if not last character)
    my @fullArray = ();

    # Array of adjacent characters to first character
    my @firstCharArray = @{$fuzzKeys{$firstChar}};

    if ($inputString =~ /^.(.+)/) {
        $trailingString = $1;
        #print "trailingString: $trailingString\n";
        my @trailingArray = createInitialPermsRecursive($trailingString);
        for my $i (0..@firstCharArray - 1) {
            for my $j (0..@trailingArray - 1) {
                push (@fullArray, $firstCharArray[$i] . $trailingArray[$j]);
            }
        }
        return @fullArray;
    }
    else {
        return @firstCharArray;
    }
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
    #print "Total accuracy = $numberCorrect / $totalSize = $accuracy\n";
    return $accuracy;
}

sub getAllAccuratePerms {
    # Takes all initial permutations and filters out the ones that don't meet the basic accuracy threshold passed in.
    # Input: threshold between 0 and 1 <float>, initial permutations <array>, length of initial permutations list
    my $threshold = $_[0];                  # All accuracies >= this value will be added to array
    my $inputPerms = $_[1];                 # Input array of permutations (reference)
    my $totalPerms = @_ - 2;                # Total number of permutations in input array
    my $placeHolderAccuracy = 0;            # Used to determine accuracies to add to return array
    my @returnArray = ();                   # Return array with permutations that are of acceptable accuracy

    # If accuracy of perm passes threshold, add it to @returnArray
    foreach my $i (0..$totalPerms - 1) {
        $placeHolderAccuracy = getAccuracy($inputPerms->[$i]);
        if ($placeHolderAccuracy >= $threshold) {
            push (@returnArray, $inputPerms->[$i]);
        }
    }
    return @returnArray;
}

# Create initial permutation list
print "Creating list of all permutations of adjacent keystrokes...\n";
my @recurse = createInitialPermsRecursive($searchString);

# Handle grammar of singular versus plural (initial perms)
my $printPerm = "permutations";
if (@recurse == 1) {
    $printPerm = "permutation";
}

# Notify user when initial list has been created
print "   List created with " . @recurse . " $printPerm.\nParsing list into most accurate variations...this may take some time.\n";
my @accurates = getAllAccuratePerms($accuracyThreshold, \@recurse, @recurse);

# Handle grammar of singular versus plural (accurate perms)
my $printPerm2 = "permutations";
if (@accurates == 1) {
    $printPerm2 = "permutation";
}

# Notify user when accurate list has been created
print "   Parsing complete! Using accuracy threshold of $accuracyThreshold, "
    . @recurse . " general permutations reduced to "
    . @accurates . " 'accurate' $printPerm2 (";
printf("%.3f", (@accurates / @recurse) * 100);
print "% of original size).\n";

# Find words in input file
print "Searching file for $printPerm2...\n";
while (my $line = <$fh>) {
    chomp $line;
    foreach my $perm (@accurates) {
        foreach my $word (split /\s+/, $line) {
            if ($word ~~ $perm) {
                $accurateCounts{$word} ++;
                $totalAccuratesInFile ++;

                # Add to uniqueFoundPerms list if not already there
                push (@uniqueFoundPerms, $perm);
            }
        }
    }
}

print "   Search complete. Each of the following variations of '$searchString' were found in '$filename':\n";

#TODO: sort output by accuracy

# Reduce @uniqueFoundPerms to unique set
sub uniq {
    my %alreadySeen;
    grep !$alreadySeen{$_}++, @_;
}
@uniqueFoundPerms = uniq(@uniqueFoundPerms);

# Add accuracies to each unique permutation found in file, then sort by accuracy
foreach my $i (0..@uniqueFoundPerms - 1) {
    $uniqueFoundPerms[$i] = getAccuracy($uniqueFoundPerms[$i]) . " $uniqueFoundPerms[$i]";
    #print "  $uniqueFoundPerms[$i]\n";
}
@uniqueFoundPerms = sort {$b cmp $a} @uniqueFoundPerms;

my $grabbedPerm;
#for (keys %accurateCounts) {

# Print header for table
print "\tPERMUTATION\t\tFREQUENCY\tACCURACY\n";

foreach my $i (0..@uniqueFoundPerms - 1) {
    $grabbedPerm = $1 if ($uniqueFoundPerms[$i] =~ /\s(\w+)/);
    #print " GRABBED PERM: $grabbedPerm\n";
    print "\t'$grabbedPerm'\t\t$accurateCounts{$grabbedPerm}\t\t";
    #print "\t (accuracy: ";
    printf ("%.2f", getAccuracy($grabbedPerm) * 100);
    print "%\n";
}

print "Total number of appearances, including typos: $totalAccuratesInFile\n";
