# ***********************************************************************
#  ------------------------------- Comment ------------------------------
#  SCCS Identifiers :-
#
#   SCCS Identifiers :-
#   
#       sccsid           : @(#)gri0207.mk	1.1 09/08/03
#       Module Name      : gri0207.mk
#       Date into SCCS   : 03/09/08 17:29:32
#       Date fetched Out : 07/06/13 13:55:37
#       SCCS Version     : 1.1# 
#
#  Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
# ***********************************************************************
#
# To make this module :
#   % make -f <bpr2200d.mk.mk>
# To make a production version of this module
#   % make -f <bpr2200d.mk.mk> product
# To make a debug version of this module
#   % make -f <bpr2200d.mk.mk> debug
# To remove intermediate files created by making the module :
#   % make -f <bpr2200d.mk.mk> remove
#
#
# The list of Pro*C files for the module.
PROC_FILES =  gri0207.pc 
C_FILES    =
H_FILES    =  
TARGET     =  gri0207
PL_SQL     =  full

include ${PROD_HOME}/lib/proc_std.mk

