CREATE OR REPLACE PACKAGE BODY nm3recal IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3recal.pkb-arc   2.8   Jul 04 2013 16:21:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3recal.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       PVCS Version     : $Revision:   2.8  $
--
--
--   Author : Jonathan Mills
--
--   Recalibration Package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
/* History
  PT 23.11.07 recalibrate zero divide fix, subtracting just enough so that the difference is later absorbed in rounding
               e.g 5 becomes 4.9999 with 3 dec_places
               this not yet tested on nm3sdm.recalibrate_element_shape() and others procducts
  PT 05.12.07 mairecal.recal_data() brough in line with the others in recalibrate_other_products()
*/

   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.8  $"';
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
                              ,pi_neh_descr         IN nm_element_history.neh_descr%TYPE   DEFAULT NULL --CWS 0108990 12/03/2010
                              ) IS
--
   l_length_ratio      number;
   l_new_length        number;
   l_old_length_to_end number;
   l_begin_mp          number := NVL(pi_begin_mp,0);
   
   l_neh_rec nm_element_history%rowtype;

--
BEGIN
  nm_debug.debug_on;

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
   
  -- PT added start not negative check
  if l_begin_mp < 0 then
    g_recal_exc_code := -20053;
    g_recal_exc_msg  := 'Recalibrate BEGIN_MP ('||l_begin_mp||') cannot be negative';
    RAISE g_recal_exception;
  end if;
--
  
  
  -- PT zero divide fix, subtracting just enough so that the difference is later absorbed in rounding
  --  e.g 5 becomes 4.9999 with 3 dec_places
  if l_begin_mp = g_element_length then
    l_begin_mp := g_element_length - (1 / to_number(rpad('1', g_dec_places + 2, '0')));
  end if;
  
    l_old_length_to_end := g_element_length - l_begin_mp;
    
    l_length_ratio := pi_new_length_to_end / l_old_length_to_end;
    
  
  nm_debug.debug(
      'pi_ne_id='||pi_ne_id
  ||', pi_begin_mp='||pi_begin_mp
  ||', pi_new_length_to_end='||pi_new_length_to_end
  ||', l_begin_mp='||l_begin_mp
  ||', g_element_length='||g_element_length
  ||', l_old_length_to_end='||l_old_length_to_end
  ||', l_length_ratio='||l_length_ratio
  ||')');
    
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
    SET   ne_length = round(ne_length + (pi_new_length_to_end - l_old_length_to_end),g_dec_places)
   WHERE  ne_id     = pi_ne_id;
--
   l_new_length := nm3get.get_ne (pi_ne_id => pi_ne_id).ne_length;
--
-- Modify NNU_CHAIN for this element
--
   UPDATE nm_node_usages
    SET   nnu_chain     = round(nnu_chain + (pi_new_length_to_end - l_old_length_to_end),g_dec_places)
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
      -- PT todo: this fails on another broken package down the line on dorset@dawson
      --  the p_measure parameter goes in same as element length if same, to be tested on a working package    
   nm3sdm.recalibrate_element_shape(p_ne_id=> pi_ne_id,
                                    p_measure => round(l_begin_mp,g_dec_places),
                                    p_new_length_to_end => pi_new_length_to_end);
    null;
   END IF;
--

-- PT this handles the fix well, replaced pi_begin with l_begin_mp in the members call
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
                                       ,pi_recal_start_mp => l_begin_mp --pi_begin_mp
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

  -- PT 
  -- this runs throuh ok
  -- todo: to be tested so that there are real assets affected
   recalibrate_other_products (pi_ne_id             => pi_ne_id
                              ,pi_recal_start_point => l_begin_mp
                              ,pi_length_ratio      => l_length_ratio
                              ,pi_dec_places        => g_dec_places
                              ,pi_new_datum_length  => l_new_length
                              );
--
   --create history record
   l_neh_rec.neh_id             := nm3seq.next_neh_id_seq;
   l_neh_rec.neh_ne_id_old      := pi_ne_id;
   l_neh_rec.neh_ne_id_new      := pi_ne_id;
   l_neh_rec.neh_operation      := nm3net_history.c_neh_op_recalibrate;
   l_neh_rec.neh_effective_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_neh_rec.neh_old_ne_length  := g_element_length;
   l_neh_rec.neh_new_ne_length  := l_new_length;
   l_neh_rec.neh_param_1        := round(l_begin_mp,g_dec_places); --pi_begin_mp;
   l_neh_rec.neh_param_2        := pi_new_length_to_end;
   l_neh_rec.neh_descr          := pi_neh_descr; --CWS 0108990 12/03/2010
   --
   nm3nw_edit.ins_neh(p_rec_neh => l_neh_rec); --CWS 0108990 12/03/2010
   --
   reset_for_return;
--
   nm_debug.proc_end(g_package_name,'recalibrate_section');
   nm_debug.debug_off;
--
EXCEPTION
--
   WHEN g_recal_exception
    THEN
      nm_debug.debug_off;
      reset_for_return;
      RAISE_APPLICATION_ERROR(g_recal_exc_code, g_recal_exc_msg);
   WHEN others
    THEN
      nm_debug.debug_off;
      reset_for_return;
      RAISE;
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

    nm_debug.debug(
      '  l_new_begin_mp='||l_new_begin_mp
  ||', l_new_end_mp='||l_new_end_mp
  ||', pi_ne_id_in='||pi_ne_id_in
  ||', pi_ne_id_of='||pi_ne_id_of
  ||', pi_begin_mp='||pi_begin_mp
  ||', pi_length_ratio='||pi_length_ratio
  ||', g_dec_places='||g_dec_places
  ||')');

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
                        ,pi_neh_descr      IN nm_element_history.neh_descr%TYPE  DEFAULT NULL --CWS 0108990 12/03/2010
                        ) IS
   l_begin_mp          number := NVL(pi_begin_mp,0);
--
   v_errors            NUMBER;
   v_err_text          VARCHAR2(10000);
   
   l_neh_rec nm_element_history%rowtype;
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
   --create history record
   l_neh_rec.neh_id             := nm3seq.next_neh_id_seq;
   l_neh_rec.neh_ne_id_old      := pi_ne_id;
   l_neh_rec.neh_ne_id_new      := pi_ne_id;
   l_neh_rec.neh_operation      := nm3net_history.c_neh_op_shift;
   l_neh_rec.neh_effective_date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_neh_rec.neh_old_ne_length  := g_element_length;
   l_neh_rec.neh_new_ne_length  := g_element_length;
   l_neh_rec.neh_param_1        := pi_begin_mp;
   l_neh_rec.neh_param_2        := pi_shift_distance;
   l_neh_rec.neh_descr          := pi_neh_descr; --CWS 0108990 12/03/2010
   --
   nm3nw_edit.ins_neh(p_rec_neh => l_neh_rec); --CWS 0108990 12/03/2010
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
    -- Task 0109508 CWS
    -- This caused point assets to be stretched out
    OR (pi_begin_mp = 0 and pi_end_mp > 0) --OR pi_begin_mp = 0
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
      dyn_recal('mairecal.recal_data');
--       EXECUTE IMMEDIATE            'BEGIN'
--                         ||CHR(10)||'   mairecal.recal_data'
--                         ||CHR(10)||'         (p_rse_he_id   => :pi_ne_id'
--                         ||CHR(10)||'         ,p_orig_length => :pi_orig_length'
--                         ||CHR(10)||'         ,p_new_length  => :pi_new_length'
--                         ||CHR(10)||'         );'
--                         ||CHR(10)||'END;'
--        USING IN pi_ne_id
--                ,g_element_length
--                ,pi_new_datum_length;
   END IF;
--
   IF hig.is_product_licensed( nm3type.c_ukp )
   THEN
      -- dyn_recal is not used as the new datum length is needed
      EXECUTE IMMEDIATE 'BEGIN'
             ||CHR(10)||'  ukprecal.recalibrate '
             ||CHR(10)||'  ( p_rse            => :pi_ne_id '
             ||CHR(10)||'   ,p_start_point    => :pi_recal_start_point '
             ||CHR(10)||'   ,p_length_ratio   => :pi_length_ratio '
             ||CHR(10)||'   ,p_new_length     => :pi_new_datum_length '
             ||CHR(10)||'   ,p_decimal_places => :pi_dec_places '
             ||CHR(10)||'  ); '
             ||CHR(10)||'END;'
       USING IN pi_ne_id
               ,pi_recal_start_point
               ,pi_length_ratio
               ,pi_new_datum_length
               ,pi_dec_places;

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
   IF hig.is_product_licensed( nm3type.c_ukp )
   THEN
      dyn_shift('ukprecal.shift');
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
FUNCTION get_mp_translation_recal(pi_mp                  IN nm_members.nm_begin_mp%TYPE
                                 ,pi_orig_element_length IN nm_elements.ne_length%TYPE
                                 ,pi_begin_mp            IN nm_members.nm_begin_mp%TYPE
                                 ,pi_new_length_to_end   IN nm_elements.ne_length%TYPE
                                 ) RETURN nm_members.nm_begin_mp%TYPE IS

  l_new_length   nm_elements.ne_length%TYPE;
  l_length_ratio number;
  
  l_retval       nm_members.nm_begin_mp%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_mp_translation_recal');

  if pi_mp <= pi_begin_mp
  then
    --mp is before recalibrate start point so not affected
    l_retval := pi_mp;
  else
    --mp is within recalibrated portion so work out new position
    l_new_length := pi_begin_mp + pi_new_length_to_end;
    
    l_length_ratio := l_new_length / pi_orig_element_length;
    
    l_retval := pi_begin_mp + ((pi_mp - pi_begin_mp) * l_length_ratio);
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_mp_translation_recal');

  RETURN l_retval;

END get_mp_translation_recal;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mp_translation_shift(pi_mp             IN nm_members.nm_begin_mp%TYPE
                                 ,pi_element_length IN nm_elements.ne_length%TYPE
                                 ,pi_begin_mp       IN nm_members.nm_begin_mp%TYPE
                                 ,pi_shift_distance IN nm_elements.ne_length%TYPE
                                 ) RETURN nm_members.nm_begin_mp%TYPE IS

  l_shift_distance number;
  
  l_retval nm_members.nm_begin_mp%TYPE := pi_mp;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_mp_translation_shift');

  IF pi_mp > pi_begin_mp
    AND not pi_mp = pi_element_length
  then
    l_retval := l_retval + pi_shift_distance;
  END IF;
  
  IF l_retval < 0
  THEN
    --overhang at beginning
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 449);
   end if;
      
   IF l_retval > pi_element_length
   THEN
     --overhang at end
     hig.raise_ner(pi_appl => nm3type.c_net
                  ,pi_id   => 450);
   END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_mp_translation_shift');

  RETURN l_retval;

END get_mp_translation_shift;
--
-----------------------------------------------------------------------------
--
END nm3recal;
/

