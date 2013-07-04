DECLARE
--
--       sccsid           : @(#)higprivsyn.sql	1.3 11/06/02
--       Module Name      : higprivsyn.sql
--       Date into SCCS   : 02/11/06 15:00:36
--       Date fetched Out : 07/06/13 13:57:07
--       SCCS Version     : 1.3
--
--   Author : Jonathan Mills
--
--  Create synonyms
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3ddl.refresh_private_synonyms;
END;
/
