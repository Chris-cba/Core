------------------------------------------------------------------
-- nm4600_nm4700_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4600_nm4700_ddl_upg.sql-arc   1.0   Jul 11 2013 10:09:10   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4600_nm4700_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 11 2013 10:09:10  $
--       Date fetched Out : $Modtime:   Jul 11 2013 10:07:18  $
--       Version          : $Revision:   1.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2013

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT DDL Upgrade to DOC_STD_ACTIONS and DOC_REDIR_PRIOR
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- Imported from NM_4600_fix2.sql
-- 
------------------------------------------------------------------
DECLARE
  --
  already_exists EXCEPTION;
  PRAGMA exception_init( already_exists,-01430); 
  --
  lv_top_admin_unit hig_admin_units.hau_admin_unit%TYPE;
  --
  PROCEDURE get_top_admin_unit
    IS
  BEGIN
    SELECT hau_admin_unit
      INTO lv_top_admin_unit
      FROM hig_admin_units
     WHERE hau_level = 1
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Cannot find the top admin unit.');
    WHEN others
     THEN RAISE;
  END;
BEGIN
  /*
  ||Add the Admin Unit Column.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior ADD(drp_admin_unit NUMBER(9))');
  /*
  ||Populate existing rows with the top Admin Unit;
  */
  get_top_admin_unit;
  --
  EXECUTE IMMEDIATE('UPDATE doc_redir_prior SET drp_admin_unit = :lv_top_admin_unit') USING lv_top_admin_unit;
  /*
  ||Make the column NOT NULL.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior MODIFY(drp_admin_unit NOT NULL)');
  /*
  ||Create FK for Admin Unit.
  */
  EXECUTE IMMEDIATE('CREATE INDEX drp_fk_nau_ind ON doc_redir_prior (drp_admin_unit)');
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior ADD (CONSTRAINT drp_fk_nau FOREIGN KEY (drp_admin_unit) REFERENCES nm_admin_units_all (nau_admin_unit))');
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT SDE Sub-layer exemptions
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- From nm3_4600_fix3 (supporting MCI changes)
-- 
------------------------------------------------------------------
declare
obj_exists exception;
pragma exception_init( obj_exists, -955);
begin
execute immediate ' CREATE TABLE NM_SDE_SUB_LAYER_EXEMPT '||
'( '||
'  NSSL_OBJECT_NAME  VARCHAR2(128),'||
'  NSSL_OBJECT_TYPE  VARCHAR2(19), '||
'  CONSTRAINT NSSL_PK'||
'  PRIMARY KEY'||
'  (NSSL_OBJECT_NAME, NSSL_OBJECT_TYPE)'||
'  ENABLE VALIDATE'||
')'||
'ORGANIZATION INDEX';
exception
  when obj_exists then
    NULL;
end;
/


begin
nm3ddl.create_synonym_for_object('NM_SDE_SUB_LAYER_EXEMPT');
end;
/

declare
obj_exists exception;
pragma exception_init( obj_exists, -2264);
begin
execute immediate 'ALTER TABLE NM_SDE_SUB_LAYER_EXEMPT ADD ( '||
'  CONSTRAINT NSSL_OBJ_NAME_UPP_CHK '||
'  CHECK (Nssl_Object_Name = Upper(Nssl_Object_Name)) '||
'  ENABLE VALIDATE, '||
'  CONSTRAINT NSSL_OBJ_TYPE_UPP_CHK '||
'  CHECK (Nssl_Object_Type = Upper(Nssl_Object_Type)) '||
'  ENABLE VALIDATE) ';
exception
  when obj_exists then
    NULL;
end;
/


------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

