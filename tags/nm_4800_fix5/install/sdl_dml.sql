-----------------------------------------------------------------------------
-- sdl_dml.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_dml.sql-arc   1.0   Aug 03 2020 16:14:30   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_dml.sql  $
--       Date into PVCS   : $Date:   Aug 03 2020 16:14:30  $
--       Date fetched Out : $Modtime:   Jul 30 2020 09:47:40  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- update existing records from SDL tables with status NO_ACTION to REVIEW
UPDATE sdl_wip_datums
SET status = 'REVIEW'
WHERE status = 'NO_ACTION'
/
UPDATE sdl_spatial_review_levels
SET ssrl_default_action = 'REVIEW'
WHERE ssrl_default_action = 'NO_ACTION'
/
-- delete the NO_ACTION code from domain 
DELETE hig_codes
WHERE hco_domain = 'SDL_REVIEW_ACTION'
  AND hco_code = 'NO_ACTION'
/
COMMIT
/