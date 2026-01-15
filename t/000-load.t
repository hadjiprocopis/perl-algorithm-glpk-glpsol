#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

use lib 'blib/lib', 'blib/arch';

plan tests => 1;

BEGIN {
    use_ok( 'Algorithm::GLPK::GLPsol' ) || print "Bail out!\n";
}

diag( "Testing Algorithm::GLPK::GLPsol $Algorithm::GLPK::GLPsol::VERSION, Perl $], $^X" );
