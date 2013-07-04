CREATE OR REPLACE FORCE VIEW V_NM_GAZ_QUERY_SAVED_ALL
(
  VNGQS_NGQS_NGQ_ID,
  VNGQS_NGQS_SOURCE_ID,
  VNGQS_NGQS_SOURCE_DESCR,
  VNGQS_NGQS_SOURCE,
  VNGQS_NGQS_OPEN_OR_CLOSED,
  VNGQS_NGQS_ITEMS_OR_AREA,
  VNGQS_NGQS_QUERY_ALL_ITEMS,
  VNGQS_NGQS_BEGIN_MP,
  VNGQS_NGQS_BEGIN_DATUM_NE_ID,
  VNGQS_NGQS_BEGIN_DATUM_OFFSET,
  VNGQS_NGQS_END_MP,
  VNGQS_NGQS_END_DATUM_NE_ID,
  VNGQS_NGQS_END_DATUM_OFFSET,
  VNGQS_NGQS_AMBIG_SUB_CLASS,
  VNGQS_NGQS_DESCR,
  VNGQS_NGQS_QUERY_OWNER,
  VNGQS_NGQS_DATE_CREATED,
  VNGQS_NGQS_DATE_MODIFIED,
  VNGQS_NGQS_MODIFIED_BY,
  VNGQS_NGQS_CREATED_BY,
  VNGQS_NGQS_ITEM_TYPE_TYPE,
  VNGQS_NGQS_ITEM_TYPE_DESCR,
  VNGQS_NGQS_ITEM_TYPE,
  VNGQS_NGQS_TYPE_DESCR
)
AS
    SELECT   
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_gaz_query_saved_all.vw-arc   3.1   Jul 04 2013 11:35:14   James.Wadsworth  $
    --       Module Name      : $Workfile:   v_nm_gaz_query_saved_all.vw  $
    --       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
    --       Date fetched Out : $Modtime:   Jul 04 2013 11:32:30  $
    --       Version          : $Revision:   3.1  $
    --       Based on SCCS version : 
    -----------------------------------------------------------------------------
    --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
             ngqs_ngq_id,
             ngqs_source_id,
             CASE
               WHEN ngqs_source = 'ROUTE' THEN nm3net.get_ne_unique (ngqs_source_id)
               WHEN ngqs_source = 'TEMP_NE' THEN 'ALL NETWORK'
             END ,
             ngqs_source,
             ngqs_open_or_closed,
             ngqs_items_or_area,
             ngqs_query_all_items,
             ngqs_begin_mp,
             ngqs_begin_datum_ne_id,
             ngqs_begin_datum_offset,
             ngqs_end_mp,
             ngqs_end_datum_ne_id,
             ngqs_end_datum_offset,
             ngqs_ambig_sub_class,
             ngqs_descr,
             ngqs_query_owner,
             ngqs_date_created,
             ngqs_date_modified,
             ngqs_modified_by,
             ngqs_created_by,
             ngqts_item_type_type,
             CASE
               WHEN ngqts_item_type_type = 'I' THEN 'Inventory'
               WHEN ngqts_item_type_type = 'E' THEN 'Network'
             END ,
             ngqts_item_type,
             CASE
               WHEN ngqts_item_type_type = 'I'
               THEN
                 (SELECT   nit_descr
                    FROM   nm_inv_types
                   WHERE   nit_inv_type = ngqts_item_type)
             END 
      FROM   nm_gaz_query_saved, nm_gaz_query_types_saved
     WHERE   ngqts_ngq_id(+) = ngqs_ngq_id;
/


