--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/jxp_upgrade.sql-arc   1.0   Jan 16 2017 21:43:26   Rob.Coupe  $
--       Module Name      : $Workfile:   jxp_upgrade.sql  $
--       Date into PVCS   : $Date:   Jan 16 2017 21:43:26  $
--       Date fetched Out : $Modtime:   Jan 16 2017 21:38:44  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
--  upgrade script to create juxtaposition integrity and sequences
  
DECLARE
   max_value        INTEGER := 1;

   CURSOR c1
   IS
      SELECT con.table_name, con.constraint_name, col.column_name
        FROM user_constraints con, user_cons_columns col
       WHERE     con.table_name in ('NM_ASSET_TYPE_JUXTAPOSITIONS', 'NM_JUXTAPOSITIONS', 'NM_JUXTAPOSITION_TYPES')
             AND con.constraint_type = 'P'
             AND col.constraint_name = con.constraint_name;

   --
   ALREADY_EXISTS   EXCEPTION;
   PRAGMA EXCEPTION_INIT (ALREADY_EXISTS, -955);
BEGIN

   FOR irec IN c1
   LOOP
      BEGIN
         EXECUTE IMMEDIATE
            'select max(' || irec.column_name || ') from ' || irec.table_name
            INTO max_value;

         max_value := NVL (max_value, 1);
         --
         nm_debug.debug (
            'select max(' || irec.column_name || ') from ' || irec.table_name);
         nm_debug.debug ('max value = ' || max_value);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            max_value := 1;
      END;

      --
      BEGIN
         IF NM3DDL.DOES_OBJECT_EXIST (irec.column_name || '_SEQ')
         THEN
            EXECUTE IMMEDIATE 'drop sequence ' || irec.column_name || '_SEQ ';
         END IF;
         --
         EXECUTE IMMEDIATE
               'create sequence '
            || irec.column_name
            || '_SEQ start with '
            || TO_CHAR (max_value);
      END;
   --
----  create the trigger to populate sequence value when NULL;
--
--      execute immediate 'CREATE TRIGGER '||irec.column_name || '_SEQ_TRG'||chr(13)
--                   ||'BEFORE INSERT ON '||irec.table_name||chr(13)
--                   ||'REFERENCING NEW AS New OLD AS Old '||chr(13)
--                   ||'FOR EACH ROW '||chr(13)
--                   ||'BEGIN '||chr(13)
--                   ||'  :new.'||irec.column_name||' := '||irec.column_name||'_SEQ.nextval;'||chr(13)
--                   ||'END  '||irec.column_name || '_SEQ_TRG;';
--   
   END LOOP;
END;
/

ALTER TABLE NM_JUXTAPOSITIONS ADD 
CONSTRAINT njx_uk
 UNIQUE (NJX_NJXT_ID, NJX_CODE)
 ENABLE
 VALIDATE;

ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS ADD 
CONSTRAINT NAJX_NJXT_FK
 FOREIGN KEY (NAJX_NJXT_ID)
 REFERENCES NM_JUXTAPOSITION_TYPES (NJXT_ID)
 ENABLE
 VALIDATE;
 
CREATE OR REPLACE TRIGGER NAJX_ID_SEQ_TRG
BEFORE INSERT ON NM_ASSET_TYPE_JUXTAPOSITIONS
REFERENCING NEW AS New OLD AS Old 
FOR EACH ROW
BEGIN 
  :new.NAJX_ID := NAJX_ID_SEQ.nextval;
END  NAJX_ID_SEQ_TRG;
/

CREATE OR REPLACE TRIGGER NJX_ID_SEQ_TRG
BEFORE INSERT ON NM_JUXTAPOSITIONS
REFERENCING NEW AS New OLD AS Old 
FOR EACH ROW
BEGIN 
  :new.NJX_ID := NJX_ID_SEQ.nextval;
END  NJX_ID_SEQ_TRG;
/

CREATE OR REPLACE TRIGGER NJXT_ID_SEQ_TRG
BEFORE INSERT ON NM_JUXTAPOSITION_TYPES
REFERENCING NEW AS New OLD AS Old 
FOR EACH ROW
BEGIN 
  :new.NJXT_ID := NJXT_ID_SEQ.nextval;
END  NJXT_ID_SEQ_TRG;
/
