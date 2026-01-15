#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <glpk.h>

#include "glpsol.c"

/* _argv : is an ARRAY_REF of cli-params to glpsol executable.
	   For example ['-m', $programfile, '-o', $outputfile]
	   see https://en.wikibooks.org/wiki/GLPK/Using_GLPSOL
	   for glpsol's command-line parameters.
   VERBOSITY : optionally specify the verbosity level as an integer
	   of zero or more. Default is zero which is mute.
*/

/* note: varargs: https://www.lemoda.net/xs/xs-variable-arguments/index.html */

MODULE = Algorithm::GLPK::GLPsol  PACKAGE = Algorithm::GLPK::GLPsol
PROTOTYPES: DISABLE

int glpsol(_argv, ...)
    SV *_argv

    PREINIT:
	I32 argc = 0;
	char **argv = NULL;
	int VERBOSITY = 0;

    CODE:
	/* handle varargs: only VERBOSITY at the moment */
	if( items > 1 ){
		if( items > 2 ){ 
			fprintf(stderr, "glpsol() : error, the number of variable arguments after the 1st parameter (argv) must be zero or one (VERBOSITY).\n");
			RETVAL = 1;
			goto EXIT;
		}
		/* we have exactly one extra arg: VERBOSITY */
		VERBOSITY = (int )SvNV(ST(1)); /* the 2nd arg (first of varargs) */
	}

	SV* tmpSV = NULL;
	AV* inpArray = NULL;
	if( ! SvROK(_argv) ){
		fprintf(stderr, "glpsol() : error, input expected to be an ARRAY_REF/1.\n");
		RETVAL = 1;
		goto EXIT;
		//XSRETURN(1);
	}
	/* we know we have a reference */
	tmpSV = (SV* )SvRV(_argv); /* deref */
	if( SvTYPE(tmpSV) != SVt_PVAV) {
		fprintf(stderr, "glpsol() : error, input expected to be an ARRAY_REF/2.\n");
		RETVAL = 1;
		goto EXIT;
		//XSRETURN(1);
	}
	/* it's an array reference */
	inpArray = (AV* )tmpSV;

	argc = av_len(inpArray) + 1;
	if( VERBOSITY > 0 ){ fprintf(stdout, "starting with %d args ...\n", argc); }

	/* argv should contain the parameters to glpsol
	   but first item is the program name, so we need 1 extra item here:
	*/
	argv = (char **)malloc((argc+1)*sizeof(char *));
	for(int i=argc;i-->0;){
		SV *tmp = *av_fetch(inpArray,i,0);
		STRLEN len;
		char *str = SvPVutf8(tmp,len);
		argv[i+1] = strdup(str);
	}
	argv[0] = strdup("glpsol");
	if( VERBOSITY > 0 ){
	  for(int i=0;i<=argc;i++){
		fprintf(stdout, "glpsol() : parsed input (argv) param #%d as '%s'\n", i, argv[i]);
	  }
	}
	argc++;

	int ret = glpsol(argc, argv);
	if( ret != 0 ){
		fprintf(stderr, "error, call to glpsol() has failed.\n");
		RETVAL = 1;
	} else {
		RETVAL = 0;
	}

	if( VERBOSITY > 0 ){
		fprintf(stdout, "glpsol() : done and returning back to Perl.\n");
	}

	EXIT:

    OUTPUT:
	RETVAL

    CLEANUP:
	if( argv != NULL ){
		if( VERBOSITY > 0 ){ fprintf(stdout, "glpsol() : cleaning up ...\n"); }
		for(int i=argc;i-->0;){
		  if( argv != NULL ){
			if( VERBOSITY > 0 ){ fprintf(stdout, "glpsol() : freeing memory for argv[%d] ...\n", i); }
			free(argv[i]);
		  }
		}
		if( VERBOSITY > 0 ){ fprintf(stdout, "glpsol() : freeing memory for argv.\n"); }
		free(argv);
	} else {
		if( VERBOSITY > 0 ){ fprintf(stdout, "glpsol() : nothing to clean up.\n"); }
	}
