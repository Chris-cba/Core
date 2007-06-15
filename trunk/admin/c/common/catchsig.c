/*Old SCCS ID keyword, do not remove */
/* static char *sccsid = "@(#)catchsig.c	1.1 09/08/03"; */

/*PVCS keyword, do not remove */
static char *sccsid = "$Workfile:   catchsig.c  $ $Revision:   2.0  $ $Modtime:   Jun 15 2007 14:41:24  $";

/*=============================================================================
 *
 * Program      : catchsig - Standard library
 *
 * Author       : G.Fletcher
 * Version      : 1.0
 * Date         : 31-Oct-1997
 * Description  : Standard signal handler
 * Handle signals gracefully. Call usersigfunc() to allow a module to update
 * a file or whatever it needs to do before disconnecting from database and 
 * dumping core
 * K&R style declarations for portability
 =============================================================================*/

#include <signal.h>

void catchsig();
void usersigfunc();
void dblogoff();

void catchsig(sig)
int sig;
{
	signal(sig,SIG_IGN); /* Reset caught signal */

	usersigfunc(sig);
	abort();
}
