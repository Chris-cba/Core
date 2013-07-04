CREATE OR REPLACE PACKAGE BODY nm3asset_rep AS
--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3asset_rep.pkb-arc   2.3   Jul 04 2013 15:15:40   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3asset_rep.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:40  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.2
--
--   Author : Kevin Angus
--
--   nm3asset_rep body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.3  $';
  g_package_name           CONSTANT varchar2(30) := 'nm3asset_rep';
  c_nl                     CONSTANT varchar2(1) := CHR(10);
  c_aor_filename           CONSTANT hig_modules.hmo_filename%TYPE := 'NM0560';
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
FUNCTION get_aor_reports_lov_sql RETURN varchar2 IS

  l_retval nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_aor_reports_lov_sql');

  ---------------------------------------------------------------
  --select modules that use the AOR from and are also gri modules
  ---------------------------------------------------------------
  l_retval :=            'SELECT'
              || c_nl || '  hmo.hmo_module lup_meaning,'
              || c_nl || '  hmo.hmo_title  lup_description,'
              || c_nl || '  hmo.hmo_module lup_value'
              || c_nl || 'FROM'
              || c_nl || '  hig_modules hmo,'
              || c_nl || '  gri_modules grm'
              || c_nl || 'WHERE'
              || c_nl || '  LOWER(hmo.hmo_filename) = LOWER(' || nm3flx.string(c_aor_filename) || ')'
              || c_nl || 'AND'
              || c_nl || '  hmo.hmo_module = grm.grm_module';

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_aor_reports_lov_sql');

  RETURN l_retval;

END get_aor_reports_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION create_list_from_inv_attrs(pi_attr_tab  IN nm3asset.tab_rec_inv_flex_col_details
                                   ,pi_separator IN varchar2 DEFAULT ', '
                                   ) RETURN varchar2 IS

  c_max_varchar2_size CONSTANT pls_integer := nm3type.c_max_varchar2_size;

  l_retval nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_list_from_inv_attrs');

  IF pi_attr_tab.COUNT > 0
  THEN
    l_retval := pi_attr_tab(1).iit_value;

    FOR l_i IN 2..pi_attr_tab.COUNT
    LOOP
      IF LENGTH(l_retval) = c_max_varchar2_size
      THEN
        EXIT;
      END IF;

      l_retval := SUBSTR(l_retval || pi_separator || pi_attr_tab(l_i).iit_value, 1, c_max_varchar2_size);
    END LOOP;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_list_from_inv_attrs');

  RETURN l_retval;

END create_list_from_inv_attrs;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_inventory_item_details(pi_iit_ne_id           IN nm_inv_items.iit_ne_id%TYPE
                                    ,pi_nit_inv_type        IN nm_inv_types.nit_inv_type%TYPE
                                    ,pi_separator           IN varchar2 DEFAULT ', '
                                    ,pi_display_xsp_if_reqd IN boolean DEFAULT TRUE
                                    ,pi_display_descr       IN boolean DEFAULT TRUE
                                    ,pi_display_start_date  IN boolean DEFAULT TRUE
                                    ,pi_display_admin_unit  IN boolean DEFAULT TRUE
                                    ,pi_nias_id             IN nm_inv_attribute_sets.nias_id%TYPE DEFAULT NULL
                                    ,pi_populate_narsd      IN boolean DEFAULT FALSE
                                    ,pi_nars_job_id         IN nm_assets_on_route_store.nars_job_id%TYPE DEFAULT NULL
                                    ) IS


 -------------------------------------------------------------------------------------------------
 -- Populates the following temporary tables
 --    nm_assets_on_route_store_att
 --    nm_assets_on_route_att_d
 -- with details of inventory item attributes
 --
 -- IMPORTANT
 -- These temporary tables are ON COMMIT DELETE ROWS
 -- therefore a commit is not issued in this procedure
 -- However, a commit is subsequently issued in the report(s) that use these temp tables (to ensure
 -- that they are cleared down)
 -------------------------------------------------------------------------------------------------

   l_attr_tab nm3asset.tab_rec_inv_flex_col_details;

   l_narsd_rec nm_assets_on_route_store_att_d%ROWTYPE;
   l_narsa_rec nm_assets_on_route_store_att%ROWTYPE;

   l_retval nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_inv_attrs_as_list');



  IF pi_iit_ne_id IS NOT NULL
  THEN
    nm3asset.get_inv_flex_col_details(pi_iit_ne_id           => pi_iit_ne_id
                                     ,pi_nit_inv_type        => pi_nit_inv_type
                                     ,pi_display_xsp_if_reqd => pi_display_xsp_if_reqd
                                     ,pi_display_descr       => pi_display_descr
                                     ,pi_display_start_date  => pi_display_start_date
                                     ,pi_display_admin_unit  => pi_display_admin_unit
                                     ,pi_nias_id             => pi_nias_id
                                     ,po_flex_col_dets       => l_attr_tab);


    ------------------------------------------------------------------------
    -- For the given inventory item build a record to insert
    -- into temporary nm_assets_on_route_store_att
    -- This table will store the inventory item description as a single row
    ------------------------------------------------------------------------
    l_narsa_rec.narsa_job_id := pi_nars_job_id;
    l_narsa_rec.narsa_iit_ne_id := pi_iit_ne_id;
    l_narsa_rec.narsa_value     := create_list_from_inv_attrs(pi_attr_tab  => l_attr_tab
                                                             ,pi_separator => pi_separator);

    ----------------------------------------------------------------------
    -- call procedure to insert a record into nm_assets_on_route_store_att
    ----------------------------------------------------------------------
    nm3ins.ins_narsa(p_rec_narsa => l_narsa_rec);


    ------------------------------------------------------------------------
    -- If the flag has been set to indicate that a breakdown of the inventory
    -- item attributes is required then cycle through the l_attr_tab and create
    -- record(s) in temporary table nm_assets_on_route_store_att_d
    -- This table will store the a row for each inventory item attribute
    ------------------------------------------------------------------------
    IF pi_populate_narsd
      AND pi_nars_job_id IS NOT NULL
      AND l_attr_tab.COUNT > 0
    THEN
      l_narsd_rec.narsd_job_id    := pi_nars_job_id;
      l_narsd_rec.narsd_iit_ne_id := pi_iit_ne_id;

      FOR l_i IN 1..l_attr_tab.COUNT
      LOOP
        l_narsd_rec.narsd_attrib_name := l_attr_tab(l_i).ita_attrib_name;
        l_narsd_rec.narsd_scrn_text   := l_attr_tab(l_i).ita_scrn_text;  --GJ
        l_narsd_rec.narsd_seq_no      := l_i;
        l_narsd_rec.narsd_value       := l_attr_tab(l_i).iit_value;

         ------------------------------------------------------------------------
         -- call procedure to insert a record into nm_assets_on_route_store_att_d
         ------------------------------------------------------------------------
        nm3ins.ins_narsd(p_rec_narsd => l_narsd_rec);
      END LOOP;
    END IF;
  END IF;

--  COMMIT;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_inv_attrs_as_list');

END get_inventory_item_details;
--
-----------------------------------------------------------------------------
--
FUNCTION narsa_already_exists(
                              pi_narsa_job_id     IN nm_assets_on_route_store_att.narsa_job_id%TYPE
                             ,pi_narsa_iit_ne_id  IN nm_assets_on_route_store_att.narsa_iit_ne_id%TYPE
                             ) RETURN BOOLEAN IS

 l_narsa_exists VARCHAR2(1) := Null;

BEGIN

 SELECT 'Y'
 INTO   l_narsa_exists
 FROM   nm_assets_on_route_store_att narsa
 WHERE  narsa.narsa_job_id    = pi_narsa_job_id
 AND    narsa.narsa_iit_ne_id = pi_narsa_iit_ne_id
 AND    rownum=1;

 IF l_narsa_exists IS NOT NULL THEN
    RETURN(TRUE);
 ELSE
    RETURN(FALSE);
 END IF;

EXCEPTION
  WHEN no_data_found THEN
     RETURN (FALSE);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_inventory_items(
                                  pi_narsh_job_id         IN nm_assets_on_route_store_head.narsh_job_id%TYPE
                                 ,pi_populate_narsd       IN BOOLEAN
                                 ) IS

 -------------------------------------------------------------------------------------------------
 -- Calls get_inventory_item_details to populate the following temporary tables
 --    nm_assets_on_route_store_att
 --    nm_assets_on_route_att_d
 -- with details of inventory item attributes for inventory items that are referred to in the following tables
 --    nm_assets_on_route_store_head
 --    nm_assets_on_route_store
 --
 -- Temporary tables are used in certain Assets on Route reports
 -------------------------------------------------------------------------------------------------

 ------------
 -- row types
 ------------
 v_narsh_rec        nm_assets_on_route_store_head%ROWTYPE;  -- storing nm_assets_on_route_store_head record

 ----------------
 -- pl/sql tables
 ----------------
 l_tab_nars_ne_id_in              nm3type.tab_number;             -- storing nm_assets_on_route_store.nars_ne_id
 l_tab_nars_item_type             nm3type.tab_varchar4;           -- storing nm_assets_on_route_store.nars_item_type
 l_tab_nars_reference_item_id     nm3type.tab_number;             -- storing nm_assets_on_route_store.nars_reference_item_id

 ------------
 -- Constants
 ------------
 c_attr_list_sep hig_option_values.hov_value%TYPE := hig.get_user_or_sys_opt(pi_option => 'ATTRLSTSEP');

BEGIN

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_inventory_items');


 -------------------------------------------------------
 -- get details from nm_assets_on_route_store_head
 -------------------------------------------------------
 SELECT *
 INTO   v_narsh_rec
 FROM   nm_assets_on_route_store_head narsh
 WHERE  narsh.narsh_job_id = pi_narsh_job_id;



 --------------------------------------------------------------------------------------------------------
 -- If narsh reference item specified, and the reference item has not already been done i.e. there is not an existing record
 -- in nm_assets_on_route_store_att for the item id then
 -- Get Description and full list of attributes for NARSH_REFERENCE_ITEM_ID
 -- Write description to nm_assets_on_route_store_att
 -- Write full list of attributes to nm_assets_on_route_store_att_d
 --------------------------------------------------------------------------------------------------------
 IF v_narsh_rec.narsh_reference_item_id IS NOT NULL THEN

    IF NOT narsa_already_exists(pi_narsh_job_id
                               ,v_narsh_rec.narsh_reference_item_id )  THEN

       get_inventory_item_details(pi_iit_ne_id           => v_narsh_rec.narsh_reference_item_id
                                 ,pi_nit_inv_type        => v_narsh_rec.narsh_reference_inv_type
                                 ,pi_separator           => c_attr_list_sep
                                 ,pi_display_xsp_if_reqd => FALSE
                                 ,pi_display_descr       => FALSE
                                 ,pi_display_start_date  => FALSE
                                 ,pi_display_admin_unit  => FALSE
                                 ,pi_nias_id             => v_narsh_rec.narsh_nias_id
                                 ,pi_populate_narsd      => pi_populate_narsd
                                 ,pi_nars_job_id         => pi_narsh_job_id
                                 );

    END IF;  -- NOT narsa_already_exists

 END IF;  -- v_narsh_rec.narsh_reference_id IS NOT NULL


 -------------------------------------------------------------------------------------
 -- bulk collect into our pl/sql tables all records from from nm_assets_on_route_store
 -------------------------------------------------------------------------------------
 SELECT nars.nars_ne_id_in
       ,nars.nars_item_type
       ,nars.nars_reference_item_id
 BULK  COLLECT
 INTO  l_tab_nars_ne_id_in
      ,l_tab_nars_item_type
      ,l_tab_nars_reference_item_id
 FROM  nm_assets_on_route_store nars
 WHERE  nars.nars_job_id = pi_narsh_job_id;


 -------------------------------------------------------
 -- loop through all records in our pl/sql tables
 -------------------------------------------------------
 FOR i IN 1..l_tab_nars_ne_id_in.COUNT LOOP


     -----------------------------------------------------------------------------------------------
     -- Process the item if the item has not already been done i.e. there is not an existing record
     -- in nm_assets_on_route_store_att for the item id
     -- it is possible for an item to appear as the item and the nars reference item so we have to
     -- eliminate duplication otherwise the pk constraints of our temp tables will be broken
     -----------------------------------------------------------------------------------------------
     IF NOT narsa_already_exists(pi_narsh_job_id
                                ,l_tab_nars_ne_id_in(i) )  THEN

        --------------------------------------------------------------------------------------------------------
        -- Get Description and full list of attributes for NARS_NE_ID_IN
        -- Write description to nm_assets_on_route_store_att
        -- Write full list of attributes to nm_assets_on_route_store_att_d
        --------------------------------------------------------------------------------------------------------
        get_inventory_item_details(pi_iit_ne_id           => l_tab_nars_ne_id_in(i)
                                  ,pi_nit_inv_type        => l_tab_nars_item_type(i)
                                  ,pi_separator           => c_attr_list_sep
                                  ,pi_display_xsp_if_reqd => FALSE
                                  ,pi_display_descr       => FALSE
                                  ,pi_display_start_date  => FALSE
                                  ,pi_display_admin_unit  => FALSE
                                  ,pi_nias_id             => v_narsh_rec.narsh_nias_id
                                  ,pi_populate_narsd      => pi_populate_narsd
                                  ,pi_nars_job_id         => pi_narsh_job_id
                                  );

     END IF;  -- NOT narsa_already_exists

     ---------------------------------------------------------------------------------------------------------------------
     -- If reference item specified, and the reference item has not already been done i.e. there is not an existing record
     -- in nm_assets_on_route_store_att for the item id then
     --
     -- Get Description and full list of attributes for NARS_REFERENCE_ITEM_ID (if specified)
     -- Write description to nm_assets_on_route_store_att
     -- Write full list of attributes to nm_assets_on_route_store_att_d
     --------------------------------------------------------------------------------------------------------
     IF l_tab_nars_reference_item_id(i) IS NOT NULL THEN

       IF NOT narsa_already_exists(pi_narsh_job_id
                                  ,l_tab_nars_reference_item_id(i) ) THEN

         -----------------------------------------------------------------------------------------
         -- note: the reference inv type comes from nm_assets_on_route_store_head and not from the
         --       nm_assets_on_route_store record (which is where the reference item id is found)
         -----------------------------------------------------------------------------------------
         get_inventory_item_details(pi_iit_ne_id           => l_tab_nars_reference_item_id(i)
                                   ,pi_nit_inv_type        => v_narsh_rec.narsh_reference_inv_type
                                   ,pi_separator           => c_attr_list_sep
                                   ,pi_display_xsp_if_reqd => FALSE
                                   ,pi_display_descr       => FALSE
                                   ,pi_display_start_date  => FALSE
                                   ,pi_display_admin_unit  => FALSE
                                   ,pi_nias_id             => v_narsh_rec.narsh_nias_id
                                   ,pi_populate_narsd      => pi_populate_narsd
                                   ,pi_nars_job_id         => pi_narsh_job_id
                                   );

       END IF;  -- NOT narsa_already_exists

     END IF;  -- l_tab_nars_reference_item_id(i) IS NOT NULL AND NOT narsa_already_exists

  END LOOP;  -- FOR i IN 1..l_tab_nars_ne_id_in.COUNT

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_inventory_items');

END process_inventory_items;
--
-----------------------------------------------------------------------------
--
END nm3asset_rep;
/
