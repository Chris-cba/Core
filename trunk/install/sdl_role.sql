-----------------------------------------------------------------------------
-- sdl_role.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_role.sql-arc   1.0   Aug 03 2020 16:14:32   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_role.sql  $
--       Date into PVCS   : $Date:   Aug 03 2020 16:14:32  $
--       Date fetched Out : $Modtime:   Jul 30 2020 09:47:40  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE SDL_ADMIN';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/
DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE SDL_USER';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/