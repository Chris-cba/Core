-----------------------------------------------------------------------------
-- sdl_ddl.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_ddl.sql-arc   1.0   Aug 03 2020 16:14:30   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_ddl.sql  $
--       Date into PVCS   : $Date:   Aug 03 2020 16:14:30  $
--       Date fetched Out : $Modtime:   Jul 30 2020 09:47:40  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
PROMPT Creating table 'SDL_WIP_DATUM_REVERSALS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE SDL_WIP_DATUM_REVERSALS'
                  ||'(BATCH_ID          NUMBER(38) NOT NULL,'
                  ||' SLD_KEY           NUMBER(38) NOT NULL,'
                  ||' SWD_ID            NUMBER(38) NOT NULL,'
                  ||' DATUM_ID          NUMBER(38) NOT NULL,'
                  ||' DATM_GEOM         SDO_GEOMETRY,'
                  ||' HASHCODE          VARCHAR2(20) NOT NULL,'
                  ||' NODE_TYPE         VARCHAR2(1) NOT NULL,'
                  ||' NODE_MEASURE      NUMBER NOT NULL,'
                  ||' GEOM_MEASURE      NUMBER NOT NULL,'
                  ||' MAX_DATUM_ID      NUMBER(38) NOT NULL,'
                  ||' LOAD_GEOM_MEASURE NUMBER NOT NULL,'
                  ||' NEW_DATUM_ID      NUMBER(38) NOT NULL,'
                  ||' NEW_NODE_MEASURE  NUMBER NOT NULL,'
                  ||' NEW_NODE_TYPE     VARCHAR2(1) NOT NULL,'
                  ||' NEW_START_MEASURE NUMBER NOT NULL,'
                  ||' NEW_END_MEASURE   NUMBER NOT NULL,'
                  ||' PCT_MATCH         NUMBER(10,3),'
                  ||' STATUS            VARCHAR2(30),'
                  ||' MANUAL_OVERRIDE   VARCHAR2(1),'
                  ||' NEW_NE_ID         NUMBER(38),'
                  ||' NEW_GEOMETRY      SDO_GEOMETRY)'
                  ||' ON COMMIT DELETE ROWS';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_WIP_DATUM_REVERSALS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUM_REVERSALS ADD CONSTRAINT SWDR_PK PRIMARY KEY (SLD_KEY, SWD_ID, NODE_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Alter Table 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD SP_ATTRIBUTE_EDIT_ALLOWED VARCHAR2(1) DEFAULT ''N'' NOT NULL';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating check constraint on 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD CONSTRAINT SP_ATTRIBUTE_EDIT_ALLOWED_CHK CHECK (SP_ATTRIBUTE_EDIT_ALLOWED IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
-- Modify constraint SWD_STATUS_CHK to remove NO_ACTION status from check constraint
PROMPT DROP check constraint SWD_STATUS_CHK if exists and re-create
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2443);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUMS DROP CONSTRAINT SWD_STATUS_CHK';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Re-add check constraint on table SDL_WIP_DATUMS
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUMS ADD CONSTRAINT SWD_STATUS_CHK CHECK (STATUS IN (''NEW'',''VALID'',''INVALID'',''REVIEW'',''LOAD'',''SKIP'',''TRANSFERRED'',''REJECTED''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/