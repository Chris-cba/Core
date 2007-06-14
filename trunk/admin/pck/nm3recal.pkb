CREATE OR REPLACE PACKAGE BODY nm3recal IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3recal.pkb	1.23 01/16/06
--       Module Name      : nm3recal.pkb
--       Date into SCCS   : 06/01/16 16:26:43
--       Date fetched Out : 07/06/13 14:13:13
--       SCCS Version     : 1.23
--
--
--   Author : Jonathan Mills
--
--   Recalibration Package
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3recal.pkb	1.23 01/16/06"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30) := 'nm3recal';
--
   g_tab_rec_nm      nm3type.tab_rec_nm;
--
   g_gis_call        boolean := FALSE;
--
-----------------------------------------------------------------------------
--
   g_recal_exception EXCEPTION;
   g_recal_exc_code  number         := -20001;                              --Initial Value
   g_recal_exc_msg   varchar2(2000) := 'Unspecified error within NM3RECAL'; --Initial Value
--
   g_tab_ne_id      nm3type.tab_number;
   g_tab_begin_mp   nm3type.tab_number;
   g_tab_end_mp     nm3type.tab_number;
   g_tab_start_date nm3type.tab_date;
--
   g_element_length     nm_elements.ne_length%TYPE;
   g_new_element_length nm_elements.ne_length%TYPE;
   g_dec_places         number;
   g_sign               number(1);
   g_recal_begin_mp     nm_members.nm_begin_mp%TYPE;
   g_recal_new_length_to_end nm_elements.ne_length%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE reset_for_return;
--
-----------------------------------------------------------------------------
--
PROCEDURE shift_other_products (pi_ne_id          nm_elements.ne_id%TYPE
                               ,pi_shift_start_mp number
                               ,pi_shift_distance number
                               );
--
-----------------------------------------------------------------------------
--
PROCEDURE recalibrate_other_products (pi_ne_id             nm_elements.ne_id%TYPE
                                     ,pi_recal_start_point number
                                     ,pi_length_ratio      number
                                     ,pi_dec_places        number
                                     ,pi_new_datum_length  number
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
PROCEDURE recalibrate_individual_member (pi_ne_id_in       IN nm_members.nm_ne_id_in%TYPE
                                        ,pi_ne_id_of       IN nm_members.nm_ne_id_of%TYPE
                                        ,pi_begin_mp       IN nm_members.nm_begin_mp%TYPE
                                        ,pi_end_mp         IN nm_members.nm_end_mp%TYPE
                                        ,pi_start_date     IN date
                                        ,pi_recal_start_mp IN nm_members.nm_begin_mp%TYPE
                                        ,pi_length_ratio   IN number
                                        );
--
-----------------------------------------------------------------------------
--
PROCEDURE process_individual_shift (pi_ne_id_in       IN nm_members.nm_ne_id_in%TYPE
                                   ,pi_ne_id_of       IN nm_members.nm_ne_id_of%TYPE
                                   ,pi_begin_mp       IN nm_members.nm_begin_mp%TYPE
                                   ,pi_end_mp         IN nm_members.nm_end_mp%TYPE
                                   ,pi_start_date     IN date
                                   ,pi_shift_distance IN nm_elements.ne_length%TYPE
                                   ,pi_shift_start_mp IN nm_members.nm_begin_mp%TYPE
                                   );
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_global_variables (pi_ne_id IN nm_elements.ne_id%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE gis_recalibrate_section (pi_ne_id             IN nm_elements.ne_id%TYPE
                                  ,pi_begin_mp          IN nm_members.nm_begin_mp%TYPE
                                  ,pi_new_length_to_end IN nm_elements.ne_length%TYPE
                                  ) IS
BEGIN
   g_gis_call := TRUE;
   recalibrate_section (pi_ne_id
                       ,pi_begin_mp
                       ,pi_new_length_to_end
                       );
   g_gis_call := FALSE;
EXCEPTION
   WHEN others
    THEN
      g_gis_call := FALSE;
      RAISE;
END gis_recalibrate_section;
--
-----------------------------------------------------------------------------
--
PROCEDURE recalibrate_section (pi_ne_id             IN nm_elements.ne_id%TYPE
                              ,pi_begin_mp          IN nm_members.nm_begin_mp%TYPE
                              ,pi_new_length_to_end IN nm_elements.ne_length%TYPE
                              ) IS
--
   l_length_ratio      number;
   l_new_length        number;
   l_old_length_to_end number;
   l_begin_mp          number := NVL(pi_begin_mp,0);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'recalibrate_section');
--
   nm3ausec.set_status(nm3type.c_off);

   nm3merge.set_nw_operation_in_progress;
--
   g_sign := NULL;
--
   IF pi_new_length_to_end IS NULL
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 107
                   ,pi_supplementary_info => 'pi_new_length_to_end'
                   );
   END IF;
--
   g_tab_rec_nm.DELETE;
--
   g_recal_begin_mp          := l_begin_mp;
   g_recal_new_length_to_end := pi_new_length_to_end;
--
   populate_global_variables (pi_ne_id);
--
   IF l_begin_mp > g_element_length
    THEN
      g_recal_exc_code := -20053;
      g_recal_exc_msg  := 'Recalibrate BEGIN_MP ('||l_begin_mp||') is greater than element NE_LENGTH ('||g_element_length||')';
      RAISE g_recal_exception;
   END IF;
--
   l_old_length_to_end := g_element_length - l_begin_mp;
--
   l_length_ratio := pi_new_length_to_end / l_old_length_to_end;
--
   IF l_old_length_to_end = pi_new_length_to_end
    THEN
      g_recal_exc_code := -20054;
      g_recal_exc_msg  := 'Nothing to do. NEW and OLD lengths are identical';
      RAISE g_recal_exception;
   END IF;
--
-- Increase the length of the element
--
   UPDATE nm_elements
    SET   ne_length = ne_length + (pi_new_length_to_end - l_old_length_to_end)
   WHERE  ne_id     = pi_ne_id;
--
   l_new_length := nm3get.get_ne (pi_ne_id => pi_ne_id).ne_length;
--
-- Modify NNU_CHAIN for this element
--
   UPDATE nm_node_usages
    SET   nnu_chain     = nnu_chain + (pi_new_length_to_end - l_old_length_to_end)
   WHERE  nnu_ne_id     = pi_ne_id
    AND   nnu_node_type = 'E';
--
-- Added by AE
-- RAC - Recalibrate the element shape
--
   IF not nm3sdm.prevent_operation(pi_ne_id) -- JM 21.07.2004 - only call if element has shape.
                                 --  seeing as the SSv code was failing if the element had no shape
                                 --  Corrected by RAC - can't use higgis.has_shape.
                                 --  Also, moved up before the changes to the members.
    THEN
   nm3sdm.recalibrate_element_shape(p_ne_id=> pi_ne_id,
                                    p_measure => l_begin_mp,
                                    p_new_length_to_end => pi_new_length_to_end);
   END IF;
--


   FOR l_count IN 1..g_tab_ne_id.COUNT
    LOOP
      IF  g_tab_end_mp(l_count) >  l_begin_mp
       OR g_tab_end_mp(l_count) IS NULL
       THEN
--
         recalibrate_individual_member (pi_ne_id_in       => g_tab_ne_id(l_count)
                                       ,pi_ne_id_of       => pi_ne_id
                                       ,pi_begin_mp       => g_tab_begin_mp(l_count)
                                       ,pi_end_mp         => g_tab_end_mp(l_count)
                                       ,pi_start_date     => g_tab_start_date(l_count)
                                       ,pi_recal_start_mp => pi_begin_mp
                                       ,pi_length_ratio   => l_length_ratio
--*                                       ,pi_effective_date => pi_effective_date
                                       );
--
      ELSE
         --
         -- This record ends before the start point of my recalibration, so ignore it
         --
         NULL;
      END IF;
   END LOOP;
--

   recalibrate_other_products (pi_ne_id             => pi_ne_id
                              ,pi_recal_start_point => l_begin_mp
                              ,pi_length_ratio      => l_length_ratio
                              ,pi_dec_places        => g_dec_places
                              ,pi_new_datum_length  => l_new_length
                              );
--
   reset_for_return;
--
   nm_debug.proc_end(g_package_name,'recalibrate_section');
--
EXCEPTION
--
   WHEN g_recal_exception
    THEN
      reset_for_return;
      RAISE_APPLICATION_ERROR(g_recal_exc_code, g_recal_exc_msg);
--    WHEN others
--     THEN
--       reset_for_return;
--       RAISE;
--
END recalibrate_section;
--
-----------------------------------------------------------------------------
--
PROCEDURE recalibrate_individual_member (pi_ne_id_in       IN nm_members.nm_ne_id_in%TYPE
                                        ,pi_ne_id_of       IN nm_members.nm_ne_id_of%TYPE
                                        ,pi_begin_mp       IN nm_members.nm_begin_mp%TYPE
                                        ,pi_end_mp         IN nm_members.nm_end_mp%TYPE
                                        ,pi_start_date     IN date
                                        ,pi_recal_start_mp IN nm_members.nm_begin_mp%TYPE
                                        ,pi_length_ratio   IN number
                                        ) IS
--
   l_new_begin_mp number;
   l_new_end_mp   number;
--
   l_begin_mp_from_recal number := pi_begin_mp - pi_recal_start_mp;
   l_end_mp_from_recal   number := pi_end_mp - pi_recal_start_mp;
--
   l_rec_nm nm_members%ROWTYPE;
--
BEGIN
--
   IF pi_begin_mp < pi_recal_start_mp
    THEN
      --
      -- The recalibration is only for part of the member
      --
      l_new_begin_mp := pi_begin_mp;
   ELSE
      l_new_begin_mp := pi_recal_start_mp + (l_begin_mp_from_recal * pi_length_ratio);
   END IF;
--
   l_new_end_mp   := pi_recal_start_mp + (l_end_mp_from_recal * pi_length_ratio);
--
   l_new_begin_mp := ROUND(l_new_begin_mp,g_dec_places);
   l_new_end_mp   := ROUND(l_new_end_mp,g_dec_places);
--
   UPDATE nm_members_all
    SET   nm_begin_mp   = l_new_begin_mp
         ,nm_end_mp     = l_new_end_mp
   WHERE  nm_ne_id_in   = pi_ne_id_in
    AND   nm_ne_id_of   = pi_ne_id_of
    AND   nm_begin_mp   = pi_begin_mp
    AND   nm_start_date = pi_start_date;
--
--
END recalibrate_individual_member;
--
-----------------------------------------------------------------------------
--
PROCEDURE gis_shift_section (pi_ne_id          IN nm_elements.ne_id%TYPE
                            ,pi_begin_mp       IN nm_members.nm_begin_mp%TYPE
                            ,pi_shift_distance IN nm_elements.ne_length%TYPE
                            ) IS
BEGIN
   g_gis_call := TRUE;
   shift_section (pi_ne_id
                 ,pi_begin_mp
                 ,pi_shift_distance
                 );
   g_gis_call := FALSE;
EXCEPTION
   WHEN others
    THEN
      g_gis_call := FALSE;
      RAISE;
END gis_shift_section;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_other_products
                    (p_ne_id1            IN nm_elements.ne_id%TYPE
                    ,p_length            IN nm_elements.ne_length%TYPE
                    ,p_from_chain        IN NUMBER
                    ,p_chain_adjst       IN NUMBER
                    ,p_errors           OUT NUMBER
                    ,p_err_text         OUT VARCHAR2
                    ) IS

   l_block    VARCHAR2(32767);
BEGIN
--
   nm_debug.debug_on;
   nm_debug.proc_start(g_package_name,'check_other_products');
--
   IF hig.is_product_licensed(nm3type.c_str)
    THEN
--
      nm_debug.debug('Check STR before recalibrate');
--
      l_block :=            'BEGIN'
                 ||CHR(10)||'    strrecal.check_data'
                 ||CHR(10)||'              (p_rse_he_id    => :p_ne_id1'
                 ||CHR(10)||'              ,p_new_length   => :p_length'
                 ||CHR(10)||'              ,p_from_chain   => :p_from_chain'
                 ||CHR(10)||'              ,p_chain_adjust => :p_chain_adjust'
                 ||CHR(10)||'              ,p_errors       => :p_errors'
                 ||CHR(10)||'              ,p_error_string => :p_err_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id1
               ,p_length
               ,p_from_chain
               ,p_chain_adjst
        ,IN OUT p_errors
        ,IN OUT p_err_text;
--
      nm_debug.debug('Check STR finished');

  END IF;

  -- Check if MM is installed and check for data
   IF hig.is_product_licensed(nm3type.c_mai)
    THEN
--
      nm_debug.debug('Check MAI before Shift');
--
      l_block :=            'BEGIN'
                 ||CHR(10)||'    mairecal.check_data'
                 ||CHR(10)||'              (p_rse_he_id      => :p_ne_id1'
                 ||CHR(10)||'              ,p_new_length     => :p_length'
                 ||CHR(10)||'              ,p_from_chain     => :p_from_chain'
                 ||CHR(10)||'              ,p_chain_adjust   => :p_chain_adjst'
                 ||CHR(10)||'              ,p_errors         => :p_errors'
                 ||CHR(10)||'              ,p_error_string   => :p_err_text'
                 ||CHR(10)||'              );'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block
       USING IN p_ne_id1
               ,p_length
               ,p_from_chain
               ,p_chain_adjst
        ,IN OUT p_errors
        ,IN OUT p_err_text;

      nm_debug.debug('Check MAI finished');
--
  END IF;
--
   nm_debug.proc_end(g_package_name,'check_other_products');
   nm_debug.debug_off;
--
END check_other_products;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE shift_section (pi_ne_id          IN nm_elements.ne_id%TYPE
                        ,pi_begin_mp       IN nm_members.nm_begin_mp%TYPE
                        ,pi_shift_distance IN nm_elements.ne_length%TYPE
                        ) IS
   l_begin_mp          number := NVL(pi_begin_mp,0);
--
   v_errors            NUMBER;
   v_err_text          VARCHAR2(10000);
--

BEGIN
--
   nm_debug.proc_start(g_package_name,'shift_section');
--
   nm3ausec.set_status(nm3type.c_off);

   nm3merge.set_nw_operation_in_progress;
--
   g_sign := SIGN(pi_shift_distance)*-1;
--
   IF pi_shift_distance IS NULL
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 107
                   ,pi_supplementary_info => 'pi_shift_distance'
                   );
   END IF;

   -- NM - Add check here for other products
   check_other_products ( p_ne_id1         => pi_ne_id
                         ,p_length         => nm3net.get_ne_length(pi_ne_id)
                         ,p_from_chain     => pi_begin_mp
                         ,p_chain_adjst    => pi_shift_distance
                         ,p_errors         => v_errors
                         ,p_err_text       => v_err_text
                        );

   IF v_err_text IS NOT NULL
    THEN
       hig.raise_ner(pi_appl               => nm3type.c_mai
                    ,pi_id                 => 5
                    ,pi_supplementary_info => v_err_text
                     );
   END IF;
--

--
   populate_global_variables (pi_ne_id);
--
   IF l_begin_mp + pi_shift_distance < 0
    THEN
      g_recal_exc_code := -20055;
      g_recal_exc_msg  := 'Shift is before start of section';
      RAISE g_recal_exception;
   ELSIF l_begin_mp + pi_shift_distance > g_element_length
    THEN
      g_recal_exc_code := -20056;
      g_recal_exc_msg  := 'Shift is after end of section';
      RAISE g_recal_exception;
   END IF;
--
   FOR l_count IN 1..g_tab_ne_id.COUNT
    LOOP
      process_individual_shift (pi_ne_id_in       => g_tab_ne_id(l_count)
                               ,pi_ne_id_of       => pi_ne_id
                               ,pi_begin_mp       => g_tab_begin_mp(l_count)
                               ,pi_end_mp         => g_tab_end_mp(l_count)
                               ,pi_start_date     => g_tab_start_date(l_count)
                               ,pi_shift_distance => pi_shift_distance
                               ,pi_shift_start_mp => l_begin_mp
                               );
   END LOOP;
--
   shift_other_products (pi_ne_id          => pi_ne_id
                        ,pi_shift_start_mp => l_begin_mp
                        ,pi_shift_distance => pi_shift_distance
                        );
--
   reset_for_return;
--
   nm_debug.proc_end(g_package_name,'shift_section');
--
EXCEPTION
--
   WHEN g_recal_exception
    THEN
      reset_for_return;
      RAISE_APPLICATION_ERROR(g_recal_exc_code, g_recal_exc_msg);
   WHEN others
    THEN
      reset_for_return;
      RAISE;
--
END shift_section;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_global_variables (pi_ne_id IN nm_elements.ne_id%TYPE) IS
--
   CURSOR cs_members (p_nm_ne_id_of nm_members.nm_ne_id_of%TYPE) IS
   SELECT nm_ne_id_in
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_start_date
    FROM  nm_members_all
   WHERE  nm_ne_id_of  = p_nm_ne_id_of
   ORDER BY nm_ne_id_in
           ,g_sign*nm_begin_mp ASC
   FOR UPDATE OF nm_end_mp NOWAIT;
--
   CURSOR cs_ne (p_ne_id nm_elements.ne_id%TYPE) IS
   SELECT ne_length
         ,nm3flx.get_dec_places_from_mask(nm3unit.get_unit_mask(nm3net.get_nt_units(ne_nt_type)))
         ,ne_nt_type
         ,ne_unique
    FROM  nm_elements
   WHERE  ne_id = p_ne_id
   FOR UPDATE OF ne_length NOWAIT;
--
  l_nt_type   nm_elements.ne_nt_type%TYPE;
  l_ne_unique nm_elements.ne_unique%TYPE;
--
BEGIN
--
-- nm_debug.proc_start(g_package_name,'populate_global_variables');
--
   OPEN  cs_ne (pi_ne_id);
   FETCH cs_ne INTO g_element_length, g_dec_places,l_nt_type,l_ne_unique;
   IF cs_ne%NOTFOUND
    THEN
      CLOSE cs_ne;
      g_recal_exc_code := -20051;
      g_recal_exc_msg  := 'NM_ELEMENTS record not found';
      RAISE g_recal_exception;
   END IF;
   CLOSE cs_ne;
--
   IF g_sign IS NULL
    THEN -- recalibrate
      IF g_recal_begin_mp + g_recal_new_length_to_end > g_element_length
       THEN -- If we are making it longer, we want the members with the larger begin MP first
         g_sign := -1;
      ELSE
         g_sign := 1;
      END IF;
   END IF;
--
   IF nm3net.is_nt_datum(l_nt_type) = 'N'
    THEN
      g_recal_exc_code := -20058;
      g_recal_exc_msg  := l_ne_unique||' is not a Datum Element';
      RAISE g_recal_exception;
   END IF;
--
   IF g_element_length IS NULL
    THEN
      g_recal_exc_code := -20052;
      g_recal_exc_msg  := 'NM_ELEMENTS record has no NE_LENGTH specified';
      RAISE g_recal_exception;
   END IF;
--
   nm3lock.lock_parent(pi_ne_id);
--
-- Get into the local arrays all NM_MEMBERS record which are on this sectiom
--
   OPEN  cs_members (pi_ne_id);
   FETCH cs_members BULK COLLECT INTO g_tab_ne_id, g_tab_begin_mp, g_tab_end_mp, g_tab_start_date;
   CLOSE cs_members;
--
   -- Switch off exclusivity checking, we know it's gonna be fine
   nm3nwval.g_exclusivity_check := FALSE;
--
--   nm_debug.proc_end(g_package_name,'populate_global_variables');
--
END populate_global_variables;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_individual_shift (pi_ne_id_in       IN nm_members.nm_ne_id_in%TYPE
                                   ,pi_ne_id_of       IN nm_members.nm_ne_id_of%TYPE
                                   ,pi_begin_mp       IN nm_members.nm_begin_mp%TYPE
                                   ,pi_end_mp         IN nm_members.nm_end_mp%TYPE
                                   ,pi_start_date     IN date
                                   ,pi_shift_distance IN nm_elements.ne_length%TYPE
                                   ,pi_shift_start_mp IN nm_members.nm_begin_mp%TYPE
                                   ) IS
--
   l_rec_nm nm_members%ROWTYPE;
--
   l_start_shift_dist number;
   l_end_shift_dist   number;
--
BEGIN
--
   IF  pi_begin_mp < pi_shift_start_mp
    OR pi_begin_mp = 0
    OR pi_begin_mp = g_element_length
    THEN
      l_start_shift_dist := 0;
   ELSE
      l_start_shift_dist := pi_shift_distance;
   END IF;
--
   IF  pi_end_mp < pi_shift_start_mp
    OR pi_end_mp = g_element_length
    THEN
      l_end_shift_dist := 0;
   ELSE
      l_end_shift_dist := pi_shift_distance;
   END IF;
--
   IF pi_begin_mp + l_start_shift_dist < 0
    THEN
      g_recal_exc_code := -20056;
      g_recal_exc_msg  := 'Shift causes overhang at beginning of section';
      RAISE g_recal_exception;
   ELSIF pi_end_mp + l_end_shift_dist > g_element_length
    THEN
      g_recal_exc_code := -20057;
      g_recal_exc_msg  := 'Shift causes overhang at end of section';
      RAISE g_recal_exception;
   END IF;
--
   UPDATE nm_members_all
    SET   nm_begin_mp   = nm_begin_mp + l_start_shift_dist
         ,nm_end_mp     = nm_end_mp   + l_end_shift_dist
   WHERE  nm_ne_id_in   = pi_ne_id_in
    AND   nm_ne_id_of   = pi_ne_id_of
    AND   nm_begin_mp   = pi_begin_mp
    AND   nm_start_date = pi_start_date;
--
END process_individual_shift;
--
-----------------------------------------------------------------------------
--
PROCEDURE recalibrate_other_products (pi_ne_id             nm_elements.ne_id%TYPE
                                     ,pi_recal_start_point number
                                     ,pi_length_ratio      number
                                     ,pi_dec_places        number
                                     ,pi_new_datum_length  number
                                     ) IS
--
   PROCEDURE dyn_recal (p_pack_proc varchar2) IS
   BEGIN
      EXECUTE IMMEDIATE            'BEGIN'
                        ||CHR(10)||'   '||p_pack_proc
                        ||CHR(10)||'         (:pi_ne_id'
                        ||CHR(10)||'         ,:pi_recal_start_point'
                        ||CHR(10)||'         ,:pi_length_ratio'
                        ||CHR(10)||'         ,:pi_dec_places'
                        ||CHR(10)||'         );'
                        ||CHR(10)||'END;'
       USING IN pi_ne_id
               ,pi_recal_start_point
               ,pi_length_ratio
               ,pi_dec_places;
   END dyn_recal;
--
BEGIN
--
   IF hig.is_product_licensed( nm3type.c_acc )
    THEN
      dyn_recal('accloc.acc_recalibrate');
   END IF;
--
   IF hig.is_product_licensed( nm3type.c_str )
    THEN
      dyn_recal('strrecal.recal_data');
   END IF;
--
   IF hig.is_product_licensed( nm3type.c_stp )
    THEN
      dyn_recal('stp_network_ops.do_recalibrate');
   END IF;
--
   IF hig.is_product_licensed( nm3type.c_mai )
    THEN
      EXECUTE IMMEDIATE            'BEGIN'
                        ||CHR(10)||'   mairecal.recal_data'
                        ||CHR(10)||'         (p_rse_he_id   => :pi_ne_id'
                        ||CHR(10)||'         ,p_orig_length => :pi_orig_length'
                        ||CHR(10)||'         ,p_new_length  => :pi_new_length'
                        ||CHR(10)||'         );'
                        ||CHR(10)||'END;'
       USING IN pi_ne_id
               ,g_element_length
               ,pi_new_datum_length;
   END IF;
--
END recalibrate_other_products;
--
-----------------------------------------------------------------------------
--
PROCEDURE shift_other_products (pi_ne_id          nm_elements.ne_id%TYPE
                               ,pi_shift_start_mp number
                               ,pi_shift_distance number
                               ) IS
--
   PROCEDURE dyn_shift (p_pack_proc varchar2) IS
   BEGIN
      EXECUTE IMMEDIATE            'BEGIN'
                        ||CHR(10)||'   '||p_pack_proc
                        ||CHR(10)||'         (:pi_ne_id'
                        ||CHR(10)||'         ,:pi_shift_start_mp'
                        ||CHR(10)||'         ,:pi_shift_distance'
                        ||CHR(10)||'         );'
                        ||CHR(10)||'END;'
       USING IN pi_ne_id
               ,pi_shift_start_mp
               ,pi_shift_distance;
   END dyn_shift;
--
BEGIN
--
   IF hig.is_product_licensed( nm3type.c_acc )
    THEN
      dyn_shift('accloc.acc_shift');
   END IF;
--
   IF hig.is_product_licensed( nm3type.c_str )
    THEN
      dyn_shift('strrecal.shift_data');
   END IF;
--
   IF hig.is_product_licensed( nm3type.c_stp )
    THEN
      dyn_shift('stp_network_ops.do_shift');
   END IF;
--
   IF hig.is_product_licensed( nm3type.c_mai )
    THEN
      EXECUTE IMMEDIATE            'BEGIN'
                        ||CHR(10)||'   mairecal.shift_data'
                        ||CHR(10)||'         (p_rse_he_id    => :pi_ne_id'
                        ||CHR(10)||'         ,p_new_length   => Null'
                        ||CHR(10)||'         ,p_from_chain   => :pi_shift_start_mp'
                        ||CHR(10)||'         ,p_chain_adjust => :pi_shift_distance'
                        ||CHR(10)||'         );'
                        ||CHR(10)||'END;'
       USING IN pi_ne_id
               ,pi_shift_start_mp
               ,pi_shift_distance;
   END IF;
--
END shift_other_products;
--
-----------------------------------------------------------------------------
--
PROCEDURE reset_for_return IS
BEGIN
   nm3ausec.set_status(nm3type.c_on);

   nm3nwval.g_exclusivity_check := TRUE;

   nm3merge.set_nw_operation_in_progress(FALSE);

END reset_for_return;
--
-----------------------------------------------------------------------------
--
END nm3recal;
/

