CREATE OR REPLACE TRIGGER nm_load_batches_b_d_trg
   BEFORE DELETE ON nm_load_batches
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_load_batches_b_d_trg.trg	1.3 04/08/04
--       Module Name      : nm_load_batches_b_d_trg.trg
--       Date into SCCS   : 04/04/08 02:31:38
--       Date fetched Out : 07/06/13 17:03:11
--       SCCS Version     : 1.3
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_load_batches_b_d_trg
--      BEFORE DELETE ON nm_load_batches
--      FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   BEGIN
      IF :old.nlb_batch_source = 'C'
       THEN -- This came from the client
         nm3load.delete_nuf_for_nlb (pi_nlb_batch_no => :OLD.nlb_batch_no);
--         DELETE FROM nm_upload_files
--         WHERE  SUBSTR(name,1,LENGTH(:old.nlb_filename)) = :old.nlb_filename;
      END IF;
   EXCEPTION
      WHEN others
       THEN
         Null;
   END;
--
   BEGIN
      EXECUTE IMMEDIATE   'DELETE FROM '
                        ||nm3load.get_holding_table_name (p_nlf_id => :OLD.nlb_nlf_id)
                        ||' WHERE batch_no = :batch_no'
        USING :OLD.nlb_batch_no;
   EXCEPTION
      WHEN others
       THEN
         Null;
   END;
--
END nm_load_batches_b_d_trg;
/
