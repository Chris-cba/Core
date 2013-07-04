CREATE OR REPLACE FORCE VIEW v_nm_gaz_query_item_list AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_gaz_query_item_list.vw	1.2 12/03/03
--       Module Name      : v_nm_gaz_query_item_list.vw
--       Date into SCCS   : 03/12/03 10:05:31
--       Date fetched Out : 07/06/13 17:08:33
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   v_nm_gaz_query_item_list view on nm_gaz_query_item_list
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       ngqi_job_id
      ,ngqi_item_type_type
      ,ngqi_item_type
      ,ngqi_item_id
      ,SUBSTR(nm3gaz_qry.get_ngqt_item_type_type_descr (ngqi_item_type_type),1,80) item_type_type
      ,SUBSTR(nm3gaz_qry.get_ngqt_lov_descr (ngqi_item_type_type,ngqi_item_type),1,80) item_type
 FROM  nm_gaz_query_item_list
WITH READ ONLY
/
