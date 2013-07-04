--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm3.typ-arc   2.1   Jul 04 2013 13:55:16   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3.typ  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:55:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:37:10  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM SCCS ID Keyword, do no remove
define sccsid = '@(#)nm3.typ	1.1 03/02/01';

-- j:\nm3\db_create\nm31_final.typ
--
-- Generated for Oracle 8 on Thu Mar 01  14:00:43 2001 by Server Generator 6.0.3.3.0

CREATE TYPE USER_HIST_ITEM
/
CREATE TYPE USER_HIST_MODULE
/


PROMPT Creating Type 'USER_HIST_MODULE'
CREATE OR REPLACE TYPE USER_HIST_MODULE AS OBJECT
 (UHI_MODULE VARCHAR2(30)
 ,UHI_DATE DATE
 )
/

PROMPT Creating Collection Type 'USER_HIST_MODULES'
CREATE TYPE USER_HIST_MODULES AS VARRAY(10) OF USER_HIST_MODULE
/

PROMPT Creating Type 'USER_HIST_ITEM'
CREATE OR REPLACE TYPE USER_HIST_ITEM AS OBJECT
 (UHI_MODULES USER_HIST_MODULES
 ,MEMBER PROCEDURE DUMP_MODULE_HIST
 ,PRAGMA RESTRICT_REFERENCES (DUMP_MODULE_HIST, WNDS)
 ,MEMBER FUNCTION INITIALIZE_VARRAY
 RETURN USER_HIST_ITEM

 ,MEMBER FUNCTION MODULE_EXISTS
 (MODULE IN VARCHAR2
 )
 RETURN NUMBER

 ,MEMBER FUNCTION REMOVE_MODULE
 (VINDEX IN NUMBER
 )
 RETURN USER_HIST_ITEM

 ,MEMBER FUNCTION MODULE_RESEQUENCE
 (VINDEX IN NUMBER
 )
 RETURN USER_HIST_ITEM

 ,MEMBER FUNCTION ADD_NEW_MODULE
 (MODULE IN VARCHAR2
 )
 RETURN USER_HIST_ITEM

 ,MEMBER FUNCTION GET_MODULE
 (VINDEX IN NUMBER
 )
 RETURN VARCHAR2

 )
/


