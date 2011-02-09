--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/0110548_das_data_repair.sql-arc   3.0   Feb 09 2011 08:47:26   Ade.Edwards  $
--       Module Name      : $Workfile:   0110548_das_data_repair.sql  $
--       Date into PVCS   : $Date:   Feb 09 2011 08:47:26  $
--       Date fetched Out : $Modtime:   Feb 09 2011 08:46:30  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

PROMPT Start of DOC_ASSOCS repair

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE x_doc_assocs_backup';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE x_doc_assocs_backup AS SELECT * FROM doc_assocs;

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE x_existing_doc_assocs';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
  EXECUTE IMMEDIATE 'ALTER TRIGGER doc_assocs_b_iu_trg DISABLE';
END;
/

CREATE TABLE x_existing_doc_assocs
AS
SELECT das_doc_id, das_table_name, iit_ne_id, iit_primary_key, iit_start_date, iit_inv_type 
  FROM (WITH all_doc_assocs
          AS
          (SELECT das_rec_id, das_doc_id, das_table_name
             FROM doc_assocs
            WHERE das_table_name IN ( SELECT 'NM_INV_ITEMS'     FROM dual                               UNION
                                      SELECT 'NM_INV_ITEMS_ALL' FROM dual                               UNION
                                      SELECT 'INV_ITEMS_ALL'    FROM dual                               UNION
                                      SELECT 'INV_ITEMS'        FROM dual                               UNION
                                      SELECT dgs_table_syn      FROM doc_gate_syns
                                      WHERE dgs_dgt_table_name IN ('NM_INV_ITEMS','NM_INV_ITEMS_ALL')))
          SELECT TO_NUMBER(das_rec_id) asset_id
               , das_doc_id
               , das_table_name
            FROM all_doc_assocs) a
     , nm_inv_items_all
 WHERE iit_ne_id = asset_id; 

CREATE INDEX xeda_iit_primary_key ON x_existing_doc_assocs (iit_primary_key);

INSERT INTO doc_assocs
SELECT UNIQUE das_table_name, asset_id, das_doc_id 
FROM (
SELECT i.iit_primary_key  asset_pk
     , i.iit_ne_id        asset_id
     , x.iit_ne_id        das_asset_id
     , x.iit_primary_key  das_asset_pk
     , x.das_table_name   das_table_name
     , x.das_doc_id       das_doc_id
  FROM nm_inv_items_all i, x_existing_doc_assocs x
 WHERE i.iit_primary_key IN (SELECT iit_primary_key
                             FROM (  SELECT iit_primary_key
                                          , COUNT ( * )
                                       FROM nm_inv_items_all
                                      WHERE iit_primary_key IN (SELECT UNIQUE iit_primary_key FROM x_existing_doc_assocs)
                                   GROUP BY iit_primary_key
                                     HAVING COUNT ( * ) > 1))
   AND i.iit_primary_key = x.iit_primary_key
) a
WHERE NOT EXISTS
  (SELECT 1 FROM doc_assocs das2
    WHERE a.das_table_name = das2.das_table_name
      AND a.asset_id       = das2.das_rec_id
      AND a.das_doc_id     = das2.das_doc_id);


BEGIN
  EXECUTE IMMEDIATE 'ALTER TRIGGER doc_assocs_b_iu_trg ENABLE';
END;
/

PROMPT End of DOC_ASSOCS repair


