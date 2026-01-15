#!/usr/bin/env perl

###################################################################
#### NOTE env-var PERL_TEST_TEMPDIR_TINY_NOCLEANUP=1 will stop erasing tmp files
###################################################################

use strict;
use warnings;

use lib ('blib/lib', 'blib/arch');

our $VERSION = '0.11';

use Test::More;
use Test2::Plugin::UTF8; # rids of the Wide Character in TAP message!

use Encode;
use FindBin;
use Data::Roundtrip qw/perl2dump no-unicode-escape-permanently/;
use Test::TempDir::Tiny;
use File::Spec;

use Algorithm::GLPK::GLPsol qw/glpsol/;

my $VERBOSITY = 3;

my $curdir = $FindBin::Bin;
my $tmpdir = tempdir(); # will be erased unless a BAIL_OUT or env var set

my $input_prog_filename = File::Spec->catfile($curdir, 't-data', 'assign.mod');
ok(-e $input_prog_filename, "Input program exists ($input_prog_filename).") or BAIL_OUT;

my $output_solution_filename = File::Spec->catfile($tmpdir, 'output.sol');

my (@args, $retval);

# this should fail, no such file
@args = (
	'-m', $input_prog_filename.'xxxx',
	'-o', $output_solution_filename,
	'--verbosity', $VERBOSITY # this passes VERBOSITY to glpsol.c
);
$retval = glpsol(\@args);
ok(defined $retval, 'glpsol()'.": called and got result.") or BAIL_OUT;
is(ref($retval), '', 'glpsol()'.": result is a SCALAR.") or BAIL_OUT("no, it is '".ref($retval)."'.");
is($retval, 1, 'glpsol()'.": result is 1 (for failure) as expected.") or BAIL_OUT("no return is '$retval'.");

# this should fail, too many varargs, VERBOSITY is the only vararg expected
@args = (
	'-m', $input_prog_filename,
	'-o', $output_solution_filename,
	'--verbosity', $VERBOSITY # this passes VERBOSITY to glpsol.c
);
$retval = glpsol(\@args, $VERBOSITY, 2);
ok(defined $retval, 'glpsol()'.": called and got result.") or BAIL_OUT;
is(ref($retval), '', 'glpsol()'.": result is a SCALAR.") or BAIL_OUT("no, it is '".ref($retval)."'.");
is($retval, 1, 'glpsol()'.": result is 1 (for failure) as expected.") or BAIL_OUT("no return is '$retval'.");

# this should fail, we don't pass an array ref in at all
$retval = glpsol(undef);
ok(defined $retval, 'glpsol()'.": called and got result.") or BAIL_OUT;
is(ref($retval), '', 'glpsol()'.": result is a SCALAR.") or BAIL_OUT("no, it is '".ref($retval)."'.");
is($retval, 1, 'glpsol()'.": result is 1 (for failure) as expected.") or BAIL_OUT("no return is '$retval'.");

# this should fail, we pass a hash ref instead of array
$retval = glpsol({});
ok(defined $retval, 'glpsol()'.": called and got result.") or BAIL_OUT;
is(ref($retval), '', 'glpsol()'.": result is a SCALAR.") or BAIL_OUT("no, it is '".ref($retval)."'.");
is($retval, 1, 'glpsol()'.": result is 1 (for failure) as expected.") or BAIL_OUT("no return is '$retval'.");

###  Success!
# this should succeed
@args = (
	'-m', $input_prog_filename,
	'-o', $output_solution_filename,
	'--verbosity', $VERBOSITY # this passes VERBOSITY to glpsol.c
);
$retval = glpsol(\@args);
ok(defined $retval, 'glpsol()'.": called and got good result.") or BAIL_OUT;
is(ref($retval), '', 'glpsol()'.": result is a SCALAR.") or BAIL_OUT("no, it is '".ref($retval)."'.");
is($retval, 0, 'glpsol()'.": result is 0 as expected.") or BAIL_OUT("no return is '$retval'.");
ok(-f $output_solution_filename, 'glpsol()'.": output solution file ($output_solution_filename) exists.") or BAIL_OUT;

# this should succeed we pass VERBOSITY to the XS as well
# we pass verbosity to glpsol as well with -V
@args = (
	'-m', $input_prog_filename,
	'-o', $output_solution_filename,
	'-V', $VERBOSITY # this passes VERBOSITY to glpsol.c
);
$retval = glpsol(\@args, $VERBOSITY);
ok(defined $retval, 'glpsol()'.": called (with VERBOSITY=$VERBOSITY) and got good result.") or BAIL_OUT;
is(ref($retval), '', 'glpsol()'.": result is a SCALAR.") or BAIL_OUT("no, it is '".ref($retval)."'.");
is($retval, 0, 'glpsol()'.": result is 0 as expected.") or BAIL_OUT("no return is '$retval'.");
ok(-f $output_solution_filename, 'glpsol()'.": output solution file ($output_solution_filename) exists.") or BAIL_OUT;

# this should succeed we pass VERBOSITY to the XS as well
# we pass verbosity to glpsol as well with -V
# MUTE IT
$VERBOSITY = 0;
diag "Running totally mute with VERBOSITY = $VERBOSITY ...";
@args = (
	'-m', $input_prog_filename,
	'-o', $output_solution_filename,
	'-V', $VERBOSITY # this passes VERBOSITY to glpsol.c
);
$retval = glpsol(\@args, $VERBOSITY);
ok(defined $retval, 'glpsol()'.": called (with VERBOSITY=$VERBOSITY) and got good result.") or BAIL_OUT;
is(ref($retval), '', 'glpsol()'.": result is a SCALAR.") or BAIL_OUT("no, it is '".ref($retval)."'.");
is($retval, 0, 'glpsol()'.": result is 0 as expected.") or BAIL_OUT("no return is '$retval'.");
ok(-f $output_solution_filename, 'glpsol()'.": output solution file ($output_solution_filename) exists.") or BAIL_OUT;


#diag Encode::decode_utf8(perl2dump($results));
done_testing;
