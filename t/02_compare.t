use strict;
use warnings;
BEGIN {
    $| = 1;
    print "1..15\n";
}
use PackedArray qw/:all/;

my ( $l, $r, $c, @l, @r, @c );

# overlapped
$l = array_to_packed(1..10); $r = array_to_packed(6..15);
$c = compare_packed($l, $r);
@l = packed_to_array($l);
@r = packed_to_array($r);
@c = packed_to_array($c);
print "@l" eq '1 2 3 4 5'      ? "ok 1\n" : "not ok 1 # @l\n";
print "@r" eq '11 12 13 14 15' ? "ok 2\n" : "not ok 2 # @r\n";
print "@c" eq '6 7 8 9 10'     ? "ok 3\n" : "not ok 3 # @c\n";

# disjoint
$l = array_to_packed(1..5); $r = array_to_packed(6..10);
$c = compare_packed($l, $r);
@l = packed_to_array($l);
@r = packed_to_array($r);
@c = packed_to_array($c);
print "@l" eq '1 2 3 4 5'  ? "ok 4\n" : "not ok 4 # @l\n";
print "@r" eq '6 7 8 9 10' ? "ok 5\n" : "not ok 5 # @r\n";
print "@c" eq ''           ? "ok 6\n" : "not ok 6 # @c\n";

# left empty
$l = array_to_packed(); $r = array_to_packed(6..10);
$c = compare_packed($l, $r);
@l = packed_to_array($l);
@r = packed_to_array($r);
@c = packed_to_array($c);
print "@l" eq ''           ? "ok 7\n" : "not ok 7 # @l\n";
print "@r" eq '6 7 8 9 10' ? "ok 8\n" : "not ok 8 # @r\n";
print "@c" eq ''           ? "ok 9\n" : "not ok 9 # @c\n";

# right empty
$l = array_to_packed(1..5); $r = array_to_packed();
$c = compare_packed($l, $r);
@l = packed_to_array($l);
@r = packed_to_array($r);
@c = packed_to_array($c);
print "@l" eq '1 2 3 4 5' ? "ok 10\n" : "not ok 10 # @l\n";
print "@r" eq ''          ? "ok 11\n" : "not ok 11 # @r\n";
print "@c" eq ''          ? "ok 12\n" : "not ok 12 # @c\n";

# both empty
$l = array_to_packed(); $r = array_to_packed();
$c = compare_packed($l, $r);
@l = packed_to_array($l);
@r = packed_to_array($r);
@c = packed_to_array($c);
print "@l" eq '' ? "ok 13\n" : "not ok 13 # @l\n";
print "@r" eq '' ? "ok 14\n" : "not ok 14 # @r\n";
print "@c" eq '' ? "ok 15\n" : "not ok 15 # @c\n";
