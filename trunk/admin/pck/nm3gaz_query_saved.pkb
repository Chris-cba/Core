CREATE OR REPLACE PACKAGE BODY nm3gaz_query_saved
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3gaz_query_saved.pkb-arc   3.1   Jul 04 2013 15:37:06   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3gaz_query_saved.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:37:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:35:48  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.1  $';

  g_package_name CONSTANT varchar2(30) := 'nm3gaz_query_saved';
--
-----------------------------------------------------------------------------
--
  FUNCTION get_version RETURN varchar2 IS
  BEGIN
     RETURN g_sccsid;
  END get_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN varchar2 IS
  BEGIN
     RETURN g_body_sccsid;
  END get_body_version;
--
-----------------------------------------------------------------------------
--
  PROCEDURE clearout_tables ( pi_ngq_id IN nm_gaz_query.ngq_id%TYPE )
  IS
  BEGIN
    DELETE nm_gaz_query_values_saved WHERE ngqvs_ngq_id = pi_ngq_id;
    DELETE nm_gaz_query_attribs_saved WHERE ngqas_ngq_id = pi_ngq_id;
    DELETE nm_gaz_query_types_saved WHERE ngqts_ngq_id = pi_ngq_id;
    DELETE nm_gaz_query_saved WHERE ngqs_ngq_id = pi_ngq_id;
  END clearout_tables;
--
-----------------------------------------------------------------------------
--
  PROCEDURE save_ngq_query(pi_ngq_id      IN VARCHAR2
                          ,pi_query_owner IN VARCHAR2 DEFAULT 'PUBLIC'
                          ,pi_descr       IN VARCHAR2) 
  IS
    l_nit_type   nm_inv_types.nit_inv_type%TYPE;
    l_nit_descr   nm_inv_types.nit_descr%TYPE;
  BEGIN

  --############################################################
  --PI_QUERY_TYPE parameter - default 'PUBLIC'
  --which you set to NM_GAZ_QUERY_SAVED.NGQS_QUERY_TYPE column
  --and the PI_DESCR attribute - set to NM_GAZ_QUERY_SAVED.NGQS_DESCR
  --############################################################
  --
    clearout_tables (pi_ngq_id);
  --
    INSERT INTO nm_gaz_query_saved
       ( ngqs_ngq_id
       , ngqs_source_id
       , ngqs_source
       , ngqs_open_or_closed
       , ngqs_items_or_area
       , ngqs_query_all_items
       , ngqs_begin_mp
       , ngqs_begin_datum_ne_id
       , ngqs_begin_datum_offset
       , ngqs_end_mp
       , ngqs_end_datum_ne_id
       , ngqs_end_datum_offset
       , ngqs_ambig_sub_class
       , ngqs_descr
       , ngqs_query_owner )
      SELECT ngq_id
           , ngq_source_id
           , ngq_source
           , ngq_open_or_closed
           , ngq_items_or_area
           , ngq_query_all_items
           , ngq_begin_mp
           , ngq_begin_datum_ne_id
           , ngq_begin_datum_offset
           , ngq_end_mp
           , ngq_end_datum_ne_id
           , ngq_end_datum_offset
           , ngq_ambig_sub_class
           , pi_descr 
           , pi_query_owner
        FROM nm_gaz_query
       WHERE ngq_id = pi_ngq_id;
  --
    INSERT INTO nm_gaz_query_types_saved
      ( ngqts_ngq_id
      , ngqts_seq_no
      , ngqts_item_type_type
      , ngqts_item_type )
      SELECT ngqt_ngq_id
           , ngqt_seq_no
           , ngqt_item_type_type
           , ngqt_item_type
        FROM nm_gaz_query_types 
       WHERE ngqt_ngq_id = pi_ngq_id;
  --
    WITH unique_asset 
      AS
        (SELECT UNIQUE ngqt_item_type asset_type
           FROM nm_gaz_query_types 
          WHERE ngqt_ngq_id = pi_ngq_id ) 
    SELECT asset_type
      INTO l_nit_type
      FROM unique_asset; 
  --
      INSERT into nm_gaz_query_attribs_saved
      ( ngqas_ngq_id
      , ngqas_ngqt_seq_no
      , ngqas_seq_no
      , ngqas_nit_type
      , ngqas_attrib_name
      , ngqas_operator
      , ngqas_pre_bracket
      , ngqas_post_bracket
      , ngqas_condition)
      SELECT ngqa_ngq_id
           , ngqa_ngqt_seq_no
           , ngqa_seq_no
           , l_nit_type
           , ngqa_attrib_name
           , ngqa_operator
           , ngqa_pre_bracket
           , ngqa_post_bracket
           , ngqa_condition
        FROM nm_gaz_query_attribs
       WHERE ngqa_ngq_id = pi_ngq_id;
  --
    INSERT INTO nm_gaz_query_values_saved
      ( ngqvs_ngq_id
      , ngqvs_ngqt_seq_no
      , ngqvs_ngqa_seq_no
      , ngqvs_sequence
      , ngqvs_value ) 
        SELECT ngqv_ngq_id
             , ngqv_ngqt_seq_no
             , ngqv_ngqa_seq_no
             , ngqv_sequence
             , ngqv_value 
          FROM nm_gaz_query_values 
         WHERE ngqv_ngq_id = pi_ngq_id;
  --
  END save_ngq_query;
--
-----------------------------------------------------------------------------
--
  PROCEDURE restore_query( pi_ngq_id  IN VARCHAR2 )
  IS
    l_rec_ngq   nm_gaz_query%ROWTYPE;
    l_rec_ngqt  nm_gaz_query_types%ROWTYPE;
  --
    l_tab_ngqa_ngq_id        nm3type.tab_number;
    l_tab_ngqa_ngqt_seq_no   nm3type.tab_number;
    l_tab_ngqa_seq_no        nm3type.tab_number;
    l_tab_ngqa_attrib_name   nm3type.tab_varchar30;
    l_tab_ngqa_operator      nm3type.tab_varchar4;
    l_tab_ngqa_pre_bracket   nm3type.tab_varchar30;
    l_tab_ngqa_post_bracket  nm3type.tab_varchar30;
    l_tab_ngqa_condition     nm3type.tab_varchar30;
  --
    l_tab_ngqv_ngq_id        nm3type.tab_number;
    l_tab_ngqv_ngqt_seq_no   nm3type.tab_number;
    l_tab_ngqv_ngqa_seq_no   nm3type.tab_number;
    l_tab_ngqv_sequence      nm3type.tab_number;
    l_tab_ngqv_value         nm3type.tab_varchar4000;
  --
  BEGIN
  --
  --
    SELECT ngqs_ngq_id
         , ngqs_source_id
         , ngqs_source
         , ngqs_open_or_closed
         , ngqs_items_or_area
         , ngqs_query_all_items
         , ngqs_begin_mp
         , ngqs_begin_datum_ne_id
         , ngqs_begin_datum_offset
         , ngqs_end_mp
         , ngqs_end_datum_ne_id
         , ngqs_end_datum_offset
         , ngqs_ambig_sub_class
      INTO l_rec_ngq
      FROM nm_gaz_query_saved
     WHERE ngqs_ngq_id = pi_ngq_id;
  --
  -- nm_gaz_query
  --
    MERGE INTO nm_gaz_query a
    USING (SELECT l_rec_ngq.ngq_id                 ngq_id
                , l_rec_ngq.ngq_source_id          ngq_source_id
                , l_rec_ngq.ngq_source             ngq_source
                , l_rec_ngq.ngq_open_or_closed     ngq_open_or_closed
                , l_rec_ngq.ngq_items_or_area      ngq_items_or_area
                , l_rec_ngq.ngq_query_all_items    ngq_query_all_items
                , l_rec_ngq.ngq_begin_mp           ngq_begin_mp
                , l_rec_ngq.ngq_begin_datum_ne_id  ngq_begin_datum_ne_id
                , l_rec_ngq.ngq_begin_datum_offset ngq_begin_datum_offset
                , l_rec_ngq.ngq_end_mp             ngq_end_mp
                , l_rec_ngq.ngq_end_datum_ne_id    ngq_end_datum_ne_id
                , l_rec_ngq.ngq_end_datum_offset   ngq_end_datum_offset
                , l_rec_ngq.ngq_ambig_sub_class    ngq_ambig_sub_class
             FROM dual ) b
         ON ( a.ngq_id = b.ngq_id )
       WHEN MATCHED THEN
     UPDATE SET a.ngq_source_id          = b.ngq_source_id
              , a.ngq_source             = b.ngq_source
              , a.ngq_open_or_closed     = b.ngq_open_or_closed
              , a.ngq_items_or_area      = b.ngq_items_or_area
              , a.ngq_query_all_items    = b.ngq_query_all_items
              , a.ngq_begin_mp           = b.ngq_begin_mp
              , a.ngq_begin_datum_ne_id  = b.ngq_begin_datum_ne_id
              , a.ngq_begin_datum_offset = b.ngq_begin_datum_offset
              , a.ngq_end_mp             = b.ngq_end_mp
              , a.ngq_end_datum_ne_id    = b.ngq_end_datum_ne_id
              , a.ngq_end_datum_offset   = b.ngq_end_datum_offset
              , a.ngq_ambig_sub_class    = b.ngq_ambig_sub_class
       WHEN NOT MATCHED 
       THEN INSERT VALUES l_rec_ngq;
  --
  ------------
  --
    SELECT ngqts_ngq_id, ngqts_seq_no, ngqts_item_type_type, ngqts_item_type
      INTO l_rec_ngqt
      FROM nm_gaz_query_types_saved
     WHERE ngqts_ngq_id = pi_ngq_id;
  --
  -- nm_gaz_query_types
  --
    MERGE INTO nm_gaz_query_types a
    USING (SELECT l_rec_ngqt.ngqt_ngq_id          ngqt_ngq_id
                , l_rec_ngqt.ngqt_seq_no          ngqt_seq_no
                , l_rec_ngqt.ngqt_item_type_type  ngqt_item_type_type
                , l_rec_ngqt.ngqt_item_type       ngqt_item_type
             FROM dual ) b
         ON (    a.ngqt_ngq_id = b.ngqt_ngq_id
             AND a.ngqt_seq_no = b.ngqt_seq_no )
       WHEN MATCHED THEN
     UPDATE SET a.ngqt_item_type_type = b.ngqt_item_type_type
              , a.ngqt_item_type      = b.ngqt_item_type
       WHEN NOT MATCHED 
       THEN INSERT VALUES l_rec_ngqt;
  --
    SELECT ngqas_ngq_id
         , ngqas_ngqt_seq_no
         , ngqas_seq_no
         , ngqas_attrib_name
         , ngqas_operator
         , ngqas_pre_bracket
         , ngqas_post_bracket
         , ngqas_condition
      BULK COLLECT INTO l_tab_ngqa_ngq_id 
                      , l_tab_ngqa_ngqt_seq_no
                      , l_tab_ngqa_seq_no
                      , l_tab_ngqa_attrib_name
                      , l_tab_ngqa_operator
                      , l_tab_ngqa_pre_bracket
                      , l_tab_ngqa_post_bracket
                      , l_tab_ngqa_condition
      FROM nm_gaz_query_attribs_saved
     WHERE ngqas_ngq_id = pi_ngq_id;
  --
  -- nm_gaz_query_attribs
    FORALL items IN 1..l_tab_ngqa_ngq_id.COUNT
      MERGE INTO nm_gaz_query_attribs a
      USING (SELECT l_tab_ngqa_ngq_id(items)       ngqa_ngq_id
                  , l_tab_ngqa_ngqt_seq_no(items)  ngqa_ngqt_seq_no
                  , l_tab_ngqa_seq_no(items)       ngqa_seq_no
                  , l_tab_ngqa_attrib_name(items)  ngqa_attrib_name
                  , l_tab_ngqa_operator(items)     ngqa_operator
                  , l_tab_ngqa_pre_bracket(items)  ngqa_pre_bracket
                  , l_tab_ngqa_post_bracket(items) ngqa_post_bracket
                  , l_tab_ngqa_condition(items)    ngqa_condition
             FROM dual ) b
         ON (    a.ngqa_ngq_id      = b.ngqa_ngq_id
             AND a.ngqa_ngqt_seq_no = b.ngqa_ngqt_seq_no
             AND a.ngqa_seq_no      = b.ngqa_seq_no )
       WHEN MATCHED THEN
        UPDATE SET a.ngqa_attrib_name  = b.ngqa_attrib_name
                 , a.ngqa_operator     = b.ngqa_operator
                 , a.ngqa_pre_bracket  = b.ngqa_pre_bracket
                 , a.ngqa_post_bracket = b.ngqa_post_bracket
                 , a.ngqa_condition    = b.ngqa_condition
       WHEN NOT MATCHED 
       THEN INSERT (ngqa_ngq_id, ngqa_ngqt_seq_no, ngqa_seq_no
                  , ngqa_attrib_name, ngqa_operator, ngqa_pre_bracket
                  , ngqa_post_bracket, ngqa_condition)
            VALUES ( l_tab_ngqa_ngq_id(items)
                 , l_tab_ngqa_ngqt_seq_no(items)
                 , l_tab_ngqa_seq_no(items)
                 , l_tab_ngqa_attrib_name(items)
                 , l_tab_ngqa_operator(items)
                 , l_tab_ngqa_pre_bracket(items)
                 , l_tab_ngqa_post_bracket(items)
                 , l_tab_ngqa_condition(items));
  --
    SELECT ngqvs_ngq_id
         , ngqvs_ngqt_seq_no
         , ngqvs_ngqa_seq_no
         , ngqvs_sequence
         , ngqvs_value
      BULK COLLECT INTO l_tab_ngqv_ngq_id
                      , l_tab_ngqv_ngqt_seq_no
                      , l_tab_ngqv_ngqa_seq_no
                      , l_tab_ngqv_sequence
                      , l_tab_ngqv_value
      FROM nm_gaz_query_values_saved
     WHERE ngqvs_ngq_id = pi_ngq_id;
  --
--  -- nm_gaz_query_values
    FORALL items IN 1..l_tab_ngqv_ngq_id.COUNT
      MERGE INTO nm_gaz_query_values a
        USING (SELECT l_tab_ngqv_ngq_id(items)      ngqv_ngq_id
                    , l_tab_ngqv_ngqt_seq_no(items) ngqv_ngqt_seq_no
                    , l_tab_ngqv_ngqa_seq_no(items) ngqv_ngqa_seq_no
                    , l_tab_ngqv_sequence(items)    ngqv_sequence
                    , l_tab_ngqv_value(items)       ngqv_value
                 FROM dual ) b
           ON (  a.ngqv_ngq_id      = b.ngqv_ngq_id
             AND a.ngqv_ngqt_seq_no = b.ngqv_ngqt_seq_no
             AND a.ngqv_ngqa_seq_no = b.ngqv_ngqa_seq_no 
             AND a.ngqv_sequence    = b.ngqv_sequence )
      WHEN MATCHED THEN
        UPDATE SET a.ngqv_value  = b.ngqv_value
      WHEN NOT MATCHED THEN 
        INSERT ( ngqv_ngq_id, ngqv_ngqt_seq_no, ngqv_ngqa_seq_no
               , ngqv_sequence, ngqv_value)
          VALUES ( l_tab_ngqv_ngq_id(items)
                 , l_tab_ngqv_ngqt_seq_no(items)
                 , l_tab_ngqv_ngqa_seq_no(items)
                 , l_tab_ngqv_sequence(items)
                 , l_tab_ngqv_value(items) );
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      RAISE_APPLICATION_ERROR (-20101,'No saved query found for '||pi_ngq_id );
  END restore_query;
--
-----------------------------------------------------------------------------
--
END nm3gaz_query_saved;
/
