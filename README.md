# Practice Perl Project Collection
Various little projects to familiarize myself with Perl. 
Though some may say Perl is a dying language, it's still a language that I've always wanted to learn.
Luckily, when I don't have any projects to work on, my boss is letting me learn more programming skills on my own. Woohoo!
I will grow this repository as I develop more Perl code, but for now it is in an unfortunate state of "not having any Perl code".

#

<h3>Projects:</h3>
<h5>Pyramid Generator (2test.pl)</h5>
Simple program that takes input size / string from user and creates a pyramid of said string as tall as the size specified.
Whipped up in a few minutes, this was more or less a way to familiarize myself with the conventions of Perl (e.g. $calars and foreach loop syntax).

<h5>Happy Number Finder (3test_HappyNumbers.pl)</h5>
Takes input of a positive integer and checks whether or not that integer is 'happy' -- that is, the sum of each of its digits squared and then repeated with this new sum over and over will eventually equal 1.
For example, 19 is a happy number:
19 -> 1^2 + 9^2 = 1 + 81 = 82
82 -> 8^2 + 2^2 = 64 + 4 = 68
68 -> 6^2 + 8^2 = 36 + 64 = 100
100 -> 1^2 + 0^2 + 0^2 = 1
Because the end result is 1, this number is happy.

If a number is not happy, it will fall into the following cycle:
4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4 -> ...

