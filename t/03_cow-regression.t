use warnings;
use strict;
BEGIN {
    $| = 1;
    print "1..14\n";
}
use PackedArray qw/:all/;

my $preserve = array_to_packed(6..15);
my $old = array_to_packed(1..10);
my $new = $preserve; # use a copy

unique_packed($new, $old);

for ( [ packed_to_array($new) ] ) {
    print "@$_" eq "11 12 13 14 15" ? "ok 1\n" : "not ok 1 # @$_\n";
}

for ( [ packed_to_array($old) ] ) {
    print "@$_" eq "1 2 3 4 5" ? "ok 2\n" : "not ok 2 # @$_\n";
}

for ( [ packed_to_array($preserve) ] ) {
    print "@$_" eq "@{[ 6..15 ]}" ? "ok 3\n" : "not ok 3 # @$_\n";
}

# test other messages for COW handling as well

{
    # sort_packed

    my @unordered = ( 10, 2, 9, 7, 1, 4, 8, 6, 3, 5 );
    my $packed = array_to_packed(@unordered);
    my $copy = $packed;
    sort_packed($copy);

    for ( [ packed_to_array($packed) ] ) {
        print "@$_" eq "@unordered" ? "ok 4\n" : "not ok 4 # @$_\n";
    }

    for ( [ packed_to_array($copy) ] ) {
        print "@$_" eq "@{[ 1..10 ]}" ? "ok 5\n" : "not ok 5 # @$_\n";
    }
}

{
    # dedup_packed
    my @dups = ( 1, 2, 2, 3, 3, 3, 4, 5, 5 );
    my $packed = array_to_packed(@dups);
    my $copy = $packed;
    dedup_packed($copy);

    for ( [ packed_to_array($packed) ] ) {
        print "@$_" eq "@dups" ? "ok 6\n" : "not ok 6 # @$_\n";
    }

    for ( [ packed_to_array($copy) ] ) {
        print "@$_" eq "@{[ 1..5 ]}" ? "ok 7\n" : "not ok 7 # @$_\n";
    }

}

{
    # compare_packed
    my @left = ( 1..10 );
    my @right = ( 6..15 );

    my $packed_left = array_to_packed(@left);
    my $copy_left = $packed_left;

    my $packed_right = array_to_packed(@right);
    my $copy_right = $packed_right;

    my $common = compare_packed($copy_left, $copy_right);

    for ( [ packed_to_array($copy_left) ] ) {
        print "@$_" eq "@{[ 1..5 ]}" ? "ok 8\n" : "not ok 8 # @$_\n";
    }

    for ( [ packed_to_array($copy_right) ] ) {
        print "@$_" eq "@{[ 11..15 ]}" ? "ok 9\n" : "not ok 9 # @$_\n";
    }

    for ( [ packed_to_array($packed_left) ] ) {
        print "@$_" eq "@left" ? "ok 10\n" : "not ok 10 # @$_\n";
    }

    for ( [ packed_to_array($packed_right) ] ) {
        print "@$_" eq "@right" ? "ok 11\n" : "not ok 11 # @$_\n";
    }
}

{
    # intersect_packed
    my @left = ( 1..10 );
    my @right = ( 6..15 );

    my $packed_left = array_to_packed(@left);
    my $copy_left = $packed_left;

    my $packed_right = array_to_packed(@right);
    my $copy_right = $packed_right;

    intersect_packed($copy_left, $copy_right);

    for ( [ packed_to_array($packed_right) ] ) {
        print "@$_" eq "@right" ? "ok 12\n" : "not ok 12 # @$_\n";
    }

    for ( [ packed_to_array($packed_left) ] ) {
        print "@$_" eq "@left" ? "ok 13\n" : "not ok 13 # @$_\n";
    }

    for ( [ packed_to_array($copy_left) ] ) {
        print "@$_" eq "@{[ 6..10 ]}" ? "ok 14\n" : "not ok 14 # @$_\n";
    }
}
