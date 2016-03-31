package PackedArray;
use 5.14.1;
use warnings;
use Scalar::Util qw/blessed/;

BEGIN {
   our $VERSION = 0.01;

   require XSLoader;
   XSLoader::load ("PackedArray", $VERSION);
}

sub array_to_packed {
    pack 'q*', ref $_[0] eq 'ARRAY' ? @{shift()} : @_;
}

sub packed_to_array { unpack 'q*', shift }

use Sub::Exporter -setup => {
    exports => [qw/
        sort_packed
        dedup_packed
        unique_packed
        array_to_packed
        packed_to_array
    /],
};
1;
