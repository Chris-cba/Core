------------------------------------------------------------------
-- nm4010_nm4020_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4010_nm4020_ddl_upg.sql-arc   2.2   Jul 19 2007 15:23:18   gjohnson  $
--       Module Name      : $Workfile:   nm4010_nm4020_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 19 2007 15:23:18  $
--       Date fetched Out : $Modtime:   Jul 19 2007 15:22:08  $
--       Version          : $Revision:   2.2  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Grant DROP ANY SYNONYM to HIG_ADMIN role
SET TERM OFF

-- GJ  16-MAY-2007
-- 
-- DEVELOPMENT COMMENTS
-- HIG1832 was reporting a "You do not have permission to perform this action" error message.
-- Problem was due to lack of DROP ANY SYNONYM priv - which caused nm3sdm.Create_Msv_Feature_Views to raise the exception.
------------------------------------------------------------------
GRANT DROP ANY SYNONYM to HIG_ADMIN
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New indexes on FK constrained columns, where no suitable index already exists
SET TERM OFF

-- GJ  13-JUN-2007
-- 
-- DEVELOPMENT COMMENTS
-- All FK constrained columns should be indexed.
-- This DDL will add new indexes to existing tables that have been identified as needing such constraints.
------------------------------------------------------------------
DECLARE

 ex_ignore exception;
 pragma exception_init(ex_ignore,-955);

BEGIN
 
  BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX HAG_FK2_HAU_IND ON NM_ADMIN_GROUPS(NAG_CHILD_ADMIN_UNIT)';
   EXCEPTION    
   WHEN ex_ignore THEN
      Null;
   WHEN others THEN
      RAISE;  
  END;

  BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX NUA_NAU_FK_IND ON NM_USER_AUS_ALL(NUA_ADMIN_UNIT)';
  EXCEPTION
   WHEN ex_ignore THEN
      Null;
   WHEN others THEN
      RAISE;  
  END;
  
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Upgrade nm_element_history
SET TERM OFF

-- AE  19-JUL-2007
-- 
-- DEVELOPMENT COMMENTS
-- KA: Recreate nm_element_history with new structure and populate with data from original table.
------------------------------------------------------------------
CREATE TABLE nm_element_history_old AS SELECT * FROM nm_element_history;

SET serverout ON SIZE 1000000

DECLARE
  PROCEDURE drop_con(pi_tab IN varchar2
                    ,pi_con IN varchar2
                    ) IS
                    
    e_nonexistent_tab EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_nonexistent_tab, -942);
                    
    e_nonexistent_con EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_nonexistent_con, -2443);
     
  BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ' || pi_tab || ' DROP CONSTRAINT ' || pi_con;
    dbms_output.put_line('Dropped constraint ' || pi_tab || '.' || pi_con);
    
  EXCEPTION
    WHEN e_nonexistent_tab
      OR e_nonexistent_con
    THEN
      NULL;
      
  END drop_con;
BEGIN
  drop_con(pi_tab => 'nm_members_all'
          ,pi_con => 'nmh_neh_fk');
  drop_con(pi_tab => 'acc_location_history'
          ,pi_con => 'alh_neh_fk');
  drop_con(pi_tab => 'stp_scheme_loc_datum_history'
          ,pi_con => 'ssldh_neh_fk');
  drop_con(pi_tab => 'road_int_history'
          ,pi_con => 'rih_neh_fk');
END;
/

SET serverout OFF

DROP TABLE nm_element_history CASCADE CONSTRAINTS;

CREATE TABLE nm_element_history
(
  neh_id              number(9)                 NOT NULL,
  neh_ne_id_old       number(9)                 NOT NULL,
  neh_ne_id_new       number(9)                 NOT NULL,
  neh_operation       varchar2(1)               NOT NULL,
  neh_effective_date  date                      NOT NULL,
  neh_actioned_date   date                      DEFAULT TRUNC(SYSDATE) NOT NULL,
  neh_actioned_by     varchar2(30)              DEFAULT USER NOT NULL,
  neh_old_ne_length   number,
  neh_new_ne_length   number,
  neh_param_1         number,
  neh_param_2         number
);

COMMENT ON TABLE nm_element_history IS 'This table contains a list of all the split and merged section';

CREATE UNIQUE INDEX neh_pk ON nm_element_history
(neh_id);

CREATE INDEX neh_ne_id_old_new_ind ON nm_element_history
(neh_ne_id_old, neh_ne_id_new);

CREATE INDEX neh_ne_id_new_fk_ind ON nm_element_history
(neh_ne_id_new);

ALTER TABLE nm_element_history ADD (
  CONSTRAINT neh_pk
 PRIMARY KEY
 (neh_id));

ALTER TABLE nm_element_history ADD (
CONSTRAINT neh_ne_id_new_fk
FOREIGN KEY (neh_ne_id_new)
REFERENCES nm_elements_all (ne_id));
 
ALTER TABLE nm_element_history ADD (
CONSTRAINT neh_ne_id_old_fk
FOREIGN KEY (neh_ne_id_old)
REFERENCES nm_elements_all (ne_id));

CREATE SEQUENCE neh_id_seq
  START WITH 1
  MINVALUE 1
  NOCYCLE
  CACHE 20;

INSERT INTO
  nm_element_history(neh_id
                    ,neh_ne_id_old
                    ,neh_ne_id_new
                    ,neh_operation
                    ,neh_effective_date
                    ,neh_actioned_date
                    ,neh_actioned_by)
                    --,neh_old_ne_length
                    --,neh_new_ne_length
                    --,neh_param_1
                    --,neh_param_2)
SELECT
  neh_id_seq.NEXTVAL,
  nehv.neh_ne_id_old,
  nehv.neh_ne_id_new,
  nehv.neh_operation,
  nehv.neh_effective_date,
  nehv.neh_actioned_date,
  nehv.neh_actioned_by
FROM
  (SELECT
     neho.*
   FROM
     nm_element_history_old neho
   ORDER BY
     neho.neh_actioned_date) nehv;


------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

