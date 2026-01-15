package Algorithm::GLPK::GLPsol;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

use parent 'Exporter';
our @EXPORT_OK;
BEGIN {
	# export this by default? no
	@EXPORT_OK = qw/glpsol/;
}

require XSLoader;
XSLoader::load("Algorithm::GLPK::GLPsol", $VERSION);

# only pod below
=pod

=encoding utf8

=head1 NAME

Algorithm::GLPK::GLPsol - lame interface to the great Gnu Linear Programming Kit solver, GLPK and glpsol

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

GNU provides a Linear Programming solver at L<https://www.gnu.org/software/glpk/>.
GLPK stands for Gnu Linear Programming Kit and it is a prerequisite
to the current module. Make sure you have the developer version
of GLPK via your package manager or from L<source|https://ftp.gnu.org/gnu/glpk/>.
The author of GLPK is Andrew Makhorin, L<mao@gnu.org>.

In addition to being great and of great help it is also free and open source
in the great GNU tradition.
And in the UNIX tradition too although GNU is not UNIX :)

The current module provides an XS interface to GLPK's C<glpsol>
executable but without calling the executable itself, via C<system()>
or C<exec()>. Instead we lamely built an XS interface to C<glpsol>
which it takes in command-line args exactly how C<glpsol> would
and runs it. That means that the input program and the output solution
are files and not strings which are passed in and returned back
from L<glpsol>. That would be ideal of course but GLPK's L<API|https://most.ccib.rutgers.edu/glpk.pdf> is too
complex for me to decypher and understand how to tell it
to create a program using GLPK's L<API|https://most.ccib.rutgers.edu/glpk.pdf>.

See L<RELATED> for information about
a B<proper> porting of GLPK's API to Perl/PDL
with L<PDL::Opt::GLPK>.

Example usage:

    use Algorithm::GLPK::GLPsol;

    my $ret = Algorithm::GLPK::GLPsol::glpsol(
      [
        '-m', 'input-program.mod',
        '-o', 'output.sol'
      ],
      # optional verbosity level as integer >= 0 (0 means mute)
      $VERBOSITY
    );
    die unless $ret == 0;
    # you can read the solution from output  file ... lame I know!

    ...

=head1 EXPORT

This module can export these:

=over 2

=item * L<glpsol> : e.g. C<use Algorithm::GLPK::GLPsol qw/glpsol/;>

=back

=head1 SUBROUTINES

=head2 glpsol

C<glpsol(['-m', 'inprogram.mod', '-o' 'out.sol'], $VERBOSITY) or die;>

It calls C<glpsol> with the specified command-line
arguments to GLPK's C<glpsol> executable as an ARRAY_REF
as the first parameter and, optionally, an integer
denoting the verbosity level as the second parameter.

C<glpsol()> is an XS sub which calls GLPK's C<glpsol> command.
It is not as lame as calling it via C<system()> or C<exec()>
but it does not use GLPK's L<API|https://most.ccib.rutgers.edu/glpk.pdf> which would have been the most
preferable way to do this. The reason being that I do not know
how an LP program in GNU's MathProg can be translated to
API calls. It is too complex for me at the moment.

So, logically, this way
should be faster than calling the C<glpsol> executable via
a C<system()> call but slower (?) than doing it with API calls.
Having said that, I have not benchmarked this claim.

The most time consuming task is to write your program to a file before
passing it to L<glpsol()> and then reading the output solution from
file.

=head3 C<glpsol> COMMAND ARGS

All the command line options to L<glpsol()>
are documented here
L<https://en.wikibooks.org/wiki/GLPK/Using_GLPSOL>


=head3 RETURN

It returns C<1> on failure, C<0> on success.

=head1 AUTHOR

Andreas Hadjiprocopis, C<< <bliako at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-algorithm-glpk-glpsol at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Algorithm-GLPK-GLPsol>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 RELATED

There is a B<proper> port of GLPK to Perl/PDL provided by
L<Jörg Sommrey|https://metacpan.org/author/SOMMREY>
published as L<PDL::Opt::GLPK>.

As far as I can understand,
L<PDL::Opt::GLPK> does not accept L<MathProg|https://iuuk.mff.cuni.cz/~bohm/texts/mathprog_intro.html>
programs but it requires that the problem be specified with
L<PDL> matrices.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Algorithm::GLPK::GLPsol


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Algorithm-GLPK-GLPsol>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Algorithm-GLPK-GLPsol>

=item * Search CPAN

L<https://metacpan.org/release/Algorithm-GLPK-GLPsol>

=item * PerlMonks!

L<https://perlmonks.org/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2026 by Andreas Hadjiprocopis.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1; # End of Algorithm::GLPK::GLPsol
