DROP MATERIALIZED VIEW v_lb_rep_asset_locations;

CREATE MATERIALIZED VIEW V_LB_REP_ASSET_LOCATIONS
   (
   GUID,
   ASSET_SOURCE,
   ASSET_ID,
   EB_OBJECT_TYPE,
   EXOR_ASSET_TYPE,
   ASSET_TYPE_DESCR,
   XSP,
   NETWORK_ELEMENT_ID,
   NETWORK_ELEMENT_NAME,
   NETWORK_ELEMENT_TYPE,
   NETWORK_ELEMENT_GROUP_TYPE,
   NETWORK_ELEMENT_DESCRIPTION,
   DIRECTION_INDICATOR,
   START_MEASURE,
   END_MEASURE,
   NETWORK_NAME_DESCR,
   REVISION
   )
   BUILD IMMEDIATE
   REFRESH FORCE ON DEMAND
AS
   SELECT                                                                   --
          -- A materialized set of aggregated asset locations. The data consists of all assets from the eB/LB or Exor inventory data.
          -- The locations of each asset are supplied as they are persisted (usually against a datum network) and aggregated relative
          -- to each possible route type.
          -- The difference between the handling of XSP values means that the network locations are built from four parts that are unioned together.
          -- The persisted data in brought back as two of the components, each feeding into the aggregation procedure for that particular data.
          -- The network text data is concatenated to provide a text based index to operate on both name
          -- and description simultaneously.
          --
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/views/V_LB_REP_ASSET_LOCATIONS.vw-arc   1.5   May 16 2018 15:04:08   Rob.Coupe  $
          --       Module Name      : $Workfile:   V_LB_REP_ASSET_LOCATIONS.vw  $
          --       Date into PVCS   : $Date:   May 16 2018 15:04:08  $
          --       Date fetched Out : $Modtime:   May 16 2018 15:03:26  $
          --       Version          : $Revision:   1.5  $
          -----------------------------------------------------------------------------------------------------
          --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------------------------------
          --
          SYS_GUID () guid, -- globally unique identifier assemebled through sys_guid() at time of materialization
          t1.category Asset_Source, -- a flag of either 'I' for Exor Inventory or 'L' for Location Bridge/eB assets.
          Asset_id Asset_id, -- the Exor internal Inventory ID (IIT_NE_ID) or the eB asset id depending on the source
          eB_object_type eb_object_type, -- the eB object as defined in the LB_TYPES table for the specific asset type (NULL for Exor inventory)
          Exor_asset_type, -- the Exor Inventory type or LB foreign table type (Exor NIT_INV_TYPE)
          Asset_type_descr, -- the description of the asset type (from the Location Bridge asset registry or the inventory type description
          XSP, -- The Cross-Sectional-Position of the asset location (relative to the network element in the case of LB data)
          ne_id network_element_id, -- the internal ID of the Exor network element (NE_ID)
          ne_unique network_element_name, -- Exor network element name (NE_UNIQUE)
          ne_nt_type network_element_type, -- Exor network element network type
          ne_gty_group_type network_element_group_type, -- Exor network element group type (NULL for Datums)
          ne_descr network_element_description, -- Exor network element description
          dir_flag direction_indicator, -- An indicator to suggest the relative direction of the recording of the asset relative to that of the linear element
          start_measure, -- The measure along the referenced element at which the asset is deemed to start
          end_measure, -- The measure along the referenced element at which the asset is deemed to end
          ne_unique || ne_descr network_name_descr, -- A concatenation of network name and description to provide text-based indexing
          '$Revision:   1.5  $' Revision 
     FROM (WITH inv_types
                AS (SELECT CASE nit_category WHEN 'L' THEN 'L' ELSE 'I' END
                              category,
                           nit_inv_type,
                           CASE nit_category
                              WHEN 'L'
                              THEN
                                 (SELECT NVL (lb_asset_group, nit_descr)
                                    FROM lb_types
                                   WHERE lb_exor_inv_type = nit_inv_type)
                              ELSE
                                 nit_descr
                           END
                              asset_type_descr
                      FROM nm_inv_types
                     WHERE nit_category IN ('I', 'L')), -- and nit_inv_type = 'EW'),
                gty
                AS (  SELECT nin_nit_inv_code inv_type,
                             nng_group_type linear_group_type
                        FROM nm_inv_nw,
                             nm_nt_groupings,
                             nm_linear_types,
                             inv_types
                       WHERE     nlt_gty_type = nng_group_type
                             AND nng_nt_type = nin_nw_type
                             AND nin_nit_inv_code = nit_inv_type
                    GROUP BY nin_nit_inv_code, nng_group_type),
                inv_membs
                AS (SELECT category,
                           asset_type_descr,
                           nm_ne_id_in Asset_id,
                           NULL eB_object_type,
                           iit_x_sect xsp,
                           iit_x_sect new_xsp,
                           nm_ne_id_in location_id,
                           nm_ne_id_of datum_id,
                           nm_obj_type exor_asset_type,
                           nm_begin_mp start_measure,
                           nm_end_mp end_measure,
                           nm_start_date,
                           nm_end_date,
                           nm_cardinality dir_flag,
                           NULL nlt_id,
                           nm_start_date start_date,
                           nm_end_date end_date
                      FROM nm_members, inv_types, nm_inv_items
                     WHERE     nm_obj_type = nit_inv_type
                           AND category = 'I'
                           AND nm_ne_id_in = iit_ne_id
                           ),
                lb_membs
                AS (SELECT category,
                           asset_type_descr,
                           nal_asset_id Asset_Id,
                           lb_object_type eB_object_type,
                           nm_x_sect_st XSP,
                           CASE
                              WHEN nm_x_sect_st IS NULL
                              THEN
                                 NULL
                              ELSE
                                 (SELECT NVL (rvrs_xsp, nm_x_sect_st)
                                    FROM v_nm_element_xsp_rvrs r
                                   WHERE     r.xsp_element_id = nm_ne_id_of
                                         AND r.element_xsp = nm_x_sect_st)
                           END
                              new_xsp,
                           nm_ne_id_in location_id,
                           nm_ne_id_of datum_id,
                           nm_obj_type exor_asset_type,
                           nm_begin_mp start_measure,
                           nm_end_mp end_measure,
                           nm_start_date,
                           nm_end_date,
                           nm_dir_flag dir_flag,
                           nm_nlt_id nlt_id,
                           nm_start_date start_date,
                           nm_end_date end_date
                      FROM nm_locations_all,
                           inv_types,
                           lb_types,
                           nm_asset_locations
                     WHERE     nm_obj_type = nit_inv_type
                           AND category = 'L'
                           AND nit_inv_type = lb_exor_inv_type
                           AND nal_id = nm_ne_id_in
                           AND nm_end_date IS NULL
                           )
           SELECT category,
                  asset_type_descr,
                  asset_id,
                  eB_object_type,
                  dir_flag,
                  XSP,
                  location_id,
                  exor_asset_type,
                  datum_id network_element_id,
                  start_measure,
                  end_measure
             FROM inv_membs
           UNION ALL
           SELECT category,
                  asset_type_descr,
                  asset_id,
                  eB_object_type,
                  dir_flag,
                  new_xsp,
                  location_id,
                  exor_asset_type,
                  datum_id network_element_id,
                  start_measure,
                  end_measure
             FROM lb_membs
           UNION ALL
           SELECT category,
                  asset_type_descr,
                  asset_id,
                  eB_object_type,
                  t.dir_flag,
                  XSP,
                  location_id,
                  exor_asset_type,
                  t.refnt,
                  t.start_m,
                  t.end_m
             FROM (  SELECT category,
                            asset_type_descr,
                            asset_id,
                            eB_object_type,
                            dir_flag,
                            XSP,
                            location_id,
                            exor_asset_type,
                            CAST (COLLECT (lb_rpt (datum_id,
                                                   nlt_id,
                                                   exor_asset_type,
                                                   location_id,
                                                   NULL,
                                                   NULL,
                                                   dir_flag,
                                                   start_measure,
                                                   end_measure,
                                                   1)) AS lb_rpt_tab)
                               location_tab
                       FROM inv_membs
                   GROUP BY category,
                            asset_type_descr,
                            asset_id,
                            eB_object_type,
                            dir_flag,
                            XSP,
                            location_id,
                            exor_asset_type),
                  gty,
                  TABLE (
                     lb_get.get_lb_rpt_r_tab (location_tab,
                                              linear_group_type,
                                              10)) t
            WHERE exor_asset_type = inv_type
           UNION ALL
           SELECT category,
                  asset_type_descr,
                  asset_id,
                  eB_object_type,
                  t.dir_flag,
                  t.XSP,
                  location_id,
                  exor_asset_type,
                  t.refnt,
                  t.start_m,
                  t.end_m
             FROM (  SELECT category,
                            asset_type_descr,
                            asset_id,
                            eB_object_type,
                            dir_flag,
                            XSP,
                            location_id,
                            exor_asset_type,
                            CAST (COLLECT (lb_xrpt (datum_id,
                                                    nlt_id,
                                                    exor_asset_type,
                                                    location_id,
                                                    NULL,
                                                    NULL,
                                                    dir_flag,
                                                    start_measure,
                                                    end_measure,
                                                    1,
                                                    xsp,
                                                    NULL,
                                                    NULL,
                                                    NULL)) AS lb_xrpt_tab)
                               location_tab
                       FROM lb_membs
                   GROUP BY category,
                            asset_type_descr,
                            asset_id,
                            eB_object_type,
                            dir_flag,
                            XSP,
                            location_id,
                            exor_asset_type),
                  gty,
                  TABLE (
                     lb_get.get_lb_xrpt_r_tab (location_tab,
                                               linear_group_type,
                                               10)) t
            WHERE exor_asset_type = inv_type) t1,
          nm_elements e
    WHERE network_element_id = ne_id
/


COMMENT ON MATERIALIZED VIEW V_LB_REP_ASSET_LOCATIONS IS
   'snapshot table for snapshot V_LB_REP_ASSET_LOCATIONS';

COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.guid IS
   'Generally Universal Identifier assigned at time of materialization';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.Asset_Source IS
   'A flag of either I for Exor Inventory or L for Location Bridge/eB assets';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.Asset_id IS
   'The Exor internal Inventory ID (IIT_NE_ID) or the eB asset id depending on the source';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.eB_object_type IS
   'The eB object as defined in the LB_TYPES table for the specific asset type (NULL for Exor inventory)';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.Exor_asset_type IS
   'The Exor Inventory type or LB foreign table type (Exor NIT_INV_TYPE)';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.XSP IS
   'The Cross-Sectional-Position of the asset location (relative to the network element in the case of LB data)';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.network_element_id IS
   'The internal ID of the Exor network element (NE_ID)';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.network_element_name IS
   'Exor network element name (NE_UNIQUE)';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.network_element_type IS
   'Exor network element network type';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.network_element_group_type IS
   'Exor network element group type (NULL for Datums)';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.network_element_description IS
   'Exor network element description';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.start_measure IS
   'The measure along the referenced element at which the asset is deemed to start';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.end_measure IS
   'The measure along the referenced element at which the asset is deemed to end';
COMMENT ON COLUMN V_LB_REP_ASSET_LOCATIONS.network_name_descr IS
   'A concatenation of network name and description to provide text-based indexing';

ALTER TABLE V_LB_REP_ASSET_LOCATIONS ADD CONSTRAINT PK_V_LB_REP_ASSET_LOCATIONS PRIMARY KEY (guid);

CREATE INDEX lb_rep_al_asset_idx
   ON V_LB_REP_ASSET_LOCATIONS (asset_id, asset_source);

CREATE INDEX lb_rep_al_network_id_idx
   ON V_LB_REP_ASSET_LOCATIONS (network_element_id,
                                exor_asset_type,
                                asset_id,
                                asset_source);

CREATE INDEX lb_rep_al_network_name_idx
   ON V_LB_REP_ASSET_LOCATIONS (network_element_name,
                                network_element_type,
                                network_element_group_type,
                                exor_asset_type,
                                asset_id,
                                asset_source);

CREATE INDEX lb_rep_al_net_concat_idx
   ON V_LB_REP_ASSET_LOCATIONS (network_name_descr)
   INDEXTYPE IS ctxsys.context;
   