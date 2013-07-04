CREATE OR REPLACE TRIGGER nm_mrg_query_delete
 BEFORE DELETE
 ON NM_MRG_QUERY_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_query_delete
--   BEFORE DELETE
--   ON NM_MRG_QUERY
--   FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_view_name      VARCHAR2(30) := nm3mrg_view.get_mrg_view_name_by_unique(:OLD.NMQ_UNIQUE);
   c_count CONSTANT PLS_INTEGER  := nm3mrg_view.g_views_to_del.COUNT+1;
--
BEGIN
--
   nm3mrg_view.g_views_to_del(c_count)   := l_view_name;
   nm3mrg_view.g_tab_nmq_id_del(c_count) := :OLD.nmq_id;
--
END nm_mrg_query_delete;
/


CREATE OR REPLACE TRIGGER nm_mrg_query_delete_stm
 AFTER DELETE
 ON NM_MRG_QUERY_ALL
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_query_delete_stm
--    AFTER DELETE
--    ON NM_MRG_QUERY
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   FOR i IN 1..nm3mrg_view.g_views_to_del.COUNT
    LOOP
      nm3mrg_view.drop_merge_view(nm3mrg_view.g_views_to_del(i));
   END LOOP;
--
   FORALL i IN 1..nm3mrg_view.g_tab_nmq_id_del.COUNT
      DELETE FROM nm_mrg_query_roles
      WHERE  nqro_nmq_id = nm3mrg_view.g_tab_nmq_id_del(i);
--
   nm3mrg_view.g_views_to_del.DELETE;
   nm3mrg_view.g_tab_nmq_id_del.DELETE;
--
END nm_mrg_query_delete_stm;
/

CREATE OR REPLACE TRIGGER nm_mrg_query_delete_b4_stm
 BEFORE DELETE
 ON NM_MRG_QUERY_ALL
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_query_delete_b4_stm
--    BEFORE DELETE
--    ON NM_MRG_QUERY
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3mrg_view.g_views_to_del.DELETE;
   nm3mrg_view.g_tab_nmq_id_del.DELETE;
   nm3mrg_output.delete_change_array;
END nm_mrg_query_delete_b4_stm;
/

CREATE OR REPLACE TRIGGER nm_mrg_query_types_b_id_Stm
   BEFORE INSERT OR DELETE
    ON   NM_MRG_QUERY_TYPES_ALL
BEGIN
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_query_types_b_id_Stm
--    BEFORE INSERT OR DELETE
--     ON   NM_MRG_QUERY_TYPES
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   nm3mrg_view.g_tab_nmq_id.DELETE;
END nm_mrg_query_types_b_id_Stm;
/

CREATE OR REPLACE TRIGGER nm_mrg_query_types_b_id
   BEFORE INSERT OR DELETE
    ON   NM_MRG_QUERY_TYPES_ALL
   FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_query_types_b_id
--   BEFORE INSERT OR DELETE
--    ON   NM_MRG_QUERY_TYPES
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_add    NUMBER;
   l_nmq_id nm_mrg_query.nmq_id%TYPE;
--
BEGIN
--
   IF deleting
    THEN
      l_add    := -1;
      l_nmq_id := :old.nqt_nmq_id;
   ELSE
      l_add    := 1;
      l_nmq_id := :new.nqt_nmq_id;
   END IF;
--
   IF nm3mrg_view.g_tab_nmq_id.EXISTS(l_nmq_id)
    THEN
      nm3mrg_view.g_tab_nmq_id(l_nmq_id) := nm3mrg_view.g_tab_nmq_id(l_nmq_id) + l_add;
   ELSE
      nm3mrg_view.g_tab_nmq_id(l_nmq_id) := l_add;
   END IF;
--
END nm_mrg_query_types_b_id;
/

CREATE OR REPLACE TRIGGER nm_mrg_query_types_a_id_Stm
   AFTER INSERT OR DELETE
    ON   NM_MRG_QUERY_TYPES_ALL
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_query_types_a_id_Stm
--    AFTER INSERT OR DELETE
--     ON   NM_MRG_QUERY_TYPES
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_count BINARY_INTEGER;
BEGIN
--
   l_count := nm3mrg_view.g_tab_nmq_id.FIRST;
--
   WHILE l_count IS NOT NULL
    LOOP
    --
      UPDATE nm_mrg_query
       SET   nmq_inv_type_x_sect_count = nmq_inv_type_x_sect_count + nm3mrg_view.g_tab_nmq_id(l_count)
      WHERE  nmq_id                    = l_count;
    --
      l_count := nm3mrg_view.g_tab_nmq_id.NEXT(l_count);
   END LOOP;
--
   nm3mrg_view.g_tab_nmq_id.DELETE;
--
END nm_mrg_query_types_a_id_Stm;
/

CREATE OR REPLACE TRIGGER nm_mrg_output_file_b4_stm_trg
   BEFORE DELETE
    ON   nm_mrg_output_file
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_file_output_file_b4_stm
--      BEFORE DELETE
--       ON   nm_mrg_file_output_file
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3mrg_output.delete_change_array;
END nm_mrg_output_file_b4_stm_trg;
/

CREATE OR REPLACE TRIGGER nm_mrg_output_file_stm_trg
   AFTER DELETE
    ON   nm_mrg_output_file
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_file_output_file_stm
--      AFTER DELETE
--       ON   nm_mrg_file_output_file
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3mrg_output.drop_nmf_objects_from_chg_arr;
   nm3mrg_output.delete_change_array;
END nm_mrg_output_file_stm_trg;
/

CREATE OR REPLACE TRIGGER nm_mrg_output_file_b_d_trg
   BEFORE DELETE
    ON   nm_mrg_output_file
    FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nm_mrg_file_output_file_a_d
--      BEFORE DELETE
--       ON   nm_mrg_file_output_file
--       FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3mrg_output.add_to_change_array(:OLD.nmf_id);
END nm_mrg_output_file_b_d_trg;
/

CREATE OR REPLACE TRIGGER nmc_b_i_u_trg
  BEFORE INSERT OR UPDATE
   ON    nm_mrg_output_cols
   FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)merge.trg	1.10 03/05/02
--       Module Name      : merge.trg
--       Date into SCCS   : 02/03/05 10:41:47
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.10
--
--   TRIGGER nmc_b_i_u_trg
--    BEFORE INSERT OR UPDATE
--     ON    nm_mrg_output_cols
--     FOR   EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   IF :NEW.nmc_view_col_name IS NULL
    THEN
      :NEW.nmc_view_col_name := 'COL_'||:NEW.nmc_seq_no;
   ELSIF NOT nm3flx.is_string_valid_for_object(:NEW.nmc_view_col_name)
    THEN
      hig.raise_ner('NET',30,Null,'"'||:NEW.nmc_view_col_name||'"');
   END IF;
END nmc_b_i_u_trg;
/
