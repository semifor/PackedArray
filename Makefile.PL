use ExtUtils::MakeMaker;

WriteMakefile(
    dist => {
        PREOP =>
        'pod2text PackedArray.pm | tee README >$(DISTVNAME)/README; chmod -R u=rwX,go=rX . ;',
        COMPRESS => 'gzip -9v',
        SUFFIX   => '.gz',
    },
    NAME => "PackedArray",
    VERSION_FROM => "PackedArray.pm",
    CONFIGURE_REQUIRES => {
       "ExtUtils::MakeMaker" => 6.52,
       "Sub::Exporter" => 0,
    },
);
