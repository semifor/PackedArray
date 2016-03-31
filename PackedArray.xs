#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdlib.h>
#include <stdint.h>

typedef struct {
    int64_t *start, *end, *tail, *p;
} packed_array;

packed_array init_packed_array (SV *packed)
{
    packed_array p;
    STRLEN len;
    p.start = (int64_t*)SvPV(packed, len);
    p.end   = p.start + len / sizeof(int64_t);
    p.tail = p.p = p.start;
    return p;
}

void finalize_packed_array (SV *packed, packed_array p)
{
    SvCUR_set(packed, (p.tail - p.start) * sizeof(int64_t));
}

int comp (const void * elem1, const void * elem2)
{
    int64_t a = *((int64_t*)elem1);
    int64_t b = *((int64_t*)elem2);
    if (a > b) return  1;
    if (a < b) return -1;
    return 0;
}

static void
sort_packed (char *packed, int len)
{
    qsort(packed, len / sizeof(int64_t), sizeof(int64_t), comp);
}

static void
dedup_packed (SV *packed)
{
    STRLEN len;
    int64_t *start = (int64_t*)SvPV(packed, len);
    int n          = len / sizeof(int64_t);
    int64_t *end   = start + n;
    int64_t *tail  = start + 1;
    int64_t *p     = tail;

    while ( p < end ) {
        if ( *p != *(p - 1) ) {
            if ( p != tail )
                *tail = *p;
            ++tail;
        }
        ++p;
    }

    if ( tail < end )
        SvCUR_set(packed, (tail - start) * sizeof(int64_t));
}

static void
unique_packed (SV *asv, SV *bsv)
{
    packed_array a = init_packed_array(asv);
    packed_array b = init_packed_array(bsv);

    int i = 0;
    while ( a.p < a.end || b.p < b.end ) {
        if ( a.p == a.end )
            *(b.tail++) = *(b.p++);
        else if ( b.p == b.end )
            *(a.tail++) = *(a.p++);
        else if ( *a.p < *b.p )
            *(a.tail++) = *(a.p++);
        else if ( *b.p < *a.p )
            *(b.tail++) = *(b.p++);
        else
            ++a.p, ++b.p;
    }

    finalize_packed_array(asv, a);
    finalize_packed_array(bsv, b);
}

MODULE = PackedArray    PACKAGE = PackedArray

void sort_packed(char *packed, int length(packed))

void dedup_packed(SV *packed)

void unique_packed(SV *a, SV *b)
