PackedArray.pm
==============

A perl XS module for fast set operations on 64-bit integer arrays.

Install
-------
```
perl Makefile.PL
make install
```

Usage
-----
Basic example:
```perl
use Packed::Array qw/:all/;

my $left  = array_to_packed(1..100);
my $right = array_to_packed(11..110);
unique_packed($left, $right);

say join ',' => packed_to_array($left);
say join ',' => packed_to_array($right);
```
Output:
```
1,2,3,4,5,6,7,8,9,10
101,102,103,104,105,106,107,108,109,110
```

Author
-------

* [Marc Mims](https://github.com/semifor)

