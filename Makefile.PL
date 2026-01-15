use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
#INSTALL_BASE => $ENV{HOME}.'/usr',
    NAME             => 'Algorithm::GLPK::GLPsol',
    AUTHOR           => q{Andreas Hadjiprocopis <bliako@cpan.org>},
    VERSION_FROM     => 'lib/Algorithm/GLPK/GLPsol.pm',
    ABSTRACT_FROM    => 'lib/Algorithm/GLPK/GLPsol.pm',
    LICENSE          => 'artistic_2',
    MIN_PERL_VERSION => '5.006',
    # XS:
    LIBS             => '-lglpk',
    CCFLAGS          => '-Wall -std=c99',
    OPTIMIZE         => '-O3',
    # GLPK is licensed as GPL v3 or later, so we use this license
    LICENSE          => 'gpl_3',
    XSMULTI          => 1,

    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    TEST_REQUIRES => {
	'Test::More' => '0',
	'Data::Roundtrip' => '0',
	'Encode' => '0',
	'File::Spec' => '0',
	'FindBin' => '0',
	'Test2::Plugin::UTF8' => '0',
	'Test::TempDir::Tiny' => '0',
    },
    PREREQ_PM => {
	'Exporter' => '0',
	'XSLoader' => '0',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Algorithm-GLPK-GLPsol-* tmp' },
);

# Compatibility with old versions of ExtUtils::MakeMaker
unless (eval { ExtUtils::MakeMaker->VERSION('6.64'); 1 }) {
    my $test_requires = delete $WriteMakefileArgs{TEST_REQUIRES} || {};
    @{$WriteMakefileArgs{PREREQ_PM}}{keys %$test_requires} = values %$test_requires;
}

unless (eval { ExtUtils::MakeMaker->VERSION('6.55_03'); 1 }) {
    my $build_requires = delete $WriteMakefileArgs{BUILD_REQUIRES} || {};
    @{$WriteMakefileArgs{PREREQ_PM}}{keys %$build_requires} = values %$build_requires;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
    unless eval { ExtUtils::MakeMaker->VERSION('6.52'); 1 };
delete $WriteMakefileArgs{MIN_PERL_VERSION}
    unless eval { ExtUtils::MakeMaker->VERSION('6.48'); 1 };
delete $WriteMakefileArgs{LICENSE}
    unless eval { ExtUtils::MakeMaker->VERSION('6.31'); 1 };

WriteMakefile(%WriteMakefileArgs);
