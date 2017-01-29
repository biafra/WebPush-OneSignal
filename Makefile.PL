use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'WebPush::OneSignal',
    AUTHOR           => q{Biafra <biafra@bodogemu.com>},
    VERSION_FROM     => 'lib/WebPush/OneSignal.pm',
    ABSTRACT_FROM    => 'lib/WebPush/OneSignal.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Class::Tiny::Antlers' => 0,
        'Net::Curl::Easy'      => 0,
        'Try::Tiny'            => 0,
        'JSON'                 => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WebPush-OneSignal-*' },
);
