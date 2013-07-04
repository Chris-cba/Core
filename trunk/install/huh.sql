--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/huh.sql-arc   2.1   Jul 04 2013 13:45:32   James.Wadsworth  $
--       Module Name      : $Workfile:   huh.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:02:20  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM SCCS ID Keyword, do no remove
define sccsid = '%W% %G%';

create table hig_user_history (
	huh_user_id number,
	huh_user_history user_hist_item
)
/
