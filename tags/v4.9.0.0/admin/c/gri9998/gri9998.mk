# ***********************************************************************
#  ------------------------------- Comment ------------------------------
#  SCCS Identifiers :-
#       sccsid           : @(#)gri9998.mk	1.1 09/08/03
#       Module Name      : gri9998.mk
#       Date into SCCS   : 03/09/08 17:30:47
#       Date fetched Out : 07/06/13 13:56:09
#       SCCS Version     : 1.1# 
#
#  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
#
# ***********************************************************************
#
# To make this module :
#   % make -f <gri9998.mk.mk>
# To make a production version of this module
#   % make -f <gri9998.mk.mk> product
# To make a debug version of this module
#   % make -f <gri9998.mk.mk> debug
# To remove intermediate files created by making the module :
#   % make -f <gri9998.mk.mk> remove
#
#
# The list of Pro*C files for the module.

PROC_FILES =  gri9998.pc jobrun.pc dblogon.pc sqlerr.pc
C_FILES    =  catchsig.c unx_pipe.c
H_FILES    =  sqlext.h rmms.h
TARGET     =  gri9998
PL_SQL     =  full

include ${PROD_HOME}/lib/proc_std.mk

