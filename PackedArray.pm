package PackedArray;
use 5.14.1;
use warnings;
use Scalar::Util qw/blessed/;

BEGIN {
   our $VERSION = 0.05;

   require XSLoader;
   XSLoader::load ("PackedArray", $VERSION);
}

sub array_to_packed {
    pack 'q*', ref $_[0] eq 'ARRAY' ? @{shift()} : @_;
}

sub packed_to_array { unpack 'q*', shift // '' }

sub venn_segment_packed {
    my @venn;
    while ( @_ ) {
        my $top = @venn;
        push @venn, shift;
        for ( my $i = 0; $i < $top; ++$i ) {
            push @venn, compare_packed($venn[$i], $venn[$top]);
        }
    }
    return @venn;
}

use Sub::Exporter -setup => {
    exports => [qw/
        array_to_packed
        compare_packed
        count_packed
        dedup_packed
        intersect_packed
        packed_to_array
        sort_packed
        unique_packed
        venn_segment_packed
    /],
};

1;

__END__

=head1 NAME

PackedArray - Set operations on packed, 64-bit integer arrays

=head1 SYNOPSIS

    use PackedArray qw/:all/;

    my $left = array_to_packed(1..10);
    my $right = array_to_packed(6..15);
    unique_packed($left, $right);
    say sprintf 'left: %s, right: %s',
        join(' ', packed_to_array($left)),
        join(' ', packed_to_array($right));

    # left: 1 2 3 4 5, right: 11 12 13 14 15

=head1 DESCRIPTION

Set functions on packed, 64-bit integer arrays, implemented in XS for speed.

=head1 FUNCTIONS

=over 4

=item array_to_packed(@integers)

=item array_to_packed(\@integers)

Returns a string of packed 64-bit integers.

=item compare_packed($left, $right)

Takes two, sorted, packed arrays of 64-bit integers. Returns a packed, sorted,
64-bit array of unique integers common to both C<$left> and C<$right>. Both
C<$left> and C<$right> are modified to remove the common integers. I.e., on
return they will contain only their unique elements.

=item count_packed($packed)

Returns the count of elements in a packed array of 64-bit integers.

=item dedup_packed($packed)

De-duplicate elements in a sorted, packed array of 64-bit integers, in place.
The array will be shortened by the number of duplicates.

=item intersect_packed($left, $right)

Takes two, sorted, packed arrays of 64-bit integers. On return C<$left>
contains the intersection of the two arrays.

=item packed_to_array($packed)

Returns a list of integers by unpacking C<$packed>.

=item sort_packed($packed)

Sorts a packed array of 64-bit integers, in-place.

=item unique_packed($left, $right)

Reduces C<$left> and C<$right> to their unique elements. Both arguments must be
sorted and de-duplicated, first.

=back

=head1 AUTHOR

Marc Mims <mmims@cpan.org>

=cut
