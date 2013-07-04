CREATE OR REPLACE FORCE VIEW nm0575_matching_records (asset_category
                                                    , asset_type
                                                    , asset_type_descr
                                                    , asset_count)
AS SELECT /*+RULE*/
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm0575_matching_records.vw	1.2 11/16/06
--       Module Name      : nm0575_matching_records.vw
--       Date into SCCS   : 06/11/16 15:42:17
--       Date fetched Out : 07/06/13 17:08:23
--       SCCS Version     : 1.2
--
--
--   Author : Graeme Johnson
--   Returns the results of a gaz query grouped up by asset type
--   Used by forms module NM0575 and package nm0575
--
--   Date         Initials    Change
--
--   14-NOB-2006  GJ          Original Version
--   16-NOV-2006  GJ          Added RULE hint cos against certain schemas the query
--                            would not perform i.e. fts of nm_inv_types even though
--                            the join between nm_inv_items_all and nm_inv_types uses a unique indexed column 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
        nit_category       asset_category          
       ,nit_inv_type       asset_type
       ,UPPER(nit_descr)   asset_type_descr
       ,count(*)           asset_count
 FROM  nm_inv_items_all
      ,nm_gaz_query_item_list
      ,nm_inv_types_all
 WHERE ngqi_job_id  = nm0575.get_current_result_set_id
 AND   ngqi_item_id = iit_ne_id
 AND   iit_inv_type =  nit_inv_type
 GROUP BY  nit_category          
          ,nit_inv_type
          ,UPPER(nit_descr)
 HAVING COUNT(*) > 0            
 ORDER BY 1,2
/
