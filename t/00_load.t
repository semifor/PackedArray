use warnings;
use strict;
my $loaded;
BEGIN { $| = 1; print "1..24\n"; }
END { print "not ok 1\n" unless $loaded }
use PackedArray qw/:all/;
$loaded = 1;
print "ok 1\n";

my ( $l, $r, $p, @l, @r, @p );

# unique_packed
$l = pack 'q*', 1..100; $r = pack 'q*', 11..105;
unique_packed($l, $r);
@l = unpack 'q*', $l; @r = unpack 'q*', $r;
print "@l" eq '1 2 3 4 5 6 7 8 9 10' ? "ok 2\n" : "not ok 2 # @l\n";
print "@r" eq '101 102 103 104 105'  ? "ok 3\n" : "not ok 3 # @r\n";

# unique, left empty
unique_packed($l = '', $r = pack 'q*', 1..3);
@l = unpack 'q*', $l; @r = unpack 'q*', $r;
print "@l" eq ''      ? "ok 4\n" : "not ok 4 # @l\n";
print "@r" eq '1 2 3' ? "ok 5\n" : "not ok 4 # @r\n";

# unique right empty
$l = pack 'q*', 1..3; $r = '';
unique_packed($l, $r);
@l = unpack 'q*', $l;
@r = unpack 'q*', $r;
print "@l" eq '1 2 3' ? "ok 6\n" : "not ok 6 # @l\n";
print "@r" eq ''      ? "ok 7\n" : "not ok 7 # @r\n";

# unique, both empty
$l = $r = ''; unique_packed($l, $r);
print $l eq '' ? "ok 8\n" : "not ok 8 # left empty\n";
print $r eq '' ? "ok 9\n" : "not ok 9 # right empty\n";

# unique, equivalent
$l = $r = pack 'q*', 1..3;
unique_packed($l, $r);
print $l eq '' ? "ok 10\n" : "not ok 10 # left empty\n";
print $r eq '' ? "ok 11\n" : "not ok 11 # right empty\n";

# sort
$p = pack 'q*', 9, 8, 4, 2, 3, 5;
sort_packed($p);
@p = unpack 'q*', $p;
print "@p" eq '2 3 4 5 8 9' ? "ok 12\n" : "not ok 12 # sort @p\n";

# sort empty
$p = '';
sort_packed($p);
@p = unpack 'q*', $p;
print "@p" eq '' ? "ok 13\n" : "not ok 13 # sort empty\n";

# dedup all
$p = pack 'q*', 1, 1, 1, 1;
dedup_packed($p);
@p = unpack 'q*', $p;
print "@p" eq '1' ? "ok 14\n" : "not ok 14 # dedup @p\n";

# dedup first
dedup_packed($p = pack 'q*', 1, 1, 2, 3);
@p = unpack 'q*', $p;
print "@p" eq '1 2 3' ? "ok 15\n" : "not ok 15 # dedup first @p\n";

# dedup last
dedup_packed($p = pack 'q*', 1, 2, 3, 3);
@p = unpack 'q*', $p;
print "@p" eq '1 2 3' ? "ok 16\n" : "not ok 16 # dedup last @p\n";

# dedup several
dedup_packed($p = pack 'q*', 1, 1, 2, 2, 3, 3, 3);
@p = unpack 'q*', $p;
print "@p" eq '1 2 3' ? "ok 17\n" : "not ok 17 # dedup several @p\n";

# dedup empty
$p = '';
@p = dedup_packed($p);
print "@p" eq '' ? "ok 18\n" : "not ok 18 # dedup empty\n";

# pack list
$p = array_to_packed(4, 3, 1, 2);
@p = unpack 'q*', $p;
print "@p" eq '4 3 1 2' ? "ok 19\n" : "not ok 19 # pack list @p\n";

# pack arrayref
$p = array_to_packed([ 1, 2, 3]);
@p = unpack 'q*', $p;
print "@p" eq '1 2 3' ? "ok 20\n" : "not ok 20 # pack arrayref @p\n";

# pack empty list
$p = array_to_packed();
print $p eq '' ? "ok 21\n" : "not ok 21 # pack empty list\n";

# pack empty arrayref
$p = array_to_packed([]);
print $p eq '' ? "ok 22\n" : "not ok 22 # pack empty arrayref\n";

# unpack
$p = pack 'q*', 1..3;
@p = packed_to_array($p);
print "@p" eq '1 2 3' ? "ok 23\n" : "not ok 23 # unpack @p\n";

# unpack empty
@p = packed_to_array($p = '');
print "@p" eq '' ? "ok 24\n" : "not ok 24 # unpack empty @p\n";
