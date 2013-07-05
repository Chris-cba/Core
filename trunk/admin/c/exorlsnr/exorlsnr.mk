# ***********************************************************************
#  ------------------------------- Comment ------------------------------
#       sccsid           : @(#)exorlsnr.mk	1.1 09/08/03
#       Module Name      : exorlsnr.mk
#       Date into SCCS   : 03/09/08 17:17:30
#       Date fetched Out : 07/06/13 11:55:11
#       SCCS Version     : 1.1# 
#
#       Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
# ***********************************************************************
#
# To make this module :
#   % make -f <exorlsnr.mk>
# To make a production version of this module
#   % make -f <exorlsnr.mk> product
# To make a debug version of this module
#   % make -f <exorlsnr.mk> debug
# To remove intermediate files created by making the module :
#   % make -f <exorlsnr.mk> remove
#
#
# The list of Pro*C files for the module.
PROC_FILES =  exorlsnr.pc
C_FILES    =  unxlsnr.c unx_pipe.c
H_FILES    =  
TARGET     =  exorlsnr
PL_SQL     =  full

include ${PROD_HOME}/lib/proc_std.mk

