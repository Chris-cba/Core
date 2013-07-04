CREATE OR REPLACE PACKAGE BODY nm3mrg IS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg.pkb-arc   2.9   Jul 04 2013 16:16:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3mrg.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:16:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:46:58  $
--       PVCS Version     : $Revision:   2.9  $
--       Based on SCCS version : 1.60
--
--   Author : Jonathan Mills
--
--     nm3mrg package. Used for Merge Queries
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
/* History
  06.08.09 RC Changed the default on the system option MRGCODE32 (Not NM3CODE32 as below) to work on old code if no option.
  26.03.09 PT in execute_mrg_query() added logic to call new code in nm3bulk_mrg
                to use old code set option NM3CODE32 = 'Y'
                requires nm3bulk_mrg.pkh 2.2 or higher (4.0.2.0)
                TODO: the procedure load_temp_extent_datums() needs to be migrated into nm3bulk_mrg
  30.03.09 PT modified sql_load_nm_datum_criteria_tmp() to work in two modes: direct / assign group_id
                the load_temp_extent_datums calls it both modes - as the NTE_ROUTE_NE_ID can be a group_id or datum_id
  08.09.09 PT log 722431: modified sql_load_nm_datum_criteria_tmp() so that elements are not left out when not part of any route
                removed direct / assign modes
  07.04.09 PT log 724637: in load_temp_extent_datums() changed the member datum multiple routes check logic to work as intended
  03.05.10 PT load_temp_extent_datums() and related subprocedures moved to nm3bulk_mrg
                NB! requires nm3bulk_mrg.pkh 2.6 or higher
  12.05.10 PT added p_domain_return parameter in call to nm3bulk_mrg.std_run()
                NB! requires nm3bulk_mrg_pkh 2.7 or higher (logs 723574, 724275)
*/

  g_body_sccsid   constant varchar2(200) :='"$Revision:   2.9  $"';
  g_package_name     CONSTANT  varchar2(30)   := 'NM3MRG';
--
  g_mrg_section_id  pls_integer;
--
  c_mrg_au_type CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('MRGAUTYPE');
--
------------------------------------------------------------------------------------------------
--
--
---- Package Local Procedure Definitions -------------------------------------------------------
--
PROCEDURE populate_query_vars (pi_query_id IN nm_mrg_query.nmq_id%TYPE);
--
------------------------------------------------------------------------------------------------
--
PROCEDURE insert_details (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                         ,pi_job_id       IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                         );
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_mrg_query_type_from_array (pi_nqt_seq_no IN nm_mrg_query_types.nqt_seq_no%TYPE
                                       ) RETURN nm_mrg_query_types%ROWTYPE;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE upd_nm_mrg_sections  (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                               ,pi_job_id IN nm_mrg_sections.nms_mrg_job_id%TYPE
                               );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE deal_with_continuous (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                               ,pi_job_id       IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                               );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE deal_with_point      (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                               ,pi_job_id       IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                               );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_on_poe_and_route(pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                                ,pi_job_id       IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                );
--
------------------------------------------------------------------------------------------------
--
PROCEDURE deal_with_individual_point
                        (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                        ,pi_job_id       IN nm_mrg_sections.nms_mrg_job_id%TYPE
                        ,pi_ne_id        IN nm_mrg_members.nm_ne_id_of%TYPE
                        ,pi_begin_mp     IN nm_mrg_members.nm_begin_mp%TYPE
                        );

--
-----Global Procedures -------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE execute_mrg_query
             (pi_query_id      IN     nm_mrg_query.nmq_id%TYPE
             ,pi_nte_job_id    IN     nm_members.nm_ne_id_in%TYPE
             ,pi_description   IN     nm_mrg_query_results.nqr_description%TYPE
             ,po_result_job_id IN OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE
             ) IS
--
   l_admin_unit    nm_mrg_query_results.nqr_admin_unit%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_mrg_query');
--
   l_admin_unit := nm3ausec.get_highest_au_of_au_type(c_mrg_au_type);
--
   execute_mrg_query
             (pi_query_id      => pi_query_id
             ,pi_nte_job_id    => pi_nte_job_id
             ,pi_description   => pi_description
             ,pi_admin_unit    => l_admin_unit
             ,po_result_job_id => po_result_job_id
             );
--
   nm_debug.proc_end(g_package_name,'execute_mrg_query');
--
END execute_mrg_query;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE execute_mrg_query
             (pi_query_id      IN     nm_mrg_query.nmq_id%TYPE
             ,pi_nte_job_id    IN     nm_members.nm_ne_id_in%TYPE
             ,pi_description   IN     nm_mrg_query_results.nqr_description%TYPE
             ,pi_admin_unit    IN     nm_mrg_query_results.nqr_admin_unit%TYPE
             ,po_result_job_id IN OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE
             ) IS
--
   l_section_count binary_integer;
--
   CURSOR cs_rec_count (p_mrg_job_id number) IS
   SELECT COUNT(*)
    FROM  nm_mrg_section_members
   WHERE  nsm_mrg_job_id = p_mrg_job_id;

    l_sqlcount  pls_integer;
    r_longops   nm3sql.longops_rec;
--
BEGIN

  -- the MRGCODE32 product option can be used to let the old code run
  if nvl(hig.get_sysopt('MRGCODE32'), 'Y') != 'Y' then

    -- populate nm_datum_criteria_tmp from temp extent
    nm3bulk_mrg.load_temp_extent_datums(
       p_group_type => null
      ,p_nte_job_id => pi_nte_job_id
      ,p_sqlcount   => l_sqlcount
    );

    -- load nm_route_connectivity_tmp
    nm3bulk_mrg.ins_route_connectivity(
       p_criteria_rowcount  => l_sqlcount
      ,p_ignore_poe         => null -- MRGPOE option will be used
    );

    -- run the merge
    nm3bulk_mrg.std_run(
       p_nmq_id         => pi_query_id
      ,p_nqr_admin_unit => pi_admin_unit
      ,p_nqr_source     => nm3bulk_mrg.NQR_SOURCE_TEMP_NE
      ,p_nqr_source_id  => pi_nte_job_id
      ,p_domain_return  => null -- defaults to 'C' - code
      ,p_nmq_descr      => pi_description
      ,p_criteria_rowcount => l_sqlcount
      ,p_mrg_job_id     => po_result_job_id
      ,p_longops_rec    => r_longops
    );


  -- use old logic as flagged
  else

--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
   nm_debug.proc_start(g_package_name,'execute_mrg_query');
--
--  Check to see if we are allowed to execute this query
--
   IF NOT nm3mrg_security.is_query_executable (pi_query_id)
    THEN
      g_mrg_exc_code := -20917;
      g_mrg_exc_msg  := 'You are not allowed to execute this merge query';
      RAISE g_mrg_exception;
   END IF;
--
   g_running_merge       := TRUE;
   g_resequence_reqd     := FALSE;
   g_mrg_section_id      := 0;
--
   IF c_mrg_au_type IS NOT NULL
    THEN
      IF nm3ausec.get_au_type (pi_admin_unit) != c_mrg_au_type
       THEN
         g_mrg_exc_code := -20918;
         g_mrg_exc_msg  := 'Admin Unit is not of the correct Admin Type';
         RAISE g_mrg_exception;
      END IF;
   END IF;
--
   -- Delete from temporary tables
   -- This will clear out any data from them if MRG is run more than once in the same commit unit
   DELETE FROM nm_mrg_inv_items;
   DELETE FROM nm_mrg_members;
   DELETE FROM nm_mrg_members2;
   DELETE FROM nm_mrg_query_members_temp;
   DELETE FROM nm_mrg_query_results_temp;
   DELETE FROM nm_mrg_query_results_temp2;
--
   DELETE FROM nm_nw_temp_extents
   WHERE nte_job_id != pi_nte_job_id;
--
   -- If we are merging on a single point then all inventory is treated as point
   g_single_point_merge  := nm3extent.nte_is_single_point (pi_nte_job_id);
--   nm_debug.debug('g_single_point_merge : '||nm3flx.boolean_to_char(g_single_point_merge));
--
   g_tab_rec_query_types                  .DELETE;
   g_tab_rec_query_attribs                .DELETE;
   g_tab_query_attrib_datatypes           .DELETE;
   g_tab_rec_query_values                 .DELETE;
   g_tab_rec_nita                         .DELETE;
   g_tab_rec_nit                          .DELETE;
   nm3mrg_supplementary.g_tab_cs_distinct .delete;
   nm3mrg_supplementary.g_tab_ne_id_of    .delete;
   nm3mrg_supplementary.g_tab_begin_mp    .delete;
   nm3mrg_supplementary.g_tab_end_mp      .delete;
--
--   nm3extent.debug_temp_extents(pi_nte_job_id);
--
-- Validate the query
--
--   nm_debug.debug ('   validate_mrg_query  (pi_query_id);');
   validate_mrg_query   (pi_query_id);
--
-- Get the next JOB_ID
--
   IF po_result_job_id IS NULL
    THEN
      po_result_job_id := nm3pbi.get_job_id;
   ELSE
      DECLARE
         l_rec_nqr nm_mrg_query_results%ROWTYPE;
      BEGIN
         l_rec_nqr := nm3mrg_supplementary.select_nqr(po_result_job_id);
         IF l_rec_nqr.nqr_mrg_job_id IS NOT NULL
          THEN
            -- One found, therefore this job id has been previously used
            g_mrg_exc_code := -20916;
            g_mrg_exc_msg  := 'nm_mrg_query_results already exists with this nqr_mrg_job_id';
            RAISE g_mrg_exception;
         END IF;
      END;
   END IF;
--
   INSERT INTO nm_mrg_query_results
           (nqr_mrg_job_id
           ,nqr_nmq_id
           ,nqr_source_id
           ,nqr_source
           ,nqr_description
           ,nqr_mrg_section_members_count
           ,nqr_admin_unit
           )
   VALUES  (po_result_job_id
           ,pi_query_id
           ,nm3extent.g_last_temp_extent_source_id
           ,nm3extent.g_last_temp_extent_source
           ,pi_description
           ,-1
           ,pi_admin_unit
           );
--
-- nm_debug.debug ('   insert_details      (pi_nte_job_id, po_result_job_id);');
   insert_details       (pi_nte_job_id, po_result_job_id);
--
--nm_debug.debug ('   deal_with_continuous (pi_nte_job_id, po_result_job_id);');
   deal_with_continuous (pi_nte_job_id, po_result_job_id);
--
--nm_debug.debug ('   deal_with_point (pi_nte_job_id, po_result_job_id);');
   deal_with_point      (pi_nte_job_id, po_result_job_id);
   commit ;
--
-- nm_debug.debug ('   assess_inner_join   (po_result_job_id);');
   nm3mrg_supplementary.assess_inner_join    (po_result_job_id);
   commit ;
--
-- nm_debug.debug ('   split_on_poe_and_route (pi_nte_job_id, po_result_job_id);');
   split_on_poe_and_route(pi_nte_job_id, po_result_job_id);
   commit ;
--
-- nm_debug.debug ('   upd_nm_mrg_sections (po_result_job_id);');
   upd_nm_mrg_sections  (pi_nte_job_id,po_result_job_id);
--
   OPEN  cs_rec_count(po_result_job_id);
   FETCH cs_rec_count INTO l_section_count;
   CLOSE cs_rec_count;
--
   UPDATE nm_mrg_query_results
    SET   nqr_mrg_section_members_count = l_section_count
   WHERE  nqr_mrg_job_id = po_result_job_id;
--
-- nm_debug.debug ('end of EXECUTE_MRG_QUERY');
--
   -- Refresh the results snapshot if necessary
   IF l_section_count > 0
    THEN
      nm3mrg_view.refresh_merge_results_snapshot(pi_query_id);
   END IF;
--
   g_running_merge := FALSE;
--
   g_tab_rec_query_types                  .DELETE;
   g_tab_rec_query_attribs                .DELETE;
   g_tab_query_attrib_datatypes           .DELETE;
   g_tab_rec_query_values                 .DELETE;
   g_tab_rec_nita                         .DELETE;
   g_tab_rec_nit                          .DELETE;
   nm3mrg_supplementary.g_tab_cs_distinct .delete;
   nm3mrg_supplementary.g_tab_ne_id_of    .delete;
   nm3mrg_supplementary.g_tab_begin_mp    .delete;
   nm3mrg_supplementary.g_tab_end_mp      .delete;

   DELETE FROM nm_mrg_inv_items;
   DELETE FROM nm_mrg_members;
   DELETE FROM nm_mrg_members2;
   DELETE FROM nm_mrg_query_members_temp;
   DELETE FROM nm_mrg_query_results_temp;
   DELETE FROM nm_mrg_query_results_temp2;
   commit ;
   nm_debug.proc_end(g_package_name,'execute_mrg_query');

  end if;
--   nm_debug.debug_off;
--
EXCEPTION
--
   WHEN g_mrg_exception
    THEN
      g_running_merge := FALSE;
      RAISE_APPLICATION_ERROR(g_mrg_exc_code,g_mrg_exc_msg);
--
   WHEN others
    THEN
      g_running_merge := FALSE;
      nm_debug.debug(SQLERRM);
      RAISE;
--
END execute_mrg_query;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE validate_mrg_query(pi_query_id IN nm_mrg_query.nmq_id%TYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_mrg_query');
--
   populate_query_vars (pi_query_id);
--
   nm3mrg_supplementary.validate_data;
--
   nm_debug.proc_end(g_package_name,'validate_mrg_query');
--
EXCEPTION
--
   WHEN g_mrg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_mrg_exc_code,g_mrg_exc_msg);
--
END validate_mrg_query;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE populate_query_vars (pi_query_id IN nm_mrg_query.nmq_id%TYPE) IS
--
   CURSOR cs_check (p_table_name  user_tab_columns.table_name%TYPE
                   ,p_column_name user_tab_columns.column_name%TYPE
                   ) IS
   SELECT COUNT(*)
    FROM  user_tab_columns
   WHERE  table_name = p_table_name
    AND   column_name LIKE p_column_name||'%';
--
   l_inv_type_xsp varchar2(50);
--
   l_rec_nqt      nm_mrg_query_types%ROWTYPE;
   l_rec_utc      user_tab_columns%ROWTYPE;
--
   l_attrib_col_count number := 0;
--
   l_arr_count        number;
--
   l_been_into_xsp_loop boolean;
--
BEGIN
--
--  Empty PL/SQL tables
--
   g_tab_rec_query_types.DELETE;
   g_tab_rec_query_attribs.DELETE;
   g_tab_rec_query_values.DELETE;
   g_tab_rec_nita.DELETE;
   g_tab_rec_nit.DELETE;
   g_tab_query_attrib_datatypes.DELETE;
--
-- Select NM_MRG_QUERY record
--
   g_rec_query := select_mrg_query (pi_query_id);
--
-- Select NM_MRG_QUERY_TYPES records
--
   l_arr_count := 0;
   FOR cs_rec IN (SELECT *
                   FROM  nm_mrg_query_types
                  WHERE  nqt_nmq_id = pi_query_id
                 )
    LOOP
--
      l_arr_count := l_arr_count + 1;
--
      -- Check to make sure this INV_TYPE + XSP combo hasn't been previously used
      FOR l_counter IN 1..g_tab_rec_query_types.COUNT
       LOOP
--
         l_inv_type_xsp := cs_rec.nqt_inv_type||'-'||NVL(cs_rec.nqt_x_sect,'%');
--
         IF g_tab_rec_query_types(l_counter).nqt_inv_type||'-'||NVL(g_tab_rec_query_types(l_counter).nqt_x_sect,'%')
           = l_inv_type_xsp
       --   AND cs_rec.nqt_default = g_tab_rec_query_types(l_counter).nqt_default
          THEN
            g_mrg_exc_code := -20902;
            g_mrg_exc_msg  := 'INV_TYPE + XSP combination specified more than once '||l_inv_type_xsp;
            RAISE g_mrg_exception;
         END IF;
--
      END LOOP;
--
      g_tab_rec_query_types(l_arr_count) := cs_rec;
--
      g_tab_rec_nit(l_arr_count) := nm3inv.get_inv_type(cs_rec.nqt_inv_type);
--
   END LOOP;
--
   IF g_tab_rec_query_types.COUNT = 0
    THEN
      g_mrg_exc_code := -20903;
      g_mrg_exc_msg  := 'No query types defined';
      RAISE g_mrg_exception;
   END IF;
--
-- Select NM_MRG_QUERY_ATTRIBS records
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_mrg_query_attribs
                  WHERE  nqa_nmq_id = pi_query_id
                  ORDER BY 1,2,3
                 )
    LOOP
      g_tab_rec_query_attribs(g_tab_rec_query_attribs.COUNT+1) := cs_rec;
   END LOOP;
--
-- Select NM_MRG_QUERY_VALUES records
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_mrg_query_values
                  WHERE  nqv_nmq_id = pi_query_id
                  ORDER BY 1,2,3,4,5
                 )
    LOOP
      g_tab_rec_query_values(g_tab_rec_query_values.COUNT+1) := cs_rec;
   END LOOP;
--
-- select NM_INV_TYPE_ATTRIBS records
--
   FOR l_count IN 1..g_tab_rec_query_attribs.COUNT
    LOOP
--
      l_rec_nqt := get_mrg_query_type_from_array(g_tab_rec_query_attribs(l_count).nqa_nqt_seq_no);
--
      g_tab_rec_nita(l_count) := get_ita_for_mrg (l_rec_nqt.nqt_inv_type
                                                 ,g_tab_rec_query_attribs(l_count).nqa_attrib_name
                                                 );
--
   END LOOP;
--
-- Get query_attrib datatype records for g_tab_query_attrib_datatypes
--
   FOR l_count IN 1..g_tab_rec_query_attribs.COUNT
    LOOP
--
      DECLARE
--
         l_table_name varchar2(30);
--
      BEGIN
--
         FOR l_dummy IN 1..g_tab_rec_query_types.COUNT
          LOOP
            IF g_tab_rec_query_types(l_dummy).nqt_seq_no = g_tab_rec_query_attribs(l_count).nqa_nqt_seq_no
             THEN
               l_table_name := NVL(g_tab_rec_nit(l_dummy).nit_table_name, 'NM_INV_ITEMS_ALL');
               EXIT;
            END IF;
         END LOOP;
--
         l_rec_utc := get_tab_column_details
                           (l_table_name
                           ,g_tab_rec_query_attribs(l_count).nqa_attrib_name
                           );
      END;
--
      g_tab_query_attrib_datatypes(l_count) := l_rec_utc.data_type;
--
   END LOOP;
--
--
-- Check to make sure there aren't too many NM_MRG_QUERY_ATTRIBS records for the temporary table
--   NOTE - although the number is not hard-coded here, it has to be further down the code. The magic number is 500
--
--   OPEN  cs_check (c_temp_table_name, c_attrib_column_prefix);
--   FETCH cs_check INTO l_attrib_col_count;
--   CLOSE cs_check;
   l_attrib_col_count := 500;
--
   IF g_tab_rec_query_attribs.COUNT > l_attrib_col_count
    THEN
      g_mrg_exc_code := -20907;
      g_mrg_exc_msg  := 'Too many NM_MRG_QUERY_ATTRIBS records for the temporary table ('
                        ||g_tab_rec_query_attribs.COUNT||','||l_attrib_col_count||')';
      RAISE g_mrg_exception;
   END IF;
--
-- Get the INV_TYPE and XPS combos which are valid
--
   l_arr_count := 0;
   g_tab_rec_inv_type_xsp.DELETE;
--
   FOR l_count IN 1..g_tab_rec_nit.COUNT
    LOOP
--
      IF g_tab_rec_nit(l_count).nit_x_sect_allow_flag = 'N'
       THEN -- If no XSP allowed for this inv_type
         l_arr_count := l_arr_count + 1;
         g_tab_rec_inv_type_xsp(l_arr_count).query_type_id     := l_count;
         g_tab_rec_inv_type_xsp(l_arr_count).inv_type          := g_tab_rec_nit(l_count).nit_inv_type;
         g_tab_rec_inv_type_xsp(l_arr_count).x_sect            := NULL;
         g_tab_rec_inv_type_xsp(l_arr_count).pnt_or_cont       := g_tab_rec_nit(l_count).nit_pnt_or_cont;
         g_tab_rec_inv_type_xsp(l_arr_count).ft_name           := g_tab_rec_nit(l_count).nit_table_name;
         g_tab_rec_inv_type_xsp(l_arr_count).ft_ne_column_name := g_tab_rec_nit(l_count).nit_lr_ne_column_name;
         g_tab_rec_inv_type_xsp(l_arr_count).ft_st_chain       := g_tab_rec_nit(l_count).nit_lr_st_chain;
         g_tab_rec_inv_type_xsp(l_arr_count).ft_end_chain      := g_tab_rec_nit(l_count).nit_lr_end_chain;
         g_tab_rec_inv_type_xsp(l_arr_count).foreign_pk_column := g_tab_rec_nit(l_count).nit_foreign_pk_column;
      ELSE
         l_been_into_xsp_loop := FALSE;
         FOR cs_rec IN (SELECT xsr_x_sect_value
                         FROM  xsp_restraints
                        WHERE  xsr_ity_inv_code = g_tab_rec_nit(l_count).nit_inv_type
                         AND  (xsr_x_sect_value LIKE g_tab_rec_query_types(l_count).nqt_x_sect
                               OR g_tab_rec_query_types(l_count).nqt_x_sect IS NULL
                              )
                        GROUP BY xsr_x_sect_value
                       )
          LOOP
            l_been_into_xsp_loop := TRUE;
            l_arr_count := l_arr_count + 1;
            g_tab_rec_inv_type_xsp(l_arr_count).query_type_id     := l_count;
            g_tab_rec_inv_type_xsp(l_arr_count).inv_type          := g_tab_rec_nit(l_count).nit_inv_type;
            g_tab_rec_inv_type_xsp(l_arr_count).x_sect            := cs_rec.xsr_x_sect_value;
             -- If we are merging on a single point then all inventory is treated as point
            IF g_single_point_merge
             THEN
               g_tab_rec_inv_type_xsp(l_arr_count).pnt_or_cont    := 'P';
            ELSE
               g_tab_rec_inv_type_xsp(l_arr_count).pnt_or_cont    := g_tab_rec_nit(l_count).nit_pnt_or_cont;
            END IF;
            g_tab_rec_inv_type_xsp(l_arr_count).ft_name           := g_tab_rec_nit(l_count).nit_table_name;
            g_tab_rec_inv_type_xsp(l_arr_count).ft_ne_column_name := g_tab_rec_nit(l_count).nit_lr_ne_column_name;
            g_tab_rec_inv_type_xsp(l_arr_count).ft_st_chain       := g_tab_rec_nit(l_count).nit_lr_st_chain;
            g_tab_rec_inv_type_xsp(l_arr_count).ft_end_chain      := g_tab_rec_nit(l_count).nit_lr_end_chain;
            g_tab_rec_inv_type_xsp(l_arr_count).foreign_pk_column := g_tab_rec_nit(l_count).nit_foreign_pk_column;
         END LOOP;
         IF NOT l_been_into_xsp_loop
          THEN
            g_mrg_exc_code := -20908;
            g_mrg_exc_msg  := 'No XSP_RESTRAINTS record(s) found for '||g_tab_rec_nit(l_count).nit_inv_type
                              ||':'||g_tab_rec_query_types(l_count).nqt_x_sect;
            RAISE g_mrg_exception;
         END IF;
      END IF;
--
   END LOOP;
--
END populate_query_vars;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_mrg_query_type_from_array (pi_nqt_seq_no IN nm_mrg_query_types.nqt_seq_no%TYPE
                                       ) RETURN nm_mrg_query_types%ROWTYPE IS
--
   l_retval   nm_mrg_query_types%ROWTYPE;
--
BEGIN
--
   FOR l_count IN 1..g_tab_rec_query_types.COUNT
    LOOP
--
      IF g_tab_rec_query_types(l_count).nqt_seq_no = pi_nqt_seq_no
       THEN
         l_retval   := g_tab_rec_query_types(l_count);
         EXIT;
      END IF;
--
   END LOOP;
--
   RETURN l_retval;
--
END get_mrg_query_type_from_array;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_nmq_id RETURN number IS
BEGIN
--
   RETURN nm3mrg_supplementary.get_nmq_id;
--
END get_nmq_id;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE insert_details (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                         ,pi_job_id       IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                         ) IS
--
   l_query_sql long;
   l_rec_itx   rec_inv_type_xsp;
--
   l_rec_attrib       nm_mrg_query_attribs%ROWTYPE;
   l_dyn_sql_rowcount number;
   l_temp_string      varchar2(4000);
--
-------------------------------------------------------------
--
   PROCEDURE build_where_clause (p_table_alias varchar2) IS
      l_table_alias varchar2(30);
   BEGIN
      IF p_table_alias IS NOT NULL
       THEN
         l_table_alias := p_table_alias||'.';
      END IF;
   -- nm_debug.debug ('      FOR l_counter IN 1..g_tab_rec_query_attribs.COUNT');
      FOR l_counter IN 1..g_tab_rec_query_attribs.COUNT
       LOOP
   --
         l_rec_attrib := g_tab_rec_query_attribs(l_counter);
   --
         IF   l_rec_attrib.nqa_nqt_seq_no =  g_tab_rec_query_types(l_rec_itx.query_type_id).nqt_seq_no
          AND l_rec_attrib.nqa_condition  IS NOT NULL
          THEN
   --
   IF nm3gaz_qry.get_ignore_case THEN
       l_query_sql := l_query_sql||
                               CHR(10)||' AND  UPPER('||l_table_alias||l_rec_attrib.nqa_attrib_name||') '||l_rec_attrib.nqa_condition
                                      ||nm3mrg_supplementary.build_value_list(l_rec_attrib.nqa_condition
                                                        ,l_rec_attrib.nqa_nqt_seq_no
                                                        ,l_rec_attrib.nqa_attrib_name
                                                        ,g_tab_rec_nita(l_counter).ita_format
                                                        );
   ELSE
            l_query_sql := l_query_sql||
                               CHR(10)||' AND   '||l_table_alias||l_rec_attrib.nqa_attrib_name||' '||l_rec_attrib.nqa_condition||' '
                                      ||nm3mrg_supplementary.build_value_list(l_rec_attrib.nqa_condition
                                                        ,l_rec_attrib.nqa_nqt_seq_no
                                                        ,l_rec_attrib.nqa_attrib_name
                                                        ,g_tab_rec_nita(l_counter).ita_format
                                                        );
   END IF;
   --
         END IF;
   --
      END LOOP;
--
   END build_where_clause;
--
-------------------------------------------------------------
--
   PROCEDURE build_insert (p_ne_id       varchar2
                          ,p_inv_type    varchar2
                          ,p_xsp         varchar2
                          ,p_pnt_or_cont varchar2
                          ) IS
   BEGIN
      l_query_sql :=            'INSERT INTO '||c_temp_table_name||' -- '||l_rec_itx.inv_type||'('||l_rec_itx.x_sect||')'
                     ||CHR(10)||'    (ne_id'
                     ||CHR(10)||'    ,inv_type'
                     ||CHR(10)||'    ,x_sect'
                     ||CHR(10)||'    ,pnt_or_cont';
   --
   -- nm_debug.debug ('      FOR l_counter IN 1..g_tab_rec_query_attribs.COUNT');
      FOR l_counter IN 1..g_tab_rec_query_attribs.COUNT
       LOOP
   --
         l_rec_attrib := g_tab_rec_query_attribs(l_counter);
   --
         IF l_rec_attrib.nqa_nqt_seq_no = g_tab_rec_query_types(l_rec_itx.query_type_id).nqt_seq_no
          THEN
   --
            l_query_sql := l_query_sql||
                               CHR(10)||'    ,attrib'||l_counter;
   --
         END IF;
   --
      END LOOP;
   --
   -- nm_debug.debug ('      l_query_sql := l_query_sql||');
      l_query_sql := l_query_sql||
                         CHR(10)||'    )';
   --
      l_query_sql := l_query_sql||
                         CHR(10)||'SELECT /*+ RULE */ '||p_ne_id
                       ||CHR(10)||'      ,'||p_inv_type
                       ||CHR(10)||'      ,'||p_xsp
                       ||CHR(10)||'      ,'||p_pnt_or_cont;
   --
   -- nm_debug.debug ('      FOR l_counter IN 1..g_tab_rec_query_attribs.COUNT');
      FOR l_counter IN 1..g_tab_rec_query_attribs.COUNT
       LOOP
   --
         l_rec_attrib := g_tab_rec_query_attribs(l_counter);
   --
         IF l_rec_attrib.nqa_nqt_seq_no = g_tab_rec_query_types(l_rec_itx.query_type_id).nqt_seq_no
          THEN
   --
            IF l_rec_attrib.nqa_itb_banding_id IS NOT NULL
             THEN
   --
               -- If we are banding the attributes
               IF g_tab_query_attrib_datatypes(l_counter) = nm3type.c_date
                THEN
                  l_temp_string := 'TO_NUMBER(TO_CHAR('||l_rec_attrib.nqa_attrib_name||','||nm3flx.string('J')||'))';
   --                  l_temp_string := 'TO_CHAR('||l_rec_attrib.nqa_attrib_name||','||nm3flx.string('J')||')';
               ELSE
                  l_temp_string := l_rec_attrib.nqa_attrib_name;
               END IF;
               l_temp_string := 'nm3invband.get_inv_band_det('||nm3flx.string(l_rec_itx.inv_type)
                                                         ||','||nm3flx.string(l_rec_attrib.nqa_attrib_name)
                                                         ||','||l_rec_attrib.nqa_itb_banding_id
                                                         ||','||l_temp_string
                                                         ||')';
   --
            ELSE
   --
               IF (nm3inv.g_validate_flex_inv_func_rtn     !=  nm3inv.c_code
                   OR g_tab_query_attrib_datatypes(l_counter) IN (nm3type.c_date,nm3type.c_number)
                  )
                AND nm3get.get_ita (pi_ita_inv_type    => l_rec_itx.inv_type
                                   ,pi_ita_attrib_name => l_rec_attrib.nqa_attrib_name
                                   ,pi_raise_not_found => FALSE
                                   ).ita_inv_type IS NOT NULL
                THEN
   --
                  -- Call validate_flex_inv for non-banded, non FT fields to get domain description
                  --  or formatted date/number depending on type
                  l_temp_string := 'nm3inv.validate_flex_inv('||nm3flx.string(l_rec_itx.inv_type)
                                                         ||','||nm3flx.string(l_rec_attrib.nqa_attrib_name)
                                                         ||','||l_rec_attrib.nqa_attrib_name
                                                         ||')';
   --
               ELSIF g_tab_query_attrib_datatypes(l_counter) = nm3type.c_date
                THEN
                  DECLARE
                     l_rec_ita nm_inv_type_attribs%ROWTYPE;
                  BEGIN
                     l_rec_ita := nm3mrg.get_ita_for_mrg (l_rec_itx.inv_type, l_rec_attrib.nqa_attrib_name);
                     l_temp_string := 'TO_CHAR('||l_rec_attrib.nqa_attrib_name||','||nm3flx.string(l_rec_ita.ita_format_mask)||')';
                  END;
               ELSE
   --
                  l_temp_string := l_rec_attrib.nqa_attrib_name;
   --
               END IF;
   --
            END IF;
   --
            l_query_sql := l_query_sql||
                               CHR(10)||'      ,'||l_temp_string||' -- '||g_tab_rec_nita(l_counter).ita_view_col_name;
   --
         END IF;
   --
      END LOOP;
   END build_insert;
--
-------------------------------------------------------------
--
--
   PROCEDURE create_nm_mrg_members_for_std IS
      l_tab_inv_types nm3type.tab_varchar4;
   BEGIN
   --
      SELECT nqt.nqt_inv_type
       BULK  COLLECT
       INTO  l_tab_inv_types
       FROM  nm_mrg_query_types nqt
            ,nm_inv_types       nit
      WHERE  nqt.nqt_nmq_id     = g_rec_query.nmq_id
       AND   nit.nit_inv_type   = nqt.nqt_inv_type
       AND   nit.nit_table_name IS NULL
      GROUP BY nqt.nqt_inv_type;
   --
   -- Get all of the MEMBERS for the route we are interested in
   --
   --   nm_debug.debug('Before insert into NMM',-1);
      FORALL i IN 1..l_tab_inv_types.COUNT
         INSERT INTO nm_mrg_members
               (nm_ne_id_in
               ,nm_ne_id_of
               ,nm_begin_mp
               ,nm_end_mp
               ,nm_seq_no
               ,inv_type
               ,route_ne_id
               )
         SELECT /*+ RULE */
                nm.nm_ne_id_in
               ,nm.nm_ne_id_of
               ,GREATEST(nm.nm_begin_mp,nte.nte_begin_mp)
               ,LEAST(nm.nm_end_mp,nte.nte_end_mp)
               ,nte.nte_seq_no
               ,nm.nm_obj_type
               ,nte.nte_route_ne_id
           FROM nm_nw_temp_extents nte
               ,nm_members         nm
          WHERE nte.nte_job_id  = pi_nte_job_id
            AND nm.nm_ne_id_of  = nte.nte_ne_id_of
            AND nm.nm_type      = 'I'
            AND nm.nm_end_mp   >= nte.nte_begin_mp
            AND nm.nm_begin_mp <= nte.nte_end_mp
            AND nm.nm_obj_type  =  l_tab_inv_types(i);

--      INSERT INTO nm_mrg_members
--            (nm_ne_id_in
--            ,nm_ne_id_of
--            ,nm_begin_mp
--            ,nm_end_mp
--            ,nm_seq_no
--            ,inv_type
--            ,route_ne_id
--            )
--      SELECT /*+ RULE */
--             nm.nm_ne_id_in
--            ,nm.nm_ne_id_of
--            ,GREATEST(nm.nm_begin_mp,nte.nte_begin_mp)
--            ,LEAST(nm.nm_end_mp,nte.nte_end_mp)
--            ,nte.nte_seq_no
--            ,nm.nm_obj_type
--            ,nte.nte_route_ne_id
--        FROM nm_nw_temp_extents nte
--            ,nm_members         nm
--       WHERE nte.nte_job_id  = pi_nte_job_id
--         AND nm.nm_ne_id_of  = nte.nte_ne_id_of
--         AND nm.nm_type      = 'I'
--         AND nm.nm_end_mp   >= nte.nte_begin_mp
--         AND nm.nm_begin_mp <= nte.nte_end_mp
--         AND EXISTS (SELECT 1
--                      FROM  nm_mrg_query_types nqt
--                     WHERE  nqt.nqt_nmq_id = g_rec_query.nmq_id
--                      AND   nm.nm_obj_type = nqt.nqt_inv_type
--                     );
   --
       -- If we are merging on a single point then all inventory is treated as point
      IF NOT g_single_point_merge
       THEN
         DELETE FROM nm_mrg_members
         WHERE nm_begin_mp = nm_end_mp
          AND  EXISTS (SELECT 1
                        FROM  nm_inv_types
                       WHERE  nit_inv_type    = inv_type
                        AND   nit_pnt_or_cont = 'C'
                      );
      END IF;
   --
   END create_nm_mrg_members_for_std;
--
--   nm_debug.debug('after insert into NMM',-1);
--
-------------------------------------------------------------
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'insert_details');
--
   g_tab_rec_start_pos.DELETE;
   g_tab_rec_members.DELETE;
--
--   FOR cs_rec IN (SELECT * FROM nm_mrg_members ORDER BY route_ne_id,nm_seq_no )
--    LOOP
--      nm_debug.debug(cs_rec.route_ne_id||':'||cs_rec.nm_ne_id_of||':'||cs_rec.nm_begin_mp||':'||cs_rec.nm_end_mp||':'||cs_rec.nm_seq_no||':'||cs_rec.inv_type);
--   END LOOP;
   --
   -- Quickly nip through all the inv types and create the nm_mrg_members
   --  records if any of them are standard inventory rather than FT inv
   --
   FOR l_count IN 1..g_tab_rec_inv_type_xsp.COUNT
    LOOP
      IF g_tab_rec_inv_type_xsp(l_count).ft_name IS NULL
       THEN
         create_nm_mrg_members_for_std;
         EXIT;
      END IF;
   END LOOP;
--
-- nm_debug.debug ('   FOR l_count IN 1..g_tab_rec_inv_type_xsp.COUNT');
   FOR l_count IN 1..g_tab_rec_inv_type_xsp.COUNT
    LOOP
--
--    get all matching INV_ITEMS which appear on that route
--
      l_rec_itx := g_tab_rec_inv_type_xsp(l_count);
--
--      nm_debug.debug (l_rec_itx.inv_type||' '||l_rec_itx.x_sect);
      IF l_rec_itx.ft_name IS NULL
       THEN
          -- #############################################################
          --
          --   This is NOT a foreign table
          --
          -- #############################################################
          --
          --
         l_query_sql :=            'INSERT INTO nm_mrg_inv_items -- '||l_rec_itx.inv_type||'('||l_rec_itx.x_sect||')'
                        ||CHR(10)||'SELECT /*+ RULE */ DISTINCT nii.*'
                        ||CHR(10)||'      ,'||l_rec_itx.query_type_id
                        ||CHR(10)||'      ,'||nm3flx.string(l_rec_itx.pnt_or_cont)
                        ||CHR(10)||' FROM  nm_inv_items   nii'
                        ||CHR(10)||'      ,nm_mrg_members nmm'
                        ||CHR(10)||'WHERE  nii.iit_ne_id    = nmm.nm_ne_id_in'
--                        ||CHR(10)||' AND   nii.iit_inv_type = '||nm3flx.string(l_rec_itx.inv_type)
                        ||CHR(10)||' AND   nmm.inv_type     = '||nm3flx.string(l_rec_itx.inv_type);
   --
         IF l_rec_itx.x_sect IS NOT NULL
          THEN
            l_query_sql := l_query_sql
                           ||CHR(10)||' AND   nii.iit_x_sect   = '||nm3flx.string(l_rec_itx.x_sect);
         END IF;
   --
         build_where_clause('nii');
   --
--         nm_debug.debug (l_query_sql);
         l_dyn_sql_rowcount := execute_sql(l_query_sql);
   --
         build_insert('iit_ne_id','iit_inv_type','iit_x_sect','pnt_or_cont');
   --
   -- nm_debug.debug ('      l_query_sql := l_query_sql||');
         l_query_sql := l_query_sql||
                            CHR(10)||' FROM  nm_mrg_inv_items'
                          ||CHR(10)||' WHERE iit_inv_type = '||nm3flx.string(l_rec_itx.inv_type);
   --
   -- nm_debug.debug ('      IF l_rec_itx.x_sect IS NOT NULL');
         IF l_rec_itx.x_sect IS NOT NULL
          THEN
            l_query_sql := l_query_sql
                           ||CHR(10)||' AND   iit_x_sect   = '||nm3flx.string(l_rec_itx.x_sect);
         END IF;
      ELSE
          -- #############################################################
          --
          --   This IS a foreign table
          --
          -- #############################################################
          l_query_sql :=            '   INSERT INTO nm_mrg_members'
                         ||CHR(10)||'         (nm_ne_id_in'
                         ||CHR(10)||'         ,nm_ne_id_of'
                         ||CHR(10)||'         ,nm_begin_mp'
                         ||CHR(10)||'         ,nm_end_mp'
                         ||CHR(10)||'         ,nm_seq_no'
                         ||CHR(10)||'         ,inv_type'
                         ||CHR(10)||'         ,route_ne_id'
                         ||CHR(10)||'         )'
                         ||CHR(10)||'   SELECT /*+ RULE */ DISTINCT '||l_rec_itx.foreign_pk_column
                         ||CHR(10)||'         ,nte.nte_ne_id_of'
                         ||CHR(10)||'         ,GREATEST(nte.nte_begin_mp,ft.'||l_rec_itx.ft_st_chain||')'
                         ||CHR(10)||'         ,LEAST(nte.nte_end_mp,ft.'||l_rec_itx.ft_end_chain||')'
                         ||CHR(10)||'         ,nte_seq_no'
                         ||CHR(10)||'         ,'||nm3flx.string(l_rec_itx.inv_type)
                         ||CHR(10)||'         ,nte.nte_route_ne_id'
                         ||CHR(10)||'    FROM  nm_nw_temp_extents nte'
                         ||CHR(10)||'         ,'||l_rec_itx.ft_name||' ft'
                         ||CHR(10)||'   WHERE  nte.nte_job_id    = '||pi_nte_job_id
                         ||CHR(10)||'    AND   nte.nte_ne_id_of  = ft.'||l_rec_itx.ft_ne_column_name;

         IF l_rec_itx.ft_st_chain = l_rec_itx.ft_end_chain
          THEN
            l_query_sql := l_query_sql
                             ||CHR(10)||'  AND  ft.'||l_rec_itx.ft_st_chain||' BETWEEN nte.nte_begin_mp AND nte.nte_end_mp';
         ELSE
            l_query_sql := l_query_sql
                            ||CHR(10)||'    AND   ft.'||l_rec_itx.ft_end_chain||' >= nte.nte_begin_mp'
                            ||CHR(10)||'    AND   ft.'||l_rec_itx.ft_st_chain||' <= nte.nte_end_mp';
         END IF;
         IF l_rec_itx.pnt_or_cont = 'C'
          THEN
            l_query_sql := l_query_sql
                            ||CHR(10)||'    AND   ft.'||l_rec_itx.ft_st_chain||' != ft.'||l_rec_itx.ft_end_chain;
         END IF;
         --
         -- nm_debug.debug ('  pre mrg_members   l_dyn_sql_rowcount := execute_sql(l_query_sql);');
         l_dyn_sql_rowcount := execute_sql(l_query_sql);
     --    nm_debug.debug(l_query_sql);
         -- nm_debug.debug ('  post mrg_members    l_dyn_sql_rowcount := execute_sql(l_query_sql);'||l_dyn_sql_rowcount);
         --
         build_insert (l_rec_itx.foreign_pk_column
                      ,nm3flx.string(l_rec_itx.inv_type)
                      ,nm3flx.string(l_rec_itx.x_sect)
                      ,nm3flx.string(l_rec_itx.pnt_or_cont)
                      );
         l_query_sql := l_query_sql||
                            CHR(10)||' FROM  '||l_rec_itx.ft_name||' ft'||
                            CHR(10)||'      ,nm_mrg_members nmm'||
                            CHR(10)||' WHERE nm_ne_id_in     = ft.'||l_rec_itx.foreign_pk_column||
                            CHR(10)||'  AND  nmm.inv_type    = '||nm3flx.string(l_rec_itx.inv_type)||
                            CHR(10)||'  AND  nmm.nm_ne_id_of = ft.'||l_rec_itx.ft_ne_column_name;
         IF l_rec_itx.ft_st_chain = l_rec_itx.ft_end_chain
          THEN
            l_query_sql := l_query_sql||
                               CHR(10)||'  AND  ft.'||l_rec_itx.ft_st_chain||' BETWEEN nmm.nm_begin_mp AND nmm.nm_end_mp';
         ELSE
            l_query_sql := l_query_sql||
                               CHR(10)||'  AND  ft.'||l_rec_itx.ft_end_chain||' >= nmm.nm_begin_mp'||
                               CHR(10)||'  AND  ft.'||l_rec_itx.ft_st_chain||' <= nmm.nm_end_mp';
         END IF;
         build_where_clause(NULL);
--
      END IF;
--
--  nm_debug.debug ('  pre    l_dyn_sql_rowcount := execute_sql(l_query_sql);');
--      nm_debug.debug(l_query_sql);
      l_dyn_sql_rowcount := execute_sql(l_query_sql);
--  nm_debug.debug ('  post    l_dyn_sql_rowcount := execute_sql(l_query_sql);'||l_dyn_sql_rowcount);
--
   END LOOP;
--
--  Do the update afterwards so that
--  we dont need to hit nm_elements loads of extra times
   UPDATE nm_mrg_members
   SET element_length = (SELECT ne_length FROM nm_elements WHERE ne_id = nm_ne_id_of);
--
   nm_debug.proc_end(g_package_name,'insert_details');
--
END insert_details;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE deal_with_continuous (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                               ,pi_job_id     IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                               ) IS
--
   l_guffo                  varchar2(32767);
   l_cache_cursor_id number ;
   i_ignore number ;
   CURSOR cs_distinct_locs (c_cont varchar2 DEFAULT 'C') IS
   SELECT ne_id_of
         ,position_mp
    FROM (SELECT nte_seq_no
                ,ne_id_of
                ,begin_mp position_mp
           FROM  nm_mrg_query_members_temp
          WHERE  pnt_or_cont = c_cont
          UNION
          SELECT nte_seq_no
                ,ne_id_of
                ,end_mp position_mp
           FROM  nm_mrg_query_members_temp
          WHERE  pnt_or_cont = c_cont
         );
--
   l_current_pl_id number := 0;
--
   l_arr_count        number;
--
   l_start_ne_id  number;
   l_start_offset number;
--
   l_some_cont_to_deal_with boolean := FALSE;
--
   l_tab_mrg_sections       nm3type.tab_boolean;
--
   l_last_inv_type          nm_inv_types.nit_inv_type%TYPE := '¡¡¡¡';
   l_last_x_sect            nm_inv_items.iit_x_sect%TYPE;
--
   l_block                  nm3type.tab_varchar32767;
   l_tab_attribs            nm3type.tab_varchar30;
--
   this_is_a_point          boolean := FALSE;
--
   FUNCTION does_chunk_have_data (p_ne_id    number
                                 ,p_begin_mp number
                                 ) RETURN boolean IS
   --
      CURSOR cs_mqt2 (p_ne_id number, p_begin_mp number) IS
      SELECT 1
       FROM  nm_mrg_query_members_temp
      WHERE  ne_id_of = p_ne_id
       AND   p_begin_mp >= begin_mp
       AND   p_begin_mp <  end_mp;
   --
      l_dummy binary_integer;
      l_retval boolean;
   --
   BEGIN
   --
      OPEN  cs_mqt2(p_ne_id,p_begin_mp);
      FETCH cs_mqt2 INTO l_dummy;
      l_retval := cs_mqt2%FOUND;
      CLOSE cs_mqt2;
   --
      RETURN l_retval;
   --
   END does_chunk_have_data;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'deal_with_continuous');
--
   FOR l_count IN 1..g_tab_rec_inv_type_xsp.COUNT
    LOOP
--      nm_debug.debug(g_tab_rec_inv_type_xsp(l_count).inv_type||' '||g_tab_rec_inv_type_xsp(l_count).pnt_or_cont);
      IF g_tab_rec_inv_type_xsp(l_count).pnt_or_cont = 'C'
       THEN
         l_some_cont_to_deal_with := TRUE;
         EXIT;
      END IF;
   END LOOP;
--
   IF NOT l_some_cont_to_deal_with
    THEN
      nm_debug.proc_end(g_package_name,'deal_with_continuous');
      RETURN;
   END IF;
--
/*
   l_block.DELETE;
   nm3tab_varchar.append (l_block,'DECLARE',FALSE);
   nm3tab_varchar.append (l_block,'   CURSOR cs_distinct IS');
   nm3tab_varchar.append (l_block,'   SELECT inv_type');
   nm3tab_varchar.append (l_block,'         ,x_sect');
   nm3tab_varchar.append (l_block,'         ,pnt_or_cont');
--
   FOR l_count IN 1..g_tab_rec_query_attribs.COUNT
    LOOP
      IF nm3get.get_nit(pi_nit_inv_type => get_mrg_query_type_from_array(g_tab_rec_query_attribs(l_count).nqa_nqt_seq_no).nqt_inv_type).nit_pnt_or_cont = 'C'
       THEN
         l_tab_attribs(l_tab_attribs.COUNT+1) := 'attrib'||l_count;
         nm3tab_varchar.append (l_block,'         ,'||l_tab_attribs(l_tab_attribs.COUNT));
      END IF;
   END LOOP;
   nm3tab_varchar.append (l_block,'    FROM  nm_mrg_query_results_temp');
   nm3tab_varchar.append (l_block,'   WHERE  pnt_or_cont = '||nm3flx.string('C'));
   nm3tab_varchar.append (l_block,'   GROUP BY inv_type');
   nm3tab_varchar.append (l_block,'           ,x_sect');
   nm3tab_varchar.append (l_block,'           ,pnt_or_cont');
   FOR i IN 1..l_tab_attribs.COUNT
    LOOP
      nm3tab_varchar.append (l_block,CHR(10)||'           ,'||l_tab_attribs(i),FALSE);
   END LOOP;
   nm3tab_varchar.append (l_block,';',FALSE);
   nm3tab_varchar.append (l_block,'   i NUMBER;');
   nm3tab_varchar.append (l_block,'BEGIN');
   nm3tab_varchar.append (l_block,'   nm3mrg_supplementary.g_tab_cs_distinct.DELETE;');
   nm3tab_varchar.append (l_block,'   FOR cs_rec IN cs_distinct');
   nm3tab_varchar.append (l_block,'    LOOP');
   nm3tab_varchar.append (l_block,'      i := cs_distinct%ROWCOUNT;');
   nm3tab_varchar.append (l_block,'      nm3mrg_supplementary.g_tab_cs_distinct(i).inv_type    := cs_rec.inv_type;');
   nm3tab_varchar.append (l_block,'      nm3mrg_supplementary.g_tab_cs_distinct(i).x_sect      := cs_rec.x_sect;');
   nm3tab_varchar.append (l_block,'      nm3mrg_supplementary.g_tab_cs_distinct(i).pnt_or_cont := cs_rec.pnt_or_cont;');
   FOR i IN 1..l_tab_attribs.COUNT
    LOOP
      nm3tab_varchar.append (l_block,'      nm3mrg_supplementary.g_tab_cs_distinct(i).'||RPAD(l_tab_attribs(i),13,' ')||' := cs_rec.'||l_tab_attribs(i)||';');
   END LOOP;
   nm3tab_varchar.append (l_block,'   END LOOP;');
   nm3tab_varchar.append (l_block,'END;');
--   nm3tab_varchar.debug_tab_varchar(l_block);
   nm3ddl.execute_tab_varchar (l_block);
*/
--   nm_debug.debug('done exec block:COUNT='||nm3mrg_supplementary.g_tab_cs_distinct.COUNT);
--
   l_block.DELETE;
   nm3tab_varchar.append (l_block,'   SELECT inv_type');
   nm3tab_varchar.append (l_block,'         ,x_sect');
   nm3tab_varchar.append (l_block,'         ,pnt_or_cont');
--
   FOR l_count IN 1..g_tab_rec_query_attribs.COUNT
    LOOP
      IF nm3get.get_nit(pi_nit_inv_type => get_mrg_query_type_from_array(g_tab_rec_query_attribs(l_count).nqa_nqt_seq_no).nqt_inv_type).nit_pnt_or_cont = 'C'
       THEN
         l_tab_attribs(l_tab_attribs.COUNT+1) := 'attrib'||l_count;
         nm3tab_varchar.append (l_block,'         ,'||l_tab_attribs(l_tab_attribs.COUNT));
      END IF;
   END LOOP;
   nm3tab_varchar.append (l_block,'    FROM  nm_mrg_query_results_temp');
   nm3tab_varchar.append (l_block,'   WHERE  pnt_or_cont = '||nm3flx.string('C'));
   nm3tab_varchar.append (l_block,'   GROUP BY inv_type');
   nm3tab_varchar.append (l_block,'           ,x_sect');
   nm3tab_varchar.append (l_block,'           ,pnt_or_cont');
   FOR i IN 1..l_tab_attribs.COUNT
    LOOP
      nm3tab_varchar.append (l_block,CHR(10)||'           ,'||l_tab_attribs(i),FALSE);
   END LOOP;
   nm3tab_varchar.debug_tab_varchar(l_block);
--   nm3ddl.execute_tab_varchar (l_block);
   for z in 1..l_block.count
   loop
     l_guffo := l_guffo || ' ' || l_block(z) ;
   end loop ;
--   execute immediate l_guffo using l_cache_cursor_id ;
   l_cache_cursor_id := dbms_sql.open_cursor ;
   dbms_sql.parse(l_cache_cursor_id,l_guffo,dbms_sql.native);
   i_ignore := dbms_sql.execute(l_cache_cursor_id);
   nm_debug.debug('done opening cursor');
--
   -- Now we need to set up the restricted fetch
   l_block.DELETE;
   nm3tab_varchar.append (l_block,'DECLARE');
   nm3tab_varchar.append (l_block,'  i_crsr number := ' || l_cache_cursor_id || ';');
   nm3tab_varchar.append (l_block,'  i  number ; ') ;
   nm3tab_varchar.append (l_block,'BEGIN');
   nm3tab_varchar.append (l_block,'   i := 0 ;');
   nm3tab_varchar.append (l_block,'   nm3mrg_supplementary.g_tab_cs_distinct(i).inv_type  := null ;'); -- Instantiate the record or we'll get no data found
   nm3tab_varchar.append (l_block,'   dbms_sql.define_column(i_crsr,1,nm3mrg_supplementary.g_tab_cs_distinct(i).inv_type   ,30 );');
   nm3tab_varchar.append (l_block,'   dbms_sql.define_column(i_crsr,2,nm3mrg_supplementary.g_tab_cs_distinct(i).x_sect     ,4 );');
   nm3tab_varchar.append (l_block,'   dbms_sql.define_column(i_crsr,3,nm3mrg_supplementary.g_tab_cs_distinct(i).pnt_or_cont,1 );');
   FOR i IN 1..l_tab_attribs.COUNT
   LOOP
     nm3tab_varchar.append (l_block,'   dbms_sql.define_column(i_crsr,' || to_char(i + 3)  || ',nm3mrg_supplementary.g_tab_cs_distinct(i).'||RPAD(l_tab_attribs(i),13,' ')|| ',500);');
   END LOOP;
   nm3tab_varchar.append (l_block,'   nm3mrg_supplementary.g_tab_cs_distinct.DELETE;');
   nm3tab_varchar.append (l_block,'   LOOP');
   nm3tab_varchar.append (l_block,'     i := i + 1 ; ');
   nm3tab_varchar.append (l_block,'     if dbms_sql.fetch_rows(i_crsr) > 0 and i <= nm3mrg_supplementary.gc_buffer_size then');
   nm3tab_varchar.append (l_block,'       dbms_sql.column_value(i_crsr,1,nm3mrg_supplementary.g_tab_cs_distinct(i).inv_type    );');
   nm3tab_varchar.append (l_block,'       dbms_sql.column_value(i_crsr,2,nm3mrg_supplementary.g_tab_cs_distinct(i).x_sect      );');
   nm3tab_varchar.append (l_block,'       dbms_sql.column_value(i_crsr,3,nm3mrg_supplementary.g_tab_cs_distinct(i).pnt_or_cont );');
   FOR i IN 1..l_tab_attribs.COUNT
   LOOP
     nm3tab_varchar.append (l_block,'       dbms_sql.column_value(i_crsr,' || to_char(i + 3)  || ',nm3mrg_supplementary.g_tab_cs_distinct(i).'||RPAD(l_tab_attribs(i),13,' ')|| ');');
   END LOOP;
   /*
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''----- '' || i || '' ------'' );                                         ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''inv_type    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).inv_type   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''x_sect      ''||nm3mrg_supplementary.g_tab_cs_distinct(i).x_sect     ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''pnt_or_cont ''||nm3mrg_supplementary.g_tab_cs_distinct(i).pnt_or_cont); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib1     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib1    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib2     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib2    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib3     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib3    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib4     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib4    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib5     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib5    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib6     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib6    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib7     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib7    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib8     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib8    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib9     ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib9    ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib10    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib10   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib11    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib11   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib12    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib12   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib13    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib13   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib14    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib14   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib15    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib15   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib16    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib16   ); ' );
   nm3tab_varchar.append(l_block,'        nm_debug.debug(''attrib17    ''||nm3mrg_supplementary.g_tab_cs_distinct(i).attrib17   ); ' );
   */
   nm3tab_varchar.append(l_block,'     else');
   nm3tab_varchar.append (l_block,'       nm3mrg_supplementary.g_tab_cs_distinct.delete(i) ;');
   nm3tab_varchar.append (l_block,'       exit ;');
   nm3tab_varchar.append (l_block,'    END if;');
   nm3tab_varchar.append (l_block,'   END LOOP;');
   nm3tab_varchar.append (l_block,'END;');
   nm_debug.debug('!');
   nm3tab_varchar.debug_tab_varchar(l_block);
   <<partial_fetch>>
   loop
     nm3ddl.execute_tab_varchar (l_block);
     <<main_process>>
     FOR j IN 1..nm3mrg_supplementary.g_tab_cs_distinct.COUNT
     LOOP
--
      DECLARE
--
         l_pl          nm_placement_array := nm3pla.initialise_placement_array;
         l_single_pl   nm_placement;
         l_nqt_seq_no  number;
--
      BEGIN
--
         IF  nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type                  != l_last_inv_type
          OR NVL(nm3mrg_supplementary.g_tab_cs_distinct(j).x_sect,nm3type.c_nvl) != NVL(l_last_x_sect,nm3type.c_nvl)
          THEN
--
            DELETE FROM nm_mrg_query_results_temp2;
--
            INSERT INTO nm_mrg_query_results_temp2
            SELECT *
             FROM  nm_mrg_query_results_temp
            WHERE  inv_type = nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type
             AND   NVL(x_sect,nm3type.c_nvl) = NVL(nm3mrg_supplementary.g_tab_cs_distinct(j).x_sect,nm3type.c_nvl);
--
            -- If this is for a different INV_TYPE/XSP
            -- then rebuild the anonymous block which is executed to find the matching rows
            FOR i IN 1..g_tab_rec_query_types.COUNT
             LOOP
               IF   g_tab_rec_query_types(i).nqt_inv_type = nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type
                THEN
                  IF  g_tab_rec_query_types(i).nqt_x_sect IS NULL
                   OR g_tab_rec_query_types(i).nqt_x_sect = nm3mrg_supplementary.g_tab_cs_distinct(j).x_sect
                   THEN
                     l_nqt_seq_no := g_tab_rec_query_types(i).nqt_seq_no;
                     EXIT;
                  END IF;
               END IF;
            END LOOP;
            IF l_nqt_seq_no IS NULL
             THEN
               RAISE_APPLICATION_ERROR(-20001,'No NQT found for '||nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type||':'||nm3mrg_supplementary.g_tab_cs_distinct(j).x_sect);
            END IF;
            --
            nm3mrg_supplementary.build_up_sql_for_matching_locs(l_nqt_seq_no);
--
         END IF;
--
         IF nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type != l_last_inv_type
          THEN
--
            DELETE FROM nm_mrg_members2;
--
            INSERT INTO nm_mrg_members2
            SELECT *
             FROM  nm_mrg_members
            WHERE  inv_type  = nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type;
--
         END IF;
--
         l_last_inv_type := nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type;
         l_last_x_sect   := nm3mrg_supplementary.g_tab_cs_distinct(j).x_sect;
--
         --
         -- Find all of the locations for records with these attributes and put them in a placement array
         --
--
--         nm_debug.debug('Find all of the locations for records with these attributes and put them in a placement array');
--         nm_debug.debug(nm3mrg_supplementary.cs_distinct%ROWCOUNT||' time throught the big cursor : '||nm3mrg_supplementary.g_tab_cs_distinct(j).attrib1);
         nm3mrg_supplementary.g_rec_distinct := nm3mrg_supplementary.g_tab_cs_distinct(j);
         l_pl := nm3mrg_supplementary.get_locations_which_match;
--
         l_current_pl_id := l_current_pl_id + 1;
--         ins_jon_pl (l_current_pl_id,l_pl);
--
         DECLARE
--
            l_tab_ne_id     nm3type.tab_number;
            l_tab_begin_mp  nm3type.tab_number;
            l_tab_end_mp    nm3type.tab_number;
            l_tab_measure   nm3type.tab_number;
            l_tab_pl_id     nm3type.tab_number;
            l_tab_seq_no    nm3type.tab_number;
            l_first         boolean := TRUE;
            l_rec_nsv       nm_mrg_section_inv_values%ROWTYPE;
--
            FUNCTION get_seq_no (p_ne_id number) RETURN number IS
               CURSOR cs_seq (c_ne_id number) IS
               SELECT nm_seq_no
                FROM  nm_mrg_members
               WHERE  nm_ne_id_of = c_ne_id;
               l_retval number;
            BEGIN
               OPEN  cs_seq(p_ne_id);
               FETCH cs_seq INTO l_retval;
               CLOSE cs_seq;
               RETURN l_retval;
            END get_seq_no;
--
         BEGIN
            --get attributes of array elements
            FOR i IN 1..l_pl.npa_placement_array.COUNT
             LOOP
--
               -- If the measure of this is ZERO then this is a new
               --  homogenous "chunk" for this set of vals
               IF l_pl.npa_placement_array(i).pl_measure = 0
                AND NOT l_first
                THEN
                  l_current_pl_id := l_current_pl_id + 1;
               END IF;
--
               l_first := FALSE;
--
               l_tab_pl_id(i)    := l_current_pl_id;
               l_tab_ne_id(i)    := l_pl.npa_placement_array(i).pl_ne_id;
               l_tab_begin_mp(i) := l_pl.npa_placement_array(i).pl_start;
               l_tab_end_mp(i)   := l_pl.npa_placement_array(i).pl_end;
               l_tab_measure(i)  := l_pl.npa_placement_array(i).pl_measure;
               l_tab_seq_no(i)   := NULL;
               l_tab_seq_no(i)   := get_seq_no(l_tab_ne_id(i));
--
            END LOOP;
--
            --insert record for each array element
            --
--
--          Create the MRG_SECTION_INV_VALUES record for all of these chunks
--
            l_rec_nsv.nsv_mrg_job_id  := pi_job_id;
            --
            nm3mrg_supplementary.pop_rec_nsv_from_cs_distinct (nm3mrg_supplementary.g_tab_cs_distinct(j), l_rec_nsv);
--
            nm3mrg_supplementary.ins_nm_mrg_section_inv_values (l_rec_nsv);
            --
            -- Store all of the chunks in a temporary holding area
            --
            FORALL i IN 1..l_pl.npa_placement_array.COUNT
              INSERT INTO nm_mrg_query_members_temp
                      (pl_id
                      ,ne_id_of
                      ,begin_mp
                      ,end_mp
                      ,measure
                      ,inv_type
                      ,x_sect
                      ,pnt_or_cont
                      ,value_id
                      ,nte_seq_no
                      )
               VALUES (l_tab_pl_id(i)
                      ,l_tab_ne_id(i)
                      ,l_tab_begin_mp(i)
                      ,l_tab_end_mp(i)
                      ,l_tab_measure(i)
                      ,nm3mrg_supplementary.g_tab_cs_distinct(j).inv_type
                      ,nm3mrg_supplementary.g_tab_cs_distinct(j).x_sect
                      ,nm3mrg_supplementary.g_tab_cs_distinct(j).pnt_or_cont
                      ,l_rec_nsv.nsv_value_id
                      ,l_tab_seq_no(i)
                      );
--
         END;
--
      END;
--
     END LOOP main_process ;
     exit when nm3mrg_supplementary.g_tab_cs_distinct.count < nm3mrg_supplementary.gc_buffer_size ;
     commit ;
   END LOOP partial_fetch;
   dbms_sql.close_cursor(l_cache_cursor_id);
   nm3mrg_supplementary.g_tab_cs_distinct.delete ;
--
--  Get the distinct list of ne_id_of and begin/end MP records
--
-- nm_debug.debug ('   FOR cs_rec IN (SELECT ne_id_of');
   FOR cs_rec IN cs_distinct_locs
    LOOP
      DECLARE
         l_rec_start_pos rec_start_pos;
      BEGIN
         l_rec_start_pos.ne_id       := cs_rec.ne_id_of;
         l_rec_start_pos.position_mp := cs_rec.position_mp;
         g_tab_rec_start_pos(g_tab_rec_start_pos.COUNT+1) := l_rec_start_pos;
      END;
   END LOOP;
--
   l_arr_count := 0;
--
-- nm_debug.debug ('   FOR l_count IN 1..g_tab_rec_start_pos.COUNT-1');
   << start_pos >>
   FOR l_count IN 1..g_tab_rec_start_pos.COUNT-1
    LOOP
--
--      nm_debug.debug(g_tab_rec_start_pos(l_count).ne_id||':'||g_tab_rec_start_pos(l_count).position_mp);
--
      IF g_tab_rec_start_pos(l_count).ne_id = g_tab_rec_start_pos(l_count+1).ne_id
       THEN
         --
         -- If this one is on the same section as the next one
--         nm_debug.debug('If this one is on the same section as the next one');
         --
         l_arr_count := l_arr_count + 1;
         g_tab_rec_members(l_arr_count).ne_id    := g_tab_rec_start_pos(l_count).ne_id;
         g_tab_rec_members(l_arr_count).begin_mp := g_tab_rec_start_pos(l_count).position_mp;
         g_tab_rec_members(l_arr_count).end_mp   := g_tab_rec_start_pos(l_count+1).position_mp;
--         nm_debug.debug(g_tab_rec_members(l_arr_count).ne_id
--                        ||':'
--                        ||g_tab_rec_members(l_arr_count).begin_mp
--                        ||':'
--                        ||g_tab_rec_members(l_arr_count).end_mp
--                       );
--
         IF    l_arr_count = 1
          THEN -- If this is the first one
            g_tab_rec_members(l_arr_count).measure  := 0;
--            nm_debug.debug(g_tab_rec_members(l_arr_count).ne_id
--                           ||':'
--                           ||g_tab_rec_members(l_arr_count).begin_mp
--                           ||' - If this is the first one'
--                          );
         ELSIF g_tab_rec_start_pos(l_count).ne_id = g_tab_rec_start_pos(l_count-1).ne_id
          THEN -- If this is for the same NE_ID as the previous one therefore there must be a change
--         nm_debug.debug('If this is for the same NE_ID as the previous one therefore there must be a change');
--            nm_debug.debug(g_tab_rec_members(l_arr_count).ne_id
--                           ||':'
--                           ||g_tab_rec_members(l_arr_count).begin_mp
--                           ||' - If this is for the same NE_ID as the previous one therefore there must be a change'
--                          );
            g_tab_rec_members(l_arr_count).measure  := 0;
         ELSIF g_tab_rec_start_pos(l_count).position_mp   = 0                                                             -- this one starts at zero
          AND  g_tab_rec_start_pos(l_count-1).position_mp = nm3mrg_supplementary.fn_get_element_length(g_tab_rec_start_pos(l_count-1).ne_id)   -- last one ends at end
          AND  nm3net.check_element_connectivity(g_tab_rec_start_pos(l_count).ne_id,g_tab_rec_start_pos(l_count-1).ne_id) -- And they're connected
          THEN
            --
--         nm_debug.debug('These are connected, but are not necessarily the same');
            -- These are connected, but are not necessarily the same
            --
--            raise_application_error(-20001,l_arr_count||':'||g_tab_rec_members(l_arr_count).ne_id
--                           ||':'
--                           ||g_tab_rec_members(l_arr_count).begin_mp
--                           ||' - These are connected, but are not necessarily the same'
--                          );
            DECLARE
--
               CURSOR cs_details (p_ne_id     number
                                 ,p_start_pos number
                                 ,p_end_pos   number
                                 ,p_inv_type  varchar2
                                 ,p_x_sect    varchar2
                                 ,p_nvl       varchar2 DEFAULT nm3type.c_nvl
                                 ) IS
               SELECT value_id
                FROM  nm_mrg_query_members_temp
               WHERE  ne_id_of  = p_ne_id
                AND   begin_mp <= p_start_pos
                AND   end_mp   >= p_end_pos
                AND  (p_inv_type IS NULL OR (inv_type              = p_inv_type
                                             AND NVL(x_sect,p_nvl) = NVL(p_x_sect,p_nvl)
                                            )
                     );
--
               l_dummy            cs_details%ROWTYPE;
               l_current_value_id number;
--
               l_the_same boolean := TRUE;
--
               l_current_count number := 0;
               l_prior_count   number := 0;
--
               l_defrag_connectivity number;
--
            BEGIN
               --
               -- Just 'cos they are physically connected by node, does not mean that they are allowed to be connected
               --
               l_defrag_connectivity := nm3pla.defrag_connectivity(g_tab_rec_start_pos(l_count-1).ne_id,g_tab_rec_start_pos(l_count).ne_id);
               IF   l_defrag_connectivity != 1
                AND nm3net.subclass_is_used(g_tab_rec_start_pos(l_count).ne_id)
                THEN
                  l_the_same := FALSE;
--                  nm_debug.debug('not the same');
               END IF;
            --   raise_application_error(-20001,l_defrag_connectivity);
               --
               IF l_the_same
                THEN
                  --
                  -- Check to see if there are the same number of inv_items for each record
--                  nm_debug.debug('Check to see if there are the same number of inv_items for each record');
                  --
                  FOR cs_rec IN cs_details
                                   (g_tab_rec_members(l_arr_count-1).ne_id
                                   ,g_tab_rec_members(l_arr_count-1).begin_mp
                                   ,g_tab_rec_members(l_arr_count-1).end_mp
                                   ,NULL
                                   ,NULL
                                   )
                   LOOP
                     l_prior_count := l_prior_count + 1;
                  END LOOP;
   --
                  FOR cs_rec IN cs_details
                                   (g_tab_rec_members(l_arr_count).ne_id
                                   ,g_tab_rec_members(l_arr_count).begin_mp
                                   ,g_tab_rec_members(l_arr_count).end_mp
                                   ,NULL
                                   ,NULL
                                   )
                   LOOP
                     l_current_count := l_current_count + 1;
                  END LOOP;
   --
--                  nm_debug.debug('IF '||l_current_count||' <> '||l_prior_count);
                  IF l_current_count <> l_prior_count
                   THEN
   --
                     l_the_same := FALSE;
   --
                  ELSE
                  --
                  -- If there are the same number of inv_items for each record then make sure they are the same
                  --
--                     nm_debug.debug(l_arr_count||' : If there are the same number of inv_items for each record then make sire they are the same');
   --
                     FOR cs_rec IN (SELECT inv_type, x_sect, value_id
                                     FROM  nm_mrg_query_members_temp
                                    WHERE  ne_id_of  = g_tab_rec_members(l_arr_count-1).ne_id
                                     AND   begin_mp <= g_tab_rec_members(l_arr_count-1).begin_mp
                                     AND   end_mp   >= g_tab_rec_members(l_arr_count-1).end_mp
                                   )
                      LOOP
                        DECLARE
                           l_found boolean := FALSE;
                        BEGIN
                           FOR cs_inner IN cs_details (g_tab_rec_members(l_arr_count).ne_id
                                                      ,g_tab_rec_members(l_arr_count).begin_mp
                                                      ,g_tab_rec_members(l_arr_count).end_mp
                                                      ,cs_rec.inv_type
                                                      ,cs_rec.x_sect
                                                      )
                            LOOP
                              l_found := (cs_inner.value_id = cs_rec.value_id);
                              EXIT WHEN l_found;
                           END LOOP;
                           IF NOT l_found
                            THEN
                              l_the_same := FALSE;
                              EXIT;
                           END IF;
                        END;
                     END LOOP;
   --
                  END IF;
               END IF;
--
               IF l_the_same
                THEN
                  g_tab_rec_members(l_arr_count).measure  := g_tab_rec_members(l_arr_count-1).measure
                                                            + (g_tab_rec_members(l_arr_count-1).end_mp
                                                                - g_tab_rec_members(l_arr_count-1).begin_mp
                                                              );
               ELSE
                  g_tab_rec_members(l_arr_count).measure  := 0;
               END IF;
--
            END;
         ELSE
            g_tab_rec_members(l_arr_count).measure  := 0;
         END IF;
--
         IF g_tab_rec_members(l_arr_count).measure = 0
          THEN
            --
            -- If the measure is ZERO then this is a new homogenous segment
            --
            IF l_arr_count > 1
             THEN
               --
               -- This is a new homogenous chunk so write the NM_MRG_SECTION record for the
               --  previous chunk. But only do this is there is a nm_mrg_query_members_temp record
               --
--               nm_debug.debug('Sec : '||g_tab_rec_members(l_arr_count-1).mrg_section_id||' is '||l_start_ne_id||':'||l_start_offset
--                              ||' -> '||g_tab_rec_members(l_arr_count-1).ne_id||':'||g_tab_rec_members(l_arr_count-1).end_mp
--                             ,-1);
               IF does_chunk_have_data (l_start_ne_id, l_start_offset)
                THEN
--                  nm_debug.debug('Inserting for ^',-1);
                  nm3mrg_supplementary.ins_nm_mrg_sections
                       (pi_job_id         => pi_job_id
                       ,pi_mrg_section_id => g_tab_rec_members(l_arr_count-1).mrg_section_id
                       ,pi_nte_job_id     => pi_nte_job_id
                       ,pi_ne_id_first    => l_start_ne_id
                       ,pi_begin_mp_first => l_start_offset
                       ,pi_ne_id_last     => g_tab_rec_members(l_arr_count-1).ne_id
                       ,pi_end_mp_last    => g_tab_rec_members(l_arr_count-1).end_mp
                       ,pi_orig_sect_id   => g_tab_rec_members(l_arr_count-1).mrg_section_id
                       );
                  l_tab_mrg_sections(g_tab_rec_members(l_arr_count-1).mrg_section_id) := TRUE;
               END IF;
            END IF;
            g_tab_rec_members(l_arr_count).mrg_section_id := get_nm_mrg_query_staging_seq;
            l_start_ne_id  := g_tab_rec_members(l_arr_count).ne_id;
            l_start_offset := g_tab_rec_members(l_arr_count).begin_mp;
--
         ELSE
            --
            -- otherwise this is part of the same homogenous segment as the last record
            --
            g_tab_rec_members(l_arr_count).mrg_section_id := g_tab_rec_members(l_arr_count-1).mrg_section_id;
--
         END IF;
--
      END IF;
--
      commit ;
   END LOOP start_pos;
--   nm_debug.set_level(3);
--
   --
   -- Write the NM_MRG_SECTIONS record for the last chunk processed
   --
--   nm_debug.debug ('   ins_nm_mrg_sections (pi_job_id         => pi_job_id');
   IF l_arr_count > 0
    THEN
--      nm_debug.debug('Sec : '||g_tab_rec_members(l_arr_count).mrg_section_id||' is '||l_start_ne_id||':'||l_start_offset
--                              ||' -> '||g_tab_rec_members(l_arr_count).ne_id||':'||g_tab_rec_members(l_arr_count).end_mp
--                             ,-1);
--      nm_debug.debug('Sec : '||g_tab_rec_members(l_arr_count).mrg_section_id,-1);
      -- But only do this is there is a nm_mrg_query_members_temp record
      IF does_chunk_have_data (l_start_ne_id, l_start_offset)
       THEN
--         nm_debug.debug('Inserting for ^',-1);
         nm3mrg_supplementary.ins_nm_mrg_sections
                             (pi_job_id         => pi_job_id
                             ,pi_mrg_section_id => g_tab_rec_members(l_arr_count).mrg_section_id
                             ,pi_nte_job_id     => pi_nte_job_id
                             ,pi_ne_id_first    => l_start_ne_id
                             ,pi_begin_mp_first => l_start_offset
                             ,pi_ne_id_last     => g_tab_rec_members(l_arr_count).ne_id
                             ,pi_end_mp_last    => g_tab_rec_members(l_arr_count).end_mp
                             ,pi_orig_sect_id   => g_tab_rec_members(l_arr_count).mrg_section_id
                             );
         l_tab_mrg_sections(g_tab_rec_members(l_arr_count).mrg_section_id) := TRUE;
      END IF;
   END IF;
--
   --
   -- Write all the NM_MRG_SECTION_MEMBERS records
   --
--   nm_debug.debug ('   FOR l_count IN 1..g_tab_rec_members.COUNT',-1);
   FOR l_count IN 1..g_tab_rec_members.COUNT
    LOOP
      IF l_tab_mrg_sections.EXISTS(g_tab_rec_members(l_count).mrg_section_id)
       THEN -- If we've created a MRG_SECTION for this one
--         nm_debug.debug(g_tab_rec_members(l_count).mrg_section_id||' is '
--                        ||g_tab_rec_members(l_count).ne_id||':'||g_tab_rec_members(l_count).begin_mp
--                        ||' -> '
--                        ||g_tab_rec_members(l_count).ne_id||':'||g_tab_rec_members(l_count).end_mp
--                       ,-1);
         nm3mrg_supplementary.ins_nm_mrg_section_members
                            (pi_mrg_job_id     => pi_job_id
                            ,pi_mrg_section_id => g_tab_rec_members(l_count).mrg_section_id
                            ,pi_ne_id          => g_tab_rec_members(l_count).ne_id
                            ,pi_begin_mp       => g_tab_rec_members(l_count).begin_mp
                            ,pi_end_mp         => g_tab_rec_members(l_count).end_mp
                            ,pi_measure        => g_tab_rec_members(l_count).measure
                            );
      END IF;
   END LOOP;
   commit ;
--
   -- Create NM_MRG_SECTIONS and NM_MRG_SECTION_MEMBERS records
   --  for any continous inventory which is located at a single point
   nm3mrg_supplementary.deal_with_point_continous_inv (pi_job_id);
--
   DECLARE
      l_tab_inv_type nm3type.tab_varchar4;
      l_tab_x_sect   nm3type.tab_varchar4;
   BEGIN
--   nm_debug.debug ('   INSERT INTO nm_mrg_section_member_inv');
--
      FOR i IN 1..g_tab_rec_inv_type_xsp.COUNT
       LOOP
         -- Build up an array of all of the inv type and XSP combos for continuous inventory
         IF g_tab_rec_inv_type_xsp(i).pnt_or_cont = 'C'
          THEN
            l_tab_inv_type(l_tab_inv_type.COUNT+1) := g_tab_rec_inv_type_xsp(i).inv_type;
            l_tab_x_sect(l_tab_x_sect.COUNT+1)     := g_tab_rec_inv_type_xsp(i).x_sect;
         END IF;
      END LOOP;
--
      FOR i IN 1..l_tab_inv_type.COUNT
      LOOP
--      -- Write the NM_MRG_SECTION_MEMBER_INV records
         INSERT INTO nm_mrg_section_member_inv
               (nsi_mrg_job_id
               ,nsi_mrg_section_id
               ,nsi_inv_type
               ,nsi_x_sect
               ,nsi_value_id
               )
         SELECT pi_job_id
               ,nmms.nsm_mrg_section_id
               ,nmqmt.inv_type
               ,nmqmt.x_sect
               ,nmqmt.value_id
          FROM  nm_mrg_query_members_temp nmqmt
               ,nm_mrg_section_members    nmms
         WHERE  nmms.nsm_mrg_job_id             = pi_job_id
          AND   nmqmt.inv_type                  = l_tab_inv_type(i)
          AND   NVL(nmqmt.x_sect,nm3type.c_nvl) = NVL(l_tab_x_sect(i),nm3type.c_nvl)
          AND   nmms.nsm_ne_id                  = nmqmt.ne_id_of
          AND   nmms.nsm_begin_mp              >= nmqmt.begin_mp
          AND   nmms.nsm_end_mp                <= nmqmt.end_mp
         GROUP BY pi_job_id
                 ,nmms.nsm_mrg_section_id
                 ,nmqmt.inv_type
                 ,nmqmt.x_sect
                 ,nmqmt.value_id;
       end loop ;
   END;
--
   nm_debug.proc_end(g_package_name,'deal_with_continuous');
   exception
     when others then
       if dbms_sql.is_open(l_cache_cursor_id)
       then
         dbms_sql.close_cursor(l_cache_cursor_id);
       end if ;
       raise ;
--
END deal_with_continuous;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE deal_with_point      (pi_nte_job_id   IN nm_members.nm_ne_id_in%TYPE
                               ,pi_job_id       IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                               ) IS
--
   CURSOR cs_point (c_nte_job_id number) IS
   SELECT nmm.nm_ne_id_of
         ,nte.nte_seq_no
         ,nte.nte_route_ne_id
         ,nmm.nm_begin_mp
    FROM  nm_mrg_members            nmm
         ,nm_mrg_query_results_temp nmqrt
         ,nm_nw_temp_extents        nte
   WHERE  nmm.nm_ne_id_in   = nmqrt.ne_id
    AND   nte.nte_job_id    = c_nte_job_id
    AND   nte.nte_ne_id_of  = nmm.nm_ne_id_of
    AND   nmm.nm_begin_mp BETWEEN nte.nte_begin_mp AND nte.nte_end_mp
    AND   nmqrt.pnt_or_cont = 'P'
    AND   nmqrt.inv_type    = nmm.inv_type
   GROUP BY nmm.nm_ne_id_of
           ,nte.nte_seq_no
           ,nte.nte_route_ne_id
           ,nmm.nm_begin_mp
   ORDER BY nte.nte_seq_no
           ,nmm.nm_begin_mp;
--
   l_some_point_to_deal_with boolean := FALSE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'deal_with_point');
--
--
   FOR l_count IN 1..g_tab_rec_inv_type_xsp.COUNT
    LOOP
      IF g_tab_rec_inv_type_xsp(l_count).pnt_or_cont = 'P'
       THEN
         l_some_point_to_deal_with := TRUE;
         EXIT;
      END IF;
   END LOOP;
--
   IF NOT l_some_point_to_deal_with
    THEN -- If there are no Point items in this query then just bail out of this procedure
      nm_debug.proc_end(g_package_name,'deal_with_point');
      RETURN;
   END IF;
--
   g_tab_mrg_sect_inv_val.DELETE;
--
--   nm_debug.debug ('Dealing with point items');
--
-- Get a distinct list of all of the point items with which we are dealing
--
   FOR cs_rec IN cs_point(pi_nte_job_id)
    LOOP
      deal_with_individual_point(pi_nte_job_id
                                ,pi_job_id
                                ,cs_rec.nm_ne_id_of
                                ,cs_rec.nm_begin_mp
                                );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'deal_with_point');
--
--
END deal_with_point;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE deal_with_individual_point
                        (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                        ,pi_job_id       IN nm_mrg_sections.nms_mrg_job_id%TYPE
                        ,pi_ne_id        IN nm_mrg_members.nm_ne_id_of%TYPE
                        ,pi_begin_mp     IN nm_mrg_members.nm_begin_mp%TYPE
                        ) IS
--
   CURSOR cs_nsm (p_job_id   nm_mrg_section_members.nsm_mrg_job_id%TYPE
                 ,p_ne_id    nm_mrg_section_members.nsm_ne_id%TYPE
                 ,p_begin_mp nm_mrg_section_members.nsm_begin_mp%TYPE
                 ) IS
   SELECT *
    FROM  nm_mrg_section_members
   WHERE  nsm_mrg_job_id =  p_job_id
    AND   nsm_ne_id      =  p_ne_id
    AND   nsm_begin_mp   <= p_begin_mp
    AND   nsm_end_mp     >  p_begin_mp;
--
   CURSOR cs_nsm_end (p_job_id   nm_mrg_section_members.nsm_mrg_job_id%TYPE
                     ,p_ne_id    nm_mrg_section_members.nsm_ne_id%TYPE
                     ,p_begin_mp nm_mrg_section_members.nsm_begin_mp%TYPE
                     ) IS
   SELECT *
    FROM  nm_mrg_section_members
   WHERE  nsm_mrg_job_id =  p_job_id
    AND   nsm_ne_id      =  p_ne_id
    AND   nsm_end_mp     =  p_begin_mp;
--
   CURSOR cs_nsm2 (c_job_id     nm_mrg_section_members.nsm_mrg_job_id%TYPE
                  ,c_section_id nm_mrg_section_members.nsm_mrg_section_id%TYPE
                  ) IS
   SELECT *
    FROM  nm_mrg_section_members
   WHERE  nsm_mrg_job_id     = c_job_id
    AND   nsm_mrg_section_id = c_section_id
   ORDER BY nsm_measure;
--
   l_rec_nsm         nm_mrg_section_members%ROWTYPE;
   l_cs_nsm_rowcount binary_integer := 0;
--
   l_initial_pl  nm_placement_array := nm3pla.initialise_placement_array;
   l_pre_pl      nm_placement_array := nm3pla.initialise_placement_array;
   l_post_pl     nm_placement_array := nm3pla.initialise_placement_array;
--
   l_current_pl  nm_placement;
--
   l_tab_mrg_sections     tab_mrg_sections;
   l_tab_mrg_sect_members tab_mrg_sect_members;
   l_tab_mrg_sect_mem_inv tab_mrg_sect_mem_inv;
   l_tab_mrg_sect_inv_val tab_mrg_sect_inv_val;
--
   l_pre_section_id       nm_mrg_sections.nms_mrg_section_id%TYPE;
   l_new_section_id       nm_mrg_sections.nms_mrg_section_id%TYPE;
   l_post_section_id      nm_mrg_sections.nms_mrg_section_id%TYPE;
--
   l_arr_pos              binary_integer;
--
-- Local procedure
--
   PROCEDURE pc_pop_member_inv_and_vals IS
      l_empty_rec_nsv  nm_mrg_section_inv_values%ROWTYPE;
   BEGIN
--
      l_rec_nsv := l_empty_rec_nsv;
--
      FOR cs_rec IN nm3mrg_supplementary.cs_inv_val_by_mem (pi_ne_id, pi_begin_mp)
       LOOP
--
--         nm_debug.debug(nm3mrg_supplementary.cs_inv_val_by_mem%ROWCOUNT||'. nm3mrg_supplementary.cs_inv_val_by_mem');
         l_rec_nsv.nsv_mrg_job_id  := pi_job_id;
         nm3mrg_supplementary.pop_rec_nsv_from_inv_val_mem (cs_rec, l_rec_nsv);
--
         nm3mrg_supplementary.build_up_sql_individual_point (pi_job_id);
--

--         FOR l_count IN 1..l_tab_mrg_sect_inv_val.COUNT
--          LOOP
--            IF nm3mrg_supplementary.compare_rec_nsv
--                               (pi_rec_1 => l_rec_nsv
--                               ,pi_rec_2 => l_tab_mrg_sect_inv_val(l_count)
--                               )
--             THEN
--               l_rec_nsv.nsv_value_id := l_tab_mrg_sect_inv_val(l_count).nsv_value_id;
--               EXIT;
--            END IF;
--         END LOOP;
----
         IF l_rec_nsv.nsv_value_id IS NULL
          THEN  -- No record already there, so add it into the array
            l_rec_nsv.nsv_value_id := nm3mrg_supplementary.get_nmqv_id;
            l_tab_mrg_sect_inv_val(l_tab_mrg_sect_inv_val.COUNT+1) := l_rec_nsv;
            nm3mrg_supplementary.ins_nm_mrg_section_inv_values (l_rec_nsv);
         END IF;
--
         l_arr_pos := l_tab_mrg_sect_mem_inv.COUNT + 1;
         l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_mrg_job_id     := pi_job_id;
         l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_mrg_section_id := l_new_section_id;
         l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_inv_type       := l_rec_nsv.nsv_inv_type;
         l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_x_sect         := l_rec_nsv.nsv_x_sect;
         l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_value_id       := l_rec_nsv.nsv_value_id;
--
      END LOOP;
--
   END pc_pop_member_inv_and_vals;
   --
   -- End of local procedure
   --
--
BEGIN
--
   l_tab_mrg_sections.DELETE;
   l_tab_mrg_sect_members.DELETE;
   l_tab_mrg_sect_mem_inv.DELETE;
   l_tab_mrg_sect_inv_val.DELETE;
--
--   nm_debug.debug('deal_with_individual_point '||pi_ne_id||':'||pi_begin_mp);
   nm_debug.proc_start(g_package_name,'deal_with_individual_point '||pi_ne_id||':'||pi_begin_mp);
--
   FOR cs_rec IN cs_nsm (pi_job_id, pi_ne_id, pi_begin_mp)
    LOOP
      l_rec_nsm         := cs_rec;
      l_cs_nsm_rowcount := l_cs_nsm_rowcount + 1;
   END LOOP;
--
   IF l_cs_nsm_rowcount = 0
    THEN
      -- If there is none found then have a quick shufty to see
      --  if it is right at the end of a element
      FOR cs_rec IN cs_nsm_end (pi_job_id, pi_ne_id, pi_begin_mp)
       LOOP
         l_rec_nsm         := cs_rec;
         l_cs_nsm_rowcount := l_cs_nsm_rowcount + 1;
      END LOOP;
   END IF;
--
   IF l_cs_nsm_rowcount > 1
    THEN
      --
      -- If the rowcount is greater than 1 then something has gone badly wrong!
      --
      nm_debug.DEBUG ('If the rowcount is greater than 1 then something has gone badly wrong! - '||l_cs_nsm_rowcount,-2);
      g_mrg_exc_code := -20909;
      g_mrg_exc_msg  := 'Fatal error in NM3MRG. Point item exists on more than 1 NM_MRG_SECTION_MEMBERS record';
      RAISE g_mrg_exception;
   ELSIF l_cs_nsm_rowcount = 1
    THEN
      --
      -- If the rowcount is 1 then we have a section here already so we'll have to modify NM_MRG_SECTIONS etc
      --
--      nm_debug.debug('If the rowcount is 1 then we have a section here already so we'||CHR(39)||'ll have to modify it');
--
      -- Put all of the member rows into a placement array
      FOR cs_rec IN cs_nsm2 (pi_job_id,l_rec_nsm.nsm_mrg_section_id)
       LOOP
         nm3pla.add_element_to_pl_arr (l_initial_pl
                                      ,cs_rec.nsm_ne_id
                                      ,cs_rec.nsm_begin_mp
                                      ,cs_rec.nsm_end_mp
                                      ,cs_rec.nsm_measure
                                      ,FALSE
                                      );
      END LOOP;
--
      nm3pla.split_placement_array (this_npa    => l_initial_pl
                                   ,pi_ne_id    => pi_ne_id
                                   ,pi_mp       => pi_begin_mp
                                   ,po_npa_pre  => l_pre_pl
                                   ,po_npa_post => l_post_pl
                                   ,pi_allow_zero_length_placement => FALSE
                                   );
--
      IF NOT l_pre_pl.is_empty
       THEN -- If there are some entries in the placement array
         -- This one is for the merge section which is before the point item
         l_arr_pos          := l_tab_mrg_sections.COUNT + 1;
         l_pre_section_id   := get_nm_mrg_query_staging_seq;
         l_tab_mrg_sections(l_arr_pos).nms_mrg_job_id     := pi_job_id;
         l_tab_mrg_sections(l_arr_pos).nms_mrg_section_id := l_pre_section_id;
         l_tab_mrg_sections(l_arr_pos).nms_offset_ne_id   := pi_nte_job_id;
         l_tab_mrg_sections(l_arr_pos).nms_ne_id_first    := l_pre_pl.npa_placement_array(l_pre_pl.npa_placement_array.FIRST).pl_ne_id;
         l_tab_mrg_sections(l_arr_pos).nms_begin_mp_first := l_pre_pl.npa_placement_array(l_pre_pl.npa_placement_array.FIRST).pl_start;
         l_tab_mrg_sections(l_arr_pos).nms_ne_id_last     := l_pre_pl.npa_placement_array(l_pre_pl.npa_placement_array.LAST).pl_ne_id;
         l_tab_mrg_sections(l_arr_pos).nms_end_mp_last    := l_pre_pl.npa_placement_array(l_pre_pl.npa_placement_array.LAST).pl_end;
         l_tab_mrg_sections(l_arr_pos).nms_orig_sect_id   := l_rec_nsm.nsm_mrg_section_id;
      END IF;
--
      -- This one is for the merge section which is at the point item
      l_arr_pos          := l_tab_mrg_sections.COUNT + 1;
      l_new_section_id   := get_nm_mrg_query_staging_seq;
      l_tab_mrg_sections(l_arr_pos).nms_mrg_job_id     := pi_job_id;
      l_tab_mrg_sections(l_arr_pos).nms_mrg_section_id := l_new_section_id;
      l_tab_mrg_sections(l_arr_pos).nms_offset_ne_id   := pi_nte_job_id;
      l_tab_mrg_sections(l_arr_pos).nms_ne_id_first    := pi_ne_id;
      l_tab_mrg_sections(l_arr_pos).nms_begin_mp_first := pi_begin_mp;
      l_tab_mrg_sections(l_arr_pos).nms_ne_id_last     := pi_ne_id;
      l_tab_mrg_sections(l_arr_pos).nms_end_mp_last    := pi_begin_mp;
      l_tab_mrg_sections(l_arr_pos).nms_orig_sect_id   := l_rec_nsm.nsm_mrg_section_id;
--
      IF NOT l_post_pl.is_empty
       THEN -- If there are some entries in the placement array
         -- This one is for the merge section which is after the point item
         l_arr_pos          := l_tab_mrg_sections.COUNT + 1;
         l_post_section_id  := get_nm_mrg_query_staging_seq;
         l_tab_mrg_sections(l_arr_pos).nms_mrg_job_id     := pi_job_id;
         l_tab_mrg_sections(l_arr_pos).nms_mrg_section_id := l_post_section_id;
         l_tab_mrg_sections(l_arr_pos).nms_offset_ne_id   := pi_nte_job_id;
         l_tab_mrg_sections(l_arr_pos).nms_ne_id_first    := l_post_pl.npa_placement_array(l_post_pl.npa_placement_array.FIRST).pl_ne_id;
         l_tab_mrg_sections(l_arr_pos).nms_begin_mp_first := l_post_pl.npa_placement_array(l_post_pl.npa_placement_array.FIRST).pl_start;
         l_tab_mrg_sections(l_arr_pos).nms_ne_id_last     := l_post_pl.npa_placement_array(l_post_pl.npa_placement_array.LAST).pl_ne_id;
         l_tab_mrg_sections(l_arr_pos).nms_end_mp_last    := l_post_pl.npa_placement_array(l_post_pl.npa_placement_array.LAST).pl_end;
         l_tab_mrg_sections(l_arr_pos).nms_orig_sect_id   := l_rec_nsm.nsm_mrg_section_id;
      END IF;
--
--    Populate the rows required for the new NM_MRG_SECTION_MEMBERS records
--
      -- Pre the point item
      IF NOT l_pre_pl.is_empty
       THEN
         FOR l_count IN l_pre_pl.npa_placement_array.FIRST..l_pre_pl.npa_placement_array.LAST
          LOOP
--
            l_current_pl := l_pre_pl.npa_placement_array(l_count);
--
            l_arr_pos := l_tab_mrg_sect_members.COUNT + 1;
--
            l_tab_mrg_sect_members(l_arr_pos).nsm_mrg_job_id     := pi_job_id;
            l_tab_mrg_sect_members(l_arr_pos).nsm_mrg_section_id := l_pre_section_id;
            l_tab_mrg_sect_members(l_arr_pos).nsm_ne_id          := l_current_pl.pl_ne_id;
            l_tab_mrg_sect_members(l_arr_pos).nsm_begin_mp       := l_current_pl.pl_start;
            l_tab_mrg_sect_members(l_arr_pos).nsm_end_mp         := l_current_pl.pl_end;
            l_tab_mrg_sect_members(l_arr_pos).nsm_measure        := l_current_pl.pl_measure;
         END LOOP;
      END IF;
--
      -- For the point item
      l_arr_pos := l_tab_mrg_sect_members.COUNT + 1;
--
      l_tab_mrg_sect_members(l_arr_pos).nsm_mrg_job_id     := pi_job_id;
      l_tab_mrg_sect_members(l_arr_pos).nsm_mrg_section_id := l_new_section_id;
      l_tab_mrg_sect_members(l_arr_pos).nsm_ne_id          := pi_ne_id;
      l_tab_mrg_sect_members(l_arr_pos).nsm_begin_mp       := pi_begin_mp;
      l_tab_mrg_sect_members(l_arr_pos).nsm_end_mp         := pi_begin_mp;
      l_tab_mrg_sect_members(l_arr_pos).nsm_measure        := 0;
--
      -- Post the point item
      IF NOT l_post_pl.is_empty
       THEN
         FOR l_count IN l_post_pl.npa_placement_array.FIRST..l_post_pl.npa_placement_array.LAST
          LOOP
            l_current_pl := l_post_pl.npa_placement_array(l_count);
--
            l_arr_pos := l_tab_mrg_sect_members.COUNT + 1;
--
            l_tab_mrg_sect_members(l_arr_pos).nsm_mrg_job_id     := pi_job_id;
            l_tab_mrg_sect_members(l_arr_pos).nsm_mrg_section_id := l_post_section_id;
            l_tab_mrg_sect_members(l_arr_pos).nsm_ne_id          := l_current_pl.pl_ne_id;
            l_tab_mrg_sect_members(l_arr_pos).nsm_begin_mp       := l_current_pl.pl_start;
            l_tab_mrg_sect_members(l_arr_pos).nsm_end_mp         := l_current_pl.pl_end;
            l_tab_mrg_sect_members(l_arr_pos).nsm_measure        := l_current_pl.pl_measure;
         END LOOP;
      END IF;
--
--    Populate the rows required to duplicate the presence of the inventory (for continuous items)
--
      FOR l_count IN 1..l_tab_mrg_sections.COUNT
       LOOP
         FOR cs_rec IN (SELECT *
                         FROM  nm_mrg_section_member_inv
                        WHERE  nsi_mrg_job_id     = pi_job_id
                         AND   nsi_mrg_section_id = l_rec_nsm.nsm_mrg_section_id
                       )
          LOOP
            l_arr_pos := l_tab_mrg_sect_mem_inv.COUNT + 1;
            l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_mrg_job_id     := cs_rec.nsi_mrg_job_id;
            l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_mrg_section_id := l_tab_mrg_sections(l_count).nms_mrg_section_id;
            l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_inv_type       := cs_rec.nsi_inv_type;
            l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_x_sect         := cs_rec.nsi_x_sect;
            l_tab_mrg_sect_mem_inv(l_arr_pos).nsi_value_id       := cs_rec.nsi_value_id;
         END LOOP;
      END LOOP;
--
--    Populate the rows for the point items
--
      pc_pop_member_inv_and_vals;
--
      --
      -- now get rid of the old NM_MRG_SECTIONS record (+ it's MEMBERS + MEMBER_INV)
      --
      DELETE FROM nm_mrg_sections
      WHERE  nms_mrg_job_id     = pi_job_id
       AND   nms_mrg_section_id = l_rec_nsm.nsm_mrg_section_id;
--
   ELSE
      --
      -- The rowcount is zero so we can just create a new contiguous section (zero length)
      --
--      nm_debug.debug('The rowcount is zero so we can just create a new contiguous section');
--
      -- Section
      l_new_section_id   := get_nm_mrg_query_staging_seq;
      l_tab_mrg_sections(1).nms_mrg_job_id     := pi_job_id;
      l_tab_mrg_sections(1).nms_mrg_section_id := l_new_section_id;
      l_tab_mrg_sections(1).nms_offset_ne_id   := pi_nte_job_id;
      l_tab_mrg_sections(1).nms_ne_id_first    := pi_ne_id;
      l_tab_mrg_sections(1).nms_begin_mp_first := pi_begin_mp;
      l_tab_mrg_sections(1).nms_ne_id_last     := pi_ne_id;
      l_tab_mrg_sections(1).nms_end_mp_last    := pi_begin_mp;
      l_tab_mrg_sections(1).nms_orig_sect_id   := l_new_section_id;
--
      -- Section Members
      l_tab_mrg_sect_members(1).nsm_mrg_job_id     := pi_job_id;
      l_tab_mrg_sect_members(1).nsm_mrg_section_id := l_new_section_id;
      l_tab_mrg_sect_members(1).nsm_ne_id          := pi_ne_id;
      l_tab_mrg_sect_members(1).nsm_begin_mp       := pi_begin_mp;
      l_tab_mrg_sect_members(1).nsm_end_mp         := pi_begin_mp;
      l_tab_mrg_sect_members(1).nsm_measure        := 0;
--
      pc_pop_member_inv_and_vals;
--
   END IF;
--
-- Insert values from arrays
--
   FOR l_count IN 1..l_tab_mrg_sections.COUNT
    LOOP
--      nm_debug.debug(l_count
--                     ||':'
--                     ||l_tab_mrg_sections(l_count).nms_mrg_section_id
--                     ||':'
--                     ||l_tab_mrg_sections(l_count).nms_offset_ne_id
--                     ||':'
--                     ||l_tab_mrg_sections(l_count).nms_ne_id_first
--                     ||':'
--                     ||l_tab_mrg_sections(l_count).nms_begin_mp_first
--                     ||':'
--                     ||l_tab_mrg_sections(l_count).nms_ne_id_last
--                     ||':'
--                     ||l_tab_mrg_sections(l_count).nms_end_mp_last
--                     ||':'
--                     ||l_tab_mrg_sections(l_count).nms_orig_sect_id
--                    );
      nm3mrg_supplementary.ins_nm_mrg_sections  (l_tab_mrg_sections(l_count).nms_mrg_job_id
                          ,l_tab_mrg_sections(l_count).nms_mrg_section_id
                          ,l_tab_mrg_sections(l_count).nms_offset_ne_id
                          ,l_tab_mrg_sections(l_count).nms_ne_id_first
                          ,l_tab_mrg_sections(l_count).nms_begin_mp_first
                          ,l_tab_mrg_sections(l_count).nms_ne_id_last
                          ,l_tab_mrg_sections(l_count).nms_end_mp_last
                          ,l_tab_mrg_sections(l_count).nms_orig_sect_id
                          );
   END LOOP;
--
   nm3mrg_supplementary.ins_nm_mrg_section_members (l_tab_mrg_sect_members);
--
--   FOR l_count IN 1..l_tab_mrg_sect_inv_val.COUNT
--    LOOP
--      nm3mrg_supplementary.ins_nm_mrg_section_inv_values (l_tab_mrg_sect_inv_val(l_count));
--   END LOOP;
--
   FOR l_count IN 1..l_tab_mrg_sect_mem_inv.COUNT
    LOOP
      nm3mrg_supplementary.ins_nm_mrg_section_member_inv (l_tab_mrg_sect_mem_inv(l_count));
   END LOOP;
--
   -- If there have been any point items then we need to resequence the results
   g_resequence_reqd := TRUE;
--
   nm_debug.proc_end(g_package_name,'deal_with_individual_point '||pi_ne_id||':'||pi_begin_mp);
--
END deal_with_individual_point;
--
------------------------------------------------------------------------------------------------
--
FUNCTION valid_pbi_condition_values (pi_condition    IN varchar2
                                    ,pi_values_count IN number
                                    ) RETURN boolean IS
BEGIN
--
   RETURN nm3mrg_supplementary.valid_pbi_condition_values
                                     (pi_condition
                                     ,pi_values_count
                                     );
--
END valid_pbi_condition_values;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_tab_column_details (pi_table_name  IN user_tab_columns.table_name%TYPE
                                ,pi_column_name IN user_tab_columns.column_name%TYPE
                                ) RETURN user_tab_columns%ROWTYPE IS
BEGIN
--
   RETURN nm3mrg_supplementary.get_tab_column_details (pi_table_name,pi_column_name);
--
END get_tab_column_details;
--
------------------------------------------------------------------------------------------------
--
FUNCTION execute_sql (pi_sql_string IN long) RETURN binary_integer IS
   l_dyn_sql_rowcount binary_integer;
BEGIN
--   nm_debug.debug('PRE  - '||pi_sql_string);
   EXECUTE IMMEDIATE pi_sql_string;
   l_dyn_sql_rowcount := SQL%rowcount;
--   nm_debug.debug('POST ('||l_dyn_sql_rowcount||') - '||pi_sql_string);
   RETURN l_dyn_sql_rowcount;
END execute_sql;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE upd_nm_mrg_sections  (pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                               ,pi_job_id IN nm_mrg_sections.nms_mrg_job_id%TYPE
                               ) IS
--
   CURSOR cs_reseq (c_nte_job_id number, c_mrg_job_id number)IS
   SELECT nms.*
         ,nte.nte_seq_no
         ,nte.nte_route_ne_id
    FROM  nm_mrg_sections     nms
         ,nm_nw_temp_extents  nte
   WHERE  nms.nms_mrg_job_id     =  c_mrg_job_id
    AND   nte.nte_job_id         =  c_nte_job_id
    AND   nms.nms_ne_id_first    =  nte.nte_ne_id_of
    --
    AND   nms.nms_begin_mp_first >= nte.nte_begin_mp
    --
    AND  (nms.nms_begin_mp_first <  nte.nte_end_mp  -- It is before the end_mp of the temp_ne entry
          OR (DECODE(nms.nms_ne_id_first
                   ,nms.nms_ne_id_last,DECODE(nms_begin_mp_first
                                             ,nms_end_mp_last,1
                                             ,2
                                             )
                   ,2
                   ) = 1    -- Unless it is a point item
       --       AND nms.nms_begin_mp_first <= nte.nte_end_mp
             )
         )
    --
   ORDER BY nte.nte_seq_no
           ,nms.nms_begin_mp_first
           ,DECODE(nms.nms_ne_id_first
                  ,nms.nms_ne_id_last,DECODE(nms_begin_mp_first
                                            ,nms_end_mp_last,1
                                            ,2
                                            )
                  ,2
                  ); -- Do point before cont
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'upd_nm_mrg_sections');
--
   IF g_resequence_reqd
    THEN -- If we need to resequence (there has been some point data (or POE) splitting up the contiguous sections
--      nm_debug.debug('Resequence sections start');
      FOR cs_rec IN cs_reseq (pi_nte_job_id,pi_job_id)
       LOOP
--         nm_debug.debug(cs_rec.nms_mrg_section_id,-1);
         DECLARE
            l_rec_nms nm_mrg_sections%ROWTYPE;
         BEGIN
            --
            --nm_debug.debug(cs_rec.nte_route_ne_id||':'||cs_rec.nte_seq_no||':'||cs_rec.nms_begin_mp_first);
            --
            l_rec_nms.nms_mrg_job_id         := cs_rec.nms_mrg_job_id;
            l_rec_nms.nms_mrg_section_id     := cs_rec.nms_mrg_section_id;
            l_rec_nms.nms_offset_ne_id       := cs_rec.nms_offset_ne_id;
            l_rec_nms.nms_begin_offset       := cs_rec.nms_begin_offset;
            l_rec_nms.nms_end_offset         := cs_rec.nms_end_offset;
            l_rec_nms.nms_ne_id_first        := cs_rec.nms_ne_id_first;
            l_rec_nms.nms_begin_mp_first     := cs_rec.nms_begin_mp_first;
            l_rec_nms.nms_ne_id_last         := cs_rec.nms_ne_id_last;
            l_rec_nms.nms_end_mp_last        := cs_rec.nms_end_mp_last;
            l_rec_nms.nms_in_results         := cs_rec.nms_in_results;
            l_rec_nms.nms_orig_sect_id       := cs_rec.nms_orig_sect_id;
            --
            nm3mrg_supplementary.do_cascading_sect_update(l_rec_nms,get_nm_mrg_query_staging_seq);
            --
         END;
      END LOOP;
--      nm_debug.debug('Resequence sections finish');
   END IF;
--
   nm3mrg_supplementary.get_route_offsets(pi_job_id);
--
   nm_debug.proc_end(g_package_name,'upd_nm_mrg_sections');
--
END upd_nm_mrg_sections;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_nm_mrg_query_staging_seq RETURN number IS
BEGIN
--
   g_mrg_section_id := g_mrg_section_id + 1;
   RETURN g_mrg_section_id;
--
END get_nm_mrg_query_staging_seq;
--
------------------------------------------------------------------------------------------------
--
FUNCTION defaults_exist RETURN boolean IS
BEGIN
   RETURN nm3mrg_supplementary.defaults_exist;
END defaults_exist;
--
------------------------------------------------------------------------------------------------
--
FUNCTION defaults_in_query(pi_query_id IN nm_mrg_query.nmq_id%TYPE
                          ) RETURN boolean IS
BEGIN
   RETURN nm3mrg_supplementary.defaults_in_query(pi_query_id);
--
END defaults_in_query;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE add_defaults (pi_query_id IN nm_mrg_query.nmq_id%TYPE) IS
--
BEGIN
--
   nm3mrg_supplementary.add_defaults (pi_query_id);
--
END add_defaults;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE refresh_defaults (pi_query_id IN nm_mrg_query.nmq_id%TYPE) IS
--
BEGIN
--
   nm3mrg_supplementary.refresh_defaults (pi_query_id);
--
END refresh_defaults;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE refresh_all_defaults IS
BEGIN
--
   nm3mrg_supplementary.refresh_all_defaults;
--
END refresh_all_defaults;
--
------------------------------------------------------------------------------------------------
--
FUNCTION select_mrg_query (pi_query_id IN nm_mrg_query.nmq_id%TYPE) RETURN nm_mrg_query%ROWTYPE IS
--
BEGIN
--
   RETURN nm3mrg_supplementary.select_mrg_query(pi_query_id);
--
END select_mrg_query;
--
------------------------------------------------------------------------------------------------
--
FUNCTION count_query_results (p_nmq_id IN number) RETURN number IS
BEGIN
--
   RETURN nm3mrg_supplementary.count_query_results(p_nmq_id);
--
END count_query_results;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE delete_query_results (p_nmq_id IN number) IS
BEGIN
--
   nm3mrg_supplementary.delete_query_results(p_nmq_id);
--
END delete_query_results;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_on_poe_and_route(pi_nte_job_id IN nm_members.nm_ne_id_in%TYPE
                                ,pi_job_id     IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                ) IS
--
   l_pl_arr nm_placement_array;
--
   CURSOR cs_ones_to_split (p_job_id number) IS
   SELECT nsm_mrg_section_id
    FROM  nm_mrg_section_members
   WHERE  nsm_mrg_job_id = p_job_id
   GROUP BY nsm_mrg_section_id
   HAVING COUNT(*) > 1;
--
   l_tab_mrg_section_id nm3type.tab_number;
--
   CURSOR cs_section_members (p_job_id     number
                             ,p_section_id number
                             ) IS
   SELECT *
    FROM  nm_mrg_section_members
   WHERE  nsm_mrg_job_id     = p_job_id
    AND   nsm_mrg_section_id = p_section_id
   ORDER BY nsm_measure;
--
   l_prior_route_id number;
--
   l_change         nm3type.tab_number;
--
   l_rec_nms nm_mrg_sections%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'split_on_poe_and_route');
--
--
   IF NOT (g_poe_split OR g_route_split)
    THEN
      -- if we are not splitting the results on either POE
      --  or route then bail out of this procedure
      RETURN;
   END IF;
--
   OPEN  cs_ones_to_split (pi_job_id);
   FETCH cs_ones_to_split BULK COLLECT INTO l_tab_mrg_section_id;
   CLOSE cs_ones_to_split;
--
   FOR i IN 1..l_tab_mrg_section_id.COUNT
    LOOP
      --
      -- This cursor returns all MRG_SECTIONS for the current job which
      --  have more than 1 MRG_SECTION_MEMBERS record
      --
      -- Populate the placement array with all of the section members for this
      --  section
      l_pl_arr := nm3pla.initialise_placement_array;
      l_change.DELETE;
      --
      FOR cs_inner_rec IN cs_section_members (pi_job_id, l_tab_mrg_section_id(i))
       LOOP
         nm3pla.add_element_to_pl_arr (l_pl_arr
                                      ,cs_inner_rec.nsm_ne_id
                                      ,cs_inner_rec.nsm_begin_mp
                                      ,cs_inner_rec.nsm_end_mp
                                      ,cs_inner_rec.nsm_measure
                                      ,FALSE
                                      );
      END LOOP;
--
      l_prior_route_id := get_parent_ne_id_from_temp (l_pl_arr.npa_placement_array(1).pl_ne_id);
--
--   #########################################################
--
--    Work out all of the points at which this SECTION needs splitting
--
--   #########################################################
--
      FOR l_count IN 2..l_pl_arr.npa_placement_array.COUNT
       LOOP
         DECLARE
           l_pl_prior    nm_placement := l_pl_arr.npa_placement_array(l_count-1);
           l_pl          nm_placement := l_pl_arr.npa_placement_array(l_count);
           l_route_ne_id number;
         BEGIN
           l_route_ne_id := get_parent_ne_id_from_temp(l_pl.pl_ne_id);
           IF   g_route_split
            AND l_route_ne_id <> l_prior_route_id
            THEN
              -- Change of route throw a change
              l_prior_route_id           := l_route_ne_id;
              l_change(l_change.COUNT+1) := l_count;
           ELSE
             -- This is on the same route so check for POE
             IF g_poe_split
              THEN
                IF nm3net.is_node_poe (l_route_ne_id, l_pl_prior.pl_ne_id, l_pl.pl_ne_id)
                 THEN
                   -- There is a POE so throw a change
                   l_change(l_change.COUNT+1) := l_count;
                END IF;
             END IF;
           END IF;
         END;
      END LOOP;
--
-- ################################################################
--
--  We've established that it needs splitting, so split it
--
-- ################################################################
--
      IF l_change.COUNT > 0
       THEN
         -- If there are some splits required in this MRG_SECTION
         --
         --
         l_rec_nms := get_mrg_section (pi_job_id, l_tab_mrg_section_id(i));
         l_rec_nms.nms_orig_sect_id := l_tab_mrg_section_id(i);
         --
         DECLARE
            l_mrg_section_id   number;
            l_new_pl           nm_placement_array;
            l_remaining_pl_arr nm_placement_array := l_pl_arr;
            --
            l_first_pl         nm_placement;
            l_last_pl          nm_placement;
            --
         BEGIN
            -- Split the placment array up, reseetting the measures to zero at the
            --  required points
            FOR l_count IN 1..l_change.COUNT
             LOOP
               nm3pla.split_placement_array
                               (l_remaining_pl_arr
                               ,l_pl_arr.npa_placement_array(l_change(l_count)).pl_ne_id
                               ,l_pl_arr.npa_placement_array(l_change(l_count)).pl_start
                               ,l_new_pl
                               ,l_remaining_pl_arr
                               ,FALSE
                               );
               --
               -- Add details for all of the rows in l_new_pl
               --
               IF NOT l_new_pl.is_empty
                THEN
                  --
                  l_first_pl := l_new_pl.npa_placement_array(1);
                  l_last_pl  := l_new_pl.npa_placement_array(l_new_pl.npa_placement_array.COUNT);
                  --
                  l_rec_nms.nms_mrg_section_id := get_nm_mrg_query_staging_seq;
                  l_rec_nms.nms_ne_id_first    := l_first_pl.pl_ne_id;
                  l_rec_nms.nms_begin_mp_first := l_first_pl.pl_start;
                  l_rec_nms.nms_ne_id_last     := l_last_pl.pl_ne_id;
                  l_rec_nms.nms_end_mp_last    := l_last_pl.pl_end;
                  --
                  -- insert the new NM_MRG_SECTIONS record
                  --
                  nm3mrg_supplementary.ins_nm_mrg_sections
                              (pi_job_id         => l_rec_nms.nms_mrg_job_id
                              ,pi_mrg_section_id => l_rec_nms.nms_mrg_section_id
                              ,pi_nte_job_id     => l_rec_nms.nms_offset_ne_id
                              ,pi_ne_id_first    => l_rec_nms.nms_ne_id_first
                              ,pi_begin_mp_first => l_rec_nms.nms_begin_mp_first
                              ,pi_ne_id_last     => l_rec_nms.nms_ne_id_last
                              ,pi_end_mp_last    => l_rec_nms.nms_end_mp_last
                              ,pi_orig_sect_id   => l_rec_nms.nms_orig_sect_id
                              ,pi_in_results     => 'Y' -- This one is in the results
                              );
                  --
                  -- insert the new NM_MRG_SECTION_MEMBERS records
                  --
                  nm3mrg_supplementary.ins_nm_mrg_section_members
                         (pi_mrg_job_id     => pi_job_id
                         ,pi_mrg_section_id => l_rec_nms.nms_mrg_section_id
                         ,pi_pl_arr         => l_new_pl
                         );
                  --
                  -- insert the new NM_MRG_SECTION_MEMBER_INV records
                  --
                  INSERT INTO nm_mrg_section_member_inv
                         (nsi_mrg_job_id
                         ,nsi_mrg_section_id
                         ,nsi_inv_type
                         ,nsi_x_sect
                         ,nsi_value_id
                         )
                  SELECT  nsi_mrg_job_id
                         ,l_rec_nms.nms_mrg_section_id
                         ,nsi_inv_type
                         ,nsi_x_sect
                         ,nsi_value_id
                   FROM  nm_mrg_section_member_inv
                   WHERE nsi_mrg_job_id     = l_rec_nms.nms_mrg_job_id
                    AND  nsi_mrg_section_id = l_rec_nms.nms_orig_sect_id;
                  --
               END IF;
            END LOOP;
            --
            -- DO the bit left at the end
            --
            IF NOT l_remaining_pl_arr.is_empty
             THEN
               -- otherwise update the original section to reflect it's new members
               l_first_pl := l_remaining_pl_arr.npa_placement_array(1);
               l_last_pl  := l_remaining_pl_arr.npa_placement_array(l_remaining_pl_arr.npa_placement_array.COUNT);
               --
               -- Create a new one to take care of any bits left at the end
               --
               l_rec_nms.nms_mrg_section_id := get_nm_mrg_query_staging_seq;
               l_rec_nms.nms_ne_id_first    := l_first_pl.pl_ne_id;
               l_rec_nms.nms_begin_mp_first := l_first_pl.pl_start;
               l_rec_nms.nms_ne_id_last     := l_last_pl.pl_ne_id;
               l_rec_nms.nms_end_mp_last    := l_last_pl.pl_end;
               --
               -- insert the new NM_MRG_SECTIONS record
               --
               nm3mrg_supplementary.ins_nm_mrg_sections
                           (pi_job_id         => l_rec_nms.nms_mrg_job_id
                           ,pi_mrg_section_id => l_rec_nms.nms_mrg_section_id
                           ,pi_nte_job_id     => l_rec_nms.nms_offset_ne_id
                           ,pi_ne_id_first    => l_rec_nms.nms_ne_id_first
                           ,pi_begin_mp_first => l_rec_nms.nms_begin_mp_first
                           ,pi_ne_id_last     => l_rec_nms.nms_ne_id_last
                           ,pi_end_mp_last    => l_rec_nms.nms_end_mp_last
                           ,pi_orig_sect_id   => l_rec_nms.nms_orig_sect_id
                           ,pi_in_results     => 'Y' -- This one is in the results
                           );
               --
               -- insert the new NM_MRG_SECTION_MEMBERS records
               --
               nm3mrg_supplementary.ins_nm_mrg_section_members
                      (pi_mrg_job_id     => pi_job_id
                      ,pi_mrg_section_id => l_rec_nms.nms_mrg_section_id
                      ,pi_pl_arr         => l_remaining_pl_arr
                      );
               --
               -- insert the new NM_MRG_SECTION_MEMBER_INV records
               --
               INSERT INTO nm_mrg_section_member_inv
                      (nsi_mrg_job_id
                      ,nsi_mrg_section_id
                      ,nsi_inv_type
                      ,nsi_x_sect
                      ,nsi_value_id
                      )
               SELECT  nsi_mrg_job_id
                      ,l_rec_nms.nms_mrg_section_id
                      ,nsi_inv_type
                      ,nsi_x_sect
                      ,nsi_value_id
                FROM  nm_mrg_section_member_inv
                WHERE nsi_mrg_job_id     = l_rec_nms.nms_mrg_job_id
                 AND  nsi_mrg_section_id = l_rec_nms.nms_orig_sect_id;
               --
            END IF;
            --
            -- If get rid of the original section
            --
            DELETE FROM nm_mrg_sections
            WHERE  nms_mrg_job_id     = pi_job_id
             AND   nms_mrg_section_id = l_tab_mrg_section_id(i);
--
            g_resequence_reqd := TRUE;
            --
         END;
      END IF;
--
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'split_on_poe_and_route');
--
END split_on_poe_and_route;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_mrg_section (p_mrg_job_id     IN nm_mrg_sections.nms_mrg_job_id%TYPE
                         ,p_mrg_section_id IN nm_mrg_sections.nms_mrg_section_id%TYPE
                         ) RETURN nm_mrg_sections%ROWTYPE IS
BEGIN
--
   RETURN nm3mrg_supplementary.get_mrg_section (p_mrg_job_id,p_mrg_section_id);
--
END get_mrg_section;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_parent_ne_id_from_temp (p_ne_id IN number) RETURN number IS
BEGIN
--
   RETURN nm3mrg_supplementary.get_parent_ne_id_from_temp (p_ne_id);
--
END get_parent_ne_id_from_temp;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE create_remove_transient_job (p_first_run date     DEFAULT TRUNC(SYSDATE+1)
                                      ,p_next_run  varchar2 DEFAULT 'trunc(sysdate)+1'
                                      ) IS
BEGIN
--
   nm3mrg_supplementary.create_remove_transient_job (p_first_run,p_next_run);
--
END create_remove_transient_job;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE remove_transient_results IS
BEGIN
--
   nm3mrg_supplementary.remove_transient_results;
--
END remove_transient_results;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_nmq_id_from_unique (p_nmq_unique nm_mrg_query.nmq_unique%TYPE
                                ) RETURN nm_mrg_query.nmq_id%TYPE IS
BEGIN
--
   RETURN nm3mrg_supplementary.get_nmq_id_from_unique (p_nmq_unique);
--
END get_nmq_id_from_unique;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_results_by_value_id (pi_nmq_id        IN     nm_mrg_query_results.nqr_nmq_id%TYPE
                                  ,pi_job_id        IN     nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                  ,pi_value_id      IN     nm_mrg_section_inv_values.nsv_value_id%TYPE
                                  ,po_tab_scrn_text    OUT nm3type.tab_varchar2000
                                  ,po_tab_value        OUT nm3type.tab_varchar2000
                                  ) IS
BEGIN
--  Logic removed from here into supplementary package to keep package size down
    nm3mrg_supplementary.get_results_by_value_id(pi_nmq_id,pi_job_id,pi_value_id,po_tab_scrn_text,po_tab_value);
--
END get_results_by_value_id;
--
------------------------------------------------------------------------------------------------
--
FUNCTION select_nqr (pi_job_id IN nm_mrg_query_results.nqr_mrg_job_id%TYPE) RETURN nm_mrg_query_results%ROWTYPE IS
BEGIN
--  Logic removed from here into supplementary package to keep package size down
   RETURN nm3mrg_supplementary.select_nqr(pi_job_id);
--
END select_nqr;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_invalid_mrg_qry_defaults RETURN nm3type.tab_number IS
BEGIN
--  Logic removed from here into supplementary package to keep package size down
   RETURN nm3mrg_supplementary.get_invalid_mrg_qry_defaults;
--
END get_invalid_mrg_qry_defaults;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_ndq(pi_ndq_seq_no IN nm_mrg_default_query_types.ndq_seq_no%TYPE
                ) RETURN nm_mrg_default_query_types%ROWTYPE IS
BEGIN
--  Logic removed from here into supplementary package to keep package size down
   RETURN nm3mrg_supplementary.get_ndq(pi_ndq_seq_no);
--
END get_ndq;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_ita_for_mrg (p_inv_type VARCHAR2, p_attrib VARCHAR2) RETURN nm_inv_type_attribs%ROWTYPE IS
   l_rec_ita nm_inv_type_attribs%ROWTYPE;
BEGIN
   --
   l_rec_ita := nm3inv.get_inv_type_attr (p_inv_type
                                         ,p_attrib
                                         );
   --
   IF l_rec_ita.ita_inv_type IS NULL
    THEN
      DECLARE
         l_rec_nit nm_inv_types%ROWTYPE;
         l_rec_atc all_tab_columns%ROWTYPE;
      BEGIN
         l_rec_nit := nm3get.get_nit (pi_nit_inv_type => p_inv_type);
         l_rec_ita.ita_inv_type       := p_inv_type;
         l_rec_ita.ita_attrib_name    := p_attrib;
         l_rec_nit.nit_table_name     := NVL(l_rec_nit.nit_table_name,'NM_INV_ITEMS_ALL');
         l_rec_atc                    := nm3ddl.get_column_details (p_attrib
                                                                   ,l_rec_nit.nit_table_name
                                                                   );
         l_rec_ita.ita_format         := l_rec_atc.data_type;
         l_rec_ita.ita_fld_length     := l_rec_atc.data_length;
         l_rec_ita.ita_view_col_name  := p_attrib;
         IF SUBSTR(p_attrib,1,3) = 'IIT'
          THEN
             l_rec_ita.ita_view_attri := SUBSTR(p_attrib,5);
         ELSE
             l_rec_ita.ita_view_attri := p_attrib;
         END IF;
         IF l_rec_ita.ita_format = nm3type.c_date
          THEN
            IF  l_rec_ita.ita_attrib_name LIKE '%DATE_CREATED'
             OR l_rec_ita.ita_attrib_name LIKE '%DATE_MODIFIED'
             THEN
               l_rec_ita.ita_format_mask := nm3type.c_full_Date_time_format;
            ELSE
               l_rec_ita.ita_format_mask := Sys_Context('NM3CORE','USER_DATE_MASK');
            END IF;
         END IF;
      END;
   END IF;
   RETURN l_rec_ita;
--
END get_ita_for_mrg;
--
------------------------------------------------------------------------------------------------
--
BEGIN
--
   g_tab_pbi_conditions(1)        := '<';
   g_tab_pbi_cond_values_reqd(1)  := 1;
--
   g_tab_pbi_conditions(2)        := '<=';
   g_tab_pbi_cond_values_reqd(2)  := 1;
--
   g_tab_pbi_conditions(3)        := '=';
   g_tab_pbi_cond_values_reqd(3)  := 1;
--
   g_tab_pbi_conditions(4)        := '>';
   g_tab_pbi_cond_values_reqd(4)  := 1;
--
   g_tab_pbi_conditions(5)        := '>=';
   g_tab_pbi_cond_values_reqd(5)  := 1;
--
   g_tab_pbi_conditions(6)        := 'BETWEEN';
   g_tab_pbi_cond_values_reqd(6)  := 2;
--
   g_tab_pbi_conditions(7)        := 'IN';
   g_tab_pbi_cond_values_reqd(7)  := NULL; -- Allowed any number of values (>0)
--
   g_tab_pbi_conditions(8)        := 'IS NOT NULL';
   g_tab_pbi_cond_values_reqd(8)  := 0;
--
   g_tab_pbi_conditions(9)        := 'IS NULL';
   g_tab_pbi_cond_values_reqd(9)  := 0;
--
   g_tab_pbi_conditions(10)       := 'LIKE';
   g_tab_pbi_cond_values_reqd(10) := 1;
--
   g_tab_pbi_conditions(11)       := 'NOT IN';
   g_tab_pbi_cond_values_reqd(11) := NULL; -- Allowed any number of values (>0)
--
   g_tab_pbi_conditions(12)       := 'NOT LIKE';
   g_tab_pbi_cond_values_reqd(12) := 1;
--
   g_tab_pbi_conditions(13)       := 'NOT BETWEEN';
   g_tab_pbi_cond_values_reqd(13) := 2;
--
   g_tab_pbi_conditions(14)       := '<>';
   g_tab_pbi_cond_values_reqd(14) := 1;
--
   g_tab_pbi_conditions(15)       := '!=';
   g_tab_pbi_cond_values_reqd(15) := 1;
--
END nm3mrg;
/
