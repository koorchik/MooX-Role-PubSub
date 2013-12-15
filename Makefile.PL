use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'MooX::Role::PubSub',
    AUTHOR           => q{Viktor Turskyi <koorchik@cpan.org>},
    VERSION_FROM     => 'lib/MooX/Role/PubSub.pm',
    ABSTRACT_FROM    => 'lib/MooX/Role/PubSub.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Moo' => '0',
    },
    META_MERGE       => {
        resources => {
            repository => 'https://github.com/koorchik/MooX-Role-PubSub',
            license    => 'http://www.opensource.org/licenses/artistic-license-2.0',
            bugtracker => 'https://github.com/koorchik/MooX-Role-PubSub/issues',
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'MooX-Role-PubSub-*' },
);
