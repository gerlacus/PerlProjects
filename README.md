# Practice Perl Project Collection
Various little projects to familiarize myself with Perl. 
Though some may say Perl is a dying language, it's still a language that I've always wanted to learn.
Luckily, when I don't have any projects to work on, my boss is letting me learn more programming skills on my own. Woohoo!
I will grow this repository as I develop more Perl code, but for now it is in an unfortunate state of "not having any Perl code".

#

<h3>Projects:</h3>
<h5>Triangle Generator (2test_TriangleGenerator.pl)</h5>
Simple program that takes input size / string from user and creates a pyramid of said string as tall as the size specified.
Whipped up in a few minutes, this was more or less a way to familiarize myself with the conventions of Perl (e.g. $calars and foreach loop syntax).

<h5>Happy Number Finder (3test_HappyNumbers.pl)</h5>
Takes input of a positive integer and checks whether or not that integer is 'happy' -- that is, the sum of each of its digits squared and then repeated with this new sum over and over will eventually equal 1.
For example, 19 is a happy number:
<ol>
  <li> 19 -> 1^2 + 9^2 = 1 + 81 = 82 </li>

  <li> 82 -> 8^2 + 2^2 = 64 + 4 = 68 </li>

  <li> 68 -> 6^2 + 8^2 = 36 + 64 = 100 </li>

  <li> 100 -> 1^2 + 0^2 + 0^2 = 1 </li>
</ol>
Because the end result is 1, this number is happy.

If a number is not happy, it will fall into the following cycle:
 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4 -> ... and will never reach 1.
 This script will run through iterations of an input until it either reaches 1 (in which case the number is happy) or it falls into the cycle described above (in which case the number is not happy, or 'sad').
 
 Some other neat properties of happy numbers include:
 <ul>
   <li> Large integers are very quickly reduced to smaller ones. For example: 
    <ol>
      <li> 123456789 -> 1^2 + 2^2 + 3^2 + 4^2 + 5^2 + 6^2 + 7^2 + 8^2 + 9^2 = 285 </li>
      <li> 285 -> 2^2 + 8^2 + 5^2 = 93, etc... </li>
    </ol>
   </li>
   <li> A number's happiness is unchanged by adding zeros between any of the integers. For example, 19 is a happy number, but so is 190, 109, or 100,090. </li>
   <li> A number's happiness is unchanged by rearranging the digits in the number. For example, 176 is a happy number, and thus so are 167, 716, 761, 671, and 617. </li>
 </ul>
 
More information on happy numbers can be found [here](https://en.wikipedia.org/wiki/Happy_number).

<h5>Fat-Fingered Word Count (4test_FuzzyWordCount.pl)</h5>
Word-counting tool that takes a number of typos of a given word into account when searching.
Based on the original word the user passes in, the program recursively creates permutations of words that are <i>almost</i> the original word based on keys adjacent to the ones used in the original word.
For example, a search for "cat" would yield searches for "xat", "cst", "car", etc as well.
The user can pass in a float between 0 and 1 as a threshold for how similar to the original word the permutations must be in order to be searched, calculated by dividing the number of characters that match the original by the total number of characters;
 a value of 0 will search anything even remotely near the original word, whereas a value of 1 will only accept a perfect match with the original word. If the user puts nothing in, I plan to use a default accuracy threshold of 0.6.

This script is under heavy construction; so far the script will take in a file (with which it currently does nothing) and an input word (no threshold to pass in just yet).
