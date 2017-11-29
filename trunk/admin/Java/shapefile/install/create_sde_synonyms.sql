--
---------------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/Java/shapefile/install/create_sde_synonyms.sql-arc   1.0   Nov 29 2017 09:45:54   Upendra.Hukeri  $
--       Module Name      : $Workfile:   create_sde_synonyms.sql  $
--       Date into PVCS   : $Date:   Nov 29 2017 09:45:54  $
--       Date fetched Out : $Modtime:   Nov 29 2017 09:42:06  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Upendra Hukeri
--
---------------------------------------------------------------------------------------------------
-- Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
---------------------------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- SYNONYMS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Public Synonyms
SET TERM OFF
--
SET FEEDBACK ON
--
CREATE OR REPLACE PUBLIC SYNONYM sde_varchar_array FOR sde_varchar_array;
--
CREATE OR REPLACE PUBLIC SYNONYM sde_varchar_2d_array FOR sde_varchar_2d_array;
--
CREATE OR REPLACE PUBLIC SYNONYM sde_util FOR sde_util;
--
SET FEEDBACK OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
