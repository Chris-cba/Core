CREATE OR REPLACE PACKAGE BODY nm3asset AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3asset.pkb-arc   2.23   Jun 15 2011 17:54:54   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3asset.pkb  $
--       Date into PVCS   : $Date:   Jun 15 2011 17:54:54  $
--       Date fetched Out : $Modtime:   Jun 15 2011 17:48:26  $
--       PVCS Version     : $Revision:   2.23  $
--
--
--   Author : Rob Coupe
--
--   Assets package
-- nm3inv
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.23  $"';
   g_gos_ne_id                    nm_members_all.nm_ne_id_in%type ;
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3asset';
--
   g_nar_datum_unit nm_units.un_unit_id%TYPE;
   g_maximum_mp     number;
--
   c_always_show_inv_pk        CONSTANT boolean := hig.get_user_or_sys_opt('SHOWINVPK') = 'Y';
   c_calculate_overlapping_inv CONSTANT boolean := hig.get_sysopt('AOREXTDINV') = 'Y';
--
   g_tab_flx_lock_col         nm3type.tab_varchar30;
   g_tab_flx_lock_value       nm3type.tab_varchar4000;
   g_tab_flx_lock_value_new   nm3type.tab_varchar4000;
   g_tab_flx_lock_datatype    nm3type.tab_varchar30;
   g_tab_flx_lock_format_mask nm3type.tab_varchar4000;
--
   -- This is used when adding "extra" bits onto the inventory
   --  for adjoining parts of the same item which overlap the
   --  specified area of interest
   g_tab_nte_entire_route     nm3extent.tab_nte;
   c_begin             CONSTANT varchar2(5) := 'begin';
   c_end               CONSTANT varchar2(3) := 'end';
   c_asterisk  CONSTANT  varchar2(1)  := '*';

   c_attr_list_sep hig_option_values.hov_value%TYPE := hig.get_user_or_sys_opt(pi_option => 'ATTRLSTSEP');
   
   
--
-----------------------------------------------------------------------------
--
PROCEDURE process_tab_ngqi (p_narh_job_id  nm_assets_on_route_holding.narh_job_id%TYPE
                           ,p_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE
                           ,p_tab_rec_ngqi nm3gaz_qry.tab_rec_ngqi
                           );
--
-----------------------------------------------------------------------------
--
PROCEDURE process_each_ngqi (p_narh_job_id  nm_assets_on_route_holding.narh_job_id%TYPE
                            ,p_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE
                            ,p_rec_ngqi     nm_gaz_query_item_list%ROWTYPE
                            );
--
-----------------------------------------------------------------------------
--
FUNCTION are_these_connected (p_ne_id_prior   number
                             ,p_end_mp_prior  number
                             ,p_ne_id_next    number
                             ,p_begin_mp_next number
                             ) RETURN boolean;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_reference_item_exists (pi_reference_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                                      ,pi_reference_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                                      ,pi_reference_item_id        nm_assets_on_route_holding.narh_ne_id_in%TYPE
                                      ,pi_tab_rec_ngqi             nm3gaz_qry.tab_rec_ngqi
                                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE set_reference_item_measures (pi_narh_job_id                nm_assets_on_route_holding.narh_job_id%TYPE
                                      ,pi_reference_item_type_type   nm_gaz_query_types.ngqt_item_type_type%TYPE
                                      ,pi_reference_item_type        nm_gaz_query_types.ngqt_item_type%TYPE
                                      ,pi_reference_item_id          nm_assets_on_route_holding.narh_ne_id_in%TYPE
                                      ,pi_ref_negatively_until_found boolean
                                      );
--
-----------------------------------------------------------------------------
--
FUNCTION get_rescale_write (pi_ne_id nm_rescale_write.ne_id%TYPE
                           ,pi_mp    nm_rescale_write.nm_begin_mp%TYPE
                           ) RETURN nm_rescale_write%ROWTYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION get_measure_from_rec_nrw (pi_rec_nrw nm_rescale_write%ROWTYPE
                                  ,pi_mp      nm_rescale_write.nm_begin_mp%TYPE
                                  ) RETURN nm_rescale_write.nm_true%TYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION get_measure_from_rescale_write (pi_ne_id nm_rescale_write.ne_id%TYPE
                                        ,pi_mp    nm_rescale_write.nm_begin_mp%TYPE
                                        ) RETURN nm_rescale_write.nm_true%TYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION are_segments_connected (pi_seg_no_1 nm_rescale_write.nm_seg_no%TYPE
                                ,pi_seg_no_2 nm_rescale_write.nm_seg_no%TYPE
                                ) RETURN boolean;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_rescale_write_for_duals;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_ref_item (pi_ngq_id                     IN     nm_gaz_query.ngq_id%TYPE
                       ,pi_reference_item_type_type   IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                       ,pi_reference_item_type        IN     nm_gaz_query_types.ngqt_item_type%TYPE
                       ,pi_reference_item_id          IN     nm_assets_on_route_holding.narh_ne_id_in%TYPE
                       );
--
-----------------------------------------------------------------------------
--
FUNCTION get_foreign_placement_array (pi_iit_ne_id    IN nm_inv_items.iit_ne_id%TYPE
                                     ,pi_nit_inv_type IN nm_inv_types.nit_inv_type%TYPE
                                     ,pi_pref_lrm     IN nm_members.nm_obj_type%TYPE
                                     ) RETURN nm_placement_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE convert_units_to_specified (pi_narh_job_id         IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                     ,pi_required_un_unit_id IN     nm_units.un_unit_id%TYPE
                                     ,po_output_un_unit_id   IN OUT nm_units.un_unit_id%TYPE
                                     );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_route_beg_mp_to_pl_meas (pi_narh_job_id       nm_assets_on_route_holding.narh_job_id%TYPE
                                         ,pi_ngq_id            nm_gaz_query.ngq_id%TYPE
                                         ,pi_output_un_unit_id nm_units.un_unit_id%TYPE
                                         );
--
-----------------------------------------------------------------------------
--
PROCEDURE add_rest_of_chunk_of_cont_item (pi_narh_job_id       nm_assets_on_route_holding.narh_job_id%TYPE
                                         ,pi_ngq_id            nm_gaz_query.ngq_id%TYPE
                                         ,pi_output_un_unit_id nm_units.un_unit_id%TYPE
                                         );
--
-----------------------------------------------------------------------------
--
PROCEDURE sort_out_rest_for_begin_or_end (pi_narh_job_id       nm_assets_on_route_holding.narh_job_id%TYPE
                                         ,pi_source_id         nm_gaz_query.ngq_source_id%TYPE
                                         ,pi_measure           number
                                         ,pi_begin_or_end      varchar2
                                         );
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
FUNCTION is_linear ( pi_ne_id IN nm_elements.ne_id%TYPE )
RETURN BOOLEAN
IS
  l_rec_ne  nm_elements%ROWTYPE := nm3get.get_ne(pi_ne_id => pi_ne_id, pi_raise_not_found=>FALSE);
  l_dummy   NUMBER;
BEGIN
  IF l_rec_ne.ne_id IS NOT NULL
  THEN
    SELECT COUNT(*) INTO l_dummy FROM nm_linear_types
      WHERE nlt_nt_type = l_rec_ne.ne_nt_type
        AND NVL(nlt_gty_type,nm3type.c_nvl) = NVL(l_rec_ne.ne_gty_group_type,NVL(nlt_gty_type,nm3type.c_nvl));
  --
    RETURN (l_dummy>0);
  ELSE
    RETURN FALSE;
  END IF;
END is_linear;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_nar_references IS

CURSOR c1 IS
   SELECT nar.nar_asset_pk, nar.nar_asset_measure, nar.nar_type,
          nar.nar_route_true, nar.nar_asset_ne_id,
          nar.nar_route_seg_no
  FROM nm_assets_on_route nar
  ORDER BY nar.nar_asset_measure, nar.nar_type DESC
  FOR UPDATE OF nar_asset_pk ;

  l_ref_asset_measure number;
  l_ref_asset         number;
  l_ref_asset_pk      nm_inv_items.iit_primary_key%TYPE;
  l_ref_measure       number;
  l_ref_seg_no        number;
  l_ref_found         boolean := FALSE;
BEGIN
  FOR irec IN c1 LOOP
    IF irec.nar_type = 'R' THEN
   l_ref_asset_measure := irec.nar_asset_measure;
   l_ref_asset         := irec.nar_asset_ne_id;
   l_ref_seg_no        := irec.nar_route_seg_no;
   l_ref_asset_pk      := irec.nar_asset_pk;
   l_ref_found := TRUE;

    END IF;
--
--  Need to set the ference of the post to itself
--
    IF l_ref_found AND l_ref_seg_no = irec.nar_route_seg_no THEN
   l_ref_measure := irec.nar_asset_measure - l_ref_asset_measure;
   UPDATE nm_assets_on_route
   SET nar_ref_post    = l_ref_asset,
       nar_ref_measure = l_ref_measure,
       nar_ref_pk      = l_ref_asset_pk
   WHERE CURRENT OF c1;
 END IF;
  END LOOP;
END set_nar_references;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nar_data( pi_route_id IN nm_elements.ne_id%TYPE,
                           pi_ref_type IN nm_inv_types.nit_inv_type%TYPE ) IS


l_route_unit nm_units.un_unit_id%TYPE;

BEGIN
  g_nar_datum_unit := nm3net.get_nt_units(nm3net.get_datum_nt(pi_ne_id => pi_route_id));
  l_route_unit     := nm3net.get_nt_units(nm3net.get_nt_type( p_ne_id => pi_route_id ));

  DELETE nm_assets_on_route;

  INSERT INTO nm_assets_on_route
    (  nar_route_ne_id
      ,nar_route_seq_no
      ,nar_route_seg_no
      ,nar_element_ne_id
      ,nar_element_descr
      ,nar_element_unique
      ,nar_asset_ne_id
      ,nar_asset_begin_mp
      ,nar_asset_end_mp
      ,nar_route_slk
      ,nar_route_true
      ,nar_asset_type
      ,nar_asset_measure
      ,nar_asset_type_descr
      ,nar_asset_pk
      ,nar_located_by
      ,nar_located_pk
      ,nar_located_type
      ,nar_loc_type_descr
      ,nar_type
      ,nar_ref_post
      ,nar_ref_pk
      ,nar_ref_measure   )
  SELECT   r.nm_ne_id_in, r.nm_seq_no, r.nm_seg_no, r.nm_ne_id_of, e.ne_descr, e.ne_unique,
           l1.nm_ne_id_in, l1.nm_begin_mp, NVL( l1.nm_end_mp, e.ne_length), r.nm_slk, r.nm_true,
           i1.iit_inv_type,
    nm3unit.convert_unit (l_route_unit, g_nar_datum_unit, NVL(r.nm_true,r.nm_slk))
         + DECODE( r.nm_cardinality, 1, (l1.nm_begin_mp - r.nm_begin_mp),
                                 -1, (NVL( r.nm_end_mp, e.ne_length) - l1.nm_end_mp)),
           it.nit_descr,
           i1.iit_primary_key, i1.iit_located_by, NULL, NULL, NULL,
           DECODE( l1.nm_obj_type, pi_ref_type, 'R', 'A' ),
           NULL, NULL, NULL
  FROM nm_members r, nm_members l1, nm_inv_items i1, nm_elements e, nm_inv_types it
  WHERE r.nm_ne_id_of = l1.nm_ne_id_of
  AND r.nm_ne_id_in = pi_route_id
  AND r.nm_ne_id_of = e.ne_id
  AND ((l1.nm_begin_mp <= NVL(r.nm_end_mp, l1.nm_begin_mp )
        AND
        NVL(l1.nm_end_mp, r.nm_begin_mp ) >= r.nm_begin_mp)
      OR
       (l1.nm_begin_mp = l1.nm_end_mp
        AND
        l1.nm_end_mp BETWEEN r.nm_begin_mp AND NVL(r.nm_end_mp, l1.nm_begin_mp)))
  AND i1.iit_inv_type = it.nit_inv_type
  AND i1.iit_ne_id = l1.nm_ne_id_in;

--Now create the asset reference data

  set_nar_references;

END create_nar_data;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nar_datum_unit RETURN nm_units.un_unit_id%TYPE IS
BEGIN
  RETURN g_nar_datum_unit;
END get_nar_datum_unit;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_asset_on_route_data (pi_ngq_id                     IN     nm_gaz_query.ngq_id%TYPE
                                     ,pi_effective_date             IN     date                                          DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                     ,pi_reference_item_type_type   IN     nm_gaz_query_types.ngqt_item_type_type%TYPE   DEFAULT NULL
                                     ,pi_reference_item_type        IN     nm_gaz_query_types.ngqt_item_type%TYPE        DEFAULT NULL
                                     ,pi_reference_item_id          IN     nm_assets_on_route_holding.narh_ne_id_in%TYPE DEFAULT NULL
                                     ,pi_ref_negatively_until_found IN     boolean                                       DEFAULT TRUE
                                     ,pi_reference_units            IN     nm_units.un_unit_id%TYPE                      DEFAULT NULL
                                     ,po_return_arguments              OUT rec_aor_return_args
                                     ) IS
--
   c_init_eff_date CONSTANT date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_ngqi_job_id  nm_gaz_query_item_list.ngqi_job_id%TYPE;
   l_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE;
   l_tab_rec_ngqi nm3gaz_qry.tab_rec_ngqi;
   l_first_ne     nm_elements.ne_id%type ;
   --Log 713423:Linesh:05-Mar-2009:Start
   l_rec_ngq      nm_gaz_query%ROWTYPE; 
   l_net_unit     nm_units.un_unit_id%TYPE ;
   CURSOR c_get_unit (qp_ngq_source_id nm_gaz_query.ngq_source_id%TYPE)
   IS
   SELECT nt_length_unit    
   FROM   nm_elements
         ,nm_types
   WHERE  ne_id = qp_ngq_source_id 
   AND    ne_nt_type   = nt_type ;
   --Log 713423:Linesh:05-Mar-2009:End

--
BEGIN
--

   nm_debug.proc_start (g_package_name,'create_asset_on_route_data');
--
   -- AE Task 0108227   
   -- Prevent AoaR being run on Group of Groups
   DECLARE
     l_ne_id  nm_elements.ne_id%TYPE;
     l_rec_ne nm_elements%ROWTYPE;
   BEGIN
     l_ne_id := nm3get.get_ngq(pi_ngq_id => pi_ngq_id, pi_raise_not_found => FALSE ).ngq_source_id;
   --
     IF l_ne_id IS NOT NULL
     THEN
       l_rec_ne := nm3get.get_ne_all (pi_ne_id           => l_ne_id
                                     ,pi_raise_not_found => FALSE );
       IF l_rec_ne.ne_id IS NOT NULL
       THEN
         IF l_rec_ne.ne_type =  'P'
         THEN
           hig.raise_ner ('NET',51);
         END IF;
       END IF;
     END IF;
   END;

   nm3user.set_effective_date(pi_effective_date);
   g_maximum_mp := 0;
--

   -- Make sure we are not allowing elements
   nm3gaz_qry.disallow_ele_item_type_type;
   
--
   -- Add the reference item/ref item type to the gaz query if necessary
   add_ref_item (pi_ngq_id                   => pi_ngq_id
                ,pi_reference_item_type_type => pi_reference_item_type_type
                ,pi_reference_item_type      => pi_reference_item_type
                ,pi_reference_item_id        => pi_reference_item_id
                );

--
   -- Execute the gazeteer query. This will return a list of items which meet the
   --  criteria which exist in the specified area
   --
--   nm_debug.debug('nm3gaz_qry.perform_query');
   l_ngqi_job_id := nm3gaz_qry.perform_query (pi_ngq_id         => pi_ngq_id
                                             ,pi_effective_date => pi_effective_date
                                             );

--
   -- Get the temp extent which gaz qry has just created
   l_nte_job_id   := nm3gaz_qry.get_g_nte_job_id;
--
   -- get the unit id for these datums and check to make sure there is only 1
   po_return_arguments.un_unit_id_datum := nm3extent.get_nte_unit_id(l_nte_job_id);
--
   po_return_arguments.narh_job_id := next_narh_job_id_seq;
--

   -- Get all of the items which have been found
--   nm_debug.debug('nm3gaz_qry.get_tab_rec_ngqi');

   l_tab_rec_ngqi := nm3gaz_qry.get_tab_rec_ngqi (p_ngqi_id => l_ngqi_job_id);
--
   IF l_tab_rec_ngqi.COUNT = 0
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 318
                    );
   END IF;
   
--
--   nm_debug.debug('check_reference_item_exists');
   check_reference_item_exists (pi_reference_item_type_type => pi_reference_item_type_type
                               ,pi_reference_item_type      => pi_reference_item_type
                               ,pi_reference_item_id        => pi_reference_item_id
                               ,pi_tab_rec_ngqi             => l_tab_rec_ngqi
                               );


   --
   --nm3extent.debug_temp_extents (l_nte_job_id);

   -- Rescale the temp ne
   DECLARE
     c_circ_ex_num      constant INTEGER := -20207 ;
     l_original_message          VARCHAR(2000) ;
     l_circular_ex      exception ;
     l_ne_id            nm_elements.ne_id%TYPE;
     l_rec_ne           nm_elements%ROWTYPE;
     PRAGMA EXCEPTION_INIT( l_circular_ex, -20207 );
   BEGIN
   -- AE 15 - JAN - 2008
   --
   -- Set the global to prevent circular route issues when this code falls into the exception
   -- Make sure we only do this on a Linear Group of Sections
   --
   -- Get the Gaz Query source NE_ID
     l_ne_id := nm3get.get_ngq(pi_ngq_id => pi_ngq_id, pi_raise_not_found => FALSE ).ngq_source_id;
   --
     IF l_ne_id IS NOT NULL
     THEN
     -- Get a rowtype of the element (if it is an element)
       l_rec_ne := nm3get.get_ne ( pi_ne_id           => l_ne_id
                                ,  pi_raise_not_found => FALSE);
     --
       IF l_rec_ne.ne_id IS NOT NULL
       THEN
         -- Make sure the element is a Group of Sections, and is Linear
         IF l_rec_ne.ne_type = 'G'
         AND nm3get.get_nlt ( pi_nlt_nt_type     => l_rec_ne.ne_nt_type
                            , pi_nlt_gty_type    => l_rec_ne.ne_gty_group_type
                            , pi_raise_not_found => FALSE).nlt_id 
           IS NOT NULL
         THEN
        -- Set the global GOS ne_id so that it's used in the circular route exception
           g_gos_ne_id := l_ne_id;
       --
         END IF;
       --
       END IF;
     --
     END IF;
     -- AE 15 - JAN - 2008
     -- end of changes

--     nm_debug.debug('Pre-rescale');
     nm3rsc.rescale_temp_ne(l_nte_job_id);
--     nm_debug.debug('Post-rescale');
   EXCEPTION
     WHEN l_circular_ex
     THEN
       l_original_message := SUBSTR(SQLERRM,1,2000) ;
       IF g_gos_ne_id is not null
       THEN
       BEGIN
         SELECT DISTINCT(nm_ne_id_of)
           INTO l_first_ne
           -- AE 15-JAN-2009
           -- Make sure we only look at live members!
           --FROM nm_members_all m1
           FROM nm_members m1
          WHERE nm_ne_id_in = g_gos_ne_id
          AND NOT EXISTS
         ( SELECT 1
             FROM nm_members m2
            WHERE nm_ne_id_in = g_gos_ne_id
              AND m2.nm_seq_no < m1.nm_seq_no
          )
          AND ROWNUM = 1
         ;
         IF l_first_ne IS NOT NULL
         THEN
--           nm_debug.debug('Pre-rescale 2');
           nm3rsc.rescale_temp_ne(l_nte_job_id,NULL,l_first_ne);
--           nm_debug.debug('Post-rescale 2');
         ELSE
           RAISE ;
         END IF;
       EXCEPTION
         WHEN OTHERS
         THEN
           l_original_message := SUBSTR(l_original_message,
                                        INSTR(l_original_message,TO_CHAR(c_circ_ex_num) || ':')+6) ;
           l_original_message := LTRIM(l_original_message);
           raise_application_error(c_circ_ex_num,l_original_message);
       END ;
     ELSE
       RAISE ;
     END IF ;
   END ;
   --nm_debug.debug_on ;
--   nm_debug.debug('point 1');

--
----
--   nm_debug.DEBUG('extent rescaled');
--   FOR cs_rec IN (SELECT * FROM nm_rescale_write ORDER BY nm_seq_no)
--    LOOP
--      nm_debug.DEBUG('NE_ID-'||cs_rec.ne_id
--                     ||':NE_NO_START-'||cs_rec.ne_no_start
--                     ||':NE_NO_END-'||cs_rec.ne_no_end
--                     ||':SLK-'||cs_rec.nm_slk
--                     ||':TRUE-'||cs_rec.nm_true
--                     ||':SEG-'||cs_rec.nm_seg_no
--                     ||':SEQ-'||cs_rec.nm_seq_no
--                     ||':BEGIN-'||cs_rec.nm_begin_mp
--                     ||':END-'||cs_rec.nm_end_mp
--                    );
--   END LOOP;
----
   -- Make sure there is only a single sub-class we are dealing with
   --  (for the moment) AoR does not deal with dual carriageways
--   nm_debug.debug('check_rescale_write_for_duals');
   check_rescale_write_for_duals;
--   nm_debug.debug('point 2');
--
--   nm_debug.debug('process_tab_ngqi');
   process_tab_ngqi (p_narh_job_id  => po_return_arguments.narh_job_id
                    ,p_nte_job_id   => l_nte_job_id
                    ,p_tab_rec_ngqi => l_tab_rec_ngqi
                    );
--   nm_debug.debug('point 3');
--
   --
   -- If this is being run on only part of a route then make sure we do not
   --  prematurely chop any continuous items
   --
   add_rest_of_chunk_of_cont_item (pi_narh_job_id       => po_return_arguments.narh_job_id
                                  ,pi_ngq_id            => pi_ngq_id
                                  ,pi_output_un_unit_id => po_return_arguments.un_unit_id_datum
                                  );
--   nm_debug.debug('point 4');
   
--
--   nm_debug.debug('set_reference_item_measures');
   set_reference_item_measures (pi_narh_job_id                => po_return_arguments.narh_job_id
                               ,pi_reference_item_type_type   => pi_reference_item_type_type
                               ,pi_reference_item_type        => pi_reference_item_type
                               ,pi_reference_item_id          => pi_reference_item_id
                               ,pi_ref_negatively_until_found => pi_ref_negatively_until_found
                               );
--   nm_debug.debug('point 5');
--
   --
   -- If the gaz query is not being run on the whole of a linear route then add the
   --  begin mp which was stored in the NM_GAZ_QUERY records onto all the measures
   --
   append_route_beg_mp_to_pl_meas (pi_narh_job_id       => po_return_arguments.narh_job_id
                                  ,pi_ngq_id            => pi_ngq_id
                                  ,pi_output_un_unit_id => po_return_arguments.un_unit_id_datum
                                  );
--   nm_debug.debug('point 6');
--
   -- If the data is required to be specified in units other than the datum units
   --  then convert it as appropriate
   convert_units_to_specified (pi_narh_job_id         => po_return_arguments.narh_job_id
                              ,pi_required_un_unit_id => pi_reference_units
                              ,po_output_un_unit_id   => po_return_arguments.un_unit_id_datum
                              );
--
--   nm_debug.debug('point 7');
   po_return_arguments.maximum_placement_mp := g_maximum_mp;
--   nm_debug.debug('point 8');
--
  --Corrected the values of End Reference
  --Log 713423:Linesh:05-Mar-2009:Added
  IF   pi_reference_item_type_type IS NULL
  AND  pi_reference_item_type      IS NULL
  THEN
    l_rec_ngq := nm3get.get_ngq (pi_ngq_id => pi_ngq_id);
  --
    IF l_rec_ngq.ngq_source = nm3extent.c_route
    THEN
    --
    -- ROI based on a ROUTE type (i.e. datum, or gos)
    --
      OPEN  c_get_unit(l_rec_ngq.ngq_source_id);
      FETCH c_get_unit INTO l_net_unit ;
      CLOSE c_get_unit ;
   --
   -- AE If ROI units are null then use the underlying datum units
   --
      IF l_net_unit IS NULL
      THEN
        l_net_unit := nm3get.get_nt(pi_nt_type=>nm3net.get_datum_nt(l_rec_ngq.ngq_source_id)).nt_length_unit;
      END IF;

    ELSIF l_rec_ngq.ngq_source = nm3extent.c_saved
    THEN
    --
    -- ROI based on saved/temp extent - derive the units
    --
      DECLARE
        CURSOR get_units
        IS
          SELECT UNIQUE NVL 
                   ( nt_length_unit                                          -- Use length units from Datum/Route if populated on Network type
                   , nm3net.get_nt_units( nm3net.get_datum_nt(ne_id) ) )     -- Or use length units from Datum network type
            FROM nm_saved_extent_members
               , nm_elements
               , nm_types
           WHERE ne_id = nsm_ne_id
             AND ne_nt_type = nt_type
             AND nsm_nse_id =  l_rec_ngq.ngq_source_id;
      BEGIN
        OPEN get_units;
        FETCH get_units INTO l_net_unit;
        CLOSE get_units;
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    --
    END IF;
--
--    nm_debug.debug_on;
--    nm_debug.debug('Units = '||l_net_unit||' for '||l_rec_ngq.ngq_source_id||' - '||l_rec_ngq.ngq_source);
  --
    IF l_net_unit IS NOT NULL
    THEN
      UPDATE nm_assets_on_route_holding
         SET narh_end_reference_begin_mp  = narh_placement_begin_mp -  nm3unit.convert_unit (l_net_unit,  Nvl(pi_reference_units,l_net_unit),Nvl(l_rec_ngq.ngq_end_mp,0))
            ,narh_end_reference_end_mp    = narh_placement_end_mp   -  nm3unit.convert_unit (l_net_unit,  Nvl(pi_reference_units,l_net_unit),Nvl(l_rec_ngq.ngq_end_mp,0))
      WHERE  narh_job_id                  = po_return_arguments.narh_job_id;
    END IF;
  --
  END IF ;
  --Log 713423:Linesh:05-Mar-2009:End
--   nm_debug.debug('Done');
   nm3user.set_effective_date(c_init_eff_date);
--
   nm_debug.proc_end (g_package_name,'create_asset_on_route_data');
--
--EXCEPTION
------
--   WHEN others
--    THEN
--      nm3user.set_effective_date(c_init_eff_date);
--      RAISE;
--
END create_asset_on_route_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_tab_ngqi (p_narh_job_id  nm_assets_on_route_holding.narh_job_id%TYPE
                           ,p_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE
                           ,p_tab_rec_ngqi nm3gaz_qry.tab_rec_ngqi
                           ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_tab_ngqi');
--
   DELETE FROM nm_assets_on_route_holding
   WHERE narh_job_id = p_narh_job_id;
--
--   nm_debug.debug('p_tab_rec_ngqi.COUNT : '||p_tab_rec_ngqi.COUNT);
   FOR i IN 1..p_tab_rec_ngqi.COUNT
    LOOP
--      IF MOD(i,100) = 0
--       THEN
--         nm_debug.debug('process_each_ngqi :'||i);
--      END IF;
      process_each_ngqi (p_narh_job_id => p_narh_job_id
                        ,p_nte_job_id  => p_nte_job_id
                        ,p_rec_ngqi    => p_tab_rec_ngqi(i)
                        );
   END LOOP;
--
   UPDATE nm_assets_on_route_holding
    SET   narh_item_x_sect = (SELECT iit_x_sect
                               FROM  nm_inv_items_all
                              WHERE  iit_ne_id (+) = narh_ne_id_in
                             )
   WHERE  narh_job_id      = p_narh_job_id;
--
   nm_debug.proc_end(g_package_name,'process_tab_ngqi');
--
END process_tab_ngqi;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_each_ngqi (p_narh_job_id  nm_assets_on_route_holding.narh_job_id%TYPE
                            ,p_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE
                            ,p_rec_ngqi     nm_gaz_query_item_list%ROWTYPE
                            ) IS
--
   -- "Holding" arrays (hence lh_)
   lh_tab_narh_ne_id_of_begin     nm3type.tab_number;
   lh_tab_narh_begin_mp           nm3type.tab_number;
   lh_tab_narh_ne_id_of_end       nm3type.tab_number;
   lh_tab_narh_end_mp             nm3type.tab_number;
   lh_tab_narh_seq_no             nm3type.tab_number;
   lh_tab_narh_seg_no             nm3type.tab_number;
   lh_tab_cardinality             nm3type.tab_number;
   lh_tab_narh_nm_type            nm3type.tab_varchar4;
   lh_tab_narh_nm_obj_type        nm3type.tab_varchar4;
   lh_tab_narh_placement_begin_mp nm3type.tab_number;
   lh_tab_narh_placement_end_mp   nm3type.tab_number;
--
   -- "Final" arrays (hence lf_)
   lf_tab_narh_ne_id_of_begin     nm3type.tab_number;
   lf_tab_narh_begin_mp           nm3type.tab_number;
   lf_tab_narh_ne_id_of_end       nm3type.tab_number;
   lf_tab_narh_end_mp             nm3type.tab_number;
   lf_tab_narh_seq_no             nm3type.tab_number;
   lf_tab_narh_seg_no             nm3type.tab_number;
   lf_tab_cardinality             nm3type.tab_number;
   lf_tab_narh_nm_type            nm3type.tab_varchar4;
   lf_tab_narh_nm_obj_type        nm3type.tab_varchar4;
   lf_tab_narh_placement_begin_mp nm3type.tab_number;
   lf_tab_narh_placement_end_mp   nm3type.tab_number;
--
   l_lf_index                     pls_integer;
--
   l_rec_nit                      nm_inv_types%ROWTYPE;
   l_nm_type                      varchar2(30);
   l_nm_obj_type                  varchar2(30);
   l_is_foreign_table             boolean;
   l_block nm3type.max_varchar2;

   l_pior_ne_id nm_elements.ne_id%TYPE;
   l_prior_mp   number;
   l_next_ne_id nm_elements.ne_id%TYPE;
   l_next_mp    number;
--
   PROCEDURE move_lh_to_lf (p_lh_index pls_integer
                           ,p_lf_index pls_integer
                           ) IS
   BEGIN
      lf_tab_narh_ne_id_of_begin(p_lf_index)     := lh_tab_narh_ne_id_of_begin(p_lh_index);
      lf_tab_narh_begin_mp(p_lf_index)           := lh_tab_narh_begin_mp(p_lh_index);
      lf_tab_narh_ne_id_of_end(p_lf_index)       := lh_tab_narh_ne_id_of_end(p_lh_index);
      lf_tab_narh_end_mp(p_lf_index)             := lh_tab_narh_end_mp(p_lh_index);
      lf_tab_narh_seq_no(p_lf_index)             := lh_tab_narh_seq_no(p_lh_index);
      lf_tab_narh_seg_no(p_lf_index)             := lh_tab_narh_seg_no(p_lh_index);
      lf_tab_cardinality(p_lf_index)             := lh_tab_cardinality(p_lh_index);
      lf_tab_narh_nm_type(p_lf_index)            := lh_tab_narh_nm_type(p_lh_index);
      lf_tab_narh_nm_obj_type(p_lf_index)        := lh_tab_narh_nm_obj_type(p_lh_index);
      lf_tab_narh_placement_begin_mp(p_lf_index) := lh_tab_narh_placement_begin_mp(p_lh_index);
      lf_tab_narh_placement_end_mp(p_lf_index)   := lh_tab_narh_placement_end_mp(p_lh_index);
   END move_lh_to_lf;

   PROCEDURE move_first_lh_to_lf IS

     l_temp_mp number;

   BEGIN
     move_lh_to_lf(p_lh_index => 1
                  ,p_lf_index => 1);

     --check cardinality
     IF lh_tab_cardinality(1) = -1
     THEN
       --if negative, swap measures
       l_temp_mp               := lf_tab_narh_begin_mp(1);
       lf_tab_narh_begin_mp(1) := lf_tab_narh_end_mp(1);
       lf_tab_narh_end_mp(1)   := l_temp_mp;
     END IF;

   END move_first_lh_to_lf;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_each_ngqi');
--
   --nm_debug.debug_sql_string(p_sql => 'select * from nm_rescale_write order by nm_seq_no');

   IF p_rec_ngqi.ngqi_item_type_type != nm3gaz_qry.c_ngqt_item_type_type_inv
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 324
                    ,pi_supplementary_info => p_rec_ngqi.ngqi_item_type_type
                    );
   END IF;
--
   l_rec_nit          := nm3get.get_nit (pi_nit_inv_type => p_rec_ngqi.ngqi_item_type);
   l_is_foreign_table := l_rec_nit.nit_table_name IS NOT NULL;
--
   IF NOT l_is_foreign_table
    THEN -- This is NOT a FT inv type
         -- so move the details for nm_members into the rec_nit
      l_rec_nit.nit_table_name        := 'nm_members';
      l_rec_nit.nit_lr_ne_column_name := 'nm_ne_id_of';
      l_rec_nit.nit_lr_st_chain       := 'nm_begin_mp';
      l_rec_nit.nit_lr_end_chain      := 'nm_end_mp';
      l_rec_nit.nit_foreign_pk_column := 'nm_ne_id_in';
      l_nm_type                       := 'nm.nm_type';
      l_nm_obj_type                   := 'nm.nm_obj_type';
   ELSE
      l_nm_type                       := nm3flx.string('I');
      l_nm_obj_type                   := nm3flx.string(l_rec_nit.nit_inv_type);
   END IF;
--
   IF( l_rec_nit.nit_lr_ne_column_name IS NULL
     OR  l_rec_nit.nit_lr_st_chain IS NULL )
   THEN
     hig.raise_ner(pi_appl               => nm3type.c_net
                  ,pi_id                 => 465
                  ,pi_supplementary_info => CASE WHEN l_rec_nit.nit_lr_st_chain IS NULL
                                            THEN ' [ Start Chain Column is not defined ]'
                                            ELSE ' [ NE Column is not defined ]'
                                            END);
   END IF;
--
   g_rec_ngqi := p_rec_ngqi;
--
   l_block :=            'BEGIN'
              ||CHR(10)||'   SELECT ne_id'
              ||CHR(10)||'         ,nm_begin_mp'
              ||CHR(10)||'         ,ne_id'
              ||CHR(10)||'         ,nm_end_mp'
              ||CHR(10)||'         ,nm_seq_no'
              ||CHR(10)||'         ,nm_seg_no'
              ||CHR(10)||'         ,nm_cardinality'
              ||CHR(10)||'         ,nm_type'
              ||CHR(10)||'         ,nm_obj_type'
              ||CHR(10)||'         ,to_number(Null) narh_placement_begin_mp'
              ||CHR(10)||'         ,to_number(Null) narh_placement_end_mp'
              ||CHR(10)||'    BULK  COLLECT'
              ||CHR(10)||'    INTO  '||g_package_name||'.gh_tab_narh_ne_id_of_begin'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_begin_mp'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_ne_id_of_end'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_end_mp'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_seq_no'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_seg_no'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_cardinality'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_nm_type'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_nm_obj_type'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_placement_begin_mp'
              ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_placement_end_mp'
              --||CHR(10)||'    FROM (SELECT nrw.ne_id'
              ||CHR(10)||'    FROM (SELECT * FROM  ( SELECT nrw.ne_id'
              ||CHR(10)||'                ,GREATEST(nm.'||l_rec_nit.nit_lr_st_chain||',nrw.nm_begin_mp) nm_begin_mp'
              ||CHR(10)||'                ,LEAST(nm.'||NVL(l_rec_nit.nit_lr_end_chain
                                                          ,l_rec_nit.nit_lr_st_chain)||',nrw.nm_end_mp)     nm_end_mp'
              ||CHR(10)||'                ,nrw.nm_seq_no'
              ||CHR(10)||'                ,nrw.nm_seg_no'
              ||CHR(10)||'                ,nrw.nm_cardinality'
              ||CHR(10)||'                ,'||l_nm_type||' nm_type'
              ||CHR(10)||'                ,'||l_nm_obj_type||' nm_obj_type'
              ||CHR(10)||'           FROM  nm_rescale_write nrw'
              ||CHR(10)||'                ,'||l_rec_nit.nit_table_name||' nm'
              ||CHR(10)||'          WHERE  nm.'||l_rec_nit.nit_foreign_pk_column||' = '||g_package_name||'.g_rec_ngqi.ngqi_item_id'
              ||CHR(10)||'           AND   nm.'||l_rec_nit.nit_lr_ne_column_name||' = nrw.ne_id'
              ||CHR(10)||'           AND   nm.'||NVL(l_rec_nit.nit_lr_end_chain
                                                    ,l_rec_nit.nit_lr_st_chain)||' >= nrw.nm_begin_mp'
              ||CHR(10)||'           AND   nm.'||l_rec_nit.nit_lr_st_chain||' <= nrw.nm_end_mp'
              ||CHR(10)||'       -- '
              --
              -- Aberlour changes
              -- Bring in any Groups of Datums which share the same common datums
              -- 
              ||CHR(10)||'         UNION '
              ||CHR(10)||'       -- '
              ||CHR(10)||'           SELECT ex.nm_ne_id_in ne_id '
              ||CHR(10)||'                ,qry.'||l_rec_nit.nit_lr_st_chain||'  nm_begin_mp '
              ||CHR(10)||'                ,qry.'||NVL(l_rec_nit.nit_lr_end_chain
                                                     ,l_rec_nit.nit_lr_st_chain)||' nm_end_mp '
              ||CHR(10)||'                , ex.nm_seq_no '
              ||CHR(10)||'                , ex.nm_seg_no '
              ||CHR(10)||'                , ex.nm_cardinality '
              ||CHR(10)||'                , ''I'' nm_type '
              ||CHR(10)||'                , '||nm3flx.string(l_rec_nit.nit_inv_type)||' nm_obj_type '
              ||CHR(10)||'             FROM '||l_rec_nit.nit_table_name||' qry, nm_nw_temp_extents nte , nm_members ex'
              ||CHR(10)||'            WHERE  nte.nte_job_id =  nm3gaz_qry.get_g_nte_job_id'
              ||CHR(10)||'              AND  qry.'||l_rec_nit.nit_foreign_pk_column||' = '||g_package_name||'.g_rec_ngqi.ngqi_item_id'
              ||CHR(10)||'              AND  ex.nm_ne_id_of = nte_ne_id_of '
              ||CHR(10)||'              AND  qry.'||l_rec_nit.nit_lr_ne_column_name||' = ex.nm_ne_id_in '
              ||CHR(10)||'              AND  qry.'||NVL(l_rec_nit.nit_lr_end_chain
                                                       ,l_rec_nit.nit_lr_st_chain)||' >= ex.nm_slk'
              ||CHR(10)||'              AND  qry.'||l_rec_nit.nit_lr_st_chain||' <= ex.nm_end_slk'
              ||CHR(10)||'           )'
              ||CHR(10)||' -- '
              ||CHR(10)||'          ORDER BY nm_seg_no'
              ||CHR(10)||'                  ,nm_seq_no'
              ||CHR(10)||'         );'
              ||CHR(10)||'END;';
--
--  nm_debug.debug_on;
  nm_debug.debug(l_block);
--  nm_debug.debug_off;
   EXECUTE IMMEDIATE l_block;
--
   lh_tab_narh_ne_id_of_begin     := gh_tab_narh_ne_id_of_begin;
   lh_tab_narh_begin_mp           := gh_tab_narh_begin_mp;
   lh_tab_narh_ne_id_of_end       := gh_tab_narh_ne_id_of_end;
   lh_tab_narh_end_mp             := gh_tab_narh_end_mp;
   lh_tab_narh_seq_no             := gh_tab_narh_seq_no;
   lh_tab_narh_seg_no             := gh_tab_narh_seg_no;
   lh_tab_cardinality             := gh_tab_cardinality;
   lh_tab_narh_nm_type            := gh_tab_narh_nm_type;
   lh_tab_narh_nm_obj_type        := gh_tab_narh_nm_obj_type;
   lh_tab_narh_placement_begin_mp := gh_tab_narh_placement_begin_mp;
   lh_tab_narh_placement_end_mp   := gh_tab_narh_placement_end_mp;
--
--   FOR i IN 1..lh_tab_narh_ne_id_of_begin.COUNT
--    LOOP
--      nm_debug.DEBUG('lh_tab_narh_ne_id_of_begin('||i||') : '||lh_tab_narh_ne_id_of_begin(i));
--      nm_debug.DEBUG('lh_tab_narh_begin_mp('||i||') : '||lh_tab_narh_begin_mp(i));
--      nm_debug.DEBUG('lh_tab_narh_ne_id_of_end('||i||') : '||lh_tab_narh_ne_id_of_end(i));
--      nm_debug.DEBUG('lh_tab_narh_end_mp('||i||') : '||lh_tab_narh_end_mp(i));
--   END LOOP;
--
   gh_tab_narh_ne_id_of_begin.DELETE;
   gh_tab_narh_begin_mp.DELETE;
   gh_tab_narh_ne_id_of_end.DELETE;
   gh_tab_narh_end_mp.DELETE;
   gh_tab_narh_seq_no.DELETE;
   gh_tab_narh_seg_no.DELETE;
   gh_tab_cardinality.DELETE;
   gh_tab_narh_nm_type.DELETE;
   gh_tab_narh_nm_obj_type.DELETE;
   gh_tab_narh_placement_begin_mp.DELETE;
   gh_tab_narh_placement_end_mp.DELETE;
--
   IF lh_tab_narh_ne_id_of_begin.COUNT = 0
    THEN
      -- Should never happen - we cannot have an item
      --  which has been selected based on it's location on a temp ne
      --  which then does not have a location on that temp ne
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 179
                    ,pi_supplementary_info => g_package_name||'.process_each_ngqi => lh_tab_narh_ne_id_of_begin.COUNT = 0'
                    );
   END IF;

   IF lh_tab_narh_ne_id_of_begin.COUNT = 1
    THEN
      -- Just a single location, therefore
      -- nothing to defrag - simply transfer from lh_ to lf_
      move_first_lh_to_lf;
   ELSE
      l_lf_index := 1;
      move_first_lh_to_lf;

      FOR i IN 2..lh_tab_narh_ne_id_of_begin.COUNT
       LOOP
          --nm_debug.DEBUG('prior card = ' || lh_tab_cardinality(i-1));
          --work out start/end of prior to compare based on cardinality
          IF lh_tab_cardinality(i-1) = 1
          THEN
            --nm_debug.DEBUG('using prior end');
            l_pior_ne_id := lh_tab_narh_ne_id_of_end(i-1);
            l_prior_mp   := lh_tab_narh_end_mp(i-1);
          ELSE
            --nm_debug.DEBUG('using prior begin');
            l_pior_ne_id := lh_tab_narh_ne_id_of_begin(i-1);
            l_prior_mp   := lh_tab_narh_begin_mp(i-1);
          END IF;

          --nm_debug.DEBUG('next card = ' || lh_tab_cardinality(i));
          --work out start/end of next to compare based on cardinality
          IF lh_tab_cardinality(i) = 1
          THEN
            --nm_debug.DEBUG('using next begin');
            l_next_ne_id := lh_tab_narh_ne_id_of_begin(i);
            l_next_mp    := lh_tab_narh_begin_mp(i);
          ELSE
            --nm_debug.DEBUG('using next end');
            l_next_ne_id := lh_tab_narh_ne_id_of_end(i);
            l_next_mp    := lh_tab_narh_end_mp(i);
          END IF;

--           nm_debug.DEBUG('l_pior_ne_id = ' || l_pior_ne_id
--                        || ' l_prior_mp = ' || l_prior_mp
--                        || ' l_next_ne_id = ' || l_next_ne_id
--                        || ' l_next_mp = ' || l_next_mp);

          IF are_these_connected (p_ne_id_prior   => l_pior_ne_id
                                 ,p_end_mp_prior  => l_prior_mp
                                 ,p_ne_id_next    => l_next_ne_id
                                 ,p_begin_mp_next => l_next_mp
                                 )
          THEN
            IF lh_tab_cardinality(i) = 1
            THEN
              lf_tab_narh_ne_id_of_end(l_lf_index) := lh_tab_narh_ne_id_of_end(i);
              lf_tab_narh_end_mp(l_lf_index)       := lh_tab_narh_end_mp(i);
            ELSE
              lf_tab_narh_ne_id_of_end(l_lf_index) := lh_tab_narh_ne_id_of_begin(i);
              lf_tab_narh_end_mp(l_lf_index)       := lh_tab_narh_begin_mp(i);
            END IF;
         ELSE
            l_lf_index := l_lf_index + 1;
            move_lh_to_lf (p_lh_index => i
                          ,p_lf_index => l_lf_index
                          );
         END IF;
      END LOOP;
   END IF;
--
   FOR i IN 1..lf_tab_narh_ne_id_of_begin.COUNT
    LOOP
--      nm_debug.DEBUG(i||'......................');
--      nm_debug.DEBUG('lf_tab_narh_ne_id_of_begin('||i||') : '||lf_tab_narh_ne_id_of_begin(i));
--      nm_debug.DEBUG('lf_tab_narh_begin_mp('||i||') : '||lf_tab_narh_begin_mp(i));
--      nm_debug.DEBUG('lf_tab_narh_ne_id_of_end('||i||') : '||lf_tab_narh_ne_id_of_end(i));
--      nm_debug.DEBUG('lf_tab_narh_end_mp('||i||') : '||lf_tab_narh_end_mp(i));
        lf_tab_narh_placement_begin_mp(i) := NVL ( get_measure_from_rescale_write (pi_ne_id      => lf_tab_narh_ne_id_of_begin(i)
                                                                                  ,pi_mp         => lf_tab_narh_begin_mp(i)
                                                                                  )
                                               , lf_tab_narh_begin_mp(i));
        lf_tab_narh_placement_end_mp(i)   := NVL ( get_measure_from_rescale_write (pi_ne_id      => lf_tab_narh_ne_id_of_end(i)
                                                                                  ,pi_mp         => lf_tab_narh_end_mp(i) )
                                                           ,lf_tab_narh_end_mp(i)               );
--      nm_debug.DEBUG('lf_tab_narh_placement_begin_mp('||i||') : '||lf_tab_narh_placement_begin_mp(i));
--      nm_debug.DEBUG('lf_tab_narh_placement_end_mp('||i||') : '||lf_tab_narh_placement_end_mp(i));
      IF lf_tab_narh_placement_end_mp(i) > g_maximum_mp
       THEN
         g_maximum_mp := lf_tab_narh_placement_end_mp(i);
      END IF;
   END LOOP;
--
--   FOR i IN 1..lf_tab_narh_ne_id_of_begin.COUNT
--   loop
--
--       nm_debug.debug('**** I ****                        = ' || i                                  );
--       nm_debug.debug('p_narh_job_id                      = ' || p_narh_job_id                      );
--       nm_debug.debug('p_rec_ngqi.ngqi_item_id            = ' || p_rec_ngqi.ngqi_item_id            );
--       nm_debug.debug('lf_tab_narh_ne_id_of_begin(i)      = ' || lf_tab_narh_ne_id_of_begin(i)      );
--       nm_debug.debug('lf_tab_narh_begin_mp(i)            = ' || lf_tab_narh_begin_mp(i)            );
--       nm_debug.debug('lf_tab_narh_ne_id_of_end(i)        = ' || lf_tab_narh_ne_id_of_end(i)        );
--       nm_debug.debug('lf_tab_narh_end_mp(i)              = ' || lf_tab_narh_end_mp(i)              );
--       nm_debug.debug('lf_tab_narh_seq_no(i)              = ' || lf_tab_narh_seq_no(i)              );
--       nm_debug.debug('lf_tab_narh_seg_no(i)              = ' || lf_tab_narh_seg_no(i)              );
--       nm_debug.debug('p_rec_ngqi.ngqi_item_type_type     = ' || p_rec_ngqi.ngqi_item_type_type     );
--       nm_debug.debug('p_rec_ngqi.ngqi_item_type          = ' || p_rec_ngqi.ngqi_item_type          );
--       nm_debug.debug('lf_tab_narh_nm_type(i)             = ' || lf_tab_narh_nm_type(i)             );
--       nm_debug.debug('lf_tab_narh_nm_obj_type(i)         = ' || lf_tab_narh_nm_obj_type(i)         );
--       nm_debug.debug('lf_tab_narh_placement_begin_mp(i)  = ' || lf_tab_narh_placement_begin_mp(i)  );
--       nm_debug.debug('lf_tab_narh_placement_end_mp(i)    = ' || lf_tab_narh_placement_end_mp(i)    );   
--       
--   end loop ;
   FORALL i IN 1..lf_tab_narh_ne_id_of_begin.COUNT
       INSERT INTO nm_assets_on_route_holding
              (narh_job_id
              ,narh_ne_id_in
              ,narh_ne_id_of_begin
              ,narh_begin_mp
              ,narh_ne_id_of_end
              ,narh_end_mp
              ,narh_seq_no
              ,narh_seg_no
              ,narh_item_type_type
              ,narh_item_type
              ,narh_nm_type
              ,narh_nm_obj_type
              ,narh_placement_begin_mp
              ,narh_placement_end_mp
              )
       VALUES (p_narh_job_id
              ,p_rec_ngqi.ngqi_item_id
              ,lf_tab_narh_ne_id_of_begin(i)
              ,lf_tab_narh_begin_mp(i)
              ,lf_tab_narh_ne_id_of_end(i)
              ,lf_tab_narh_end_mp(i)
              ,lf_tab_narh_seq_no(i)
              ,lf_tab_narh_seg_no(i)
              ,p_rec_ngqi.ngqi_item_type_type
              ,p_rec_ngqi.ngqi_item_type
              ,lf_tab_narh_nm_type(i)
              ,lf_tab_narh_nm_obj_type(i)
              ,lf_tab_narh_placement_begin_mp(i)
              ,lf_tab_narh_placement_end_mp(i)
              );
--
   nm_debug.proc_end(g_package_name,'process_each_ngqi');
--
END process_each_ngqi;
--
-----------------------------------------------------------------------------
--
FUNCTION are_these_connected (p_ne_id_prior   number
                             ,p_end_mp_prior  number
                             ,p_ne_id_next    number
                             ,p_begin_mp_next number
                             ) RETURN boolean IS
--
   l_true_prior    nm_members.nm_true%TYPE;
   l_true_next     nm_members.nm_true%TYPE;
   l_rec_nrw_prior nm_rescale_write%ROWTYPE;
   l_rec_nrw_next  nm_rescale_write%ROWTYPE;
   l_retval        boolean;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'are_these_connected');
--
   IF p_ne_id_prior = p_ne_id_next
    THEN -- Same element
      l_retval := p_end_mp_prior = p_begin_mp_next;
   ELSE -- Different Elements
      l_rec_nrw_prior := get_rescale_write (pi_ne_id => p_ne_id_prior
                                           ,pi_mp    => p_end_mp_prior
                                           );
      l_rec_nrw_next  := get_rescale_write (pi_ne_id => p_ne_id_next
                                           ,pi_mp    => p_begin_mp_next
                                           );
      l_true_prior := get_measure_from_rec_nrw (l_rec_nrw_prior, p_end_mp_prior);
      l_true_next  := get_measure_from_rec_nrw (l_rec_nrw_next,  p_begin_mp_next);

      IF l_true_prior != l_true_next
       THEN
         -- These are DEFINITELY NOT CONNECTED
         l_retval := FALSE;
      ELSE
         -- Even though these have the same measure, they are not necessarily connected
         l_retval := are_segments_connected (l_rec_nrw_prior.nm_seg_no, l_rec_nrw_next.nm_seg_no);
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'are_these_connected');
--
   RETURN l_retval;
--
END are_these_connected;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_reference_item_exists (pi_reference_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                                      ,pi_reference_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                                      ,pi_reference_item_id        nm_assets_on_route_holding.narh_ne_id_in%TYPE
                                      ,pi_tab_rec_ngqi             nm3gaz_qry.tab_rec_ngqi
                                      ) IS
--
   l_found boolean := FALSE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_reference_item_exists');
--
   IF   pi_reference_item_type_type IS NOT NULL
    AND pi_reference_item_type      IS NOT NULL
    THEN
      FOR i IN 1..pi_tab_rec_ngqi.COUNT
       LOOP
         l_found := (pi_tab_rec_ngqi(i).ngqi_item_type_type = pi_reference_item_type_type
                 AND pi_tab_rec_ngqi(i).ngqi_item_type      = pi_reference_item_type
                 AND pi_tab_rec_ngqi(i).ngqi_item_id        = NVL(pi_reference_item_id,pi_tab_rec_ngqi(i).ngqi_item_id)
                    );
         EXIT WHEN l_found;
      END LOOP;
      IF NOT l_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 316
                       ,pi_supplementary_info => pi_reference_item_type_type||':'||pi_reference_item_type
                       );
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'check_reference_item_exists');
--
END check_reference_item_exists;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_reference_item_measures (pi_narh_job_id                nm_assets_on_route_holding.narh_job_id%TYPE
                                      ,pi_reference_item_type_type   nm_gaz_query_types.ngqt_item_type_type%TYPE
                                      ,pi_reference_item_type        nm_gaz_query_types.ngqt_item_type%TYPE
                                      ,pi_reference_item_id          nm_assets_on_route_holding.narh_ne_id_in%TYPE
                                      ,pi_ref_negatively_until_found boolean
                                      ) IS
--
   l_tab_ref_item_id              nm3type.tab_number;
   l_tab_ref_item_begin           nm3type.tab_number;
   l_tab_ref_item_end             nm3type.tab_number;
   l_tab_ref_item_seg_no          nm3type.tab_number;
   l_tab_ref_item_rowid           nm3type.tab_rowid;
--
   l_tab_other_item_pl_begin      nm3type.tab_number;
   l_tab_other_item_pl_end        nm3type.tab_number;
   l_tab_other_item_seg_no        nm3type.tab_number;
   l_tab_other_item_rowid         nm3type.tab_rowid;
   l_tab_other_item_ref_item      nm3type.tab_number;
   l_tab_other_item_beg_ref_begin nm3type.tab_number;
   l_tab_other_item_beg_ref_end   nm3type.tab_number;
   l_tab_other_item_end_ref_begin nm3type.tab_number;
   l_tab_other_item_end_ref_end   nm3type.tab_number;
--
   l_ref_length                   number;
--
   PROCEDURE get_ref_post_begin (pi_route_mp IN     number
                                ,pi_seg_no   IN     number
                                ,po_ref_item    OUT number
                                ,po_ref_mp_st   OUT number
                                ,po_ref_length  OUT number
                                ) IS
      l_tab_ref_mp      nm3type.tab_number;
      l_tab_ref_length  nm3type.tab_number;
      l_exact_match     boolean := FALSE;
   BEGIN
      FOR i IN 1..l_tab_ref_item_id.COUNT
       LOOP
         IF    l_tab_ref_item_begin(i) = pi_route_mp
          THEN
            -- These are equal - use this one
            l_exact_match := TRUE;
            po_ref_mp_st  := 0;
            po_ref_item   := l_tab_ref_item_id(i);
            po_ref_length := l_tab_ref_item_end(i) - l_tab_ref_item_begin(i);
            EXIT;
         ELSIF l_tab_ref_item_begin(i) > pi_route_mp
          THEN
            l_tab_ref_mp(i)     := pi_route_mp - l_tab_ref_item_begin(i);
            l_tab_ref_length(i) := l_tab_ref_item_end(i) - l_tab_ref_item_begin(i);
         ELSE
            l_tab_ref_mp(i)     := pi_route_mp - l_tab_ref_item_begin(i);
            l_tab_ref_length(i) := l_tab_ref_item_end(i) - l_tab_ref_item_begin(i);
         END IF;
      END LOOP;
      IF NOT l_exact_match
       THEN
         FOR i IN 1..l_tab_ref_mp.COUNT
          LOOP
            IF    l_tab_ref_mp(i) < 0
             AND  l_tab_ref_mp(i) > NVL(po_ref_mp_st,l_tab_ref_mp(i)-1)
             THEN
               po_ref_mp_st  := l_tab_ref_mp(i);
               po_ref_item   := l_tab_ref_item_id(i);
               po_ref_length := l_tab_ref_length(i);
            ELSIF l_tab_ref_mp(i) > 0
             AND  l_tab_ref_mp(i) < NVL(po_ref_mp_st,l_tab_ref_mp(i)+1)
             THEN
               po_ref_mp_st  := l_tab_ref_mp(i);
               po_ref_item   := l_tab_ref_item_id(i);
               po_ref_length := l_tab_ref_length(i);
            END IF;
         END LOOP;
         IF po_ref_mp_st < 0
          AND NOT pi_ref_negatively_until_found
          THEN
            po_ref_mp_st     := pi_route_mp;
            po_ref_length    := NULL;
            po_ref_item      := NULL;
         END IF;
      END IF;
   END get_ref_post_begin;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_reference_item_measures');
--
   DECLARE
      l_no_ref EXCEPTION;
   BEGIN
      --
      IF   pi_reference_item_type_type IS NULL
       AND pi_reference_item_type      IS NULL
       THEN
         --
         -- If there is no reference item type specified then
         --  just set all the reference data as per the route details
         --
         UPDATE nm_assets_on_route_holding
          SET   narh_begin_reference_begin_mp = narh_placement_begin_mp
               ,narh_begin_reference_end_mp   = narh_placement_end_mp
               ,narh_end_reference_begin_mp   = 0 - narh_placement_begin_mp
               ,narh_end_reference_end_mp     = 0 - narh_placement_end_mp
         WHERE  narh_job_id                   = pi_narh_job_id;
         --
         -- Jump to the bottom of the procedure
         --
         RAISE l_no_ref;
      END IF;
      --
      -- Get all of the reference items
      --
      SELECT narh_ne_id_in
            ,narh_placement_begin_mp
            ,narh_placement_end_mp
            ,narh_seg_no
            ,narh.ROWID narh_rowid
       BULK  COLLECT
       INTO  l_tab_ref_item_id
            ,l_tab_ref_item_begin
            ,l_tab_ref_item_end
            ,l_tab_ref_item_seg_no
            ,l_tab_ref_item_rowid
       FROM  nm_assets_on_route_holding narh
      WHERE  narh_job_id         = pi_narh_job_id
       AND   narh_item_type_type = pi_reference_item_type_type
       AND   narh_item_type      = pi_reference_item_type
       AND   narh_ne_id_in       = NVL(pi_reference_item_id,narh_ne_id_in)
      ORDER BY narh_placement_begin_mp;
      --
      -- Update all the reference items, setting the reference details to themselves
      --
      FORALL i IN 1..l_tab_ref_item_rowid.COUNT
        UPDATE nm_assets_on_route_holding
         SET   narh_reference_item_id        = narh_ne_id_in
              ,narh_begin_reference_begin_mp = 0
              ,narh_begin_reference_end_mp   = (narh_placement_end_mp-narh_placement_begin_mp)
              ,narh_end_reference_begin_mp   = 0 - (narh_placement_end_mp-narh_placement_begin_mp)
              ,narh_end_reference_end_mp     = 0
        WHERE  ROWID                         = l_tab_ref_item_rowid(i);
      --
      -- Get all of the other items
      --
      SELECT narh_placement_begin_mp
            ,narh_placement_end_mp
            ,narh_seg_no
            ,narh.ROWID narh_rowid
       BULK  COLLECT
       INTO  l_tab_other_item_pl_begin
            ,l_tab_other_item_pl_end
            ,l_tab_other_item_seg_no
            ,l_tab_other_item_rowid
       FROM  nm_assets_on_route_holding narh
      WHERE  narh_job_id         = pi_narh_job_id
       AND   narh_reference_item_id IS NULL
      ORDER BY narh_placement_begin_mp;
      --
      -- Loop through all the other items working out their reference item
      --
      FOR i IN 1..l_tab_other_item_rowid.COUNT
       LOOP
         get_ref_post_begin (pi_route_mp   => l_tab_other_item_pl_begin(i)
                            ,pi_seg_no     => l_tab_other_item_seg_no(i)
                            ,po_ref_item   => l_tab_other_item_ref_item(i)
                            ,po_ref_mp_st  => l_tab_other_item_beg_ref_begin(i)
                            ,po_ref_length => l_ref_length
                            );
--         nm_debug.debug('l_ref_length = '||l_ref_length);
--         nm_debug.debug('l_tab_other_item_beg_ref_end(i)   := '||l_tab_other_item_beg_ref_begin(i)||' + ('||l_tab_other_item_pl_end(i)||'-'||l_tab_other_item_pl_begin(i)||')');
         l_tab_other_item_beg_ref_end(i)   := l_tab_other_item_beg_ref_begin(i) + (l_tab_other_item_pl_end(i)-l_tab_other_item_pl_begin(i));
         l_tab_other_item_end_ref_begin(i) := l_tab_other_item_beg_ref_begin(i) - ABS(l_ref_length);
--         nm_debug.debug('l_tab_other_item_end_ref_begin(i) := '||l_tab_other_item_beg_ref_begin(i)||' - '||ABS(l_ref_length));
         l_tab_other_item_end_ref_end(i)   := l_tab_other_item_beg_ref_end(i)   - ABS(l_ref_length);
--         nm_Debug.debug('l_tab_other_item_end_ref_end(i)   := '||l_tab_other_item_beg_ref_end(i)||'  - '||ABS(l_ref_length));
      END LOOP;
      --
      -- Update all the other items with the reference data
      --
--      FOR i IN  1..l_tab_other_item_rowid.COUNT
--       LOOP
--         nm_debug.debug(i||'................');
--         nm_debug.debug('narh_reference_item_id        = '||l_tab_other_item_ref_item(i));
--         nm_debug.debug('narh_begin_reference_begin_mp = '||l_tab_other_item_beg_ref_begin(i));
--         nm_debug.debug('narh_begin_reference_end_mp   = '||l_tab_other_item_beg_ref_end(i));
--         nm_debug.debug('narh_end_reference_begin_mp   = '||l_tab_other_item_end_ref_begin(i));
--         nm_debug.debug('narh_end_reference_end_mp     = '||l_tab_other_item_end_ref_end (i));
--      END LOOP;
      --
      FORALL i IN 1..l_tab_other_item_rowid.COUNT
        UPDATE nm_assets_on_route_holding
         SET   narh_reference_item_id        = l_tab_other_item_ref_item(i)
              ,narh_begin_reference_begin_mp = l_tab_other_item_beg_ref_begin(i)
              ,narh_begin_reference_end_mp   = l_tab_other_item_beg_ref_end(i)
              ,narh_end_reference_begin_mp   = l_tab_other_item_end_ref_begin(i)
              ,narh_end_reference_end_mp     = l_tab_other_item_end_ref_end(i)
        WHERE  ROWID                         = l_tab_other_item_rowid(i);
      --
   EXCEPTION
      WHEN l_no_ref
       THEN
         NULL;
   END;
--
   nm_debug.proc_end(g_package_name,'set_reference_item_measures');
--
END set_reference_item_measures;
--
-----------------------------------------------------------------------------
--
FUNCTION get_rescale_write (pi_ne_id nm_rescale_write.ne_id%TYPE
                           ,pi_mp    nm_rescale_write.nm_begin_mp%TYPE
                           ) RETURN nm_rescale_write%ROWTYPE IS
--
   CURSOR cs_nrw (c_ne_id nm_rescale_write.ne_id%TYPE
                 ,c_mp    nm_rescale_write.nm_begin_mp%TYPE
                 ) IS
   SELECT *
    FROM  nm_rescale_write
   WHERE  ne_id = c_ne_id
    AND   c_mp BETWEEN nm_begin_mp AND nm_end_mp;
--
   l_rec_nrw nm_rescale_write%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nrw (pi_ne_id, pi_mp);
   FETCH cs_nrw INTO l_rec_nrw;
   CLOSE cs_nrw;
--
   RETURN l_rec_nrw;
--
END get_rescale_write;
--
-----------------------------------------------------------------------------
--
FUNCTION get_measure_from_rec_nrw (pi_rec_nrw nm_rescale_write%ROWTYPE
                                  ,pi_mp      nm_rescale_write.nm_begin_mp%TYPE
                                  ) RETURN nm_rescale_write.nm_true%TYPE IS

  l_difference number;

BEGIN
   IF pi_rec_nrw.nm_cardinality = 1
    THEN
      l_difference := pi_mp - pi_rec_nrw.nm_begin_mp;
   ELSE
      l_difference := pi_rec_nrw.nm_end_mp - pi_mp;
   END IF;

   RETURN pi_rec_nrw.nm_true + l_difference;

END get_measure_from_rec_nrw;
--
-----------------------------------------------------------------------------
--
FUNCTION get_measure_from_rescale_write (pi_ne_id nm_rescale_write.ne_id%TYPE
                                        ,pi_mp    nm_rescale_write.nm_begin_mp%TYPE
                                        ) RETURN nm_rescale_write.nm_true%TYPE IS
--
   l_rec_nrw nm_rescale_write%ROWTYPE;
--
BEGIN
--
   l_rec_nrw := get_rescale_write (pi_ne_id => pi_ne_id
                                  ,pi_mp    => pi_mp
                                  );
--
   RETURN get_measure_from_rec_nrw (l_rec_nrw,pi_mp);
--
END get_measure_from_rescale_write;
--
-----------------------------------------------------------------------------
--
FUNCTION are_segments_connected (pi_seg_no_1 nm_rescale_write.nm_seg_no%TYPE
                                ,pi_seg_no_2 nm_rescale_write.nm_seg_no%TYPE
                                ) RETURN boolean IS
--
   CURSOR cs_conn (c_seg_no_1 nm_rescale_write.nm_seg_no%TYPE
                  ,c_seg_no_2 nm_rescale_write.nm_seg_no%TYPE
                  ) IS
   SELECT nrt_parent_seg_no
    FROM  nm_rescale_seg_tree
   WHERE  nrt_child_seg_no            = c_seg_no_2
   CONNECT BY PRIOR nrt_parent_seg_no = nrt_child_seg_no
   START WITH nrt_parent_seg_no       = c_seg_no_1;
--
   l_dummy  pls_integer;
   l_retval boolean;
--
BEGIN
--
   l_retval := pi_seg_no_1 = pi_seg_no_2;
   IF NOT l_retval
    THEN
      OPEN  cs_conn (pi_seg_no_1
                    ,pi_seg_no_2
                    );
      FETCH cs_conn INTO l_dummy;
      l_retval := cs_conn%FOUND;
      CLOSE cs_conn;
   --
      IF NOT l_retval
       THEN
         OPEN  cs_conn (pi_seg_no_2
                       ,pi_seg_no_1
                       );
         FETCH cs_conn INTO l_dummy;
         l_retval := cs_conn%FOUND;
         CLOSE cs_conn;
      END IF;
   END IF;
--
   RETURN l_retval;
--
END are_segments_connected;
--
-----------------------------------------------------------------------------
--
FUNCTION next_narh_job_id_seq RETURN pls_integer IS
   l_retval pls_integer;
BEGIN
--
   SELECT narh_job_id_seq.NEXTVAL
    INTO  l_retval
    FROM  dual;
--
   RETURN l_retval;
--
END next_narh_job_id_seq;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_rescale_write_for_duals IS
   l_tab_parent_seg nm3type.tab_number;
   l_tab_child_seg  nm3type.tab_number;
   l_count          pls_integer;
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_rescale_write_for_duals');
--

   SELECT nrt_parent_seg_no
         ,nrt_child_seg_no
    BULK  COLLECT
    INTO  l_tab_parent_seg
         ,l_tab_child_seg
    FROM  nm_rescale_seg_tree;
--
   FOR i IN 1..l_tab_parent_seg.COUNT
    LOOP
      l_count := 0;
      FOR j IN 1..l_tab_child_seg.COUNT
       LOOP
         IF l_tab_parent_seg(i) = l_tab_child_seg(j)
          THEN
            l_count := l_count + 1;
         END IF;
      END LOOP;
      IF l_count > 1
       THEN
         hig.raise_ner (nm3type.c_net,319);
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'check_rescale_write_for_duals');
--
END check_rescale_write_for_duals;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_user_default_pbi_query (po_npq_id     OUT nm_pbi_query.npq_id%TYPE
                                     ,po_npq_unique OUT nm_pbi_query.npq_unique%TYPE
                                     ,po_npq_descr  OUT nm_pbi_query.npq_descr%TYPE
                                     ) IS
--
   l_useopt  hig_user_options.huo_value%TYPE;
   l_rec_npq nm_pbi_query%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_user_default_pbi_query');
--
   po_npq_id     := NULL;
   po_npq_unique := NULL;
   po_npq_descr  := NULL;
--
   l_useopt := hig.get_useopt (pi_huo_hus_user_id => To_Number(Sys_Context('NM3CORE','USER_ID'))
                              ,pi_huo_id          => c_default_pbi_useopt
                              );
--
   IF l_useopt IS NULL
    OR NOT nm3flx.is_numeric (l_useopt)
    THEN
      NULL;
   ELSE
      l_rec_npq     := nm3get.get_npq (pi_npq_id          => l_useopt
                                      ,pi_raise_not_found => FALSE
                                      );
      po_npq_id     := l_rec_npq.npq_id;
      po_npq_unique := l_rec_npq.npq_unique;
      po_npq_descr  := l_rec_npq.npq_descr;
   END IF;
--
   IF po_npq_id IS NULL
    THEN
      set_user_default_pbi_query (NULL);
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_user_default_pbi_query');
--
END get_user_default_pbi_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_user_default_pbi_query (pi_npq_id     IN  nm_pbi_query.npq_id%TYPE
                                     ) IS
--
   PRAGMA autonomous_transaction;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_user_default_pbi_query');
--
   hig.set_useopt (pi_huo_hus_user_id => To_Number(Sys_Context('NM3CORE','USER_ID'))
                  ,pi_huo_id          => c_default_pbi_useopt
                  ,pi_huo_value       => pi_npq_id
                  );
--
   nm_debug.proc_end(g_package_name,'set_user_default_pbi_query');
--
   COMMIT;
--
END set_user_default_pbi_query;
--
-----------------------------------------------------------------------------
--

--
-----------------------------------------------------------------------------
--
PROCEDURE get_inv_flex_col_details (pi_iit_ne_id           IN     nm_inv_items.iit_ne_id%TYPE
                                   ,pi_nit_inv_type        IN     nm_inv_types.nit_inv_type%TYPE
                                   ,pi_display_xsp_if_reqd IN     boolean DEFAULT TRUE
                                   ,pi_display_descr       IN     boolean DEFAULT TRUE
                                   ,pi_display_start_date  IN     boolean DEFAULT TRUE
                                   ,pi_display_admin_unit  IN     boolean DEFAULT TRUE
                                   ,pi_nias_id             IN     nm_inv_attribute_sets.nias_id%TYPE DEFAULT NULL
                                   ,pi_allow_null_ne_id    IN     boolean DEFAULT FALSE
                                   ,po_flex_col_dets       IN OUT tab_rec_inv_flex_col_details
                                   ) IS

  e_no_inv_type EXCEPTION;

  c_returning_values_for_attrs CONSTANT boolean := pi_iit_ne_id IS NOT NULL OR NOT pi_allow_null_ne_id;
--
   l_rec_inv_flex_col_details rec_inv_flex_col_details;
--
   l_tab_format          nm3type.tab_varchar30;
   l_tab_scrn_text       nm3type.tab_varchar30;
   l_tab_view_col_name   nm3type.tab_varchar30;
   l_tab_id_domain       nm3type.tab_varchar30;
   l_tab_mandatory_yn    nm3type.tab_varchar4;
   l_tab_format_mask     nm3type.tab_varchar80;
--
   l_block               nm3type.tab_varchar32767;
--
   l_count               pls_integer := 0;
--
   l_rec_nit             nm_inv_types%ROWTYPE;
   l_rec_iit_empty       nm_inv_items%ROWTYPE;
--
   c_iit_pk    CONSTANT  varchar2(30) := 'IIT_PRIMARY_KEY';
   l_data_source         varchar2(61);
   c_ft_cursor_name CONSTANT varchar2(10) := 'cs_'||LOWER(pi_nit_inv_type);
   l_pk_is_a_flex_attrib boolean      := FALSE;
--
   l_iit_not_found       EXCEPTION;
   c_not_found_sqlcode CONSTANT pls_integer := -20500;
   PRAGMA EXCEPTION_INIT (l_iit_not_found,-20500);
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar (l_block, p_text, p_nl);
   END append;
   FUNCTION this_is_a_parent_item (p_iit_ne_id number) RETURN boolean IS
      CURSOR cs_exists (c_iit_ne_id number) IS
      SELECT 1
       FROM  dual
      WHERE  ROWNUM = 1
       AND   EXISTS (SELECT 1
                      FROM  nm_inv_item_groupings
                     WHERE  iig_parent_id = c_iit_ne_id
                    );
      l_dummy pls_integer;
      l_found boolean;
   BEGIN
      OPEN  cs_exists (p_iit_ne_id);
      FETCH cs_exists INTO l_dummy;
      l_found := cs_exists%FOUND;
      CLOSE cs_exists;
      RETURN l_found;
   END this_is_a_parent_item;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_inv_flex_col_details');

--    nm_debug.DEBUG('get_inv_flex_col_details');
--    nm_debug.DEBUG('pi_iit_ne_id = ' || pi_iit_ne_id);
--    nm_debug.DEBUG('pi_allow_null_ne_id = ' || nm3flx.boolean_to_char(pi_allow_null_ne_id));
--    nm_debug.DEBUG('c_returning_values_for_attrs = ' || nm3flx.boolean_to_char(c_returning_values_for_attrs));
--
   po_flex_col_dets.DELETE;
--
   g_rec_iit := l_rec_iit_empty;
--
   IF pi_nit_inv_type IS NULL
   THEN
     --no inv type so return nothing
     RAISE e_no_inv_type;
   END IF;

   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_nit_inv_type);
--
   IF pi_nias_id IS NULL
   THEN
     --get all attributes for type
     SELECT ita_attrib_name
           ,ita_format
           ,ita_scrn_text
           ,ita_view_col_name
           ,ita_id_domain
           ,ita_mandatory_yn
           ,NULL
           ,NULL
           ,ita_format_mask
       BULK COLLECT
       INTO g_tab_attrib_name
           ,l_tab_format
           ,l_tab_scrn_text
           ,l_tab_view_col_name
           ,l_tab_id_domain
           ,l_tab_mandatory_yn
           ,g_tab_value
           ,g_tab_descr
           ,l_tab_format_mask
       FROM nm_inv_type_attribs
      WHERE ita_inv_type = pi_nit_inv_type
     ORDER BY ita_disp_seq_no, ita_attrib_name;
   ELSE
     --restrict attributes returned by specified attribute set
     SELECT /*+ INDEX(ita ita_pk) */
       ita.ita_attrib_name,
       ita.ita_format,
       ita.ita_scrn_text,
       ita.ita_view_col_name,
       ita.ita_id_domain,
       ita.ita_mandatory_yn,
       NULL,
       NULL,
       ita.ita_format_mask
     BULK COLLECT INTO
       g_tab_attrib_name,
       l_tab_format,
       l_tab_scrn_text,
       l_tab_view_col_name,
       l_tab_id_domain,
       l_tab_mandatory_yn,
       g_tab_value,
       g_tab_descr,
       l_tab_format_mask   
     FROM
       nm_inv_type_attribs           ita,
       nm_inv_attribute_set_inv_attr nsia
     WHERE
       ita.ita_inv_type = pi_nit_inv_type
     AND
       ita.ita_attrib_name = nsia.nsia_ita_attrib_name
     AND
       nsia.nsia_nsit_nias_id = pi_nias_id
     AND
       nsia.nsia_nsit_nit_inv_type = pi_nit_inv_type
     ORDER BY
       ita.ita_disp_seq_no, ita.ita_attrib_name;
   END IF;

  IF c_returning_values_for_attrs
  THEN
  --
  --
  -- Build the anonymous block for dealing with the flexible attributes
  --
     append ('DECLARE',FALSE);
     append ('   c_inv_type CONSTANT nm_inv_types.nit_inv_type%TYPE := '||nm3flx.string(pi_nit_inv_type)||';');
  --
     IF l_rec_nit.nit_table_name IS NULL
      THEN
        g_rec_iit := nm3get.get_iit_all (pi_iit_ne_id         => pi_iit_ne_id
                                        ,pi_raise_not_found   => TRUE
                                        ,pi_not_found_sqlcode => c_not_found_sqlcode
                                        );
     --
        IF g_rec_iit.iit_inv_type != NVL(pi_nit_inv_type,nm3type.c_nvl)
         THEN
           hig.raise_ner (pi_appl               => nm3type.c_net
                         ,pi_id                 => 321
                         ,pi_supplementary_info => g_package_name||'.get_inv_flex_col_details:'||g_rec_iit.iit_inv_type||' != '||pi_nit_inv_type
                         );
        END IF;

--        nm_debug.DEBUG('got inv item rec');

     --
        FOR i IN 1..g_tab_attrib_name.COUNT
         LOOP
           IF g_tab_attrib_name(i) = c_iit_pk
            THEN
              l_pk_is_a_flex_attrib := TRUE;
           END IF;
        END LOOP;
     --
        IF   c_always_show_inv_pk
         AND NOT l_pk_is_a_flex_attrib
         THEN
           l_count := l_count + 1;
           po_flex_col_dets(l_count).ita_attrib_name           := c_iit_pk;
           po_flex_col_dets(l_count).ita_scrn_text             := 'Primary Key';
           po_flex_col_dets(l_count).ita_view_col_name         := po_flex_col_dets(l_count).ita_attrib_name;
           po_flex_col_dets(l_count).ita_id_domain             := NULL;
           po_flex_col_dets(l_count).ita_mandatory_yn          := 'Y';
           po_flex_col_dets(l_count).ita_mandatory_asterisk    := c_asterisk;
           po_flex_col_dets(l_count).iit_value                 := g_rec_iit.iit_primary_key;
           po_flex_col_dets(l_count).iit_description           := NULL;
           po_flex_col_dets(l_count).ita_update_allowed        := 'N';
           po_flex_col_dets(l_count).ita_format                := nm3type.c_varchar;
           po_flex_col_dets(l_count).ita_format_mask           := NULL;
        END IF;
     --
        IF   pi_display_xsp_if_reqd
         AND g_rec_iit.iit_x_sect IS NOT NULL
         THEN
           l_count := l_count + 1;
           po_flex_col_dets(l_count).ita_attrib_name           := 'IIT_X_SECT';
           po_flex_col_dets(l_count).ita_scrn_text             := 'XSP';
           po_flex_col_dets(l_count).ita_view_col_name         := po_flex_col_dets(l_count).ita_attrib_name;
           po_flex_col_dets(l_count).ita_id_domain             := NULL;
           po_flex_col_dets(l_count).ita_mandatory_yn          := 'Y';
           po_flex_col_dets(l_count).ita_mandatory_asterisk    := c_asterisk;
           po_flex_col_dets(l_count).iit_value                 := g_rec_iit.iit_x_sect;
           po_flex_col_dets(l_count).iit_description           := nm3inv.get_xsp_descr (p_inv_type   => g_rec_iit.iit_inv_type
                                                                                       ,p_x_sect_val => g_rec_iit.iit_x_sect
                                                                                       ,p_nw_type    => NULL
                                                                                       ,p_scl_class  => NULL
                                                                                       );
           po_flex_col_dets(l_count).ita_update_allowed        := 'Y';
           po_flex_col_dets(l_count).ita_format                := nm3type.c_varchar;
           po_flex_col_dets(l_count).ita_format_mask           := NULL;
           po_flex_col_dets(l_count).iit_lov_sql               :=            'SELECT *'
                                                                  ||CHR(10)||' FROM (SELECT xsr_x_sect_value lup_value'
                                                                  ||CHR(10)||'             ,xsr_x_sect_value lup_meaning'
                                                                  ||CHR(10)||'             ,xsr_descr        lup_descr'
                                                                  ||CHR(10)||'        FROM  xsp_restraints'
                                                                  ||CHR(10)||'       WHERE  xsr_ity_inv_code = '||nm3flx.string(l_rec_nit.nit_inv_type)
                                                                  ||CHR(10)||'      )'
                                                                  ||CHR(10)||'GROUP BY lup_value,lup_meaning,lup_descr';
        END IF;
     --
        IF   pi_display_admin_unit
         THEN
           DECLARE
              l_not_found EXCEPTION;
              PRAGMA EXCEPTION_INIT(l_not_found,-20500);
              c_count_store CONSTANT pls_integer := l_count;
              l_rec_nau nm_admin_units_all%ROWTYPE;
           BEGIN
              l_rec_nau := nm3get.get_nau_all (pi_nau_admin_unit    => g_rec_iit.iit_admin_unit
                                              ,pi_raise_not_found   => TRUE
                                              ,pi_not_found_sqlcode => -20500
                                              );
              l_count := l_count + 1;
              po_flex_col_dets(l_count).ita_attrib_name           := 'IIT_ADMIN_UNIT';
              po_flex_col_dets(l_count).ita_scrn_text             := 'Admin Unit';
              po_flex_col_dets(l_count).ita_view_col_name         := po_flex_col_dets(l_count).ita_attrib_name;
              po_flex_col_dets(l_count).ita_id_domain             := NULL;
              po_flex_col_dets(l_count).ita_mandatory_yn          := 'Y';
              po_flex_col_dets(l_count).ita_mandatory_asterisk    := c_asterisk;
              po_flex_col_dets(l_count).iit_value                 := g_rec_iit.iit_admin_unit;
              po_flex_col_dets(l_count).iit_meaning               := l_rec_nau.nau_unit_code;
              po_flex_col_dets(l_count).iit_description           := l_rec_nau.nau_name;
              po_flex_col_dets(l_count).ita_update_allowed        := 'Y';
              po_flex_col_dets(l_count).ita_format                := nm3type.c_varchar;
              po_flex_col_dets(l_count).ita_format_mask           := NULL;
              po_flex_col_dets(l_count).iit_lov_sql               :=            'SELECT TO_CHAR(nau_admin_unit) lup_value'
                                                                     ||CHR(10)||'      ,nau_unit_code lup_meaning'
                                                                     ||CHR(10)||'      ,nau_name lup_descr'
                                                                     ||CHR(10)||' FROM nm_admin_units'
                                                                     ||CHR(10)||'WHERE nau_admin_type = '||nm3flx.string(l_rec_nit.nit_admin_type)
                                                                     ||CHR(10)||' AND  EXISTS (SELECT 1'
                                                                     ||CHR(10)||'               FROM  v_nm_user_au_modes'
                                                                     ||CHR(10)||'              WHERE  nau_admin_unit = admin_unit'
                                                                     ||CHR(10)||'               AND   au_mode        = '||nm3flx.string(nm3type.c_normal)
                                                                     ||CHR(10)||'             )'
                                                                     ||CHR(10)||'ORDER BY nau_level, nau_unit_code';
           EXCEPTION
              WHEN l_not_found
               THEN
                 l_count := c_count_store;
           END;
        END IF;
     --
        IF   pi_display_start_date
         OR  g_rec_iit.iit_end_date IS NOT NULL
         THEN
           l_count := l_count + 1;
           po_flex_col_dets(l_count).ita_attrib_name           := 'IIT_START_DATE';
           po_flex_col_dets(l_count).ita_scrn_text             := 'Start Date';
           po_flex_col_dets(l_count).ita_view_col_name         := po_flex_col_dets(l_count).ita_attrib_name;
           po_flex_col_dets(l_count).ita_id_domain             := NULL;
           po_flex_col_dets(l_count).ita_mandatory_yn          := 'Y';
           po_flex_col_dets(l_count).ita_mandatory_asterisk    := c_asterisk;
           po_flex_col_dets(l_count).iit_value                 := TO_CHAR(g_rec_iit.iit_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
           po_flex_col_dets(l_count).iit_description           := NULL;
           po_flex_col_dets(l_count).ita_update_allowed        := 'N';
           po_flex_col_dets(l_count).ita_format                := nm3type.c_date;
           po_flex_col_dets(l_count).ita_format_mask           := NULL;
        END IF;
     --
        IF   pi_display_start_date
         OR  g_rec_iit.iit_end_date IS NOT NULL
         THEN
           l_count := l_count + 1;
           po_flex_col_dets(l_count).ita_attrib_name           := 'IIT_END_DATE';
           po_flex_col_dets(l_count).ita_scrn_text             := 'End Date';
           po_flex_col_dets(l_count).ita_view_col_name         := po_flex_col_dets(l_count).ita_attrib_name;
           po_flex_col_dets(l_count).ita_id_domain             := NULL;
           po_flex_col_dets(l_count).ita_mandatory_yn          := 'N';
           po_flex_col_dets(l_count).ita_mandatory_asterisk    := NULL;
           po_flex_col_dets(l_count).iit_value                 := TO_CHAR(g_rec_iit.iit_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
           po_flex_col_dets(l_count).iit_description           := NULL;
           po_flex_col_dets(l_count).ita_update_allowed        := 'Y';
           po_flex_col_dets(l_count).ita_format                := nm3type.c_date;
           po_flex_col_dets(l_count).ita_format_mask           := NULL;
        END IF;
     --
        IF   pi_display_descr
    --     AND g_rec_iit.iit_descr IS NOT NULL
         THEN
           l_count := l_count + 1;
           po_flex_col_dets(l_count).ita_attrib_name           := 'IIT_DESCR';
           po_flex_col_dets(l_count).ita_scrn_text             := 'Description';
           po_flex_col_dets(l_count).ita_view_col_name         := po_flex_col_dets(l_count).ita_attrib_name;
           po_flex_col_dets(l_count).ita_id_domain             := NULL;
           po_flex_col_dets(l_count).ita_mandatory_yn          := 'N';
           po_flex_col_dets(l_count).ita_mandatory_asterisk    := NULL;
           po_flex_col_dets(l_count).iit_value                 := g_rec_iit.iit_descr;
           po_flex_col_dets(l_count).iit_description           := NULL;
           po_flex_col_dets(l_count).ita_format                := nm3type.c_varchar;
           po_flex_col_dets(l_count).ita_format_mask           := NULL;
        END IF;
  --
  -- DC only include peo_invent_by_id for inventory
  -- cannot find a suitable constant so I am resorting to a hardcoded value
        IF l_rec_nit.nit_category = 'I'
        THEN

          l_count := l_count + 1;
          po_flex_col_dets(l_count).ita_attrib_name           := 'IIT_PEO_INVENT_BY_ID';
          po_flex_col_dets(l_count).ita_scrn_text             := 'Inspected By';
          po_flex_col_dets(l_count).ita_view_col_name         := po_flex_col_dets(l_count).ita_attrib_name;
          po_flex_col_dets(l_count).ita_id_domain             := NULL;
          po_flex_col_dets(l_count).ita_mandatory_yn          := 'N';
          po_flex_col_dets(l_count).ita_mandatory_asterisk    := NULL;
          DECLARE
             l_rec_hus hig_users%ROWTYPE;
          BEGIN
             l_rec_hus := nm3get.get_hus (pi_hus_user_id     => g_rec_iit.iit_peo_invent_by_id
                                         ,pi_raise_not_found => FALSE
                                         );
             po_flex_col_dets(l_count).iit_value              := l_rec_hus.hus_user_id;
             po_flex_col_dets(l_count).iit_meaning            := l_rec_hus.hus_username;
             po_flex_col_dets(l_count).iit_description        := l_rec_hus.hus_name;
          END;
          po_flex_col_dets(l_count).ita_format                := nm3type.c_number;
          po_flex_col_dets(l_count).ita_format_mask           := NULL;
          -- 0110010 CWS nm3gaz_qry.get_ngqv_lov_sql returned a sql statement that had incorrect aliases
          po_flex_col_dets(l_count).iit_lov_sql               := 'SELECT To_Char(hus_user_id) lup_value,hus_username lup_meaning, hus_name lup_descr'
                                                      ||CHR(10)||' FROM  hig_users'
                                                      ||CHR(10)||'ORDER BY hus_name';
                                                               /*nm3gaz_qry.get_ngqv_lov_sql (nm3gaz_qry.c_ngqt_item_type_type_inv
                                                                                             ,g_rec_iit.iit_inv_type
                                                                                             ,'IIT_PEO_INVENT_BY_ID'
                                                                                             );*/
        END IF;
  --
        l_data_source := g_package_name||'.g_rec_iit';
  --
     ELSE
        -- Foreign Table
        l_data_source := 'l_rec_ft';
        append ('   CURSOR '||c_ft_cursor_name||' (c_pk_val NUMBER) IS');
        append ('   SELECT *');
        append ('    FROM  '||l_rec_nit.nit_table_name);
        append ('   WHERE  '||l_rec_nit.nit_foreign_pk_column||' = c_pk_val;');
        append ('   '||l_data_source||' '||l_rec_nit.nit_table_name||'%ROWTYPE;');
        append ('   l_found  BOOLEAN;');
        g_ft_pk_val   := pi_iit_ne_id;
     END IF;
  --
  -- Build the rest of the anonymous block for dealing with the flexible attributes
  --
     append ('   PROCEDURE local_validate_flex (pi_attrib_name IN     VARCHAR2');
     append ('                                 ,pi_value       IN     VARCHAR2');
     append ('                                 ,po_value          OUT VARCHAR2');
     append ('                                 ,po_meaning        OUT VARCHAR2');
     append ('                                 ) IS');
     append ('   BEGIN');
     append ('      nm3inv.validate_flex_inv (p_inv_type               => c_inv_type');
     append ('                               ,p_attrib_name            => pi_attrib_name');
     append ('                               ,pi_value                 => pi_value');
     append ('                               ,po_value                 => po_value');
     append ('                               ,po_meaning               => po_meaning');
     append ('                               ,pi_validate_domain_dates => FALSE');
     append ('                               );');
     append ('   EXCEPTION');
     append ('      WHEN others');
     append ('       THEN');
     append ('         po_value   := pi_value;');
     append ('         po_meaning := Null;');
     append ('   END local_validate_flex;');
     append ('   PROCEDURE local_validate_flex (pi_attrib_name IN     VARCHAR2');
     append ('                                 ,pi_value       IN     DATE');
     append ('                                 ,po_value          OUT VARCHAR2');
     append ('                                 ,po_meaning        OUT VARCHAR2');
     append ('                                 ) IS');
     append ('   BEGIN');
     append ('      nm3inv.validate_flex_inv (p_inv_type               => c_inv_type');
     append ('                               ,p_attrib_name            => pi_attrib_name');
     append ('                               ,pi_value                 => pi_value');
     append ('                               ,po_value                 => po_value');
     append ('                               ,po_meaning               => po_meaning');
     append ('                               ,pi_validate_domain_dates => FALSE');
     append ('                               );');
     append ('   EXCEPTION');
     append ('      WHEN others');
     append ('       THEN');
     append ('         po_value   := TO_CHAR(pi_value,Sys_Context(''NM3CORE'',''USER_DATE_MASK''));');
     append ('         po_meaning := Null;');
     append ('   END local_validate_flex;');
     append ('BEGIN');
     IF l_rec_nit.nit_table_name IS NOT NULL
      THEN
        append ('   OPEN  '||c_ft_cursor_name||' ('||g_package_name||'.g_ft_pk_val);');
        append ('   FETCH '||c_ft_cursor_name||' INTO '||l_data_source||';');
        append ('   l_found := '||c_ft_cursor_name||'%FOUND;');
        append ('   CLOSE '||c_ft_cursor_name||';');
        append ('   IF NOT l_found');
        append ('    THEN');
        append ('      hig.raise_ner (pi_appl               => nm3type.c_hig');
        append ('                    ,pi_id                 => 67');
        append ('                    ,pi_sqlcode            => '||c_not_found_sqlcode);
        append ('                    ,pi_supplementary_info => '||nm3flx.string(l_rec_nit.nit_table_name||'.'||l_rec_nit.nit_foreign_pk_column||'=')||'||'||g_package_name||'.g_ft_pk_val');
        append ('                    );');
        append ('   END IF;');
     END IF;
     FOR i IN 1..g_tab_attrib_name.COUNT
      LOOP
        append ('   local_validate_flex (pi_attrib_name => '||g_package_name||'.g_tab_attrib_name('||i||')');
        append ('                       ,pi_value       => '||l_data_source||'.'||LOWER(g_tab_attrib_name(i)));
        append ('                       ,po_value       => '||g_package_name||'.g_tab_value('||i||')');
        append ('                       ,po_meaning     => '||g_package_name||'.g_tab_descr('||i||')');
        append ('                       );');
     END LOOP;
     append ('END;');
     --nm3tab_varchar.debug_tab_varchar(l_block);
     IF g_tab_attrib_name.COUNT > 0
      THEN
        nm3ddl.execute_tab_varchar (l_block);
     END IF;
  END IF;
--
   FOR i IN 1..g_tab_attrib_name.COUNT
    LOOP
      l_count := l_count + 1;
      po_flex_col_dets(l_count).ita_attrib_name           := g_tab_attrib_name(i);
      po_flex_col_dets(l_count).ita_scrn_text             := l_tab_scrn_text(i);
      po_flex_col_dets(l_count).ita_view_col_name         := l_tab_view_col_name(i);
      po_flex_col_dets(l_count).ita_id_domain             := l_tab_id_domain(i);
      po_flex_col_dets(l_count).ita_mandatory_yn          := l_tab_mandatory_yn(i);
      po_flex_col_dets(l_count).ita_format                := l_tab_format(i);
      po_flex_col_dets(l_count).ita_format_mask           := l_tab_format_mask(i);
      IF l_tab_mandatory_yn(i) = 'Y'
       THEN
         po_flex_col_dets(l_count).ita_mandatory_asterisk := c_asterisk;
      ELSE
         po_flex_col_dets(l_count).ita_mandatory_asterisk := NULL;
      END IF;
      IF c_returning_values_for_attrs
      THEN
        po_flex_col_dets(l_count).iit_value                 := g_tab_value(i);
        po_flex_col_dets(l_count).iit_description           := g_tab_descr(i);
      END IF;
   END LOOP;
--
   FOR i IN 1..po_flex_col_dets.COUNT
    LOOP
      IF c_returning_values_for_attrs
      THEN
        po_flex_col_dets(i).iit_ne_id                       := pi_iit_ne_id;
        po_flex_col_dets(i).iit_start_date                  := g_rec_iit.iit_start_date;
        po_flex_col_dets(i).iit_date_modified               := g_rec_iit.iit_date_modified;
        po_flex_col_dets(i).iit_admin_unit                  := g_rec_iit.iit_admin_unit;
      END IF;

      po_flex_col_dets(i).item_type_type                  := nm3gaz_qry.c_ngqt_item_type_type_inv;
      po_flex_col_dets(i).iit_inv_type                    := l_rec_nit.nit_inv_type;
      po_flex_col_dets(i).nit_category                    := l_rec_nit.nit_category;
      po_flex_col_dets(i).nit_table_name                  := l_rec_nit.nit_table_name;
      po_flex_col_dets(i).nit_lr_ne_column_name           := l_rec_nit.nit_lr_ne_column_name;
      po_flex_col_dets(i).nit_lr_st_chain                 := l_rec_nit.nit_lr_st_chain;
      po_flex_col_dets(i).nit_lr_end_chain                := l_rec_nit.nit_lr_end_chain;
      po_flex_col_dets(i).nit_foreign_pk_column           := l_rec_nit.nit_foreign_pk_column;
      po_flex_col_dets(i).nit_update_allowed              := l_rec_nit.nit_update_allowed;
      --
      -- Do not allow update of IIT_PRIMARY_KEY if this is a parent inv type and it has children
      --
      IF  (po_flex_col_dets(i).ita_attrib_name = c_iit_pk
          AND nm3invval.inv_type_is_parent_type (g_rec_iit.iit_inv_type)
          AND this_is_a_parent_item (g_rec_iit.iit_ne_id)
          )
      --
      -- Do not allow update of IIT_FOREIGN_KEY if this is a child inv type
      --
       OR (po_flex_col_dets(i).ita_attrib_name = 'IIT_FOREIGN_KEY'
          AND nm3invval.inv_type_is_child_type (g_rec_iit.iit_inv_type)
          )
       THEN
         po_flex_col_dets(i).ita_update_allowed           := 'N';
      ELSIF po_flex_col_dets(i).ita_update_allowed IS NULL
       THEN
         po_flex_col_dets(i).ita_update_allowed           := 'Y';
      END IF;
      po_flex_col_dets(i).iit_value_orig                  := po_flex_col_dets(i).iit_value;

      IF po_flex_col_dets(i).ita_id_domain IS NOT NULL
       THEN
         po_flex_col_dets(i).iit_lov_sql                  := get_ial_lov_sql (po_flex_col_dets(i).ita_id_domain);
      END IF;
   
      IF po_flex_col_dets(i).iit_meaning IS NULL
       THEN
         po_flex_col_dets(i).iit_meaning                  := po_flex_col_dets(i).iit_value;
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_inv_flex_col_details');
--
EXCEPTION
   WHEN l_iit_not_found
     OR e_no_inv_type
    THEN
      -- Inventory item not found or no type supplied
      --  don't bother returning anything
      NULL;
END get_inv_flex_col_details;

PROCEDURE get_inv_flex_col_details_char (pi_iit_ne_id           IN     nm_inv_items.iit_ne_id%TYPE
                                        ,pi_nit_inv_type        IN     nm_inv_types.nit_inv_type%TYPE
                                        ,pi_display_xsp_if_reqd IN     varchar2 DEFAULT 'TRUE'
                                        ,pi_display_descr       IN     varchar2 DEFAULT 'TRUE'
                                        ,pi_display_start_date  IN     varchar2 DEFAULT 'TRUE'
                                        ,pi_display_admin_unit  IN     varchar2 DEFAULT 'TRUE'
                                        ,pi_nias_id             IN     nm_inv_attribute_sets.nias_id%TYPE DEFAULT NULL
                                        ,pi_allow_null_ne_id    IN     varchar2 DEFAULT 'FALSE'
                                        ,po_flex_col_dets       IN OUT tab_rec_inv_flex_col_details
                                        ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_inv_flex_col_details_char');
--
   get_inv_flex_col_details (pi_iit_ne_id           => pi_iit_ne_id
                            ,pi_nit_inv_type        => pi_nit_inv_type
                            ,pi_display_xsp_if_reqd => nm3flx.char_to_boolean(pi_display_xsp_if_reqd)
                            ,pi_display_descr       => nm3flx.char_to_boolean(pi_display_descr)
                            ,pi_display_start_date  => nm3flx.char_to_boolean(pi_display_start_date)
                            ,pi_display_admin_unit  => nm3flx.char_to_boolean(pi_display_admin_unit)
                            ,pi_nias_id             => pi_nias_id
                            ,pi_allow_null_ne_id    => nm3flx.char_to_boolean(pi_allow_null_ne_id)
                            ,po_flex_col_dets       => po_flex_col_dets
                            );
-- 
   nm_debug.proc_end(g_package_name,'get_inv_flex_col_details_char');
--
END get_inv_flex_col_details_char;

--
-----------------------------------------------------------------------------
--
PROCEDURE add_ref_item (pi_ngq_id                     IN     nm_gaz_query.ngq_id%TYPE
                       ,pi_reference_item_type_type   IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                       ,pi_reference_item_type        IN     nm_gaz_query_types.ngqt_item_type%TYPE
                       ,pi_reference_item_id          IN     nm_assets_on_route_holding.narh_ne_id_in%TYPE
                       ) IS
--
   CURSOR cs_ngqt (c_ngq_id         nm_gaz_query.ngq_id%TYPE
                  ,c_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                  ,c_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                  ) IS
   SELECT ngqt_seq_no
    FROM  nm_gaz_query_types
   WHERE  ngqt_ngq_id         = c_ngq_id
    AND   ngqt_item_type_type = c_item_type_type
    AND   ngqt_item_type      = c_item_type;
--
   l_nqgt_seq_no nm_gaz_query_types.ngqt_seq_no%TYPE;
   l_found       boolean;
--
   l_rec_ngqt    nm_gaz_query_types%ROWTYPE;
   l_rec_ngqa    nm_gaz_query_attribs%ROWTYPE;
   l_rec_ngqv    nm_gaz_query_values%ROWTYPE;
--
BEGIN
--
   IF   pi_reference_item_type_type IS NOT NULL
    AND pi_reference_item_type      IS NOT NULL
    THEN
      OPEN  cs_ngqt (pi_ngq_id, pi_reference_item_type_type, pi_reference_item_type);
      FETCH cs_ngqt INTO l_nqgt_seq_no;
      l_found := cs_ngqt%FOUND;
      CLOSE cs_ngqt;
      IF NOT l_found
       THEN
         l_rec_ngqt.ngqt_ngq_id         := pi_ngq_id;
         l_rec_ngqt.ngqt_seq_no         := nm3seq.next_ngqt_seq_no_seq;
         l_rec_ngqt.ngqt_item_type_type := pi_reference_item_type_type;
         l_rec_ngqt.ngqt_item_type      := pi_reference_item_type;
         nm3ins.ins_ngqt(l_rec_ngqt);
         IF pi_reference_item_id IS NOT NULL
          THEN
            l_rec_ngqa.ngqa_ngq_id       := l_rec_ngqt.ngqt_ngq_id;
            l_rec_ngqa.ngqa_ngqt_seq_no  := l_rec_ngqt.ngqt_seq_no;
            l_rec_ngqa.ngqa_seq_no       := 1;
            l_rec_ngqa.ngqa_attrib_name  := NVL(nm3get.get_nit(pi_nit_inv_type=>pi_reference_item_type).nit_foreign_pk_column,'IIT_NE_ID');
            l_rec_ngqa.ngqa_operator     := nm3type.c_and_operator;
            l_rec_ngqa.ngqa_pre_bracket  := NULL;
            l_rec_ngqa.ngqa_post_bracket := NULL;
            l_rec_ngqa.ngqa_condition    := '=';
            nm3ins.ins_ngqa (l_rec_ngqa);
            l_rec_ngqv.ngqv_ngq_id       := l_rec_ngqa.ngqa_ngq_id;
            l_rec_ngqv.ngqv_ngqt_seq_no  := l_rec_ngqa.ngqa_ngqt_seq_no;
            l_rec_ngqv.ngqv_ngqa_seq_no  := l_rec_ngqa.ngqa_seq_no;
            l_rec_ngqv.ngqv_sequence     := 1;
            l_rec_ngqv.ngqv_value        := pi_reference_item_id;
            nm3ins.ins_ngqv(l_rec_ngqv);
         END IF;
         nm3gaz_qry.validate_query(pi_ngq_id);
      END IF;
   END IF;
--
END add_ref_item;
--
-----------------------------------------------------------------------------
--
FUNCTION is_ft_inv_type(pi_nit_rec nm_inv_types%ROWTYPE) RETURN BOOLEAN IS

BEGIN
 RETURN(pi_nit_rec.nit_table_name IS NOT NULL);
END is_ft_inv_type;
--
-----------------------------------------------------------------------------
-- 
FUNCTION is_ft_inv_type_on_network(pi_nit_rec nm_inv_types%ROWTYPE) RETURN BOOLEAN IS

BEGIN

  RETURN(is_ft_inv_type(pi_nit_rec => pi_nit_rec) 
          AND pi_nit_rec.nit_lr_ne_column_name IS NOT NULL);  -- columns to associate ft inv with network are specified i.e. this is on network
          --AND pi_nit_rec.nit_lr_st_chain  IS NOT NULL );
        --  AND pi_nit_rec.nit_lr_end_chain  IS NOT NULL);

END is_ft_inv_type_on_network;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_inv_datum_location_details (pi_iit_ne_id           IN     nm_inv_items.iit_ne_id%TYPE
                                         ,pi_nit_inv_type        IN     nm_inv_types.nit_inv_type%TYPE
                                         ,po_tab_datum_loc_dets  IN OUT tab_rec_datum_loc_dets
                                         ) IS
--
   l_count               pls_integer := 0;
--
   l_rec_nit             nm_inv_types%ROWTYPE;
   l_rec_nt              nm_types%ROWTYPE;
   l_rec_un              nm_units%ROWTYPE;
   l_rec_ne              nm_elements_all%ROWTYPE;
   l_rec_datum_loc_dets  rec_datum_loc_dets;
   l_tab_datum_loc_dets  tab_rec_datum_loc_dets;
   retval                tab_rec_datum_loc_dets;
--
   l_iit_not_found       EXCEPTION;
   c_not_found_sqlcode CONSTANT pls_integer := -20500;
   PRAGMA EXCEPTION_INIT (l_iit_not_found,-20500);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_inv_datum_location_details');
--
   po_tab_datum_loc_dets.DELETE;
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_nit_inv_type);
--
   IF l_rec_nit.nit_table_name IS NULL
    THEN
      -- This is "normal" inventory
      g_rec_iit := nm3get.get_iit_all (pi_iit_ne_id         => pi_iit_ne_id
                                      ,pi_raise_not_found   => TRUE
                                      ,pi_not_found_sqlcode => c_not_found_sqlcode
                                      );
      FOR cs_rec IN (SELECT *
                      FROM  nm_members
                     WHERE  nm_ne_id_in = pi_iit_ne_id
                     ORDER  BY nm_seq_no
                    )
       LOOP
         l_count                               := l_count + 1;
         l_rec_datum_loc_dets.datum_ne_id      := cs_rec.nm_ne_id_of;
         l_rec_datum_loc_dets.nm_begin_mp      := cs_rec.nm_begin_mp;
         l_rec_datum_loc_dets.nm_end_mp        := cs_rec.nm_end_mp;
         l_rec_datum_loc_dets.nm_seq_no        := cs_rec.nm_seq_no;
         l_rec_datum_loc_dets.nm_seg_no        := cs_rec.nm_seg_no;
         l_rec_datum_loc_dets.nm_true          := cs_rec.nm_true;
         l_rec_datum_loc_dets.nm_slk           := cs_rec.nm_slk;
         po_tab_datum_loc_dets(l_count)        := l_rec_datum_loc_dets;
      END LOOP;
--
   ELSIF is_ft_inv_type_on_network(pi_nit_rec => l_rec_nit) 
   THEN
      g_ft_pk_val := pi_iit_ne_id;
   --
      DECLARE
        l_sql        nm3type.max_varchar2;
        l_pl         nm_placement_array;
--        l_ne_id      NUMBER;
--        l_st_chain   NUMBER;
--        l_end_chain  NUMBER;
        l_ne_id      nm3type.tab_number;
        l_st_chain   nm3type.tab_number;
        l_end_chain  nm3type.tab_number;
        l_rec_ne     nm_elements%ROWTYPE;
      BEGIN
      --
        l_sql := 'SELECT '||l_rec_nit.nit_lr_ne_column_name
                     ||','||NVL(l_rec_nit.nit_lr_st_chain,'NULL')
                     ||','||NVL(NVL(l_rec_nit.nit_lr_end_chain,l_rec_nit.nit_lr_st_chain),'NULL')||
                  ' FROM '||l_rec_nit.nit_table_name||
                 ' WHERE '||l_rec_nit.nit_foreign_pk_column||' = :pk';
      --
        EXECUTE IMMEDIATE l_sql BULK COLLECT INTO l_ne_id, l_st_chain, l_end_chain USING pi_iit_ne_id;
      --
        FOR items IN 1..l_ne_id.COUNT
        LOOP
        --
          l_rec_ne := nm3get.get_ne ( pi_ne_id           => l_ne_id(items)
                                    , pi_raise_not_found => FALSE );
        --
        -------------------------------------------------------------
        -- Only get sub placement for Groups (or datums, works fine) nm_inv_types
        -------------------------------------------------------------
        --
          IF l_rec_ne.ne_type IN ('S','G')
          THEN 
          --
            IF is_linear ( pi_ne_id => l_ne_id(items) )
            --
            -- Task 0110562
            -- Make sure they actually have the columns set, even if it's located
            -- on a linear network
            --
            AND l_rec_nit.nit_lr_st_chain IS NOT NULL
            THEN
            --
            -- Linear Group of Sections - or a datum
            --
              BEGIN
                l_sql :=  'SELECT nm3pla.get_sub_placement(nm_placement('||l_rec_nit.nit_lr_ne_column_name
                                                                    ||','||l_rec_nit.nit_lr_st_chain
                                                                    ||','||NVL(l_rec_nit.nit_lr_end_chain,l_rec_nit.nit_lr_st_chain)
                                                                    ||', NULL ) ) '
               ||CHR(10)||'  FROM '||l_rec_nit.nit_table_name
               ||CHR(10)||' WHERE '||l_rec_nit.nit_foreign_pk_column||' = :pk'
               ||CHR(10)||'   AND '||l_rec_nit.nit_lr_ne_column_name||' = :ne_id';
              --
                nm_debug.debug(l_sql);
              --
                EXECUTE IMMEDIATE l_sql INTO l_pl USING pi_iit_ne_id, l_ne_id(items);
              --
                FOR i IN 1..l_pl.placement_count
                LOOP
                  DECLARE
                    l_ind NUMBER := l_tab_datum_loc_dets.COUNT+1;
                  BEGIN
                    l_tab_datum_loc_dets(l_ind).datum_ne_id := l_pl.get_entry(i).pl_ne_id;
                    l_tab_datum_loc_dets(l_ind).nm_begin_mp := l_pl.get_entry(i).pl_start;
                    l_tab_datum_loc_dets(l_ind).nm_end_mp   := l_pl.get_entry(i).pl_end;
                  END;
                END LOOP;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
              END;
            --
            ELSE
            --
            -- Non Linear Group - just return the datums for the whole groups memberships
            --
              BEGIN
              --
                SELECT *
                  BULK COLLECT INTO l_tab_datum_loc_dets
                  FROM (SELECT nm_ne_id_of datum_ne_id
                              ,NULL        datum_ne_unique
                              ,NULL        datum_ne_descr
                              ,NULL        datum_ne_nt_type
                              ,NULL        datum_ne_nt_descr
                              ,NULL        datum_length_unit
                              ,NULL        datum_length_unit_name
                              ,nm_begin_mp nm_begin_mp
                              ,nm_end_mp   nm_end_mp
                              ,nm_seq_no   nm_seq_no
                              ,nm_seg_no   nm_seg_no
                              ,nm_true     nm_true
                              ,nm_slk      nm_slk
                          FROM nm_members
                         WHERE nm_type = 'G'
                           AND nm_ne_id_in = l_ne_id(items)); 
              END;
            --
            END IF;
          --
          END IF;
        --
          DECLARE
            l_ind NUMBER := po_tab_datum_loc_dets.COUNT+1;
          BEGIN
          --
            FOR retvals IN 1..l_tab_datum_loc_dets.COUNT 
            LOOP
              po_tab_datum_loc_dets(l_ind).datum_ne_id             := l_tab_datum_loc_dets(retvals).datum_ne_id;
              po_tab_datum_loc_dets(l_ind).datum_ne_unique         := l_tab_datum_loc_dets(retvals).datum_ne_unique;
              po_tab_datum_loc_dets(l_ind).datum_ne_descr          := l_tab_datum_loc_dets(retvals).datum_ne_descr;
              po_tab_datum_loc_dets(l_ind).datum_ne_nt_type        := l_tab_datum_loc_dets(retvals).datum_ne_nt_type;
              po_tab_datum_loc_dets(l_ind).datum_ne_nt_descr       := l_tab_datum_loc_dets(retvals).datum_ne_nt_descr;
              po_tab_datum_loc_dets(l_ind).datum_length_unit       := l_tab_datum_loc_dets(retvals).datum_length_unit;
              po_tab_datum_loc_dets(l_ind).datum_length_unit_name  := l_tab_datum_loc_dets(retvals).datum_length_unit_name;
              po_tab_datum_loc_dets(l_ind).nm_begin_mp             := l_tab_datum_loc_dets(retvals).nm_begin_mp;
              po_tab_datum_loc_dets(l_ind).nm_end_mp               := l_tab_datum_loc_dets(retvals).nm_end_mp;
              po_tab_datum_loc_dets(l_ind).nm_seq_no               := l_tab_datum_loc_dets(retvals).nm_seq_no;
              po_tab_datum_loc_dets(l_ind).nm_seg_no               := l_tab_datum_loc_dets(retvals).nm_seg_no;
              po_tab_datum_loc_dets(l_ind).nm_true                 := l_tab_datum_loc_dets(retvals).nm_true;
              po_tab_datum_loc_dets(l_ind).nm_slk                  := l_tab_datum_loc_dets(retvals).nm_slk;
            END LOOP;
          --
          END;
          l_tab_datum_loc_dets.DELETE;
      --
        END LOOP;
      --
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
      END;
    --
   END IF;
--
   l_rec_nt.nt_type         := nm3type.c_nvl;
   l_rec_un.un_unit_id      := -1;
--
   FOR i IN 1..po_tab_datum_loc_dets.COUNT
    LOOP
      l_rec_datum_loc_dets                        := po_tab_datum_loc_dets(i);
      --
      l_rec_ne                                    := nm3get.get_ne_all (pi_ne_id => l_rec_datum_loc_dets.datum_ne_id);
      --
      l_rec_datum_loc_dets.datum_ne_unique        := l_rec_ne.ne_unique;
      l_rec_datum_loc_dets.datum_ne_descr         := l_rec_ne.ne_descr;
      l_rec_datum_loc_dets.datum_ne_nt_type       := l_rec_ne.ne_nt_type;
      --
      -- Only go off and get the other info if it has changed since last time through
      --
      IF l_rec_nt.nt_type != l_rec_ne.ne_nt_type
       THEN
         l_rec_nt                                 := nm3get.get_nt (pi_nt_type => l_rec_ne.ne_nt_type);
         IF l_rec_nt.nt_length_unit != l_rec_un.un_unit_id
          THEN
            l_rec_un                              := nm3get.get_un (pi_un_unit_id => l_rec_nt.nt_length_unit);
         END IF;
      END IF;
      --
      l_rec_datum_loc_dets.datum_ne_nt_descr      := l_rec_nt.nt_descr;
      l_rec_datum_loc_dets.datum_length_unit      := l_rec_un.un_unit_id;
      l_rec_datum_loc_dets.datum_length_unit_name := l_rec_un.un_unit_name;
      --
      po_tab_datum_loc_dets(i)                    := l_rec_datum_loc_dets;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_inv_datum_location_details');
--
EXCEPTION
   WHEN l_iit_not_found
    THEN
      -- Inventory item not found
      --  don't bother returning anything
      NULL;
--
END get_inv_datum_location_details;

--
-----------------------------------------------------------------------------
--
FUNCTION pop_route_loc_det_tab_from_pl(pi_pl_arr IN nm_placement_array
                                      ) RETURN nm3route_ref.tab_rec_route_loc_dets IS

  l_pl                     nm_placement;

  l_rec_nit                nm_inv_types%ROWTYPE;
  l_rec_ne                 nm_elements_all%ROWTYPE;
  l_rec_ngt                nm_group_types%ROWTYPE;
  l_rec_nt                 nm_types%ROWTYPE;
  l_rec_un                 nm_units%ROWTYPE;

  l_rec_route_loc_dets     nm3route_ref.rec_route_loc_dets;

  l_retval nm3route_ref.tab_rec_route_loc_dets;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'pop_route_loc_det_tab_from_pl');

  l_rec_nt.nt_type         := nm3type.c_nvl;
  l_rec_ngt.ngt_group_type := nm3type.c_nvl;
  l_rec_un.un_unit_id      := -1;
--
  FOR i IN 1..pi_pl_arr.placement_count
   LOOP
     --
     l_pl                                        := pi_pl_arr.get_entry(i);
     --
     l_rec_ne                                    := nm3get.get_ne_all (pi_ne_id           => l_pl.pl_ne_id);
     --
     -- Only go off and get the other info if it has changed since last time through
     --
     IF l_rec_nt.nt_type != l_rec_ne.ne_nt_type
      THEN
        l_rec_nt                                 := nm3get.get_nt     (pi_nt_type         => l_rec_ne.ne_nt_type);
        IF l_rec_un.un_unit_id != l_rec_nt.nt_length_unit
         THEN
           l_rec_un                              := nm3get.get_un     (pi_un_unit_id      => l_rec_nt.nt_length_unit);
        END IF;
     END IF;
     IF l_rec_ngt.ngt_group_type != NVL(l_rec_ne.ne_gty_group_type,nm3type.c_nvl)
      THEN
        l_rec_ngt                                := nm3get.get_ngt    (pi_ngt_group_type  => l_rec_ne.ne_gty_group_type
                                                                      ,pi_raise_not_found => FALSE
                                                                      );
     END IF;
     --
     l_rec_route_loc_dets.route_ne_id            := l_rec_ne.ne_id;
     l_rec_route_loc_dets.route_ne_unique        := l_rec_ne.ne_unique;
     l_rec_route_loc_dets.route_ne_descr         := l_rec_ne.ne_descr;
     l_rec_route_loc_dets.route_ne_nt_type       := l_rec_ne.ne_nt_type;
     l_rec_route_loc_dets.route_ne_nt_type_descr := l_rec_nt.nt_descr;
     l_rec_route_loc_dets.route_group_type       := l_rec_ne.ne_gty_group_type;
     l_rec_route_loc_dets.route_group_type_descr := l_rec_ngt.ngt_descr;
     l_rec_route_loc_dets.route_units            := l_rec_nt.nt_length_unit;
     l_rec_route_loc_dets.route_unit_name        := l_rec_un.un_unit_name;
     l_rec_route_loc_dets.nm_slk                 := l_pl.pl_start;
     l_rec_route_loc_dets.nm_end_slk             := l_pl.pl_end;
     l_rec_route_loc_dets.measure                := l_pl.pl_measure;

     l_retval(i) := l_rec_route_loc_dets;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'pop_route_loc_det_tab_from_pl');

  RETURN l_retval;

END pop_route_loc_det_tab_from_pl;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_inv_route_location_details (pi_iit_ne_id           IN     nm_inv_items.iit_ne_id%TYPE
                                         ,pi_nit_inv_type        IN     nm_inv_types.nit_inv_type%TYPE
                                         ,po_tab_route_loc_dets  IN OUT nm3route_ref.tab_rec_route_loc_dets
                                         ) IS

   l_pl_arr nm_placement_array := nm3pla.initialise_placement_array;

   l_rec_nit nm_inv_types%ROWTYPE;

BEGIN
--
   nm_debug.proc_start(g_package_name,'get_inv_route_location_details');
--
   po_tab_route_loc_dets.DELETE;
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_nit_inv_type);
--
   IF l_rec_nit.nit_table_name IS NULL
    THEN
      l_pl_arr := nm3pla.get_connected_chunks (pi_ne_id    => pi_iit_ne_id
                                              ,pi_obj_type => Sys_Context('NM3CORE','PREFERRED_LRM')
                                              );
      IF   l_pl_arr.is_empty
       AND Sys_Context('NM3CORE','PREFERRED_LRM') IS NOT NULL
       THEN
         l_pl_arr := nm3pla.get_connected_chunks (pi_ne_id    => pi_iit_ne_id
                                                 ,pi_obj_type => NULL
                                                 );
      END IF;
   ELSIF is_ft_inv_type_on_network(pi_nit_rec => l_rec_nit) THEN  
      l_pl_arr := get_foreign_placement_array (pi_iit_ne_id    => pi_iit_ne_id
                                              ,pi_nit_inv_type => pi_nit_inv_type
                                              ,pi_pref_lrm     => Sys_Context('NM3CORE','PREFERRED_LRM')
                                              );
      IF   l_pl_arr.is_empty
       AND Sys_Context('NM3CORE','PREFERRED_LRM') IS NOT NULL
       THEN
         l_pl_arr := get_foreign_placement_array (pi_iit_ne_id    => pi_iit_ne_id
                                                 ,pi_nit_inv_type => pi_nit_inv_type
                                                 ,pi_pref_lrm     => NULL
                                                 );
      END IF;
   END IF;

   po_tab_route_loc_dets := pop_route_loc_det_tab_from_pl(pi_pl_arr => l_pl_arr);

   nm_debug.proc_end(g_package_name,'get_inv_route_location_details');
--
END get_inv_route_location_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_foreign_placement_array (pi_iit_ne_id    IN nm_inv_items.iit_ne_id%TYPE
                                     ,pi_nit_inv_type IN nm_inv_types.nit_inv_type%TYPE
                                     ,pi_pref_lrm     IN nm_members.nm_obj_type%TYPE
                                     ) RETURN nm_placement_array IS
   l_tab_rec_datum_loc_dets tab_rec_datum_loc_dets;
   l_tab_nm_ne_id_in        nm3type.tab_number;
   l_pl_arr                 nm_placement_array := nm3pla.initialise_placement_array;
   l_pl_datums              nm_placement_array := nm3pla.initialise_placement_array;
BEGIN
   get_inv_datum_location_details (pi_iit_ne_id           => pi_iit_ne_id
                                  ,pi_nit_inv_type        => pi_nit_inv_type
                                  ,po_tab_datum_loc_dets  => l_tab_rec_datum_loc_dets
                                  );
 --
 -- Reassemble the datum placements into a placement array and for each Linear type
 -- get a superplacement
 --
   FOR i IN 1..l_tab_rec_datum_loc_dets.COUNT
   LOOP
     l_pl_datums := l_pl_datums.add_element
                             ( pl_ne_id   => l_tab_rec_datum_loc_dets(i).datum_ne_id
                             , pl_start   => l_tab_rec_datum_loc_dets(i).nm_begin_mp
                             , pl_end     => l_tab_rec_datum_loc_dets(i).nm_end_mp
                             , pl_mrg_mem => FALSE
                             );
   END LOOP;
 --
   DECLARE
     l_placement_array   nm_placement_array;
   BEGIN
     FOR i IN (SELECT nlt_nt_type 
                 FROM nm_linear_types
                WHERE nlt_gty_type IS NOT NULL
                  AND nlt_gty_type = NVL(pi_pref_lrm,nlt_gty_type))
     LOOP
       BEGIN
         l_placement_array := nm3pla.get_super_placement(l_pl_datums, i.nlt_nt_type);
         FOR z IN 1..l_placement_array.placement_count
         LOOP
           l_pl_arr := l_pl_arr.add_element 
                                  ( pl_pl      =>  l_placement_array.get_entry(z)
                                  , pl_mrg_mem =>  FALSE );
         END LOOP;
       EXCEPTION
         WHEN OTHERS THEN NULL;
       END;
     END LOOP;
   END;
 --
   RETURN l_pl_arr;
 --
 --   SELECT nm_ne_id_in
--    BULK  COLLECT
--    INTO  l_tab_nm_ne_id_in
--    FROM  nm_members
--         ,nm_group_types
--   WHERE  nm_ne_id_of     = l_tab_rec_datum_loc_dets(1).datum_ne_id
--    AND   nm_type         = 'G'
--    AND   nm_obj_type     = NVL(pi_pref_lrm,nm_obj_type)
--    AND   nm_obj_type     = ngt_group_type
--    AND   ngt_linear_flag = 'Y'
--   GROUP BY nm_ne_id_in;
-- --
--   FOR i IN 1..l_tab_nm_ne_id_in.COUNT
--    LOOP
--      BEGIN
--         l_pl_arr := l_pl_arr.add_element (pl_ne_id   => l_tab_nm_ne_id_in(i)
--                                          ,pl_start   => nm3lrs.get_set_offset (p_ne_parent_id => l_tab_nm_ne_id_in(i)
--                                                                               ,p_ne_child_id  => l_tab_rec_datum_loc_dets(1).datum_ne_id
--                                                                               ,p_offset       => l_tab_rec_datum_loc_dets(1).nm_begin_mp
--                                                                               )
--                                          ,pl_end     => nm3lrs.get_set_offset (p_ne_parent_id => l_tab_nm_ne_id_in(i)
--                                                                               ,p_ne_child_id  => l_tab_rec_datum_loc_dets(1).datum_ne_id
--                                                                               ,p_offset       => l_tab_rec_datum_loc_dets(1).nm_end_mp
--                                                                               )
--                                          ,pl_measure => 0
--                                          ,pl_mrg_mem => FALSE
--                                          );
--      EXCEPTION
--         WHEN others
--          THEN
--            NULL;
--      END;
--   END LOOP;
END get_foreign_placement_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_inv_flex_cols(pi_ignore_null_id     IN     varchar2 DEFAULT 'TRUE'
                            ,pio_flex_col_dets     IN OUT tab_rec_inv_flex_col_details) IS
--
   c_table_name CONSTANT varchar2(30) := 'NM_INV_ITEMS';
   l_rec_iit             nm_inv_items%ROWTYPE;
   l_rec_ita             nm_inv_type_attribs%ROWTYPE;
--
   l_block               nm3type.max_varchar2;
--
   PROCEDURE add_col_and_val_pair (p_col         varchar2
                                  ,p_value_old   varchar2
                                  ,p_value_new   varchar2 DEFAULT NULL
                                  ,p_datatype    varchar2 DEFAULT NULL
                                  ,p_format_mask varchar2 DEFAULT NULL
                                  ) IS
      c_i CONSTANT pls_integer := g_tab_flx_lock_col.COUNT+1;
   BEGIN
--      nm_debug.debug(p_col||'='||p_value_old||'='||p_value_new);
      g_tab_flx_lock_col(c_i)         := p_col;
      g_tab_flx_lock_value(c_i)       := p_value_old;
      g_tab_flx_lock_value_new(c_i)   := p_value_new;
      g_tab_flx_lock_datatype(c_i)    := p_datatype;
      g_tab_flx_lock_format_mask(c_i) := p_format_mask;
   END add_col_and_val_pair;
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_block := l_block||p_text;
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_inv_flex_cols');
--
   g_tab_flx_lock_col.DELETE;
   g_tab_flx_lock_value.DELETE;
   g_tab_flx_lock_value_new.DELETE;
   g_tab_flx_lock_datatype.DELETE;
   g_tab_flx_lock_format_mask.DELETE;
--
   IF pio_flex_col_dets.COUNT = 0
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'pio_flex_col_dets cannot be empty when calling '||g_package_name||'.lock_inv_flex_cols'
                    );
   END IF;
--
   IF pio_flex_col_dets(1).nit_table_name IS NOT NULL
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 285
                    );
   ELSIF pio_flex_col_dets(1).nit_update_allowed = 'N'
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 337
                    );
   END IF;
--
   FOR i IN 2..pio_flex_col_dets.COUNT
    LOOP
      IF pio_flex_col_dets(i).iit_ne_id != pio_flex_col_dets(i-1).iit_ne_id
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 28
                       ,pi_supplementary_info => 'the same ase inventory record must be referenced throughout the record when calling '||g_package_name||'.lock_inv_flex_cols'
                       );
      END IF;
   END LOOP;
--
   IF pio_flex_col_dets(1).iit_ne_id IS NOT NULL
     OR NOT nm3flx.char_to_boolean(pi_ignore_null_id)  --ne_id not null but deal with data anyway
   THEN

     l_rec_iit := nm3get.get_iit (pi_iit_ne_id => pio_flex_col_dets(1).iit_ne_id);
  --
  --   add_col_and_val_pair ('IIT_NE_ID',pi_iit_ne_id);
  --   add_col_and_val_pair ('IIT_INV_TYPE',pi_nit_inv_type);
  --   add_col_and_val_pair ('IIT_START_DATE',TO_CHAR(pi_iit_start_date,nm3type.c_full_date_time_format));
  --
     FOR i IN 1..pio_flex_col_dets.COUNT
      LOOP
  --      nm_debug.debug(i||'.......................................');
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_ne_id              : '||pio_flex_col_dets(i).iit_ne_id);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_inv_type           : '||pio_flex_col_dets(i).iit_inv_type);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_start_date         : '||pio_flex_col_dets(i).iit_start_date);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_date_modified      : '||pio_flex_col_dets(i).iit_date_modified);
  --      nm_debug.debug('pio_flex_col_dets('||i||').nit_table_name         : '||pio_flex_col_dets(i).nit_table_name);
  --      nm_debug.debug('pio_flex_col_dets('||i||').nit_lr_ne_column_name  : '||pio_flex_col_dets(i).nit_lr_ne_column_name);
  --      nm_debug.debug('pio_flex_col_dets('||i||').nit_lr_st_chain        : '||pio_flex_col_dets(i).nit_lr_st_chain);
  --      nm_debug.debug('pio_flex_col_dets('||i||').nit_lr_end_chain       : '||pio_flex_col_dets(i).nit_lr_end_chain);
  --      nm_debug.debug('pio_flex_col_dets('||i||').nit_foreign_pk_column  : '||pio_flex_col_dets(i).nit_foreign_pk_column);
  --      nm_debug.debug('pio_flex_col_dets('||i||').nit_update_allowed     : '||pio_flex_col_dets(i).nit_update_allowed);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_update_allowed     : '||pio_flex_col_dets(i).ita_update_allowed);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_attrib_name        : '||pio_flex_col_dets(i).ita_attrib_name);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_scrn_text          : '||pio_flex_col_dets(i).ita_scrn_text);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_view_col_name      : '||pio_flex_col_dets(i).ita_view_col_name);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_id_domain          : '||pio_flex_col_dets(i).ita_id_domain);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_lov_sql            : '||pio_flex_col_dets(i).iit_lov_sql);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_mandatory_yn       : '||pio_flex_col_dets(i).ita_mandatory_yn);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_mandatory_asterisk : '||pio_flex_col_dets(i).ita_mandatory_asterisk);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_format             : '||pio_flex_col_dets(i).ita_format);
  --      nm_debug.debug('pio_flex_col_dets('||i||').ita_format_mask        : '||pio_flex_col_dets(i).ita_format_mask);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_value_orig         : '||pio_flex_col_dets(i).iit_value_orig);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_value              : '||pio_flex_col_dets(i).iit_value);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_description        : '||pio_flex_col_dets(i).iit_description);
  --      nm_debug.debug('pio_flex_col_dets('||i||').iit_meaning            : '||pio_flex_col_dets(i).iit_meaning);
        add_col_and_val_pair (p_col         => pio_flex_col_dets(i).ita_attrib_name
                             ,p_value_old   => pio_flex_col_dets(i).iit_value_orig
                             ,p_value_new   => pio_flex_col_dets(i).iit_value
                             ,p_datatype    => pio_flex_col_dets(i).ita_format
                             ,p_format_mask => pio_flex_col_dets(i).ita_format_mask
                             );
     END LOOP;
  --
     -- Lock the inv items record
     append ('DECLARE',FALSE);
     append ('--');
     FOR i IN 1..g_tab_flx_lock_col.COUNT
      LOOP
        append ('   c_val_'||i||' CONSTANT '||nm3flx.i_t_e(g_tab_flx_lock_datatype(i)=nm3type.c_varchar,'nm3type.max_varchar2',g_tab_flx_lock_datatype(i))||' := ');
        IF g_tab_flx_lock_value(i) IS NULL
         THEN
           append ('Null',FALSE);
        ELSIF g_tab_flx_lock_datatype(i)=nm3type.c_varchar
         THEN
           append (nm3flx.string(g_tab_flx_lock_value(i)),FALSE);
        ELSIF g_tab_flx_lock_datatype(i)=nm3type.c_date
         THEN
           append ('hig.date_convert('||nm3flx.string(g_tab_flx_lock_value(i))||')',FALSE);
        ELSE
           append (g_tab_flx_lock_value(i),FALSE);
        END IF;
        append (';',FALSE);
     END LOOP;
     append ('--');
     append ('   CURSOR cs_lock IS');
     append ('   SELECT ROWID');
     append ('    FROM  '||c_table_name);
     append ('   WHERE  iit_ne_id         = :iit_ne_id');

-- GJ 31-MAY-2005
-- simplify the cursor to just lock on iit_ne_id - can't see why other
-- restriction is required and it was causing massive grief in forms such as nm0105
-- when a record was updated and then tried to do another update without re-querying
--
--     append ('    AND   iit_inv_type      = :iit_inv_type');
--     append ('    AND   iit_start_date    = :iit_start_date');
--     append ('    AND   iit_date_modified = :iit_date_modified');
--     FOR i IN 1..g_tab_flx_lock_col.COUNT
--      LOOP
--        IF g_tab_flx_lock_value(i) IS NULL
--         THEN
--           append ('    AND  ('||g_tab_flx_lock_col(i)||' IS NULL AND c_val_'||i||' IS NULL)');
--        ELSE
--           append ('    AND   '||g_tab_flx_lock_col(i)||' = c_val_'||i);
--        END IF;
--     END LOOP;
     append ('   FOR UPDATE OF iit_ne_id NOWAIT;');
     append ('--');
     append ('   l_found BOOLEAN;');
     append ('--');
     
  append ('    ex_locked exception;');
     append ('    PRAGMA EXCEPTION_INIT(ex_locked, -00054);');
 
     append ('BEGIN');
     append ('--');
--     append ('IF :iit_ne_id IS NOT NULL THEN');  
     append ('   OPEN  cs_lock;');
     append ('   FETCH cs_lock INTO '||g_package_name||'.g_flx_lock_rowid;');
     append ('   l_found := cs_lock%FOUND;');
     append ('   CLOSE cs_lock;');
--     append ('END IF;');  
     append ('--');
--     append ('   IF NOT l_found');
--     append ('    THEN');
--     append ('      hig.raise_ner (nm3type.c_net,328);');
--     append ('   END IF;');
     append ('--');
     append ('EXCEPTION');  
     append (' WHEN ex_locked THEN');
     append ('      hig.raise_ner (nm3type.c_net,328);');
     append (' WHEN others THEN');
     append ('      RAISE_APPLICATION_ERROR(-20001,sqlerrm);');    
      
     append ('END;');
--nm_dbug
--nm_debug.debug_on;
--     nm_debug.debug(l_block);
--nm_debug.debug_off;  
     EXECUTE IMMEDIATE l_block USING pio_flex_col_dets(1).iit_ne_id;
 
--                                    ,pio_flex_col_dets(1).iit_inv_type
--                                    ,pio_flex_col_dets(1).iit_start_date
--                                    ,pio_flex_col_dets(1).iit_date_modified;
  --   g_flx_lock_rowid := nm3lock.build_rowtype_and_lock_record (pi_table_name => c_table_name
  --                                                             ,pi_tab_col    => g_tab_flx_lock_col
  --                                                             ,pi_tab_value  => g_tab_flx_lock_value
  --                                                             );
  --
   END IF;

   nm_debug.proc_end(g_package_name,'lock_inv_flex_cols');
--
END lock_inv_flex_cols;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_inv_flex_cols (pi_perform_update     IN varchar2 DEFAULT 'TRUE'
                               ,pio_flex_col_dets     IN OUT tab_rec_inv_flex_col_details
                               ) IS
--
   c_perform_update CONSTANT boolean := nm3flx.char_to_boolean(pi_perform_update);

   c_table_name CONSTANT varchar2(30) := 'NM_INV_ITEMS_ALL';
--
   l_start               varchar2(10);
   l_block               nm3type.max_varchar2;
   l_some_changed_vals   boolean := FALSE;
   l_new_value           nm3type.max_varchar2;
   l_rc                  pls_integer;
--
BEGIN
--

--nm_debug.debug_on;
   nm_debug.proc_start(g_package_name,'update_inv_flex_cols');

--nm_debug.debug('pi_perform_update='||pi_perform_update);
--FOR i IN 1..pio_flex_col_dets.COUNT LOOP
--nm_debug.debug(pio_flex_col_dets(i).iit_value);
--END LOOP;
--
   IF c_perform_update
   THEN
     lock_inv_flex_cols   (pio_flex_col_dets     => pio_flex_col_dets);
  --
     IF NOT invsec.is_inv_item_updatable (p_iit_inv_type           => pio_flex_col_dets(1).iit_inv_type
                                         ,p_iit_admin_unit         => pio_flex_col_dets(1).iit_admin_unit
                                         ,pi_unrestricted_override => FALSE
                                         )
      THEN
        hig.raise_ner (pi_appl => nm3type.c_net
                      ,pi_id   => 339
                      );
     END IF;
  --
     FOR i IN 1..pio_flex_col_dets.COUNT
      LOOP
        IF   pio_flex_col_dets(i).ita_update_allowed                != 'Y'
         AND NVL(pio_flex_col_dets(i).iit_value_orig,nm3type.c_nvl) != NVL(pio_flex_col_dets(i).iit_value,nm3type.c_nvl)
         THEN
           hig.raise_ner (pi_appl               => nm3type.c_net
                         ,pi_id                 => 338
                         ,pi_supplementary_info => pio_flex_col_dets(i).ita_scrn_text
                         );
        END IF;
     END LOOP;
     -- now we've locked the record
  --
     l_block :=            'BEGIN'
                ||CHR(10)||'UPDATE '||LOWER(c_table_name);

     l_start := ' SET   ';
  --
     FOR i IN 1..g_tab_flx_lock_col.COUNT
      LOOP
        IF NVL(g_tab_flx_lock_value(i),nm3type.c_nvl) != NVL(g_tab_flx_lock_value_new(i),nm3type.c_nvl) -- Value is different
         AND g_tab_flx_lock_datatype(i) IS NOT NULL -- and its a flexible attribute
         THEN
           l_some_changed_vals := TRUE;
           IF g_tab_flx_lock_value_new(i) IS NULL
            THEN
              l_new_value := 'Null';
           ELSE
              l_new_value := g_tab_flx_lock_value_new(i);
              IF g_tab_flx_lock_datatype(i) = nm3type.c_number
               THEN -- Leave as is for NUMBER
                 NULL;
              ELSIF g_tab_flx_lock_datatype(i) = nm3type.c_date
               THEN -- Wrap a hig.date_convert for DATE
                 l_new_value := 'hig.date_convert('||nm3flx.string(l_new_value)||')';
              ELSE -- Stringify character fields
                 l_new_value := nm3flx.string(l_new_value);
              END IF;
              IF g_tab_flx_lock_format_mask(i) IS NOT NULL
                THEN
                  l_new_value := 'TO_CHAR('||l_new_value||','||nm3flx.string(g_tab_flx_lock_format_mask(i))||')';
              END IF;
           END IF;
           l_block := l_block||CHR(10)||l_start||RPAD(g_tab_flx_lock_col(i),30)||' = '||l_new_value;
           l_start := '      ,';
        END IF;
     END LOOP;
     l_block := l_block||CHR(10)||' WHERE ROWID = :c_rowid'
                       ||CHR(10)||'RETURNING iit_date_modified INTO '||g_package_name||'.g_iit_date_modified;'
                       ||CHR(10)||'END;';

--nm_dbug 
--nm_debug.debug_on;        
--     nm_debug.DEBUG('update block...');
--     nm_debug.DEBUG(l_block);
--     nm_debug.DEBUG(g_flx_lock_rowid);
     IF l_some_changed_vals
      THEN
        EXECUTE IMMEDIATE l_block USING g_flx_lock_rowid;
        l_rc := SQL%rowcount;
        FOR i IN 1..pio_flex_col_dets.COUNT
         LOOP
           pio_flex_col_dets(i).iit_date_modified := g_iit_date_modified;
        END LOOP;
     END IF;
   END IF;
--   nm_debug.debug(l_rc||' rows updated');
--nm_debug.debug_off;   
--
   nm_debug.proc_end(g_package_name,'update_inv_flex_cols');
--
END update_inv_flex_cols;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ial_lov_sql (pi_ial_domain IN nm_inv_attri_lookup.ial_domain%TYPE) RETURN varchar2 IS
   l_retval nm3type.max_varchar2;
BEGIN
--
   IF pi_ial_domain IS NOT NULL
    THEN
      l_retval :=            'SELECT ial_value   lup_value'
                  ||CHR(10)||'      ,ial_value   lup_meaning'
                  ||CHR(10)||'      ,ial_meaning lup_descr'
                  ||CHR(10)||' FROM  nm_inv_attri_lookup'
                  ||CHR(10)||'WHERE  ial_domain = '||nm3flx.string(pi_ial_domain)
                  ||CHR(10)||'ORDER BY ial_seq';
   END IF;
--
   RETURN l_retval;
--
END get_ial_lov_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE convert_units_to_specified (pi_narh_job_id         IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                     ,pi_required_un_unit_id IN     nm_units.un_unit_id%TYPE
                                     ,po_output_un_unit_id   IN OUT nm_units.un_unit_id%TYPE
                                     ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'convert_units_to_specified');
--
   IF NVL(pi_required_un_unit_id,po_output_un_unit_id) != po_output_un_unit_id
    THEN
--
      g_maximum_mp         := nm3unit.convert_unit (p_un_id_in  => po_output_un_unit_id
                                                   ,p_un_id_out => pi_required_un_unit_id
                                                   ,p_value     => g_maximum_mp
                                                   );
--
      UPDATE nm_assets_on_route_holding
       SET   narh_placement_begin_mp       = nm3unit.convert_unit (po_output_un_unit_id, pi_required_un_unit_id, narh_placement_begin_mp)
            ,narh_placement_end_mp         = nm3unit.convert_unit (po_output_un_unit_id, pi_required_un_unit_id, narh_placement_end_mp)
            ,narh_begin_reference_begin_mp = nm3unit.convert_unit (po_output_un_unit_id, pi_required_un_unit_id, narh_begin_reference_begin_mp)
            ,narh_begin_reference_end_mp   = nm3unit.convert_unit (po_output_un_unit_id, pi_required_un_unit_id, narh_begin_reference_end_mp)
            ,narh_end_reference_begin_mp   = nm3unit.convert_unit (po_output_un_unit_id, pi_required_un_unit_id, narh_end_reference_begin_mp)
            ,narh_end_reference_end_mp     = nm3unit.convert_unit (po_output_un_unit_id, pi_required_un_unit_id, narh_end_reference_end_mp)
      WHERE  narh_job_id                   = pi_narh_job_id;
--
      po_output_un_unit_id := pi_required_un_unit_id;
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'convert_units_to_specified');
--
END convert_units_to_specified;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_route_beg_mp_to_pl_meas (pi_narh_job_id       nm_assets_on_route_holding.narh_job_id%TYPE
                                         ,pi_ngq_id            nm_gaz_query.ngq_id%TYPE
                                         ,pi_output_un_unit_id nm_units.un_unit_id%TYPE
                                         ) IS
--
   l_rec_ngq               nm_gaz_query%ROWTYPE;

   l_begin_mp              nm_gaz_query.ngq_begin_mp%TYPE;

   l_route_units           nm_units.un_unit_id%TYPE;
   l_len_to_add_to_pl_meas number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'append_route_beg_mp_to_pl_meas');
--
   l_rec_ngq := nm3get.get_ngq (pi_ngq_id => pi_ngq_id);
--
   --
   -- If there is a begin mp specified - this can only happen if
   --  the ROI specified is based on a linear element - either a linear route or a datum
   --
   IF l_rec_ngq.ngq_source != nm3extent.c_route
     AND l_rec_ngq.ngq_begin_mp IS NOT NULL
   THEN
     hig.raise_ner (pi_id                 => nm3type.c_net
                   ,pi_appl               => 179
                   ,pi_supplementary_info => 'ngq_begin_mp specified where ngq_source = "'||l_rec_ngq.ngq_source||'"'
                   );
   END IF;

   --if begin mp is null set it to the minimum slk on the route (as this might not be zero)
   l_begin_mp := NVL(l_rec_ngq.ngq_begin_mp, nm3net.get_min_slk(pi_ne_id => l_rec_ngq.ngq_source_id));

   IF l_begin_mp != 0
    THEN
      --
      l_route_units := nm3net.get_nt_units_from_ne (p_ne_id => l_rec_ngq.ngq_source_id);
      --
      IF l_route_units IS NULL
       THEN
         hig.raise_ner (pi_id                 => nm3type.c_net
                       ,pi_appl               => 179
                       ,pi_supplementary_info => 'source is either non-linear or is not an element'
                       );
      END IF;
      --
      l_len_to_add_to_pl_meas := nm3unit.convert_unit (p_un_id_in  => l_route_units
                                                      ,p_un_id_out => pi_output_un_unit_id
                                                      ,p_value     => l_begin_mp
                                                      );
      --
      UPDATE nm_assets_on_route_holding
       SET   narh_placement_begin_mp = narh_placement_begin_mp + l_len_to_add_to_pl_meas
            ,narh_placement_end_mp   = narh_placement_end_mp   + l_len_to_add_to_pl_meas
      WHERE  narh_job_id             = pi_narh_job_id;
      --
   END IF;
--
   nm_debug.proc_end(g_package_name,'append_route_beg_mp_to_pl_meas');
--
END append_route_beg_mp_to_pl_meas;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_rest_of_chunk_of_cont_item (pi_narh_job_id       nm_assets_on_route_holding.narh_job_id%TYPE
                                         ,pi_ngq_id            nm_gaz_query.ngq_id%TYPE
                                         ,pi_output_un_unit_id nm_units.un_unit_id%TYPE
                                         ) IS
--
   --
   -- If this is being run on only part of a route then make sure we do not
   --  prematurely chop any continuous items
   --
   l_rec_ngq        nm_gaz_query%ROWTYPE;
   l_route_units    nm_units.un_unit_id%TYPE;
   l_nte_job_id     nm_nw_temp_extents.nte_job_id%TYPE;
--
   l_first_ne     nm_elements.ne_id%type ;


   l_length_of_partial number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_rest_of_chunk_of_cont_item');
--
   IF c_calculate_overlapping_inv
    THEN
--
      l_rec_ngq := nm3get.get_ngq (pi_ngq_id => pi_ngq_id);
   --
      IF l_rec_ngq.ngq_source = nm3extent.c_route
       THEN
         IF  l_rec_ngq.ngq_begin_mp IS NOT NULL
          OR l_rec_ngq.ngq_end_mp   IS NOT NULL
          THEN
            --
            l_route_units := nm3net.get_nt_units_from_ne (p_ne_id => l_rec_ngq.ngq_source_id);
            --
            SELECT SUM (nm_end_mp - nm_begin_mp)
             INTO  l_length_of_partial
             FROM  nm_rescale_write;
            --
            nm3extent.create_temp_ne (pi_source_id  => l_rec_ngq.ngq_source_id
                                     ,pi_source     => l_rec_ngq.ngq_source
                                     ,po_job_id     => l_nte_job_id
                                     );
            --
            
             DECLARE
               c_circ_ex_num      constant INTEGER := -20207 ;
               l_original_message          VARCHAR(2000) ;
               l_circular_ex      exception ;
               l_ne_id            nm_elements.ne_id%TYPE;
               l_rec_ne           nm_elements%ROWTYPE;
               PRAGMA EXCEPTION_INIT( l_circular_ex, -20207 );
             -- CWS 709250
             BEGIN             
               nm3rsc.rescale_temp_ne (l_nte_job_id);
             EXCEPTION
               WHEN l_circular_ex
               THEN
                 l_original_message := SUBSTR(SQLERRM,1,2000) ;
                 IF g_gos_ne_id is not null
                 THEN
                 BEGIN
                   SELECT DISTINCT(nm_ne_id_of)
                     INTO l_first_ne
                     FROM nm_members m1
                    WHERE nm_ne_id_in = g_gos_ne_id
                    AND NOT EXISTS
                   ( SELECT 1
                       FROM nm_members m2
                      WHERE nm_ne_id_in = g_gos_ne_id
                        AND m2.nm_seq_no < m1.nm_seq_no
                    )
                    AND ROWNUM = 1
                   ;
                   IF l_first_ne IS NOT NULL
                   THEN
                     nm3rsc.rescale_temp_ne(l_nte_job_id,NULL,l_first_ne);
                   ELSE
                     RAISE ;
                   END IF;
                 EXCEPTION
                   WHEN OTHERS
                   THEN
                     l_original_message := SUBSTR(l_original_message,
                                                  INSTR(l_original_message,TO_CHAR(c_circ_ex_num) || ':')+6) ;
                     l_original_message := LTRIM(l_original_message);
                     
                     raise_application_error(c_circ_ex_num,l_original_message);
                 END ;
               ELSE
                 RAISE ;
               END IF ;
             END ;         
            
            g_tab_nte_entire_route := nm3extent.get_tab_nte (l_nte_job_id);
            --
            sort_out_rest_for_begin_or_end (pi_narh_job_id  => pi_narh_job_id
                                           ,pi_source_id    => l_rec_ngq.ngq_source_id
                                           ,pi_measure      => 0
                                           ,pi_begin_or_end => c_begin
                                           );
            sort_out_rest_for_begin_or_end (pi_narh_job_id  => pi_narh_job_id
                                           ,pi_source_id    => l_rec_ngq.ngq_source_id
                                           ,pi_measure      => l_length_of_partial
--                                           ,pi_measure      => nm3unit.convert_unit (p_un_id_in  => l_route_units
--                                                                                    ,p_un_id_out => pi_output_un_unit_id
--                                                                                    ,p_value     => l_rec_ngq.ngq_end_mp-l_rec_ngq.ngq_begin_mp
--                                                                                    )
                                           ,pi_begin_or_end => c_end
                                           );
         END IF;
      END IF;
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'add_rest_of_chunk_of_cont_item');
--
END add_rest_of_chunk_of_cont_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE sort_out_rest_for_begin_or_end (pi_narh_job_id       nm_assets_on_route_holding.narh_job_id%TYPE
                                         ,pi_source_id         nm_gaz_query.ngq_source_id%TYPE
                                         ,pi_measure           number
                                         ,pi_begin_or_end      varchar2
                                         ) IS
--
   l_tab_narh_ne_id_in       nm3type.tab_number;
   l_tab_narh_ne_id_of       nm3type.tab_number;
   l_tab_narh_mp             nm3type.tab_number;
   l_tab_rowid               nm3type.tab_rowid;
--
   l_narh_ne_id_in           nm_assets_on_route_holding.narh_ne_id_in%TYPE;
   l_narh_ne_id_of_begin     nm_assets_on_route_holding.narh_ne_id_of_begin%TYPE;
   l_narh_begin_mp           nm_assets_on_route_holding.narh_begin_mp%TYPE;
   l_rowid                   ROWID;
--
   l_inv_nte_job_id          nm_nw_temp_extents.nte_job_id%TYPE;
   l_rec_nrw                 nm_rescale_write%ROWTYPE;
--
   l_tab_nte_inv_seg         nm3extent.tab_nte;
   l_tab_nte_intx            nm3extent.tab_nte;
--
   l_block                   nm3type.max_varchar2;
   l_cur                     nm3type.ref_cursor;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'sort_out_rest_for_begin_or_end');
--
   --
   -- Collect all records which exist at the beginning or end
   --  of the partial route
   --  and are continuous
   --

   g_narh_job_id   := pi_narh_job_id;
   g_measure       := pi_measure;
   l_block :=         'BEGIN'
           ||CHR(10)||'   SELECT /*+ INDEX (narh narh_pk) */'
           ||CHR(10)||'          narh.narh_ne_id_in'
           ||CHR(10)||'         ,narh.narh_ne_id_of_'||pi_begin_or_end
           ||CHR(10)||'         ,narh.narh_'||pi_begin_or_end||'_mp'
           ||CHR(10)||'         ,narh.ROWID narh_rowid'
           ||CHR(10)||'    BULK  COLLECT'
           ||CHR(10)||'    INTO  '||g_package_name||'.gh_tab_narh_ne_id_in'
           ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_ne_id_of_begin'
           ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_begin_mp'
           ||CHR(10)||'         ,'||g_package_name||'.gh_tab_narh_rowid'
           ||CHR(10)||'    FROM  nm_assets_on_route_holding narh'
           ||CHR(10)||'         ,nm_inv_types nit'
           ||CHR(10)||'   WHERE  narh.narh_job_id             = '||g_package_name||'.g_narh_job_id'
           ||CHR(10)||'    AND   narh.narh_placement_'||pi_begin_or_end||'_mp = '||g_package_name||'.g_measure'
           ||CHR(10)||'    AND   narh.narh_item_type_type     = '||nm3flx.string('I')
           ||CHR(10)||'    AND   nit.nit_inv_type             = narh.narh_item_type'
           ||CHR(10)||'    AND   nit.nit_pnt_or_cont          = '||nm3flx.string('C')||';'
           ||CHR(10)||'END;';
   --nm_debug.DEBUG(l_block);
   EXECUTE IMMEDIATE l_block;
   --
   l_tab_narh_ne_id_in := gh_tab_narh_ne_id_in;
   l_tab_narh_ne_id_of := gh_tab_narh_ne_id_of_begin;
   l_tab_narh_mp       := gh_tab_narh_begin_mp;
   l_tab_rowid         := gh_tab_narh_rowid;
--
--   nm_debug.DEBUG('pi_measure      : '||pi_measure);
--   nm_debug.DEBUG('pi_begin_or_end : '||pi_begin_or_end);
--   nm_debug.DEBUG('l_tab_narh_ne_id_in.COUNT : '||l_tab_narh_ne_id_in.COUNT);
--
   FOR i IN 1..l_tab_narh_ne_id_in.COUNT
    LOOP
--
      --
      -- Create a temp ne for the inventory item's location
      --
      nm3extent.create_temp_ne (pi_source_id  => l_tab_narh_ne_id_in(i)
                               ,pi_source     => nm3extent.c_route
                               ,po_job_id     => l_inv_nte_job_id
                               );
--
      --nm3extent.debug_temp_extents(pi_nte_job_id => l_inv_nte_job_id);
      --
      -- Rescale that temp ne to get measures for it
      --
      nm3rsc.rescale_temp_ne (p_nte_job_id => l_inv_nte_job_id
                             ,p_route_id   => pi_source_id);
--
      --nm3extent.debug_temp_extents(pi_nte_job_id => l_inv_nte_job_id);
      --
      -- Tidy up the temp NE
      --
      DELETE FROM nm_nw_temp_extents
      WHERE  nte_job_id = l_inv_nte_job_id;
--
      --
      -- Get the record from the rescale write table
      --  which holds the start of the item within the extent specified
      -- Get a placement array for that segment
      --  and then create a temp ne from it
      --
      nm3extent_o.create_temp_ne_from_pl(pi_pl_arr           => nm3pla.get_pl_from_rescale_write (pi_nm_seg_no => get_rescale_write (pi_ne_id => l_tab_narh_ne_id_of(i)
                                                                                                                                    ,pi_mp    => l_tab_narh_mp(i)
                                                                                                                                    ).nm_seg_no
                                                                                                  )
                                        ,po_job_id            => l_inv_nte_job_id
                                        ,pi_default_parent_id => pi_source_id
                                        );
--
      --nm3extent.debug_temp_extents(pi_nte_job_id => l_inv_nte_job_id);

      --
      -- Copy the temp ne into a table of ROWTYPE records
      --
      l_tab_nte_inv_seg := nm3extent.get_tab_nte (l_inv_nte_job_id);
--
      --
      -- Get the intersection of the route temp ne and this one
      --
      nm3extent.create_temp_ne_intx_of_temp_ne
                      (pi_tab_nte_1 => l_tab_nte_inv_seg
                      ,pi_tab_nte_2 => g_tab_nte_entire_route
                      ,po_tab_intx  => l_tab_nte_intx
                      );
      --
      -- Tidy up the temp NE
      --
      DELETE FROM nm_nw_temp_extents
      WHERE  nte_job_id = l_inv_nte_job_id;
--
      --
      -- Insert the intersection of the 2 temp nes
      --
      nm3extent.ins_tab_nte (l_tab_nte_intx);
      IF l_tab_nte_intx.COUNT > 0
       THEN
         --
         -- If there is an intersection
         --
         l_inv_nte_job_id := l_tab_nte_intx(1).nte_job_id;
         --nm3extent.debug_temp_extents(pi_nte_job_id => l_inv_nte_job_id);
         --
         --
         -- Rescale that temp ne to get the measures sorted
         --
         nm3rsc.rescale_temp_ne(p_nte_job_id => l_inv_nte_job_id
                               ,p_route_id   => pi_source_id);
         --nm_debug.debug_sql_string(p_sql => 'select * from nm_rescale_write order by nm_seq_no');
         --
         -- Tidy up the temp NE
          --
         DELETE FROM nm_nw_temp_extents
         WHERE  nte_job_id = l_inv_nte_job_id;
   --
         --
         -- Get the rescale write record for the measure point on the partial route extent
         --
         l_rec_nrw := get_rescale_write (pi_ne_id => l_tab_narh_ne_id_of(i)
                                        ,pi_mp    => l_tab_narh_mp(i)
                                        );
         g_measure := get_measure_from_rec_nrw (pi_rec_nrw => l_rec_nrw
                                               ,pi_mp      => l_tab_narh_mp(i)
                                                );
         --
         -- Find the true within the temp ne at the beginning/end of that segment
         --
         g_nm_seg_no := l_rec_nrw.nm_seg_no;
         g_rowid     := l_tab_rowid(i);
         l_block :=          'DECLARE'
                  ||CHR(10)||'   l_measure NUMBER := '||g_package_name||'.g_measure;'
                  ||CHR(10)||'   l_nm_true NUMBER;'
                  ||CHR(10)||'BEGIN'
                  ||CHR(10)||'   SELECT a.nm_true' || nm3flx.i_t_e(pi_begin_or_end = c_end, ' + (a.nm_end_mp - a.nm_begin_mp)', NULL)
                  ||CHR(10)||'    INTO  l_nm_true'
                  ||CHR(10)||'    FROM  nm_rescale_write a'
                  ||CHR(10)||'   WHERE  a.nm_seg_no = '||g_package_name||'.g_nm_seg_no'
                  ||CHR(10)||'    AND   nm_seq_no = (SELECT '||nm3flx.i_t_e(pi_begin_or_end=c_begin,'min','max')||'(b.nm_seq_no)'
                  ||CHR(10)||'                        FROM  nm_rescale_write b'
                  ||CHR(10)||'                       WHERE  b.nm_seg_no = a.nm_seg_no'
                  ||CHR(10)||'                      );'
--                   ||CHR(10)||'   nm_debug.debug(''l_nm_true = '' || l_nm_true);'
--                   ||CHR(10)||'   nm_debug.debug(''l_measure = '' || l_measure);'
                  ||CHR(10)||'   l_measure := l_nm_true - l_measure;'
                  ||CHR(10)||'   UPDATE nm_assets_on_route_holding'
                  ||CHR(10)||'    SET   narh_placement_'||pi_begin_or_end||'_mp = narh_placement_'||pi_begin_or_end||'_mp + l_measure'
                  ||CHR(10)||'   WHERE  ROWID = '||g_package_name||'.g_rowid;'
                  ||CHR(10)||'   '||g_package_name||'.g_measure := l_measure;'
                  ||CHR(10)||'   '||g_package_name||'.g_nm_true := l_nm_true;'
                  ||CHR(10)||'END;';
         --nm_debug.DEBUG(l_block);
         EXECUTE IMMEDIATE l_block;
      END IF;
--
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'sort_out_rest_for_begin_or_end');
--
END sort_out_rest_for_begin_or_end;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ele_flex_col_details (pi_ne_id               IN     nm_elements.ne_id%TYPE
                                   ,pi_ne_nt_type          IN     nm_elements.ne_nt_type%TYPE
                                   ,pi_display_descr       IN     boolean DEFAULT TRUE
                                   ,pi_display_start_date  IN     boolean DEFAULT TRUE
                                   ,pi_display_admin_unit  IN     boolean DEFAULT TRUE
                                   ,po_flex_col_dets       IN OUT tab_rec_inv_flex_col_details
                                   ) IS
--
   l_ele_not_found EXCEPTION;
   PRAGMA EXCEPTION_INIT (l_ele_not_found, -20999);
--
   l_rec_ele_flex_col_details rec_inv_flex_col_details;
--
   l_tab_ntc_column_name nm3type.tab_varchar30;
   l_tab_ntc_column_type nm3type.tab_varchar30;
   l_tab_ntc_mandatory   nm3type.tab_varchar4;
   l_tab_ntc_domain      nm3type.tab_varchar30;
   l_tab_ntc_query       nm3type.tab_varchar4000;
   l_tab_ntc_prompt      nm3type.tab_varchar80;
--
   l_block               nm3type.max_varchar2;
--
   l_rec_nt              nm_types%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ele_flex_col_details');
--
   po_flex_col_dets.DELETE;
--
   g_rec_ne := nm3get.get_ne_all (pi_ne_id             => pi_ne_id
                                 ,pi_not_found_sqlcode => -20999
                                 );
--
   IF g_rec_ne.ne_nt_type != NVL(pi_ne_nt_type,g_rec_ne.ne_nt_type)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 321
                    ,pi_supplementary_info => g_package_name||'.get_ele_flex_col_details:'||g_rec_ne.ne_nt_type||' != '||pi_ne_nt_type
                    );
   END IF;
--
   l_rec_nt := nm3get.get_nt (pi_nt_type => g_rec_ne.ne_nt_type);
   --
   l_rec_ele_flex_col_details.iit_ne_id              := pi_ne_id;
   l_rec_ele_flex_col_details.item_type_type         := nm3gaz_qry.c_ngqt_item_type_type_ele;
   l_rec_ele_flex_col_details.iit_inv_type           := g_rec_ne.ne_nt_type;
   l_rec_ele_flex_col_details.iit_start_date         := g_rec_ne.ne_start_date;
   l_rec_ele_flex_col_details.iit_date_modified      := g_rec_ne.ne_date_modified;
   l_rec_ele_flex_col_details.iit_admin_unit         := g_rec_ne.ne_admin_unit;
   l_rec_ele_flex_col_details.nit_category           := NULL;
   l_rec_ele_flex_col_details.nit_table_name         := NULL;
   l_rec_ele_flex_col_details.nit_lr_ne_column_name  := NULL;
   l_rec_ele_flex_col_details.nit_lr_st_chain        := NULL;
   l_rec_ele_flex_col_details.nit_lr_end_chain       := NULL;
   l_rec_ele_flex_col_details.nit_foreign_pk_column  := NULL;
   l_rec_ele_flex_col_details.nit_update_allowed     := 'N';
   l_rec_ele_flex_col_details.ita_update_allowed     := 'N';
   --
   -- NE_UNIQUE
   --
   l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_UNIQUE';
   l_rec_ele_flex_col_details.ita_scrn_text          := 'Unique';
   l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
   l_rec_ele_flex_col_details.ita_id_domain          := NULL;
   l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
   l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
   l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
   l_rec_ele_flex_col_details.ita_format             := nm3type.c_varchar;
   l_rec_ele_flex_col_details.ita_format_mask        := NULL;
   l_rec_ele_flex_col_details.iit_value_orig         := g_rec_ne.ne_unique;
   l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
   l_rec_ele_flex_col_details.iit_description        := g_rec_ne.ne_descr;
   l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value;
   po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
   --
   -- NE_DESCR
   --
   IF pi_display_descr
    THEN
      l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_DESCR';
      l_rec_ele_flex_col_details.ita_scrn_text          := 'Description';
      l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
      l_rec_ele_flex_col_details.ita_id_domain          := NULL;
      l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
      l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
      l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
      l_rec_ele_flex_col_details.ita_format             := nm3type.c_varchar;
      l_rec_ele_flex_col_details.ita_format_mask        := NULL;
      l_rec_ele_flex_col_details.iit_value_orig         := g_rec_ne.ne_descr;
      l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
      l_rec_ele_flex_col_details.iit_description        := NULL;
      l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value;
      po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
   END IF;
   --
   -- NE_NT_TYPE
   --
   l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_NT_TYPE';
   l_rec_ele_flex_col_details.ita_scrn_text          := 'Network Type';
   l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
   l_rec_ele_flex_col_details.ita_id_domain          := NULL;
   l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
   l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
   l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
   l_rec_ele_flex_col_details.ita_format             := nm3type.c_varchar;
   l_rec_ele_flex_col_details.ita_format_mask        := NULL;
   l_rec_ele_flex_col_details.iit_value_orig         := g_rec_ne.ne_nt_type;
   l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
   l_rec_ele_flex_col_details.iit_description        := l_rec_nt.nt_descr;
   l_rec_ele_flex_col_details.iit_meaning            := l_rec_nt.nt_unique;
   po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
   --
   -- NE_ADMIN_UNIT
   --
   IF pi_display_admin_unit
    THEN
      DECLARE
         l_rec_nau nm_admin_units_all%ROWTYPE;
      BEGIN
         l_rec_nau := nm3get.get_nau_all (pi_nau_admin_unit  => g_rec_ne.ne_admin_unit);
         l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_ADMIN_UNIT';
         l_rec_ele_flex_col_details.ita_scrn_text          := 'Admin Unit';
         l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
         l_rec_ele_flex_col_details.ita_id_domain          := NULL;
         l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
         l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
         l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
         l_rec_ele_flex_col_details.ita_format             := nm3type.c_date;
         l_rec_ele_flex_col_details.ita_format_mask        := NULL;
         l_rec_ele_flex_col_details.iit_value_orig         := g_rec_ne.ne_admin_unit;
         l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
         l_rec_ele_flex_col_details.iit_description        := l_rec_nau.nau_name;
         l_rec_ele_flex_col_details.iit_meaning            := l_rec_nau.nau_unit_code;
         po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
      END;
   END IF;
--
   --
   -- NE_GTY_GROUP_TYPE
   --
   IF g_rec_ne.ne_gty_group_type IS NOT NULL
    THEN
      DECLARE
         l_rec_ngt nm_group_types_all%ROWTYPE;
         l_min_slk         number;
         l_max_slk         number;
         l_max_true        number;
         l_total_route_len number;
         l_route_unit      nm_units.un_unit_name%TYPE;
         l_datum_unit      nm_units.un_unit_name%TYPE;
         CURSOR cs_first_element (c_ne_id_in nm_elements.ne_id%TYPE) IS
         SELECT nm3unit.get_unit_name(nm3net.get_nt_units_from_ne (nm_ne_id_of))
          FROM  nm_members
         WHERE  nm_ne_id_in = c_ne_id_in;
      BEGIN
         l_rec_ngt := nm3get.get_ngt_all (pi_ngt_group_type  => g_rec_ne.ne_gty_group_type);
         l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_GTY_GROUP_TYPE';
         l_rec_ele_flex_col_details.ita_scrn_text          := 'Group Type';
         l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
         l_rec_ele_flex_col_details.ita_id_domain          := NULL;
         l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
         l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
         l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
         l_rec_ele_flex_col_details.ita_format             := nm3type.c_date;
         l_rec_ele_flex_col_details.ita_format_mask        := NULL;
         l_rec_ele_flex_col_details.iit_value_orig         := g_rec_ne.ne_gty_group_type;
         l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
         l_rec_ele_flex_col_details.iit_description        := l_rec_ngt.ngt_descr;
         l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value_orig;
         po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
         IF l_rec_ngt.ngt_linear_flag = 'Y'
          THEN
       --
        l_min_slk         := nm3net.get_min_slk   (g_rec_ne.ne_id);
       l_max_slk         := nm3net.get_max_slk   (g_rec_ne.ne_id);
       l_max_true        := nm3net.get_max_true  (g_rec_ne.ne_id);
       l_total_route_len := nm3net.get_ne_length (g_rec_ne.ne_id);
       --
       IF l_rec_nt.nt_length_unit IS NOT NULL
        THEN
          l_route_unit   := nm3unit.get_unit_name (l_rec_nt.nt_length_unit);
       END IF;
       --
       OPEN  cs_first_element (g_rec_ne.ne_id);
       FETCH cs_first_element INTO l_datum_unit;
       CLOSE cs_first_element;
       --
            l_rec_ele_flex_col_details.ita_attrib_name        := 'MIN_SLK';
            l_rec_ele_flex_col_details.ita_scrn_text          := 'Min SLK';
            l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
            l_rec_ele_flex_col_details.ita_id_domain          := NULL;
            l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
            l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
            l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
            l_rec_ele_flex_col_details.ita_format             := nm3type.c_number;
            l_rec_ele_flex_col_details.ita_format_mask        := NULL;
            l_rec_ele_flex_col_details.iit_value_orig         := l_min_slk;
            l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
            l_rec_ele_flex_col_details.iit_description        := l_route_unit;
            l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value_orig;
            po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
       --
            l_rec_ele_flex_col_details.ita_attrib_name        := 'MAX_SLK';
            l_rec_ele_flex_col_details.ita_scrn_text          := 'Max SLK';
            l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
            l_rec_ele_flex_col_details.ita_id_domain          := NULL;
            l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
            l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
            l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
            l_rec_ele_flex_col_details.ita_format             := nm3type.c_number;
            l_rec_ele_flex_col_details.ita_format_mask        := NULL;
            l_rec_ele_flex_col_details.iit_value_orig         := l_max_slk;
            l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
            l_rec_ele_flex_col_details.iit_description        := l_route_unit;
            l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value_orig;
            po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
       --
            l_rec_ele_flex_col_details.ita_attrib_name        := 'MAX_TRUE';
            l_rec_ele_flex_col_details.ita_scrn_text          := 'Max True';
            l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
            l_rec_ele_flex_col_details.ita_id_domain          := NULL;
            l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
            l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
            l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
            l_rec_ele_flex_col_details.ita_format             := nm3type.c_number;
            l_rec_ele_flex_col_details.ita_format_mask        := NULL;
            l_rec_ele_flex_col_details.iit_value_orig         := l_max_true;
            l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
            l_rec_ele_flex_col_details.iit_description        := l_route_unit;
            l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value_orig;
            po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
       --
            l_rec_ele_flex_col_details.ita_attrib_name        := 'TOTAL_LEN';
            l_rec_ele_flex_col_details.ita_scrn_text          := 'Total Route Length';
            l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
            l_rec_ele_flex_col_details.ita_id_domain          := NULL;
            l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
            l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
            l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
            l_rec_ele_flex_col_details.ita_format             := nm3type.c_number;
            l_rec_ele_flex_col_details.ita_format_mask        := NULL;
            l_rec_ele_flex_col_details.iit_value_orig         := l_total_route_len;
            l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
            l_rec_ele_flex_col_details.iit_description        := l_datum_unit;
            l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value_orig;
            po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
         END IF;
      END;
   END IF;
   --
   -- NE_START_DATE
   --
   IF   pi_display_start_date
    OR  g_rec_ne.ne_end_date IS NOT NULL
    THEN
      l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_START_DATE';
      l_rec_ele_flex_col_details.ita_scrn_text          := 'Start Date';
      l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
      l_rec_ele_flex_col_details.ita_id_domain          := NULL;
      l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
      l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
      l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
      l_rec_ele_flex_col_details.ita_format             := nm3type.c_date;
      l_rec_ele_flex_col_details.ita_format_mask        := NULL;
      l_rec_ele_flex_col_details.iit_value_orig         := TO_CHAR(g_rec_ne.ne_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
      l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
      l_rec_ele_flex_col_details.iit_description        := NULL;
      l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value;
      po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
   END IF;
   --
   -- NE_END_DATE
   --
   IF   g_rec_ne.ne_end_date IS NOT NULL
    THEN
      l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_END_DATE';
      l_rec_ele_flex_col_details.ita_scrn_text          := 'End Date';
      l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
      l_rec_ele_flex_col_details.ita_id_domain          := NULL;
      l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
      l_rec_ele_flex_col_details.ita_mandatory_yn       := 'N';
      l_rec_ele_flex_col_details.ita_mandatory_asterisk := NULL;
      l_rec_ele_flex_col_details.ita_format             := nm3type.c_date;
      l_rec_ele_flex_col_details.ita_format_mask        := NULL;
      l_rec_ele_flex_col_details.iit_value_orig         := TO_CHAR(g_rec_ne.ne_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
      l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
      l_rec_ele_flex_col_details.iit_description        := NULL;
      l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value;
      po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
   END IF;
--
   --
   -- NE_LENGTH
   --
   IF g_rec_ne.ne_length IS NOT NULL
    THEN
      l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_LENGTH';
      l_rec_ele_flex_col_details.ita_scrn_text          := 'Length';
      l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
      l_rec_ele_flex_col_details.ita_id_domain          := NULL;
      l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
      l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
      l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
      l_rec_ele_flex_col_details.ita_format             := nm3type.c_date;
      l_rec_ele_flex_col_details.ita_format_mask        := NULL;
      l_rec_ele_flex_col_details.iit_value_orig         := g_rec_ne.ne_length;
      l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
      l_rec_ele_flex_col_details.iit_description        := nm3unit.get_unit_name(l_rec_nt.nt_length_unit);
      l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value_orig;
      po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
   END IF;
--
-- NODES
--
   IF l_rec_nt.nt_node_type IS NOT NULL
    THEN
      DECLARE
         l_rec_no nm_nodes_all%ROWTYPE;
      BEGIN
         l_rec_no := nm3get.get_no_all (pi_no_node_id => g_rec_ne.ne_no_start);
         l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_NO_START';
         l_rec_ele_flex_col_details.ita_scrn_text          := 'Start Node';
         l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
         l_rec_ele_flex_col_details.ita_id_domain          := NULL;
         l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
         l_rec_ele_flex_col_details.ita_mandatory_yn       := 'Y';
         l_rec_ele_flex_col_details.ita_mandatory_asterisk := c_asterisk;
         l_rec_ele_flex_col_details.ita_format             := nm3type.c_varchar;
         l_rec_ele_flex_col_details.ita_format_mask        := NULL;
         l_rec_ele_flex_col_details.iit_value_orig         := l_rec_no.no_node_id;
         l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
         l_rec_ele_flex_col_details.iit_description        := l_rec_no.no_descr;
         l_rec_ele_flex_col_details.iit_meaning            := l_rec_no.no_node_name;
         po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
         l_rec_no := nm3get.get_no_all (pi_no_node_id => g_rec_ne.ne_no_end);
         l_rec_ele_flex_col_details.ita_attrib_name        := 'NE_NO_END';
         l_rec_ele_flex_col_details.ita_scrn_text          := 'End Node';
         l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
         l_rec_ele_flex_col_details.iit_value_orig         := l_rec_no.no_node_id;
         l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
         l_rec_ele_flex_col_details.iit_description        := l_rec_no.no_descr;
         l_rec_ele_flex_col_details.iit_meaning            := l_rec_no.no_node_name;
         po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
      END;
   END IF;
--
-- "Proper" flexible attributes
--
   SELECT ntc_column_name
         ,ntc_column_type
         ,ntc_mandatory
         ,ntc_domain
         ,ntc_query
         ,ntc_prompt
    BULK  COLLECT
    INTO  l_tab_ntc_column_name
         ,l_tab_ntc_column_type
         ,l_tab_ntc_mandatory
         ,l_tab_ntc_domain
         ,l_tab_ntc_query
         ,l_tab_ntc_prompt
    FROM  nm_type_columns
   WHERE  ntc_nt_type   = g_rec_ne.ne_nt_type
    AND   ntc_displayed = 'Y'
   ORDER BY ntc_seq_no, ntc_prompt;
--
   g_tab_value.DELETE;
   l_block := 'BEGIN';
   FOR i IN 1..l_tab_ntc_column_name.COUNT
    LOOP
      l_block := l_block||CHR(10)||'   '||g_package_name||'.g_tab_value('||i||') := '||g_package_name||'.g_rec_ne.'||l_tab_ntc_column_name(i)||';';
   END LOOP;
   l_block := l_block||CHR(10)||'END;';
   IF l_tab_ntc_column_name.COUNT > 0
    THEN
      EXECUTE IMMEDIATE l_block;
   END IF;
--
   FOR i IN 1..l_tab_ntc_column_name.COUNT
    LOOP
      DECLARE
         l_auto_incl_sql nm3type.max_varchar2;
         l_id               nm3type.max_varchar2;
         l_flx_sql          nm3type.max_varchar2;   
      BEGIN
         --
         l_rec_ele_flex_col_details.ita_attrib_name        := l_tab_ntc_column_name(i);
         l_rec_ele_flex_col_details.ita_scrn_text          := l_tab_ntc_prompt(i);
         l_rec_ele_flex_col_details.ita_view_col_name      := l_rec_ele_flex_col_details.ita_attrib_name;
         l_rec_ele_flex_col_details.ita_id_domain          := l_tab_ntc_domain(i);
         l_rec_ele_flex_col_details.iit_lov_sql            := NULL;
         l_rec_ele_flex_col_details.iit_description        := NULL;
         --
   
         l_rec_ele_flex_col_details.ita_mandatory_yn       := l_tab_ntc_mandatory(i);
         l_rec_ele_flex_col_details.ita_mandatory_asterisk := nm3flx.i_t_e (l_tab_ntc_mandatory(i)='Y',c_asterisk,NULL);
         l_rec_ele_flex_col_details.ita_format             := l_tab_ntc_column_type(i);
         l_rec_ele_flex_col_details.ita_format_mask        := NULL;
         l_rec_ele_flex_col_details.iit_value_orig         := g_tab_value(i);
         l_rec_ele_flex_col_details.iit_value              := l_rec_ele_flex_col_details.iit_value_orig;
         --


-- GJ 03-JUN-05
-- Replace all of this logic below with a call to nm3flx.build_lov_sql_string to get a sql string
-- either based on inclusion, a domain , or an ntc query
-- 
--         l_auto_incl_sql                                   := nm3flx.build_inclusion_sql_string(g_rec_ne.ne_nt_type,l_tab_ntc_column_name(i));
         --
--         IF l_auto_incl_sql  IS NOT NULL
--          AND g_tab_value(i) IS NOT NULL
--          THEN
--            -- This is an auto-inclusion child column
--            l_auto_incl_sql := 'SELECT ne_descr FROM ('||l_auto_incl_sql||') WHERE ne_parent_col = :parent_value';
--            EXECUTE IMMEDIATE l_auto_incl_sql
--             INTO   l_rec_ele_flex_col_details.iit_description
--             USING  g_tab_value(i);
--            --
--         END IF;
         --
--         IF   l_tab_ntc_domain(i) IS NOT NULL
--          AND l_rec_ele_flex_col_details.iit_value_orig IS NOT NULL -- Only have a go to match if value present
--          THEN
--            hig.valid_fk_hco (a_hco_domain  => l_tab_ntc_domain(i)
--                             ,a_hco_code    => l_rec_ele_flex_col_details.iit_value_orig
--                             ,a_hco_meaning => l_rec_ele_flex_col_details.iit_description
--                             );
--         END IF;   


         l_flx_sql            := nm3flx.build_lov_sql_string (p_nt_type                    => g_rec_ne.ne_nt_type
                                                             ,p_column_name                => l_tab_ntc_column_name(i)
                                                             ,p_include_bind_variable      => FALSE
                                                             ,p_replace_bind_variable_with => Null
                                                             );
 
         IF l_flx_sql IS NOT NULL AND l_rec_ele_flex_col_details.iit_value_orig IS NOT NULL THEN   
            nm3extlov.validate_lov_value (p_statement => l_flx_sql
                                            ,p_value     => l_rec_ele_flex_col_details.iit_value_orig 
                                            ,p_meaning   => l_rec_ele_flex_col_details.iit_description 
                                            ,p_id        => l_id
           ,pi_match_col => 3 ) ;
         END IF;         
  

         --


         l_rec_ele_flex_col_details.iit_meaning            := l_rec_ele_flex_col_details.iit_value_orig;
         po_flex_col_dets(po_flex_col_dets.COUNT+1)        := l_rec_ele_flex_col_details;
         --
      END;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_ele_flex_col_details');
--
EXCEPTION
--
   WHEN l_ele_not_found
    THEN
      NULL;
--
END get_ele_flex_col_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_flex_col_details (pi_item_id             IN     nm_gaz_query_item_list.ngqi_item_id%TYPE
                               ,pi_item_type_type      IN     nm_gaz_query_item_list.ngqi_item_type_type%TYPE
                               ,pi_item_type           IN     nm_gaz_query_item_list.ngqi_item_type%TYPE
                               ,pi_display_xsp_if_reqd IN     boolean DEFAULT TRUE
                               ,pi_display_descr       IN     boolean DEFAULT TRUE
                               ,pi_display_start_date  IN     boolean DEFAULT TRUE
                               ,pi_display_admin_unit  IN     boolean DEFAULT TRUE
                               ,pi_nias_id             IN     nm_inv_attribute_sets.nias_id%TYPE DEFAULT NULL
                               ,pi_allow_null_ne_id    IN     boolean DEFAULT FALSE
                               ,po_flex_col_dets       IN OUT tab_rec_inv_flex_col_details
                               ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_flex_col_details');
--
   IF    NVL(pi_item_type_type,nm3gaz_qry.c_ngqt_item_type_type_inv) = nm3gaz_qry.c_ngqt_item_type_type_inv
    THEN
      get_inv_flex_col_details (pi_iit_ne_id           => pi_item_id
                               ,pi_nit_inv_type        => pi_item_type
                               ,pi_display_xsp_if_reqd => pi_display_xsp_if_reqd
                               ,pi_display_descr       => pi_display_descr
                               ,pi_display_start_date  => pi_display_start_date
                               ,pi_display_admin_unit  => pi_display_admin_unit
                               ,pi_nias_id             => pi_nias_id
                               ,pi_allow_null_ne_id    => pi_allow_null_ne_id
                               ,po_flex_col_dets       => po_flex_col_dets
                               );
   ELSIF pi_item_type_type = nm3gaz_qry.c_ngqt_item_type_type_ele
    THEN
      get_ele_flex_col_details (pi_ne_id               => pi_item_id
                               ,pi_ne_nt_type          => pi_item_type
                               ,pi_display_descr       => pi_display_descr
                               ,pi_display_start_date  => pi_display_start_date
                               ,pi_display_admin_unit  => pi_display_admin_unit
                               ,po_flex_col_dets       => po_flex_col_dets
                               );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_flex_col_details');
--
END get_flex_col_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_flex_col_details_char (pi_item_id             IN     nm_gaz_query_item_list.ngqi_item_id%TYPE
                                    ,pi_item_type_type      IN     nm_gaz_query_item_list.ngqi_item_type_type%TYPE
                                    ,pi_item_type           IN     nm_gaz_query_item_list.ngqi_item_type%TYPE
                                    ,pi_display_xsp_if_reqd IN     varchar2 DEFAULT 'TRUE'
                                    ,pi_display_descr       IN     varchar2 DEFAULT 'TRUE'
                                    ,pi_display_start_date  IN     varchar2 DEFAULT 'TRUE'
                                    ,pi_display_admin_unit  IN     varchar2 DEFAULT 'TRUE'
                                    ,pi_nias_id             IN     nm_inv_attribute_sets.nias_id%TYPE DEFAULT NULL
                                    ,pi_allow_null_ne_id    IN     varchar2 DEFAULT 'FALSE'
                                    ,po_flex_col_dets       IN OUT tab_rec_inv_flex_col_details
                                    ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_flex_col_details_char');
--
   get_flex_col_details (pi_item_id             => pi_item_id
                        ,pi_item_type_type      => pi_item_type_type
                        ,pi_item_type           => pi_item_type
                        ,pi_display_xsp_if_reqd => nm3flx.char_to_boolean(pi_display_xsp_if_reqd)
                        ,pi_display_descr       => nm3flx.char_to_boolean(pi_display_descr)
                        ,pi_display_start_date  => nm3flx.char_to_boolean(pi_display_start_date)
                        ,pi_display_admin_unit  => nm3flx.char_to_boolean(pi_display_admin_unit)
                        ,pi_nias_id             => pi_nias_id
                        ,pi_allow_null_ne_id    => nm3flx.char_to_boolean(pi_allow_null_ne_id)
                        ,po_flex_col_dets       => po_flex_col_dets
                        );
--
   nm_debug.proc_end(g_package_name,'get_flex_col_details_char');
--
END get_flex_col_details_char;
--
-----------------------------------------------------------------------------
--
FUNCTION store_narh(pi_narh_job_id     IN nm_assets_on_route_holding.narh_job_id%TYPE
                   ,pi_ngq_id          IN nm_gaz_query.ngq_id%TYPE
                   ,pi_entire          IN varchar2
                   ,pi_ref_type        IN hig_codes.hco_code%TYPE
                   ,pi_ref_inv_type    IN nm_inv_types.nit_inv_type%TYPE
                   ,pi_ref_inv_item_id IN nm_inv_items.iit_ne_id%TYPE
                   ,pi_ref_negative    IN varchar2
                   ,pi_results_unit_id IN nm_units.un_unit_id%TYPE
                   ,pi_nias_id         IN nm_inv_attribute_sets.nias_id%TYPE
                   ) RETURN nm_assets_on_route_store_head.narsh_job_id%TYPE IS

  c_true  CONSTANT varchar2(30) := nm3flx.boolean_to_char(TRUE);
  c_false CONSTANT varchar2(30) := nm3flx.boolean_to_char(FALSE);

  l_ngq_rec nm_gaz_query%ROWTYPE;

  l_roi_type        varchar2(4);
  l_roi_details_rec nm3extent.rec_roi_details;

  l_ref_iit_rec nm_inv_items%ROWTYPE;

  l_narsh_rec nm_assets_on_route_store_head%ROWTYPE;

  l_retval nm_assets_on_route_store_head.narsh_job_id%TYPE := pi_narh_job_id;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'store_narh');

  ---------------------------------------
  --delete any existing data for this job
  ---------------------------------------
  DELETE
    nm_assets_on_route_store_head narsh
  WHERE
    narsh.narsh_job_id = pi_narh_job_id;

  -------------
  --header data
  -------------
  l_ngq_rec := nm3get.get_ngq(pi_ngq_id => pi_ngq_id);

  l_roi_type := nm3extent.get_roi_type_from_nte_source(pi_source    => l_ngq_rec.ngq_source
                                                      ,pi_source_id => l_ngq_rec.ngq_source_id);

  l_roi_details_rec := nm3extent.get_roi_details(pi_roi_type => l_roi_type
                                                ,pi_roi_id   => l_ngq_rec.ngq_source_id);

  IF pi_ref_inv_item_id IS NOT NULL
  THEN
    l_ref_iit_rec := nm3get.get_iit(pi_iit_ne_id => pi_ref_inv_item_id);
  END IF;

  l_narsh_rec.narsh_job_id                     := pi_narh_job_id;
  l_narsh_rec.narsh_effective_date             := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
  l_narsh_rec.narsh_source_id                  := l_ngq_rec.ngq_source_id;
  l_narsh_rec.narsh_source                     := l_ngq_rec.ngq_source;
  l_narsh_rec.narsh_source_unique              := l_roi_details_rec.roi_name;
  l_narsh_rec.narsh_source_descr               := l_roi_details_rec.roi_descr;
  l_narsh_rec.narsh_source_min_offset          := l_roi_details_rec.roi_min_mp;
  l_narsh_rec.narsh_source_max_offset          := l_roi_details_rec.roi_max_mp;
--
-- Derive the Datum unit type if it's not been set in the Form
-- It appears to allow Non-Linear groups, so the ordering will be meaningless, but this
-- will at least let it run
--
  IF l_roi_details_rec.roi_datum_units IS NULL
  THEN
  --
    l_roi_details_rec.roi_datum_units := nm3get.get_nt(pi_nt_type=>nm3net.get_datum_nt(l_ngq_rec.ngq_source_id)).nt_length_unit;
  --
  END IF;
--
-- Derive the Route unit type if it's not been set in the Form
-- It appears to allow Non-Linear groups, so the ordering will be meaningless, but this
-- will at least let it run
--
  IF l_roi_details_rec.roi_units IS NULL
  THEN
  --
    l_roi_details_rec.roi_units := nm3get.get_nt ( pi_nt_type         => nm3get.get_ne(l_ngq_rec.ngq_source_id).ne_nt_type
                                                 , pi_raise_not_found => FALSE ).nt_length_unit;
    IF l_roi_details_rec.roi_units IS NULL
    THEN
      l_roi_details_rec.roi_units := l_roi_details_rec.roi_datum_units;
    END IF;
  --
  END IF;
--
  l_narsh_rec.narsh_source_length              := nm3unit.convert_unit(p_un_id_in  => l_roi_details_rec.roi_datum_units
                                                                      ,p_un_id_out => l_roi_details_rec.roi_units
                                                                      ,p_value     => nm3net.get_ne_length(p_ne_id => l_narsh_rec.narsh_source_id));
  l_narsh_rec.narsh_source_unit_id             := l_roi_details_rec.roi_units;
  l_narsh_rec.narsh_source_unit_name           := nm3unit.get_unit_name(p_un_id => l_narsh_rec.narsh_source_unit_id);
  l_narsh_rec.narsh_entire                     := pi_entire;
  IF pi_entire = 'Y'
  THEN
    l_narsh_rec.narsh_begin_mp                 := l_narsh_rec.narsh_source_min_offset;
    l_narsh_rec.narsh_end_mp                   := l_narsh_rec.narsh_source_max_offset;
  ELSE
    l_narsh_rec.narsh_begin_mp                 := l_ngq_rec.ngq_begin_mp;
    l_narsh_rec.narsh_end_mp                   := l_ngq_rec.ngq_end_mp;
  END IF;
  l_narsh_rec.narsh_begin_datum_ne_id          := l_ngq_rec.ngq_begin_datum_ne_id;
  l_narsh_rec.narsh_begin_datum_offset         := l_ngq_rec.ngq_begin_datum_offset;
  l_narsh_rec.narsh_end_datum_ne_id            := l_ngq_rec.ngq_end_datum_ne_id;
  l_narsh_rec.narsh_end_datum_offset           := l_ngq_rec.ngq_end_datum_offset;
  l_narsh_rec.narsh_ambig_sub_class            := l_ngq_rec.ngq_ambig_sub_class;
  l_narsh_rec.narsh_reference_type             := pi_ref_type;
  l_narsh_rec.narsh_reference_inv_type         := pi_ref_inv_type;
  IF l_narsh_rec.narsh_reference_inv_type IS NOT NULL
  THEN
    l_narsh_rec.narsh_reference_inv_type_descr := nm3inv.get_nit_descr(p_inv_type => pi_ref_inv_type);
  END IF;
  l_narsh_rec.narsh_reference_item_id          := pi_ref_inv_item_id;
  l_narsh_rec.narsh_reference_item_xsp         := l_ref_iit_rec.iit_x_sect;

  l_narsh_rec.narsh_ref_negative               := pi_ref_negative;
  l_narsh_rec.narsh_un_unit_id                 := pi_results_unit_id;
  l_narsh_rec.narsh_unit_name                  := nm3unit.get_unit_name(p_un_id => pi_results_unit_id);
  l_narsh_rec.narsh_nias_id                    := pi_nias_id;

  nm3ins.ins_narsh(p_rec_narsh => l_narsh_rec);

  -------------------------
  --asset data from results
  -------------------------
  INSERT INTO
    nm_assets_on_route_store(nars_job_id
                            ,nars_ne_id_in
                            ,nars_item_x_sect
                            ,nars_ne_id_of_begin
                            ,nars_begin_mp
                            ,nars_ne_id_of_end
                            ,nars_end_mp
                            ,nars_seq_no
                            ,nars_seg_no
                            ,nars_item_type_type
                            ,nars_item_type
                            ,nars_item_type_descr
                            ,nars_nm_type
                            ,nars_nm_obj_type
                            ,nars_placement_begin_mp
                            ,nars_placement_end_mp
                            ,nars_reference_item_id
                            ,nars_reference_item_x_sect
                            ,nars_begin_reference_begin_mp
                            ,nars_begin_reference_end_mp
                            ,nars_end_reference_begin_mp
                            ,nars_end_reference_end_mp)
  SELECT /*+ RULE */
    narh_job_id,
    narh_ne_id_in,
    narh_item_x_sect,
    narh_ne_id_of_begin,
    narh_begin_mp,
    narh_ne_id_of_end,
    narh_end_mp,
    narh_seq_no,
    narh_seg_no,
    narh_item_type_type,
    narh_item_type,
    nm3inv.get_nit_descr(narh_item_type),
    narh_nm_type,
    narh_nm_obj_type,
    narh_placement_begin_mp,
    narh_placement_end_mp,
    narh_reference_item_id,
    iit.iit_x_sect,
    narh_begin_reference_begin_mp,
    narh_begin_reference_end_mp,
    narh_end_reference_begin_mp,
    narh_end_reference_end_mp
  FROM
    nm_assets_on_route_holding narh,
    nm_inv_items               iit
  WHERE
    narh.narh_job_id = pi_narh_job_id
  AND
    narh.narh_reference_item_id = iit.iit_ne_id (+);

  --------------
  --summary data
  --------------
  INSERT INTO
    nm_assets_on_route_store_total(narst_job_id
                                  ,narst_inv_type
                                  ,narst_inv_type_descr
                                  ,narst_item_count
                                  ,narst_total_length)
  SELECT
    pi_narh_job_id,
    item_type,
    nm3inv.get_nit_descr(item_type),
    COUNT(item_id),
    nm3unit.convert_unit(l_narsh_rec.narsh_un_unit_id
                        ,l_roi_details_rec.roi_units
                        ,SUM(total_item_length))
  FROM
    (SELECT
       narh.narh_item_type                                            item_type,
       narh.narh_ne_id_in                                             item_id,
       SUM(narh.narh_placement_end_mp - narh.narh_placement_begin_mp) total_item_length
     FROM
       nm_assets_on_route_holding narh
     WHERE
       narh.narh_job_id = pi_narh_job_id
     GROUP BY
       narh.narh_item_type, narh.narh_ne_id_in)
  GROUP BY
    item_type;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'store_narh');

  RETURN l_retval;

END store_narh;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_non_linear_grp_membership (
  pi_iit_inv_type                IN     nm_inv_items.iit_inv_type%TYPE
, pi_iit_ne_id                   IN     nm_inv_items.iit_ne_id%TYPE
, po_tab_rec_nl_grp_membership   IN OUT nm3asset.tab_rec_nl_grp_membership )
IS
  l_rec_nit     nm_inv_types%ROWTYPE;
  b_join_to_mp  BOOLEAN ;
  b_linear      BOOLEAN := FALSE;
  l_sql         nm3type.max_varchar2;
  l_inv_members VARCHAR2(30);
  l_inv_pk      VARCHAR2(30);
  l_inv_ne_id   VARCHAR2(30);
  l_inv_st_mp   VARCHAR2(30);
  l_inv_end_mp  VARCHAR2(30);
  l_ne_id       NUMBER;
--
BEGIN
--
  -- Task 0109984
  -- Rewrite for FT Asset locations 
  --
--
  l_rec_nit  := nm3get.get_nit ( pi_nit_inv_type => pi_iit_inv_type );
--
  IF l_rec_nit.nit_table_name IS NULL
  THEN
    l_inv_members  := 'nm_members';
    l_inv_pk       := 'nm_ne_id_in';
    l_inv_ne_id    := 'nm_ne_id_of';
    l_inv_st_mp    := 'nm_begin_mp';
    l_inv_end_mp   := 'nm_end_mp';
    b_join_to_mp   := TRUE;
  ELSE
    l_inv_members  := l_rec_nit.nit_table_name;
    l_inv_pk       := l_rec_nit.nit_foreign_pk_column;
    l_inv_ne_id    := l_rec_nit.nit_lr_ne_column_name; 
    l_inv_st_mp    := l_rec_nit.nit_lr_st_chain;
    l_inv_end_mp   := NVL(l_rec_nit.nit_lr_end_chain,l_rec_nit.nit_lr_st_chain);
    b_join_to_mp   := (l_inv_st_mp IS NOT NULL);
  --
    IF l_inv_ne_id IS NOT NULL
    THEN
      BEGIN
        EXECUTE IMMEDIATE 'SELECT '||l_inv_ne_id||' FROM '||l_inv_members ||' WHERE '||l_inv_pk||' = '||pi_iit_ne_id
           INTO l_ne_id;
        b_linear := is_linear ( l_ne_id );
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
        WHEN TOO_MANY_ROWS THEN NULL;
      END;
    ELSE
      -- We cannot do anything without a network reference column set
      -- on the FT asset
      RETURN;
    END IF;
  END IF;
--
  l_sql := 'SELECT * FROM ('
  ||CHR(10)||' SELECT '
  ||CHR(10)||      'i.'||l_inv_pk||'     iit_ne_id '
  ||CHR(10)||    ', e.ne_id              ne_id'
  ||CHR(10)||    ', e.ne_unique          ne_unique'
  ||CHR(10)||    ', e.ne_descr           ne_descr'
  ||CHR(10)||    ', e.ne_gty_group_type  group_type'
  ||CHR(10)||    ', gt.ngt_descr         group_descr'
  ||CHR(10)||    ', e.ne_nt_type         nt_type'
  ||CHR(10)||' FROM nm_elements e '
  ||CHR(10)||   ' , nm_group_types gt '
  ||CHR(10)||   ' , nm_types t '
  ||CHR(10)||   ' , '||l_inv_members||' i '
  ||CHR(10)||   ' , nm_members g '
  ||CHR(10)||'WHERE t.nt_type = e.ne_nt_type '
  ||CHR(10)|| ' AND g.nm_ne_id_of = i.'||l_inv_ne_id||
--
  CASE 
    WHEN b_join_to_mp
    THEN
      CHR(10)|| ' AND ( (    i.'||l_inv_st_mp||' = i.'||l_inv_end_mp
    ||CHR(10)|| ' AND g.nm_begin_mp <= i.'||l_inv_st_mp
    ||CHR(10)|| ' AND g.nm_end_mp >= i.'||l_inv_st_mp||' )'
    ||CHR(10)|| '  OR (    i.'||l_inv_st_mp||' < i.'||l_inv_end_mp
    ||CHR(10)||      ' AND g.nm_begin_mp < i.'||l_inv_end_mp
    ||CHR(10)||      ' AND g.nm_end_mp > i.'||l_inv_st_mp||' ) '
    ||CHR(10)||  ' OR 1 = CASE WHEN nm3net.get_gty_type(i.'||l_inv_ne_id||') IS NOT NULL '
    ||CHR(10)||  '             THEN 1 '
    ||CHR(10)||  '             ELSE 2 '
    ||CHR(10)||  '        END )'
  END
--
  ||CHR(10)|| ' AND g.nm_ne_id_in = e.ne_id '
  ||CHR(10)|| ' AND i.'||l_inv_pk||' = :pi_iit_ne_id'
  ||CHR(10)|| ' AND gt.ngt_group_type = e.ne_gty_group_type '
  ||CHR(10)|| ' AND t.nt_linear = ''N'''||
--
  CASE
    WHEN NOT b_linear -- Non linear - append it's own location otherwise it won't appear anywhere else
    AND l_rec_nit.nit_table_name IS NOT NULL
    THEN
       CHR(10)|| ' UNION '
       ||CHR(10)|| ' SELECT '
       ||CHR(10)||      '  i.'||l_inv_pk||'    iit_ne_id '
       ||CHR(10)||      ', e.ne_id             ne_id'
       ||CHR(10)||      ', e.ne_unique         ne_unique'
       ||CHR(10)||      ', e.ne_descr          ne_descr'
       ||CHR(10)||      ', e.ne_gty_group_type group_type '
       ||CHR(10)||      ', g.ngt_descr         group_descr'
       ||CHR(10)||      ', e.ne_nt_type        nt_type'
       ||CHR(10)|| '   FROM nm_elements e, nm_group_types g, '||l_inv_members||' i '
       ||CHR(10)|| '  WHERE e.ne_id = '||l_ne_id
       ||CHR(10)|| '    AND g.ngt_group_type = e.ne_gty_group_type '
       ||CHR(10)|| '    AND i.'||l_inv_pk||' = '||pi_iit_ne_id
  END
--
  ||CHR(10)|| ')'
--
  ||CHR(10)|| ' GROUP BY iit_ne_id '
  ||CHR(10)|| '        , ne_id '
  ||CHR(10)|| '        , ne_unique '
  ||CHR(10)|| '        , ne_descr '
  ||CHR(10)|| '        , group_type '
  ||CHR(10)|| '        , group_descr '
  ||CHR(10)|| '        , nt_type '
  ||CHR(10)|| ' ORDER BY nt_Type';
--
  --nm_debug.debug_on;
  nm_debug.debug(l_sql);
  --nm_debug.debug_on;
--
  EXECUTE IMMEDIATE l_sql BULK COLLECT INTO po_tab_rec_nl_grp_membership
    USING IN pi_iit_ne_id;
--
END get_non_linear_grp_membership;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_type_for_nt_type(pi_nt_type IN nm_types.nt_type%TYPE) RETURN nm_group_inv_types.ngit_nit_inv_type%TYPE IS

  v_ngit_rec  nm_group_inv_types%ROWTYPE;

BEGIN

  -------------------------------------------------------------------
  -- For a given inventory type return a corresponding inventory type
  -------------------------------------------------------------------
  v_ngit_rec :=  nm3get.get_ngit(pi_ngit_ngt_group_type => pi_nt_type
                                ,pi_raise_not_found     => FALSE);

  RETURN (v_ngit_rec.ngit_nit_inv_type);

END;

--
-----------------------------------------------------------------------------
--
PROCEDURE get_inv_ele_flex_col_details (pi_ne_id                 IN     nm_elements_all.ne_id%TYPE
                                       ,po_flex_col_dets         IN OUT tab_rec_inv_flex_col_details
                                       ,pi_network_attribs_first IN     varchar2) IS

  tab_inv_flex_col_dets  tab_rec_inv_flex_col_details;
  tab_ele_flex_col_dets  tab_rec_inv_flex_col_details;

  v_ne_rec    nm_elements%ROWTYPE;
  l_nadl_rec  nm_nw_ad_link%ROWTYPE;

  v_recno PLS_INTEGER;

-- Amended by DC 22-9-04 - 698554
-- Norfolk have a requirement such that mai users
-- will not want to see core network attribibutes first in the popup
-- hence the reversed for loop on element attributes
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_inv_ele_flex_col_details');
--
   -------------------------------------------------------------
   -- For the given element get the element details
   -- ne_nt_type is required
   -------------------------------------------------------------
   v_ne_rec := nm3get.get_ne(pi_ne_id);
--   nm_debug.debug('NE_ID = '||pi_ne_id||'-'||nm3net.get_ne_unique(pi_ne_id));
   -------------------------
   -- Get network attributes
   -------------------------
   get_ele_flex_col_details (pi_ne_id               => pi_ne_id
                            ,pi_ne_nt_type          => v_ne_rec.ne_nt_type
                            ,po_flex_col_dets       => tab_ele_flex_col_dets
                             );
--   nm_debug.debug('Got ele flex col details');

   --------------------------------------------------------------------------------
   -- Get inventory attributes for the inventory type used to store network attribs
   -- if of course there is a corresponding inventory item type
   --------------------------------------------------------------------------------
   l_nadl_rec := nm3nwad.get_prim_nadl_from_ne_id
                   ( pi_nadl_ne_id     => pi_ne_id
                   , pi_raise_not_found   => FALSE);
--   nm_debug.debug('NADL Link - '||l_nadl_rec.nad_ne_id||'-'||l_nadl_rec.nad_iit_ne_id);

   get_inv_flex_col_details 
      ( pi_iit_ne_id           => l_nadl_rec.nad_iit_ne_id
      , pi_nit_inv_type        => nm3nwad.get_prim_inv_type_for_ne_id
                                   (pi_ne_id => v_ne_rec.ne_id)
      , po_flex_col_dets       => tab_inv_flex_col_dets);

   --------------------------------------------
   -- glue the 2 pl/sql tables together into 1
   --------------------------------------------
   IF pi_network_attribs_first = 'N' THEN

     FOR i IN 1..tab_inv_flex_col_dets.COUNT LOOP
       v_recno := po_flex_col_dets.COUNT +1;
       po_flex_col_dets(v_recno) := tab_inv_flex_col_dets(i);
     END LOOP;

     FOR e IN REVERSE 1..tab_ele_flex_col_dets.COUNT LOOP
       v_recno := po_flex_col_dets.COUNT +1;
       po_flex_col_dets(v_recno) := tab_ele_flex_col_dets(e);
     END LOOP;

   ELSE

     FOR e IN 1..tab_ele_flex_col_dets.COUNT LOOP
       v_recno := po_flex_col_dets.COUNT +1;
       po_flex_col_dets(v_recno) := tab_ele_flex_col_dets(e);
     END LOOP;

     FOR i IN 1..tab_inv_flex_col_dets.COUNT LOOP
       v_recno := po_flex_col_dets.COUNT +1;
       po_flex_col_dets(v_recno) := tab_inv_flex_col_dets(i);
     END LOOP;

   END IF;
--
   nm_debug.proc_end(g_package_name,'get_inv_ele_flex_col_details');
--
END get_inv_ele_flex_col_details;

--
-----------------------------------------------------------------------------
--
PROCEDURE set_gos_ne_id (pi_ne_id                 IN     nm_elements_all.ne_id%TYPE )
  is
begin
   g_gos_ne_id := pi_ne_id ;
end set_gos_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION count_asset_locations(pi_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE) RETURN PLS_INTEGER IS

 l_retval PLS_INTEGER;

BEGIN
 
 SELECT count(*)
 INTO l_retval
 from nm_members
 where nm_ne_id_in = pi_iit_ne_id;

 RETURN(l_retval);

END count_asset_locations;
--
-----------------------------------------------------------------------------
--
FUNCTION asset_is_located(pi_iit_ne_id nm_inv_items_all.iit_ne_id%TYPE) RETURN BOOLEAN IS

BEGIN
 RETURN(count_asset_locations(pi_iit_ne_id => pi_iit_ne_id) >0);
END asset_is_located;
--
-----------------------------------------------------------------------------
--
FUNCTION is_on_network(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN BOOLEAN IS

 
 l_dummy VARCHAR2(1);
 
 CURSOR c1 IS
 SELECT 'X'
 FROM   nm_inv_types
       ,nm_inv_nw
 WHERE  nit_inv_type = pi_nit_inv_type
 AND    nin_nit_inv_code = nit_inv_type;
 
BEGIN

 OPEN c1;
 FETCH c1 INTO l_dummy;
 CLOSE c1; 

 RETURN(l_dummy is not null);
 
END is_on_network;
--
-----------------------------------------------------------------------------
--
FUNCTION is_off_network(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN BOOLEAN IS

BEGIN
 RETURN(is_on_network(pi_nit_inv_type => pi_nit_inv_type)=FALSE);
END is_off_network;
--
-----------------------------------------------------------------------------
--
FUNCTION is_on_network_vc(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN VARCHAR2 IS

BEGIN

 RETURN(nm3flx.boolean_to_char(is_on_network(pi_nit_inv_type => pi_nit_inv_type)));

END is_on_network_vc;
--
-----------------------------------------------------------------------------
--
FUNCTION is_off_network_vc(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN VARCHAR2 IS

BEGIN

 RETURN(nm3flx.boolean_to_char(is_off_network(pi_nit_inv_type => pi_nit_inv_type)));

END is_off_network_vc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_category_for_inv_type(pi_nit_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN nm_inv_types_all.nit_category%TYPE IS

BEGIN

 RETURN(
          nm3get.get_nit_all(pi_nit_inv_type => pi_nit_inv_type).nit_category
    );

END get_category_for_inv_type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_icm_for_module(pi_icm_hmo_module        IN nm_inv_category_modules.icm_hmo_module%TYPE
                               ,pi_icm_updatable         IN nm_inv_category_modules.icm_hmo_module%TYPE DEFAULT NULL) RETURN nm3type.tab_varchar4 IS 
        

 l_retval nm3type.tab_varchar4;
 
 CURSOR c1 IS
 SELECT icm_nic_category
 FROM   nm_inv_category_modules
 WHERE  icm_hmo_module = UPPER(pi_icm_hmo_module)
 AND    icm_updatable = NVL(pi_icm_updatable,icm_updatable); -- restrict if a value is passed in as a param    

BEGIN

 OPEN c1;
 FETCH c1 BULK COLLECT INTO l_retval;
 CLOSE c1;
 
 RETURN(l_retval);

END get_tab_icm_for_module;        
--
-----------------------------------------------------------------------------
--        
END nm3asset;
/

