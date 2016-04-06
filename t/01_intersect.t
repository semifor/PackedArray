BEGIN {
    $| = 1;
    print "1..7\n";
}
use PackedArray qw/:all/;

# overlapped
$l = array_to_packed(1..10); $r = array_to_packed(6..15);
intersect_packed($l, $r);
@l = packed_to_array($l);
print "@l" eq '6 7 8 9 10' ? "ok 1\n" : "not ok 1 # @l\n";

# disjoint
$l = array_to_packed(1..10); $r = array_to_packed(11..20);
intersect_packed($l, $r);
@l = packed_to_array($l);
print "@l" eq '' ? "ok 2\n" : "not ok 2 # @l\w";

# same
$l = array_to_packed(1..10); $r = $l;
intersect_packed($l, $r);
@l = packed_to_array($l);
print "@l" eq '1 2 3 4 5 6 7 8 9 10' ? "ok 3\n" : "not ok 3 # @l\w";

# left includes right
$l = array_to_packed(1..10); $r = array_to_packed(3..7);
intersect_packed($l, $r);
@l = packed_to_array($l);
print "@l" eq '3 4 5 6 7' ? "ok 4\n" : "not ok 4 # @l\w";

# right includes left
$l = array_to_packed(6..10); $r = array_to_packed(1..10);
intersect_packed($l, $r);
@l = packed_to_array($l);
print "@l" eq '6 7 8 9 10' ? "ok 5\n" : "not ok 5 # @l\w";

# right empty
$l = array_to_packed(1..10); $r = '';
intersect_packed($l, $r);
@l = packed_to_array($l);
print "@l" eq '' ? "ok 6\n" : "not ok 6 # @l\w";

# left empty
$l = ''; $r = array_to_packed(1..10);
intersect_packed($l, $r);
@l = packed_to_array($l);
print "@l" eq '' ? "ok 7\n" : "not ok 7 # @l\w";
