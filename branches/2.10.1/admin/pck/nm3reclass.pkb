/* Formatted on 08/11/2011 15:48:41 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PACKAGE BODY Nm3reclass AS
  --
  -----------------------------------------------------------------------------
  --
  --   PVCS Identifiers :-
  --
  --       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3reclass.pkb-arc   2.10.1.0   Nov 08 2011 16:41:24   Ade.Edwards  $
  --       Module Name      : $Workfile:   nm3reclass.pkb  $
  --       Date into PVCS   : $Date:   Nov 08 2011 16:41:24  $
  --       Date fetched Out : $Modtime:   Nov 08 2011 16:39:52  $
  --       PVCS Version     : $Revision:   2.10.1.0  $
  --
  --
  --   Author : R.A. Coupe
  --
  --   Package for reclassification of network
  --
  -----------------------------------------------------------------------------
  --   Copyright (c) exor corporation ltd, 2001
  -----------------------------------------------------------------------------
  --
  --all global package variables here
  --
  g_body_sccsid             CONSTANT VARCHAR2 ( 2000 ) := '"$Revision:   2.10.1.0  $"';
  -- g_body_sccsid is the SCCS ID for the package body
  --
  g_package_name            CONSTANT VARCHAR2 ( 30 ) := 'nm3reclass';
  --
  -- Exception variables
  g_reclass_exception                EXCEPTION;
  g_reclass_exc_code                 NUMBER;
  g_reclass_exc_msg                  VARCHAR2 ( 4000 );
  --
  g_block                            VARCHAR2 ( 32767 );
  g_gis_call                         BOOLEAN;
  --
  g_rec_nrd                          NM_RECLASS_DETAILS%ROWTYPE;
  --
  g_inherit_au_from_parent  CONSTANT BOOLEAN := ( NVL ( Hig.get_sysopt ( 'INH_PAR_AU' ), 'N' ) = 'Y' );
  c_neh_operation           CONSTANT NM_ELEMENT_HISTORY.neh_operation%TYPE := 'N';
  g_rec_neh                          NM_ELEMENT_HISTORY%ROWTYPE;

  -- GJ 29/AUG/2006 also defined in package header   g_rec_ne                          nm_elements%ROWTYPE;
  --
  ---- Local Procedure Declarations -----------------------------------------------------------------
  --
  PROCEDURE ins_nrd ( p_rec_nrd IN NM_RECLASS_DETAILS%ROWTYPE );

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE reclassify_members ( p_old_ne IN nm_elements%ROWTYPE
                               , p_new_ne IN nm_elements%ROWTYPE );

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION check_replaceable_inv_type ( p_nm_ne_id_of  nm_members.nm_ne_id_of%TYPE
                                      , p_nt_type      NM_TYPES.nt_type%TYPE )
    RETURN BOOLEAN;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION is_inv_allowed_on_nt ( p_inv_type IN VARCHAR2
                                , p_nt_type  IN VARCHAR2 )
    RETURN BOOLEAN;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE close_member ( p_nm             IN nm_members%ROWTYPE
                         , p_effective_date IN DATE );

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION member_is_whole ( p_nm IN nm_members%ROWTYPE )
    RETURN BOOLEAN;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION is_member_allowed_in_gty ( p_nm_obj_type    IN nm_members.nm_obj_type%TYPE
                                    , p_new_ne_nt_type IN nm_elements.ne_nt_type%TYPE )
    RETURN BOOLEAN;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION end_memb_location ( p_inv_type IN nm_inv_types.nit_inv_type%TYPE )
    RETURN BOOLEAN;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE close_inv ( p_ne_id          IN nm_inv_items.iit_ne_id%TYPE
                      , p_effective_date IN DATE );

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE reclassify_group ( p_old_ne    IN     nm_elements%ROWTYPE
                             , p_new_ne    IN     nm_elements%ROWTYPE
                             , p_job_id    IN     NUMBER
                             , p_new_ne_id    OUT NUMBER
                             , p_neh_descr IN     nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                                                                                                 );

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_member_count ( p_ne_id IN nm_elements.ne_id%TYPE )
    RETURN NUMBER;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE move_flexible_cols ( p_old_rec IN     nm_elements%ROWTYPE
                               , p_new_rec IN OUT nm_elements%ROWTYPE );

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE check_unique ( p_nt_type IN     nm_elements.ne_nt_type%TYPE
                         , p_unique  IN OUT nm_elements.ne_unique%TYPE );

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE update_node_usages ( p_old_ne_id  NUMBER
                               , p_new_ne_id  NUMBER );

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE reclassify_other_products ( pi_old_ne_id       nm_elements.ne_id%TYPE
                                      , pi_new_ne_id       nm_elements.ne_id%TYPE
                                      , pi_effective_date  DATE );

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE ins_member ( p_rec_nm IN OUT nm_members%ROWTYPE );

  --
  -----Global Procedures ----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2 IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2 IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE check_other_products ( p_ne_id          IN     nm_elements.ne_id%TYPE
                                 , p_effective_date IN     DATE
                                 , p_errors            OUT NUMBER
                                 , p_err_text          OUT VARCHAR2 ) IS
    l_block           nm3type.max_varchar2;
    l_dummy_chainage  NUMBER;
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'check_other_products' );

    --
    -- MAI - use split logic
    --
    IF Hig.is_product_licensed ( Nm3type.c_mai )
    THEN
      l_block      :=
        'BEGIN' ||
        CHR ( 10 ) ||
        '    maisplit.check_data' ||
        CHR ( 10 ) ||
        '              (p_id        => :p_ne_id' ||
        CHR ( 10 ) ||
        '              ,p_chain     => :p_chain' ||
        CHR ( 10 ) ||
        '              ,p_effective => :p_effective_date' ||
        CHR ( 10 ) ||
        '              ,p_errors    => :p_errors' ||
        CHR ( 10 ) ||
        '              ,p_err_text  => :p_err_text' ||
        CHR ( 10 ) ||
        '              );' ||
        CHR ( 10 ) ||
        'END;';

      EXECUTE IMMEDIATE l_block
        USING IN p_ne_id
            , l_dummy_chainage
            , p_effective_date
            , IN OUT p_errors
            , IN OUT p_err_text;
    END IF;

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'check_other_products' );
  --
  END check_other_products;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION can_element_be_reclassed ( pi_ne_rec         IN nm_elements%ROWTYPE
                                    , pi_effective_date IN DATE )
    RETURN BOOLEAN IS
    l_errors    NUMBER;
    l_err_text  nm3type.max_varchar2;

    PROCEDURE set_output_params ( p_ner_appl           IN nm_errors.ner_appl%TYPE
                                , p_ner_id             IN nm_errors.ner_id%TYPE
                                , p_supplimentary_info IN VARCHAR2 ) IS
    BEGIN
      g_ner_appl            := p_ner_appl;
      g_ner_id              := p_ner_id;
      g_supplimentary_info  := p_supplimentary_info;
    END;

    FUNCTION element_has_future_dt_ad_links ( pi_ne_id           NUMBER
                                            , pi_effective_date  DATE )
      RETURN BOOLEAN IS
      --
      CURSOR exists_cur ( pi_ne_id           NUMBER
                        , pi_effective_date  DATE ) IS
        SELECT DISTINCT 'X'
          FROM nm_nw_ad_link T
         WHERE nad_ne_id = pi_ne_id
           AND nad_start_date > pi_effective_date;

      l_dummy       VARCHAR2 ( 1 );
      l_return_val  BOOLEAN;
    --
    BEGIN
      --
      OPEN exists_cur ( pi_ne_id           => pi_ne_id
                      , pi_effective_date  => pi_effective_date );

      FETCH exists_cur INTO l_dummy;

      l_return_val  := exists_cur%FOUND;

      CLOSE exists_cur;

      --
      RETURN l_return_val;
    END;
  BEGIN
    nm_debug.proc_start ( g_package_name
                        , 'can_element_be_reclassed' );

    --
    IF NVL ( pi_effective_date, TRUNC ( SYSDATE ) ) > TRUNC ( SYSDATE )
    THEN
      set_output_params ( nm3type.c_net
                        , 165
                        , NULL );
      RETURN (FALSE);
    END IF;

    --
    IF NOT nm3user.is_user_unrestricted
   AND NOT ( nm3inv_security.can_usr_see_all_inv_on_element ( pi_ne_id => pi_ne_rec.ne_id ) )
    THEN
      set_output_params ( nm3type.c_net
                        , 172 -- 174
                        , NULL );
      RETURN (FALSE);
    END IF;

    --
      nm_debug.debug_on;
      nm_debug.debug('** '||pi_ne_rec.ne_id||' - '||pi_effective_date);
    --
    IF nm3net.element_has_future_dated_membs ( pi_ne_id           => pi_ne_rec.ne_id
                                             , pi_effective_date  => pi_effective_date )
    THEN
      set_output_params ( nm3type.c_net
                        , 378 -- Element has memberships with a future start date
                        , NULL );

      RETURN (FALSE);
    END IF;

    --
    IF element_has_future_dt_ad_links ( pi_ne_id           => pi_ne_rec.ne_id
                                      , pi_effective_date  => pi_effective_date )
    THEN
      set_output_params ( nm3type.c_net
                        , 378
                        , 'AD Links exist after the effective date.' );
      --
      RETURN (FALSE);
    END IF;

    --
    check_other_products ( p_ne_id           => pi_ne_rec.ne_id
                         , p_effective_date  => pi_effective_date
                         , p_errors          => l_errors
                         , p_err_text        => l_err_text );

    IF l_err_text IS NOT NULL
    THEN
      set_output_params ( nm3type.c_net
                        , 265 -- Operation is invalid
                        , l_err_text );
      RETURN (FALSE);
    END IF;

    --
    -- if we've got this far then operation can go ahead
    --
    RETURN (TRUE);

    Nm_Debug.proc_end ( g_package_name
                      , 'can_element_be_reclassed' );
  END can_element_be_reclassed;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE check_element_can_be_reclassed ( pi_ne_id          IN nm_elements.ne_id%TYPE
                                           , pi_effective_date IN DATE ) IS
    l_ne_rec  nm_elements%ROWTYPE;
  BEGIN
    l_ne_rec  := Nm3net.get_ne ( pi_ne_id );

    IF NOT can_element_be_reclassed ( pi_ne_rec          => l_ne_rec
                                    , pi_effective_date  => pi_effective_date )
    THEN
      hig.raise_ner ( pi_appl                => g_ner_appl
                    , pi_id                  => g_ner_id
                    , pi_supplementary_info  => g_supplimentary_info );
    END IF;
  END check_element_can_be_reclassed;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE reclassify_element ( p_old_ne_id IN     nm_elements.ne_id%TYPE
                               , p_new_ne    IN     nm_elements%ROWTYPE
                               , p_new_ne_id    OUT nm_elements.ne_id%TYPE
                               , p_neh_descr IN     nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                                                                                                   ) IS
  BEGIN
    reclassify_element ( p_old_ne_id          => p_old_ne_id
                       , p_new_ne             => p_new_ne
                       , p_job_id             => Nm3pbi.get_job_id
                       , p_gis_call           => FALSE
                       , p_new_ne_id          => p_new_ne_id
                       , p_check_for_changes  => TRUE
                       , p_neh_descr          => p_neh_descr --CWS 0108990 12/03/2010
                                                             );
  END reclassify_element;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE resolve_default_columns ( p_ne_rec_old IN     nm_elements%ROWTYPE
                                    , p_ne_rec_new IN OUT nm_elements%ROWTYPE ) IS
    CURSOR c_defaults ( c_nt_type NM_TYPE_COLUMNS.ntc_nt_type%TYPE ) IS
      SELECT ntc_column_name
           , ntc_default
        FROM NM_TYPE_COLUMNS
       WHERE ntc_nt_type = c_nt_type
         AND ntc_default IS NOT NULL;

    l_default_bvs_tab  Nm3type.tab_varchar80;
    l_ne_rec           nm_elements%ROWTYPE;
  BEGIN
    --
    l_ne_rec      := p_ne_rec_new;

    --
    FOR cs_rec IN c_defaults ( l_ne_rec.ne_nt_type )
    LOOP
      --get any bind variables in default string
      l_default_bvs_tab  := Nm3flx.extract_all_bind_variables ( pi_string => cs_rec.ntc_default );

      IF Nm3nwval.is_nm_elements_col ( cs_rec.ntc_default )
      THEN
        -----------------------------------------
        --default is another column in nm_elements
        --and the new value of the column != new value of the column
        ------------------------------------------

        g_dyn_rec_ne   := l_ne_rec;
        g_dyn_rec_ne2  := p_ne_rec_old;
        g_block        :=
          'BEGIN' ||
          CHR ( 10 ) ||
          ' IF nm3reclass.g_dyn_rec_ne.' ||
          cs_rec.ntc_default ||
          ' != ' ||
          'g_dyn_rec_ne2.' ||
          cs_rec.ntc_default ||
          CHR ( 10 ) ||
          '   THEN ' ||
          CHR ( 10 ) ||
          '   nm3reclass.g_dyn_rec_ne.' ||
          cs_rec.ntc_column_name ||
          ' := ' ||
          cs_rec.ntc_default ||
          ';' ||
          CHR ( 10 ) ||
          ' END IF' ||
          CHR ( 10 ) ||
          'END;';

        --       Nm_Debug.DEBUG(g_block);
        EXECUTE IMMEDIATE g_block;

        l_ne_rec       := g_dyn_rec_ne;
      ELSIF l_default_bvs_tab.COUNT > 0
      THEN
        -------------------------------------------
        --default is a function with bind variables
        -------------------------------------------
        g_dyn_rec_ne  := l_ne_rec;

        -- Needed to add the quotes/amps thingy to replace any quotes, this was confusing the dynamic SQL
        g_block       :=
          'DECLARE' ||
          CHR ( 10 ) ||
          '   l_sql varchar2(1000);' ||
          CHR ( 10 ) ||
          'BEGIN' ||
          CHR ( 10 ) ||
          '   l_sql := ''SELECT ''||' ||
          nm3flx.string ( nm3flx.repl_quotes_amps_for_dyn_sql ( cs_rec.ntc_default ) ) ||
          '||'' FROM dual'';' ||
          CHR ( 10 ) ||
          '      EXECUTE IMMEDIATE l_sql INTO ' ||
          'nm3reclass.g_dyn_rec_ne.' ||
          cs_rec.ntc_column_name ||
          ' USING ';

        --add using variables, these will be columns stored in the global record
        FOR l_i IN 1 .. l_default_bvs_tab.COUNT
        LOOP
          g_block      :=
            g_block ||
            'nm3reclass.g_dyn_rec_ne.' ||
            REPLACE ( l_default_bvs_tab ( l_i )
                    , ':'
                    , '' ) ||
            ',';
        END LOOP;

        g_block       :=
          SUBSTR ( g_block
                 , 1
                 , LENGTH ( g_block ) -
                   1 ) ||
          ';';

        g_block       :=
          g_block ||
          CHR ( 10 ) ||
          'END;';

        --      Nm_Debug.DEBUG(g_block);

        EXECUTE IMMEDIATE g_block;

        l_ne_rec      := g_dyn_rec_ne;
      ELSE
        ---------------------------
        --default is simply a value
        -- do nothing
        ---------------------------
        NULL;
      --append('      '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' := '||cs_rec.ntc_default||';');
      END IF;
    END LOOP;

    p_ne_rec_new  := l_ne_rec;
  --
  END resolve_default_columns;

  --
  -----------------------------------------------------------------------------------
  --
  PROCEDURE resolve_seq_columns ( p_ne_rec IN OUT nm_elements%ROWTYPE ) /*
                                                                          -- AE this procedure nullifies columns that are derived from a sequence when
                                                                                reclassifying.
                                                                        */
  IS
    TYPE tab_ntc IS TABLE OF NM_TYPE_COLUMNS%ROWTYPE
                      INDEX BY BINARY_INTEGER;

    l_ne_rec   nm_elements%ROWTYPE;
    l_tab_ntc  tab_ntc;
  --
  BEGIN
    --
    Nm3reclass.g_rec_ne  := p_ne_rec;

      --
      SELECT *
        BULK COLLECT INTO l_tab_ntc
        FROM NM_TYPE_COLUMNS
       WHERE ntc_nt_type = Nm3reclass.g_rec_ne.ne_nt_type
         AND ntc_unique_seq IS NOT NULL
         AND ntc_seq_name IS NOT NULL
    ORDER BY ntc_unique_seq;

    --
    FOR i IN 1 .. l_tab_ntc.COUNT
    LOOP
      EXECUTE IMMEDIATE
        'BEGIN' ||
        CHR ( 10 ) ||
        g_package_name ||
        '.g_rec_ne.' ||
        l_tab_ntc ( i ).ntc_column_name ||
        ' := NULL;' ||
        CHR ( 10 ) ||
        'END;';
    END LOOP;

    --
    p_ne_rec             := Nm3reclass.g_rec_ne;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      p_ne_rec  := p_ne_rec;
    WHEN OTHERS
    THEN
      RAISE;
  END resolve_seq_columns;

  --
  -----------------------------------------------------------------------------------
  --
  PROCEDURE validate_new_element ( p_old_ne            IN nm_elements%ROWTYPE
                                 , p_new_ne            IN nm_elements%ROWTYPE
                                 , p_check_for_changes IN BOOLEAN ) IS
    CURSOR cs_nti_ngt ( c_child_nw_type NM_TYPE_INCLUSION.nti_nw_child_type%TYPE ) IS
      SELECT nti_parent_column
           , nti_child_column
           , nti_code_control_column
           , nti_nw_parent_type
           , ngt_group_type
        FROM NM_TYPE_INCLUSION
           , nm_group_types
       WHERE nti_nw_child_type = c_child_nw_type
         AND ngt_nt_type = nti_nw_parent_type;
  BEGIN
    --
    --check that the start and end nodes are vaild for the network type.
    --
    IF p_new_ne.ne_no_start IS NOT NULL
    THEN
      IF NOT Nm3net.is_node_valid_for_nw_type ( p_new_ne.ne_no_start
                                              , p_new_ne.ne_nt_type )
      THEN
        g_reclass_exc_code  := -20801;
        g_reclass_exc_msg   := 'The start node is an invalid type for this network type';
        RAISE g_reclass_exception;
      END IF;
    END IF;

    IF p_new_ne.ne_no_end IS NOT NULL
    THEN
      IF NOT Nm3net.is_node_valid_for_nw_type ( p_new_ne.ne_no_end
                                              , p_new_ne.ne_nt_type )
      THEN
        g_reclass_exc_code  := -20802;
        g_reclass_exc_msg   := 'The end node is an invalid type for this network type';
        RAISE g_reclass_exception;
      END IF;
    END IF;

    --
    -- end date must be null
    --
    IF p_new_ne.ne_end_date IS NOT NULL
    THEN
      g_reclass_exc_code  := -20804;
      g_reclass_exc_msg   := 'The new element must not be closed';
      RAISE g_reclass_exception;
    END IF;

    --
    --   Lock the old element and make sure we have NORMAL access to it
    --
    Nm3lock.lock_element_and_members ( p_old_ne.ne_id
                                     , TRUE );

    --
    -- optionally check for changes
    --
    IF p_check_for_changes
   AND nm3net.are_elements_identical ( p_old_ne
                                     , p_new_ne )
    THEN
      --nm_debug.debug('***Old rec same:');
      g_reclass_exc_code  := -20823;
      g_reclass_exc_msg   := 'Element is unchanged. Not Reclassifying';
      RAISE g_reclass_exception;
    END IF;

    --
    -- XSP violation?
    --
    IF p_old_ne.ne_nt_type != p_new_ne.ne_nt_type
    OR  p_old_ne.ne_sub_class != p_new_ne.ne_sub_class
    THEN
      IF does_nt_scl_change_break_xsp ( p_ne_id_of      => p_old_ne.ne_id
                                      , p_new_nw_type   => p_new_ne.ne_nt_type
                                      , p_new_subclass  => p_new_ne.ne_sub_class )
      THEN
        COMMIT;
        g_reclass_exc_code  := -20825;
        g_reclass_exc_msg   := 'Unable to reclassify Element as inventory XSP rules would be violated';
        RAISE g_reclass_exception;
      END IF;
    END IF;

    --
    --  old and new elements are datum sections, check if there are any columns which are used to auto-include
    --  and retrive the id of the parent into which the new element is to be included.
    --
    --  check that there is no non-replaceable inventory of a type that will not be allowed on
    --  this nw type - this will prevent closure
    --
    IF p_new_ne.ne_type = 'S'
   AND p_old_ne.ne_type = 'S'
    THEN
      IF p_old_ne.ne_nt_type != p_new_ne.ne_nt_type
     AND check_replaceable_inv_type ( p_old_ne.ne_id
                                    , p_old_ne.ne_nt_type )
      THEN
        g_reclass_exc_code  := -20805;
        g_reclass_exc_msg   := 'Unable to close Element it has un-replaceable inventory';
        RAISE g_reclass_exception;
      END IF;

      -- nm3net
      IF p_new_ne.ne_no_start IS NULL
      THEN
        g_reclass_exc_code  := -20811;
        g_reclass_exc_msg   := 'The start node must not be null';
        RAISE g_reclass_exception;
      END IF;

      --
      IF p_new_ne.ne_no_end IS NULL
      THEN
        g_reclass_exc_code  := -20812;
        g_reclass_exc_msg   := 'The end node must not be null';
        RAISE g_reclass_exception;
      END IF;

      --
      IF NOT is_subclass_valid ( p_new_ne.ne_nt_type
                               , p_new_ne.ne_sub_class )
      THEN
        g_reclass_exc_code  := -20826;
        g_reclass_exc_msg   := 'Subclass not valid on new NW Type';
        RAISE g_reclass_exception;
      END IF;

      --   nm_debug.debug('Checking group types');
      FOR irec IN cs_nti_ngt ( p_new_ne.ne_nt_type )
      LOOP
        IF NOT Nm3inv_Xattr.is_nt_valid_for_reclass ( p_old_ne.ne_id
                                                    , irec.ngt_group_type )
        THEN
          Hig.raise_ner ( Nm3type.c_net
                        , 243 );
        END IF;
      END LOOP;

      --
      --   nm_debug.debug('check inv types');
      IF NOT Nm3inv_Xattr.is_valid_for_reclass ( p_old_ne.ne_id
                                               , p_new_ne.ne_nt_type )
      THEN
        Hig.raise_ner ( Nm3type.c_net
                      , 243 );
      END IF;

      IF p_new_ne.ne_length IS NULL
      THEN
        g_reclass_exc_code  := -20808;
        g_reclass_exc_msg   := 'No length has been supplied';
        RAISE g_reclass_exception;
      ELSIF p_new_ne.ne_length <> p_old_ne.ne_length
      THEN
        g_reclass_exc_code  := -20809;
        g_reclass_exc_msg   := 'The lengths of the elements must be the same';
        RAISE g_reclass_exception;
      END IF;

      IF p_new_ne.ne_gty_group_type IS NOT NULL
      THEN
        g_reclass_exc_code  := -20810;
        g_reclass_exc_msg   := 'The supplied element must not have a group type';
        RAISE g_reclass_exception;
      END IF;
    ELSIF p_new_ne.ne_type = 'D'
       OR  p_old_ne.ne_type = 'D'
    THEN
      g_reclass_exc_code  := -20824;
      g_reclass_exc_msg   := 'Cannot reclassify distance breaks except for within the reclassification of a route';
      RAISE g_reclass_exception;
    END IF;
  END validate_new_element;

  --
  -----------------------------------------------------------------------------------
  --
  PROCEDURE reclassify_element ( p_old_ne_id         IN     nm_elements.ne_id%TYPE
                               , p_new_ne            IN     nm_elements%ROWTYPE
                               , p_job_id            IN     NM_RECLASS_DETAILS.nrd_job_id%TYPE
                               , p_gis_call          IN     BOOLEAN
                               , p_new_ne_id            OUT nm_elements.ne_id%TYPE
                               , p_check_for_changes IN     BOOLEAN DEFAULT TRUE
                               , p_neh_descr         IN     nm_element_history.neh_descr%TYPE DEFAULT NULL --CWS 0108990 12/03/2010
                                                                                                           ) IS
    --
    l_code_column  VARCHAR2 ( 30 );
    l_code_value   VARCHAR2 ( 30 );

    new_ne         NM_ELEMENTS_ALL%ROWTYPE;
    old_ne         nm_elements%ROWTYPE;
  --
  --
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'reclassify_element' );
    Nm3merge.set_nw_operation_in_progress;
    --
    old_ne                   :=
      nm3get.get_ne ( pi_ne_id            => p_old_ne_id
                    , pi_raise_not_found  => FALSE );

    IF old_ne.ne_id IS NULL
    THEN
      g_reclass_exc_code  := -20822;
      g_reclass_exc_msg   := 'Old element not found';
      RAISE g_reclass_exception;
    END IF;

    check_element_can_be_reclassed ( pi_ne_id           => p_old_ne_id
                                   , pi_effective_date  => p_new_ne.ne_start_date );

    g_gis_call               := p_gis_call;

    validate_new_element ( p_old_ne             => old_ne
                         , p_new_ne             => p_new_ne
                         , p_check_for_changes  => p_check_for_changes );

    --
    -- DATUM RECLASSIFY
    --

    IF p_new_ne.ne_type = 'S'
    OR  old_ne.ne_type = 'S'
    THEN
      p_new_ne_id                   := Nm3net.get_next_ne_id;
      --
      new_ne.ne_id                  := p_new_ne_id;
      --
      --
      new_ne.ne_number              := p_new_ne.ne_number;
      new_ne.ne_version_no          := p_new_ne.ne_version_no;
      new_ne.ne_unique              := p_new_ne.ne_unique;
      new_ne.ne_nt_type             := p_new_ne.ne_nt_type;
      new_ne.ne_type                := p_new_ne.ne_type;
      new_ne.ne_length              := p_new_ne.ne_length;
      new_ne.ne_admin_unit          := p_new_ne.ne_admin_unit;
      new_ne.ne_start_date          := p_new_ne.ne_start_date;
      new_ne.ne_end_date            := NULL;
      new_ne.ne_descr               := p_new_ne.ne_descr;
      new_ne.ne_gty_group_type      := p_new_ne.ne_gty_group_type;
      new_ne.ne_group               := p_new_ne.ne_group;
      new_ne.ne_nsg_ref             := p_new_ne.ne_nsg_ref;
      --
      new_ne.ne_no_start            := p_new_ne.ne_no_start;
      new_ne.ne_no_end              := p_new_ne.ne_no_end;
      --
      --  now set all the other attributes - leave it to the insert trigger to validate.
      --
      move_flexible_cols ( p_old_rec  => p_new_ne
                         , p_new_rec  => new_ne );
      --
      check_unique ( p_nt_type  => new_ne.ne_nt_type
                   , p_unique   => new_ne.ne_unique );
      --
      -- Resolve any default columns based on othe columns in nm_elements

      resolve_default_columns ( p_ne_rec_old  => old_ne
                              , p_ne_rec_new  => new_ne );

      --
      IF l_code_column IS NOT NULL
      THEN
        g_dyn_rec_ne  := new_ne;
        g_block       :=
          'BEGIN' ||
          CHR ( 10 ) ||
          '   nm3reclass.g_dyn_rec_ne.' ||
          l_code_column ||
          ' := ' ||
          l_code_value ||
          ';' ||
          CHR ( 10 ) ||
          'END;';

        --       nm_debug.debug(g_block);
        EXECUTE IMMEDIATE g_block;

        new_ne        := g_dyn_rec_ne;
      END IF;

      --
      -- AE - nullify any columns populated by a sequence.
      resolve_seq_columns ( p_ne_rec => new_ne );
      --  create the new element
      --
      --nm_debug.debug('***Creating following new NE');
      --nm3debug.debug_ne(new_ne);
      --    nm3net.ins_ne (new_ne);
      Nm3net.insert_any_element ( new_ne );

      --
      -- Move AD data to new element
      IF Nm3nwad.ad_data_exist ( p_old_ne_id )
      THEN
        Nm3nwad.do_ad_reclass ( pi_new_ne_id              => p_new_ne_id
                              , pi_old_ne_id              => p_old_ne_id
                              , pi_new_ne_nt_type         => new_ne.ne_nt_type
                              , pi_new_ne_gty_group_type  => new_ne.ne_gty_group_type );
      END IF;

      --
      --  Create a NM_ELEMENT_HISTORY record.
      g_rec_neh.neh_id              := NULL;
      g_rec_neh.neh_ne_id_old       := old_ne.ne_id;
      g_rec_neh.neh_ne_id_new       := p_new_ne_id;
      g_rec_neh.neh_operation       := c_neh_operation;
      g_rec_neh.neh_effective_date  := new_ne.ne_start_date;
      g_rec_neh.neh_old_ne_length   := old_ne.ne_length;
      g_rec_neh.neh_new_ne_length   := new_ne.ne_length;
      g_rec_neh.neh_descr           := p_neh_descr; --CWS 0108990 12/03/2010
      --
      Nm3nw_edit.ins_neh ( g_rec_neh ); --CWS 0108990 12/03/2010
      --
      --
      -- Update the new node usage records to reflect the old ones
      update_node_usages ( p_old_ne_id
                         , p_new_ne_id );
      --
      -- AE - Added
      -- RAC - Need to replace the shape of an element that is replaced
      -- At 1.51, this code was moved - it needs to be done before the members or any member
      -- shapes are prevented from being dyn-segged.
      --
      Nm3sdm.replace_element_shape ( p_ne_id_old  => p_old_ne_id
                                   , p_ne_id_new  => p_new_ne_id );

      --  re-locate the inventory on the old element onto the new, where the nw type
      --  allows it. Then end-date the old locations and the old element
      --
      Nm3ausec.set_status ( Nm3type.c_off );
      reclassify_members ( old_ne
                         , new_ne );
      Nm3ausec.set_status ( Nm3type.c_on );

      --
      --
      UPDATE nm_elements
         SET ne_end_date  = new_ne.ne_start_date
       WHERE ne_id = p_old_ne_id;
    --

    --
    -- GROUP RECLASSIFY
    --

    ELSIF p_new_ne.ne_type = 'G'
       OR  old_ne.ne_type = 'G'
    THEN
      DECLARE
        l_new_ne  nm_elements%ROWTYPE := p_new_ne;
      BEGIN
        check_unique ( p_nt_type  => l_new_ne.ne_nt_type
                     , p_unique   => l_new_ne.ne_unique );
        reclassify_group ( p_old_ne     => old_ne
                         , p_new_ne     => l_new_ne
                         , p_job_id     => p_job_id
                         , p_new_ne_id  => p_new_ne_id
                         , p_neh_descr  => p_neh_descr --CWS 0108990 12/03/2010
                                                       );
      END;
    END IF;

    --
    g_rec_nrd.nrd_job_id     := p_job_id;
    g_rec_nrd.nrd_old_ne_id  := p_old_ne_id;
    g_rec_nrd.nrd_new_ne_id  := p_new_ne_id;
    ins_nrd ( g_rec_nrd );
    --
    reclassify_other_products ( pi_old_ne_id       => g_rec_nrd.nrd_old_ne_id
                              , pi_new_ne_id       => g_rec_nrd.nrd_new_ne_id
                              , pi_effective_date  => p_new_ne.ne_start_date );
    --
    --   nm_debug.debug('Return Parameters');
    --   nm_debug.debug('New NE ID  : '||p_new_ne_id);
    --
    Nm3merge.set_nw_operation_in_progress ( FALSE );
    Nm_Debug.proc_end ( g_package_name
                      , 'reclassify_element' );
  ----
  EXCEPTION
    --
    WHEN g_reclass_exception
    THEN
      Nm3merge.set_nw_operation_in_progress ( FALSE );
      RAISE_APPLICATION_ERROR ( g_reclass_exc_code
                              , g_reclass_exc_msg );
    WHEN OTHERS
    THEN
      Nm3merge.set_nw_operation_in_progress ( FALSE );
      RAISE;
  --
  END reclassify_element;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE reclassify_members ( p_old_ne IN nm_elements%ROWTYPE
                               , p_new_ne IN nm_elements%ROWTYPE ) IS
    --
    CURSOR cs_members ( c_ne_id_of nm_members.nm_ne_id_of%TYPE ) IS
          SELECT *
            FROM nm_members
           WHERE nm_ne_id_of = c_ne_id_of
      FOR UPDATE OF nm_end_date NOWAIT;

    --
    CURSOR cs_members_by_in ( c_ne_id_in nm_members.nm_ne_id_in%TYPE ) IS
          SELECT *
            FROM nm_members
           WHERE nm_ne_id_in = c_ne_id_in
      FOR UPDATE OF nm_end_date NOWAIT;

    --
    new_mem            nm_members%ROWTYPE;
    mem_rec            nm_members%ROWTYPE;
    --
    l_nm_obj_type      VARCHAR2 ( 4 );
    l_nt               VARCHAR2 ( 4 ) := p_new_ne.ne_nt_type;
    --
    c_old_parent_type  nm_elements.ne_nt_type%TYPE;
    c_new_parent_type  nm_elements.ne_nt_type%TYPE;
    --
    l_tab_rec_nm       Nm3type.tab_rec_nm;
    l_tab_mem_type     Nm3type.tab_varchar4;
    l_count            PLS_INTEGER := 0;
    l_rec_nmh          NM_MEMBER_HISTORY%ROWTYPE;
    --
    c_in      CONSTANT VARCHAR2 ( 2 ) := 'IN';
    c_of      CONSTANT VARCHAR2 ( 2 ) := 'OF';

    --
    FUNCTION is_member_gty_allowed_in_gty ( pi_ngr_child_group_type   VARCHAR2
                                          , pi_ngr_parent_group_type  VARCHAR2 )
      RETURN BOOLEAN IS
      --
      CURSOR ngr_cur ( pi_ngr_parent_group_type  VARCHAR2
                     , pi_ngr_child_group_type   VARCHAR2 ) IS
        SELECT 1
          FROM nm_group_relations
         WHERE ngr_parent_group_type = pi_ngr_parent_group_type
           AND ngr_child_group_type = pi_ngr_child_group_type;

      --
      l_dummy       NUMBER;
      l_return_val  BOOLEAN;
    --
    BEGIN
      OPEN ngr_cur ( pi_ngr_child_group_type
                   , pi_ngr_parent_group_type );

      FETCH ngr_cur INTO l_dummy;

      --
      l_return_val  := ngr_cur%FOUND;

      --
      CLOSE ngr_cur;

      RETURN l_return_val;
    END;

    --
    FUNCTION is_auto_incl ( pi_ne_nt_type_child  VARCHAR2
                          , pi_gty_group_type    VARCHAR2 )
      RETURN BOOLEAN IS
      CURSOR cs_check ( c_ne_nt_type_child  VARCHAR2
                      , c_gty_group_type    VARCHAR2 ) IS
        SELECT 1
          FROM NM_TYPE_INCLUSION
             , nm_group_types
         WHERE ngt_group_type = c_gty_group_type
           AND nti_nw_parent_type = ngt_nt_type
           AND nti_nw_child_type = pi_ne_nt_type_child;

      l_dummy  PLS_INTEGER;
      l_found  BOOLEAN;
    BEGIN
      OPEN cs_check ( pi_ne_nt_type_child
                    , pi_gty_group_type );

      FETCH cs_check INTO l_dummy;

      l_found  := cs_check%FOUND;

      CLOSE cs_check;

      RETURN l_found;
    END is_auto_incl;
  --
  BEGIN
    --
    --  nm_debug.delete_debug;
    Nm_Debug.proc_start ( g_package_name
                        , 'reclassify_members' );
    --
    Nm3merge.clear_nmh_variables;

    --
    -- Put the affected memberships in a PL/SQL table. we shouldn't have to do this, but we were getting
    --  a FETCH OUT OF SEQUENCE error
    --
    -- This is a known Oracle bug (Bug 1375214) which is fixed in 8.1.7.2.1
    -- If a transaction with a select-for-update cursor open calls an
    -- autonomous transaction, the autonomous transaction will reset the
    -- fetch state in the parent transaction's cursor.  The next fetch
    -- will get error ORA-01002 "fetch out of sequence".
    --
    FOR mem_rec IN cs_members ( p_old_ne.ne_id )
    LOOP
      l_count                     :=
        l_count +
        1;
      l_tab_rec_nm ( l_count )    := mem_rec;
      l_tab_mem_type ( l_count )  := c_of;
    --     nm_debug.debug(l_count||'. '||mem_rec.nm_ne_id_in||':'||mem_rec.nm_ne_id_of||':'||mem_rec.nm_begin_mp||'->'||mem_rec.nm_end_mp);
    END LOOP;

    FOR mem_rec IN cs_members_by_in ( p_old_ne.ne_id )
    LOOP
      l_count                     :=
        l_count +
        1;
      l_tab_rec_nm ( l_count )    := mem_rec;
      l_tab_mem_type ( l_count )  := c_in;
    --     nm_debug.debug(l_count||'. '||mem_rec.nm_ne_id_in||':'||mem_rec.nm_ne_id_of||':'||mem_rec.nm_begin_mp||'->'||mem_rec.nm_end_mp);
    END LOOP;

    --
    FOR i IN 1 .. l_tab_rec_nm.COUNT
    LOOP
      --
      mem_rec        := l_tab_rec_nm ( i );
      --     nm_debug.debug(i||'. '||mem_rec.nm_ne_id_in||':'||mem_rec.nm_ne_id_of||':'||mem_rec.nm_begin_mp||'->'||mem_rec.nm_end_mp);
      --
      --  Nm_Debug.debug('membership rec : '||to_char(mem_rec.nm_ne_id_in));
      --
      new_mem        := mem_rec;

      --    new_mem.nm_ne_id_of   := p_new_ne.ne_id;
      IF p_new_ne.ne_start_date > new_mem.nm_start_date
      THEN
        new_mem.nm_start_date  := p_new_ne.ne_start_date;
      END IF;

      --
      IF l_tab_mem_type ( i ) = c_of
      THEN
        new_mem.nm_ne_id_of  := p_new_ne.ne_id;
      ELSE
        new_mem.nm_ne_id_in    := p_new_ne.ne_id;
        new_mem.nm_admin_unit  := p_new_ne.ne_admin_unit;
      END IF;

      --
      --nm_debug.debug('**start date= ' || TO_DATE(new_mem.nm_start_date, 'DD/Mon/YYYY'));
      --
      l_nm_obj_type  := mem_rec.nm_obj_type;

      --
      IF mem_rec.nm_type = 'I'
      THEN
        --      Nm_Debug.debug('membership is inv');
        --
        IF is_inv_allowed_on_nt ( l_nm_obj_type
                                , l_nt )
        THEN
          --      relocate and end-date without testing to see if inventory is needed to be end-dated
          ins_member ( new_mem );
          close_member ( mem_rec
                       , p_new_ne.ne_start_date );
        ELSE
          --
          --      the inventory may not be transferred
          --      now end date the original location
          --
          close_member ( mem_rec
                       , p_new_ne.ne_start_date );

          --
          IF member_is_whole ( mem_rec )
          THEN
            --        member is only located on the old element to be end-dated
            IF NOT end_memb_location ( mem_rec.nm_obj_type )
            THEN
              --            Nm_Debug.debug('Inv needs to be closed');

              close_inv ( mem_rec.nm_ne_id_in
                        , p_new_ne.ne_start_date );
            END IF;
          END IF;
        --
        END IF;
      ELSE
        close_member ( mem_rec
                     , p_new_ne.ne_start_date );

        IF NOT is_auto_incl ( pi_ne_nt_type_child  => p_old_ne.ne_nt_type
                            , pi_gty_group_type    => l_nm_obj_type )
       AND ( ( l_tab_mem_type ( i ) = c_of
          AND is_member_allowed_in_gty ( l_nm_obj_type
                                       , p_new_ne.ne_nt_type ) )
         OR  ( l_tab_mem_type ( i ) = c_in
          AND Nm3get.get_ngt ( pi_ngt_group_type => p_new_ne.ne_gty_group_type ).ngt_nt_type = p_new_ne.ne_nt_type )
         -- CWS 0110555 Parent members were not being recreated during reclassify
         OR  ( l_tab_mem_type ( i ) = c_of
          AND is_member_gty_allowed_in_gty ( l_nm_obj_type
                                           , p_new_ne.ne_gty_group_type ) ) )
        THEN
          ins_member ( new_mem );
        END IF;
      --
      --
      END IF;

      --
      IF l_tab_mem_type ( i ) = c_of
      THEN
        -- nm_member_history doesn't support the data structures
        --  necessary to store the data when we've reclassified a route
        l_rec_nmh.nmh_nm_ne_id_in      := mem_rec.nm_ne_id_in;
        l_rec_nmh.nmh_nm_ne_id_of_old  := mem_rec.nm_ne_id_of;
        l_rec_nmh.nmh_nm_ne_id_of_new  := new_mem.nm_ne_id_of;
        l_rec_nmh.nmh_nm_begin_mp      := mem_rec.nm_begin_mp;
        l_rec_nmh.nmh_nm_start_date    := mem_rec.nm_start_date;
        l_rec_nmh.nmh_nm_type          := mem_rec.nm_type;
        l_rec_nmh.nmh_nm_obj_type      := mem_rec.nm_obj_type;
        l_rec_nmh.nmh_nm_end_date      := mem_rec.nm_end_date;
        Nm3merge.append_nmh_to_variables ( l_rec_nmh );
      END IF;
    --    nm_debug.debug('Right at the bottom of the loop');
    END LOOP;

    Nm3merge.ins_nmh;
    --
    Nm_Debug.proc_end ( g_package_name
                      , 'reclassify_members' );
  --
  EXCEPTION
    WHEN OTHERS
    THEN
      Nm3ausec.set_status ( Nm3type.c_on );
      RAISE;
  END reclassify_members;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION check_replaceable_inv_type ( p_nm_ne_id_of  nm_members.nm_ne_id_of%TYPE
                                      , p_nt_type      NM_TYPES.nt_type%TYPE )
    RETURN BOOLEAN IS
    -- Are there any inv items on the element that have the replaceable flag set to 'N' ?

    CURSOR cs_replacable IS
      SELECT 1
        FROM DUAL
       WHERE EXISTS
               (SELECT 1
                  FROM NM_INV_TYPES_ALL
                     , nm_inv_nw
                     , nm_members
                 WHERE nit_inv_type = nm_obj_type
                   AND nit_replaceable = 'N'
                   AND nm_ne_id_of = p_nm_ne_id_of
                   AND nm_type = 'I'
                   AND nit_inv_type = nin_nit_inv_code
                   AND nin_loc_mandatory = 'Y'
                   AND nin_nw_type = p_nt_type);

    --
    dummy   NUMBER ( 1 );
    retval  BOOLEAN;
  --
  BEGIN
    --
    OPEN cs_replacable;

    FETCH cs_replacable INTO dummy;

    retval  := cs_replacable%FOUND;

    CLOSE cs_replacable;

    --
    RETURN retval;
  --
  END check_replaceable_inv_type;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION is_inv_allowed_on_nt ( p_inv_type IN VARCHAR2
                                , p_nt_type  IN VARCHAR2 )
    RETURN BOOLEAN IS
    CURSOR cs_inv_nw ( c_inv  nm_inv_types.nit_inv_type%TYPE
                     , c_nt   NM_TYPES.nt_type%TYPE ) IS
      SELECT 1
        FROM nm_inv_nw
       WHERE nin_nit_inv_code = p_inv_type
         AND nin_nw_type = p_nt_type;

    --
    l_dummy  NUMBER;
    retval   BOOLEAN;
  --
  BEGIN
    --
    OPEN cs_inv_nw ( p_inv_type
                   , p_nt_type );

    FETCH cs_inv_nw INTO l_dummy;

    retval  := cs_inv_nw%FOUND;

    CLOSE cs_inv_nw;

    --
    RETURN retval;
  --
  END is_inv_allowed_on_nt;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE close_member ( p_nm             IN nm_members%ROWTYPE
                         , p_effective_date IN DATE ) IS
  BEGIN
    --
    UPDATE nm_members
       SET nm_end_date  = p_effective_date
     WHERE nm_ne_id_in = p_nm.nm_ne_id_in
       AND nm_ne_id_of = p_nm.nm_ne_id_of
       AND nm_start_date = p_nm.nm_start_date;
  --
  END close_member;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION member_is_whole ( p_nm IN nm_members%ROWTYPE )
    RETURN BOOLEAN IS
    CURSOR cs_member ( c_in  nm_members.nm_ne_id_in%TYPE
                     , c_of  nm_members.nm_ne_id_of%TYPE ) IS
      SELECT 1
        FROM nm_members
       WHERE nm_ne_id_in = c_in
         AND nm_ne_id_of != c_of;

    --
    l_dummy  NUMBER;
    retval   BOOLEAN;
  --
  BEGIN
    --
    OPEN cs_member ( p_nm.nm_ne_id_in
                   , p_nm.nm_ne_id_of );

    FETCH cs_member INTO l_dummy;

    retval  := cs_member%NOTFOUND;

    CLOSE cs_member;

    --
    RETURN retval;
  --
  END member_is_whole;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION is_member_allowed_in_gty ( p_nm_obj_type    IN nm_members.nm_obj_type%TYPE
                                    , p_new_ne_nt_type IN nm_elements.ne_nt_type%TYPE )
    RETURN BOOLEAN IS
    CURSOR cs_nng ( c_nt  nm_nt_groupings.nng_nt_type%TYPE
                  , c_gt  nm_nt_groupings.nng_group_type%TYPE ) IS
      SELECT 1
        FROM nm_nt_groupings
       WHERE nng_nt_type = c_nt
         AND nng_group_type = c_gt;

    --
    l_dummy  NUMBER;
    --
    retval   BOOLEAN;
  --
  BEGIN
    --
    --  nm_debug.debug('NM_OBJ_TYPE (nng_group_type) : '||p_nm_obj_type);
    --  nm_debug.debug('NE_NT_TYPE  (nng_nt_type)    : '||p_new_ne_nt_type);
    --
    OPEN cs_nng ( p_new_ne_nt_type
                , p_nm_obj_type );

    FETCH cs_nng INTO l_dummy;

    retval  := cs_nng%FOUND;

    CLOSE cs_nng;

    --
    RETURN retval;
  --
  END is_member_allowed_in_gty;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION end_memb_location ( p_inv_type IN nm_inv_types.nit_inv_type%TYPE )
    RETURN BOOLEAN IS
    --
    CURSOR cs_nit ( c_inv_type nm_inv_types.nit_inv_type%TYPE ) IS
      SELECT nit_end_loc_only
        FROM nm_inv_types
       WHERE nit_inv_type = c_inv_type;

    --
    l_dummy  VARCHAR2 ( 1 );
  --
  BEGIN
    --
    OPEN cs_nit ( p_inv_type );

    FETCH cs_nit INTO l_dummy;

    CLOSE cs_nit;

    --
    RETURN l_dummy = 'Y';
  --
  END end_memb_location;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE close_inv ( p_ne_id          IN nm_inv_items.iit_ne_id%TYPE
                      , p_effective_date IN DATE ) IS
    --
    CURSOR cs_inv ( c_iit_ne_id nm_inv_items.iit_ne_id%TYPE ) IS
          SELECT ROWID
            FROM nm_inv_items
           WHERE iit_ne_id = c_iit_ne_id
      FOR UPDATE OF iit_end_date NOWAIT;

    --
    l_inv_rowid  ROWID;
  --
  BEGIN
    --
    OPEN cs_inv ( p_ne_id );

    FETCH cs_inv INTO l_inv_rowid;

    CLOSE cs_inv;

    --
    UPDATE nm_inv_items
       SET iit_end_date  = p_effective_date
     WHERE ROWID = l_inv_rowid;
  --
  END close_inv;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE reclassify_group ( p_old_ne    IN     nm_elements%ROWTYPE
                             , p_new_ne    IN     nm_elements%ROWTYPE
                             , p_job_id    IN     NUMBER
                             , p_new_ne_id    OUT NUMBER
                             , p_neh_descr IN     nm_element_history.neh_descr%TYPE ) IS
    --
    CURSOR cs_nti ( c_nt nm_types.nt_type%TYPE ) IS
      SELECT nti_parent_column
           , nti_child_column
           , nti_code_control_column
           , nti_nw_child_type
        FROM nm_type_inclusion
       WHERE nti_nw_parent_type = c_nt;

    --
    CURSOR c_members ( c_ne_id nm_elements.ne_id%TYPE ) IS
      SELECT ne_nt_type
           , ne_id
           , nm_type
           , ne_sub_class
        FROM nm_members
           , nm_elements
       WHERE nm_ne_id_of = ne_id
         AND nm_ne_id_in = c_ne_id;

    --
    CURSOR cs_mem_and_ele ( c_ne_id_in nm_members.nm_ne_id_in%TYPE ) IS
        SELECT ne.*
             , nm.*
          FROM nm_elements ne
             , nm_members nm
         WHERE nm.nm_ne_id_in = c_ne_id_in
           AND ne.ne_id = nm.nm_ne_id_of
      ORDER BY nm_seq_no;

    --
    CURSOR cs_element ( c_ne_unique   nm_elements.ne_unique%TYPE
                      , c_ne_nt_type  nm_elements.ne_nt_type%TYPE ) IS
          SELECT *
            FROM nm_elements
           WHERE ne_unique = c_ne_unique
             AND ne_nt_type = c_ne_nt_type
      FOR UPDATE OF ne_id NOWAIT;

    --
    CURSOR cs_element_all ( c_ne_unique   nm_elements.ne_unique%TYPE
                          , c_ne_nt_type  nm_elements.ne_nt_type%TYPE ) IS
      SELECT 1
        FROM nm_elements_all
       WHERE ne_unique = c_ne_unique
         AND ne_nt_type = c_ne_nt_type;

    --
    v_parent_column     VARCHAR2 ( 30 );
    v_child_column      VARCHAR2 ( 30 );
    v_query_string      VARCHAR2 ( 2000 );
    v_execute_string    VARCHAR2 ( 2000 );
    v_parent_id         NUMBER;
    l_code_value        VARCHAR2 ( 30 );
    l_ne_number         VARCHAR2 ( 10 );
    l_ne_version_no     VARCHAR2 ( 10 );
    --
    l_rec_new_ne        nm_elements%ROWTYPE;
    --
    l_rec_ne_for_child  nm_elements%ROWTYPE;
    l_child_nt_type     nm_elements.ne_nt_type%TYPE;
    --
    l_created_new_ne    BOOLEAN := FALSE;
    --
    l_dummy             PLS_INTEGER;
    l_rec_nmh           NM_MEMBER_HISTORY%ROWTYPE;
  --
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'reclassify_group' );

    --
    --   nm_debug.delete_debug(TRUE);
    --    nm_debug.debug_on;
    --   g_reclass_exc_code  := -20829;
    --   g_reclass_exc_msg   := 'Error in Group Specification';
    --   RAISE g_reclass_exception;
    --
    -- we are going to end-date a lot of elements, the inventory needs to be checked first
    -- for non-replaceable inventory types.
    -- May as well check to make sure the subclass is valid whilst we're here
    --
    --  nm_debug.delete_debug(TRUE);
    --  nm_debug.debug_on;
    --  nm_debug.set_level(-1);
    --
    FOR irec IN c_members ( p_old_ne.ne_id )
    LOOP
      IF irec.nm_type = 'I'
     AND check_replaceable_inv_type ( irec.ne_id
                                    , irec.ne_nt_type )
      THEN
        g_reclass_exc_code  := -20805;
        g_reclass_exc_msg   := 'Unable to close Element it has un-replaceable inventory';
        RAISE g_reclass_exception;
      ELSIF irec.nm_type = 'G'
        AND NOT is_subclass_valid ( irec.ne_nt_type
                                  , irec.ne_sub_class )
      THEN
        g_reclass_exc_code  := -20826;
        g_reclass_exc_msg   := 'Subclass not valid on new NW Type';
        RAISE g_reclass_exception;
      END IF;
    END LOOP;

    --
    --
    OPEN cs_element ( p_new_ne.ne_unique
                    , p_new_ne.ne_nt_type );

    FETCH cs_element INTO l_rec_new_ne;

    --
    --   nm_debug.debug(p_new_ne.ne_unique||':'||p_new_ne.ne_nt_type,-1);
    --   nm_debug.debug('Found : '||nm3flx.boolean_to_char(cs_element%FOUND),-1);
    --
    IF cs_element%NOTFOUND
    THEN
      CLOSE cs_element;

      OPEN cs_element_all ( p_new_ne.ne_unique
                          , p_new_ne.ne_nt_type );

      FETCH cs_element_all INTO l_dummy;

      IF cs_element_all%FOUND
      THEN
        CLOSE cs_element_all;

        g_reclass_exc_code  := -20827;
        g_reclass_exc_msg      :=
          'Unique Reference "' ||
          p_new_ne.ne_unique ||
          '" has previously been used for NT Type "' ||
          p_new_ne.ne_nt_type ||
          '"';
        RAISE g_reclass_exception;
      END IF;

      CLOSE cs_element_all;

      -- Create the new group record
      --      nm_debug.debug('Create the new group record',-1);
      --
      l_rec_new_ne.ne_id              := Nm3net.get_next_ne_id;
      --
      l_rec_new_ne.ne_unique          := p_new_ne.ne_unique;
      l_rec_new_ne.ne_nt_type         := p_new_ne.ne_nt_type;
      l_rec_new_ne.ne_type            := p_new_ne.ne_type;
      l_rec_new_ne.ne_length          := p_new_ne.ne_length;
      l_rec_new_ne.ne_admin_unit      := p_new_ne.ne_admin_unit;
      l_rec_new_ne.ne_start_date      := p_new_ne.ne_start_date;
      l_rec_new_ne.ne_end_date        := NULL;
      l_rec_new_ne.ne_descr           := p_new_ne.ne_descr;
      l_rec_new_ne.ne_gty_group_type  := p_new_ne.ne_gty_group_type;
      l_rec_new_ne.ne_group           := p_new_ne.ne_group;
      l_rec_new_ne.ne_no_start        := p_new_ne.ne_no_start;
      l_rec_new_ne.ne_no_end          := p_new_ne.ne_no_end;
      l_rec_new_ne.ne_nsg_ref         := p_new_ne.ne_nsg_ref;
      --
      move_flexible_cols ( p_old_rec  => p_new_ne
                         , p_new_rec  => l_rec_new_ne );
      --
      -- This is for part 2 of my change!!!! - JM 15/12/2004
      g_block                         :=
        'BEGIN' ||
        CHR ( 10 ) ||
        '   Null;';

      FOR cs_rec IN (  SELECT nti_code_control_column
                         FROM NM_TYPE_INCLUSION
                        WHERE nti_nw_parent_type = l_rec_new_ne.ne_nt_type
                          AND nti_code_control_column IS NOT NULL
                     GROUP BY nti_code_control_column )
      LOOP
        g_block      :=
          g_block ||
          CHR ( 10 ) ||
          '   ' ||
          g_package_name ||
          '.g_dyn_rec_ne.' ||
          cs_rec.nti_code_control_column ||
          ' := ' ||
          Nm3flx.string ( '0' ) ||
          ';';
      END LOOP;

      g_block                         :=
        g_block ||
        CHR ( 10 ) ||
        'END;';
      g_dyn_rec_ne                    := l_rec_new_ne;

      EXECUTE IMMEDIATE g_block;

      l_rec_new_ne                    := g_dyn_rec_ne;
      --
      check_unique ( p_nt_type  => l_rec_new_ne.ne_nt_type
                   , p_unique   => l_rec_new_ne.ne_unique );
      --
      -- Resolve any default columns based on othe columns in nm_elements

      resolve_default_columns ( p_ne_rec_old  => p_new_ne
                              , p_ne_rec_new  => l_rec_new_ne );
      --

      --nm3debug.debug_ne(l_rec_new_ne);
      Nm3net.insert_any_element ( l_rec_new_ne );
      -- nm3net.ins_ne (l_rec_new_ne);

      g_rec_neh.neh_id                := NULL;
      g_rec_neh.neh_ne_id_old         := p_old_ne.ne_id;
      g_rec_neh.neh_ne_id_new         := l_rec_new_ne.ne_id;
      g_rec_neh.neh_operation         := c_neh_operation;
      g_rec_neh.neh_effective_date    := l_rec_new_ne.ne_start_date;
      g_rec_neh.neh_old_ne_length     := p_old_ne.ne_length;
      g_rec_neh.neh_new_ne_length     := l_rec_new_ne.ne_length;
      g_rec_neh.neh_descr             := p_neh_descr; --CWS 0108990 12/03/2010
      --
      Nm3nw_edit.ins_neh ( g_rec_neh ); --CWS 0108990 12/03/2010
      --nm_debug.debug('new group ne_id= ' ||  l_rec_new_ne.ne_id);

      l_created_new_ne                := TRUE;
    ELSE
      --     nm_debug.debug('***Route element already exists ne_id',-1);
      --     nm3debug.debug_ne(l_rec_new_ne);
      CLOSE cs_element;

      --
      IF l_rec_new_ne.ne_admin_unit != p_new_ne.ne_admin_unit
      THEN
        g_reclass_exc_code  := -20828;
        g_reclass_exc_msg      :=
          'Unique Reference "' ||
          p_new_ne.ne_unique ||
          '" already exists for NT Type "' ||
          p_new_ne.ne_nt_type ||
          '" and is of different admin unit';
        RAISE g_reclass_exception;
      END IF;

      --
      DECLARE
        l_rec_ne  nm_elements%ROWTYPE := p_new_ne;
      BEGIN
        --
        g_block        :=
          'BEGIN' ||
          CHR ( 10 ) ||
          '   Null;';

        FOR irec IN cs_nti ( l_rec_ne.ne_nt_type )
        LOOP
          g_block      :=
            g_block ||
            CHR ( 10 ) ||
            '   ' ||
            g_package_name ||
            '.g_dyn_rec_ne2.' ||
            irec.nti_code_control_column ||
            ' := ' ||
            g_package_name ||
            '.g_dyn_rec_ne.' ||
            irec.nti_code_control_column ||
            ';';
        END LOOP;

        g_block        :=
          g_block ||
          CHR ( 10 ) ||
          'END;';
        g_dyn_rec_ne   := l_rec_new_ne;
        g_dyn_rec_ne2  := l_rec_ne;

        --         nm_debug.debug(g_block);
        EXECUTE IMMEDIATE g_block;

        l_rec_ne       := g_dyn_rec_ne2;

        --
        --update existing record
        UPDATE NM_ELEMENTS_ALL
           SET ne_gty_group_type  = l_rec_ne.ne_gty_group_type
             --           ,ne_admin_unit     = l_rec_ne.ne_admin_unit
             , ne_descr           = l_rec_ne.ne_descr
             , ne_owner           = l_rec_ne.ne_owner
             , ne_name_1          = l_rec_ne.ne_name_1
             , ne_name_2          = l_rec_ne.ne_name_2
             , ne_prefix          = l_rec_ne.ne_prefix
             , ne_number          = l_rec_ne.ne_number
             , ne_sub_type        = l_rec_ne.ne_sub_type
             , ne_group           = l_rec_ne.ne_group
             , ne_no_start        = l_rec_ne.ne_no_start
             , ne_no_end          = l_rec_ne.ne_no_end
             , ne_sub_class       = l_rec_ne.ne_sub_class
             , ne_nsg_ref         = l_rec_ne.ne_nsg_ref
             , ne_version_no      = l_rec_ne.ne_version_no
         WHERE ne_id = l_rec_new_ne.ne_id;
      END;

      --
      l_rec_new_ne  := Nm3net.get_ne ( l_rec_new_ne.ne_id );
    --     nm3debug.debug_ne(l_rec_new_ne);
    --
    END IF;

    p_new_ne_id  := l_rec_new_ne.ne_id;

    --
    -- loop over the inclusion data and find the parent and child column names
    -- the new record is a group and has a parent column which must share the same value of those
    -- in the child records that we must create.
    --
    IF Nm3net.is_nt_inclusion ( p_old_ne.ne_nt_type )
    THEN
      FOR cs_rec IN cs_mem_and_ele ( p_old_ne.ne_id )
      LOOP
        -- Move all values to rec_ne
        l_rec_ne_for_child.ne_id              := cs_rec.ne_id;
        l_rec_ne_for_child.ne_unique          := cs_rec.ne_unique;
        l_rec_ne_for_child.ne_type            := cs_rec.ne_type;
        l_rec_ne_for_child.ne_nt_type         := cs_rec.ne_nt_type;
        l_rec_ne_for_child.ne_descr           := cs_rec.ne_descr;
        l_rec_ne_for_child.ne_length          := cs_rec.ne_length;
        l_rec_ne_for_child.ne_admin_unit      := cs_rec.ne_admin_unit;
        l_rec_ne_for_child.ne_date_created    := cs_rec.ne_date_created;
        l_rec_ne_for_child.ne_date_modified   := cs_rec.ne_date_modified;
        l_rec_ne_for_child.ne_modified_by     := cs_rec.ne_modified_by;
        l_rec_ne_for_child.ne_created_by      := cs_rec.ne_created_by;
        l_rec_ne_for_child.ne_start_date      := cs_rec.ne_start_date;
        l_rec_ne_for_child.ne_end_date        := cs_rec.ne_end_date;
        l_rec_ne_for_child.ne_gty_group_type  := cs_rec.ne_gty_group_type;
        l_rec_ne_for_child.ne_owner           := cs_rec.ne_owner;
        l_rec_ne_for_child.ne_name_1          := cs_rec.ne_name_1;
        l_rec_ne_for_child.ne_name_2          := cs_rec.ne_name_2;
        l_rec_ne_for_child.ne_prefix          := cs_rec.ne_prefix;
        l_rec_ne_for_child.ne_number          := cs_rec.ne_number;
        l_rec_ne_for_child.ne_sub_type        := cs_rec.ne_sub_type;
        l_rec_ne_for_child.ne_group           := cs_rec.ne_group;
        l_rec_ne_for_child.ne_no_start        := cs_rec.ne_no_start;
        l_rec_ne_for_child.ne_no_end          := cs_rec.ne_no_end;
        l_rec_ne_for_child.ne_sub_class       := cs_rec.ne_sub_class;
        l_rec_ne_for_child.ne_nsg_ref         := cs_rec.ne_nsg_ref;
        l_rec_ne_for_child.ne_version_no      := cs_rec.ne_version_no;
        --
        --       JM - 699528 - commented out - no need to be here, and it was
        --          moving group attributes onto the datum record!
        --         move_flexible_cols (p_old_rec => l_rec_new_ne
        --                            ,p_new_rec => l_rec_ne_for_child
        --                            );
        g_block                               :=
          'BEGIN' ||
          CHR ( 10 ) ||
          '   Null;';

        FOR irec IN cs_nti ( p_new_ne.ne_nt_type )
        LOOP
          --
          l_child_nt_type  := irec.nti_nw_child_type;
          g_block          :=
            g_block ||
            CHR ( 10 ) ||
            '   ' ||
            g_package_name ||
            '.g_dyn_rec_ne2.' ||
            irec.nti_child_column ||
            ' := ' ||
            g_package_name ||
            '.g_dyn_rec_ne.' ||
            irec.nti_parent_column ||
            ';';

          --
          IF irec.nti_code_control_column IS NOT NULL
          THEN
            g_block      :=
              g_block ||
              CHR ( 10 ) ||
              '   ' ||
              g_package_name ||
              '.g_dyn_rec_ne2.' ||
              irec.nti_code_control_column ||
              ' := ' ||
              g_package_name ||
              '.g_dyn_rec_ne.' ||
              irec.nti_code_control_column ||
              ';';
          END IF;
        --
        END LOOP;

        l_rec_ne_for_child.ne_nt_type         := l_child_nt_type;
        g_block                               :=
          g_block ||
          CHR ( 10 ) ||
          'END;';
        g_dyn_rec_ne                          := l_rec_new_ne;
        g_dyn_rec_ne2                         := l_rec_ne_for_child;

        --      nm_debug.debug(g_block);
        EXECUTE IMMEDIATE g_block;

        l_rec_ne_for_child                    := g_dyn_rec_ne2;
        l_rec_ne_for_child.ne_start_date      := p_new_ne.ne_start_date;
        l_rec_ne_for_child.ne_sub_class       := cs_rec.ne_sub_class;

        --
        IF g_inherit_au_from_parent
        THEN
          l_rec_ne_for_child.ne_admin_unit  := p_new_ne.ne_admin_unit;
        END IF;

        --
        --
        -- #######################################################################################################################
        -- #######################################################################################################################
        --
        --  MRWA Specific Code to inherit NE_OWNER from the first 3 chars of NE_GROUP when reclassifying MDAT to (LDAT or ZDAT)
        --   as part of a group reclassification
        --
        -- #######################################################################################################################
        -- #######################################################################################################################
        --
        --      IF   l_rec_ne_for_child.ne_nt_type IN ('LDAT','ZDAT')
        IF l_rec_ne_for_child.ne_nt_type = 'ZDAT' -- LDAT no longer has NE_OWNER as a column - JM 24/07/2003
       AND Nm3get.get_hpr ( pi_hpr_product      => 'MRWA'
                          , pi_raise_not_found  => FALSE ).hpr_key
             IS NOT NULL
        THEN
          l_rec_ne_for_child.ne_owner      :=
            SUBSTR ( l_rec_ne_for_child.ne_group
                   , 1
                   , 3 );
        END IF;

        --
        -- #######################################################################################################################
        -- #######################################################################################################################
        --
        IF l_rec_ne_for_child.ne_type = 'D'
        THEN
          DECLARE
            l_db_unique  nm_elements.ne_unique%TYPE;
            l_db_ne_id   nm_elements.ne_id%TYPE;
          BEGIN
            Nm3net.insert_distance_break ( pi_route_ne_id    => l_rec_new_ne.ne_id
                                         , pi_start_node_id  => l_rec_ne_for_child.ne_no_start
                                         , pi_end_node_id    => l_rec_ne_for_child.ne_no_end
                                         , pi_start_date     => l_rec_ne_for_child.ne_start_date
                                         , pi_length         => l_rec_ne_for_child.ne_length
                                         , po_db_ne_id       => l_db_ne_id
                                         , po_db_ne_unique   => l_db_unique );
            --
            g_rec_nrd.nrd_job_id     := p_job_id;
            g_rec_nrd.nrd_old_ne_id  := l_rec_ne_for_child.ne_id;
            g_rec_nrd.nrd_new_ne_id  := l_db_ne_id;
            ins_nrd ( g_rec_nrd );
            --
            update_node_usages ( g_rec_nrd.nrd_old_ne_id
                               , g_rec_nrd.nrd_new_ne_id );
          END;

          --
          --<RC added this to prevent failure of DT trigger on element closure.
          --
          UPDATE nm_members
             SET nm_end_date  = l_rec_ne_for_child.ne_start_date
           WHERE nm_ne_id_of = l_rec_ne_for_child.ne_id;

          --end rc>

          Nm3sdm.replace_element_shape ( p_ne_id_old  => l_rec_ne_for_child.ne_id
                                       , p_ne_id_new  => l_rec_new_ne.ne_id );

          UPDATE nm_elements
             SET ne_end_date  = l_rec_ne_for_child.ne_start_date
           WHERE ne_id = l_rec_ne_for_child.ne_id;
        --
        ELSE
          --         nm_debug.debug('Calling reclass element for '||l_rec_ne_for_child.ne_id);
          --nm_debug.debug('***reclassifying child');
          l_rec_nmh.nmh_nm_ne_id_of_old  := l_rec_ne_for_child.ne_id;
          reclassify_element ( p_old_ne_id          => l_rec_ne_for_child.ne_id
                             , p_new_ne             => l_rec_ne_for_child
                             , p_job_id             => p_job_id
                             , p_gis_call           => g_gis_call
                             , p_new_ne_id          => l_rec_ne_for_child.ne_id
                             , p_check_for_changes  => FALSE );
        --         l_rec_nmh.nmh_nm_ne_id_in     := cs_rec.nm_ne_id_in;
        --         l_rec_nmh.nmh_nm_ne_id_of_new := l_rec_ne_for_child.ne_id;
        --         l_rec_nmh.nmh_nm_begin_mp     := cs_rec.nm_begin_mp;
        --         l_rec_nmh.nmh_nm_start_date   := cs_rec.nm_start_date;
        --         l_rec_nmh.nmh_nm_type         := cs_rec.nm_type;
        --         l_rec_nmh.nmh_nm_obj_type     := cs_rec.nm_obj_type;
        --         l_rec_nmh.nmh_nm_end_date     := cs_rec.nm_end_date;
        --         nm3ins.ins_nmh (p_rec_nmh => l_rec_nmh);
        END IF;
      --
      END LOOP;
    ELSE
      --
       IF l_created_new_ne
        THEN
      ---------------------------------------------
      --deal with any of memberships for this group
      ---------------------------------------------
      --create new memberships for any existing parent groups that new nt type is valid for
--       INSERT INTO NM_MEMBERS_ALL
--             (nm_ne_id_in
--             ,nm_ne_id_of
--             ,nm_type
--             ,nm_obj_type
--             ,nm_begin_mp
--             ,nm_start_date
--             ,nm_end_date
--             ,nm_end_mp
--             ,nm_slk
--             ,nm_cardinality
--             ,nm_admin_unit
--             ,nm_seq_no
--             ,nm_seg_no
--             ,nm_true
--             )
--       SELECT nm_ne_id_in
--             ,p_new_ne_id
--             ,nm_type
--             ,nm_obj_type
--             ,nm_begin_mp
--             ,p_new_ne.ne_start_date
--             ,DECODE(LEAST(NVL(p_new_ne.ne_end_date,b.big_date),NVL(nm_end_date,b.big_date))
--                    ,b.big_date,NULL
--                    ,LEAST(NVL(p_new_ne.ne_end_date,b.big_date),NVL(nm_end_date,b.big_date))
--                    )
--             ,nm_end_mp
--             ,nm_slk
--             ,nm_cardinality
--             ,nm_admin_unit
--             ,nm_seq_no
--             ,nm_seg_no
--             ,nm_true
--        FROM  nm_members a
--             ,nm_group_relations
--             ,(SELECT Nm3type.get_big_date big_date FROM dual) b
--       WHERE  nm_ne_id_of           = p_old_ne.ne_id
--        AND   ngr_parent_group_type = nm_obj_type
--        AND   ngr_child_group_type  = p_new_ne.ne_gty_group_type;
      --
      --
      Nm3ausec.set_status ( Nm3type.c_off );
      reclassify_members ( p_old_ne  => p_old_ne
                         , p_new_ne  => l_rec_new_ne );
      Nm3ausec.set_status ( Nm3type.c_on );

      --
      -- CWS 0110555 Parent members were not being recreated during reclassify
        INSERT INTO NM_MEMBER_HISTORY
              (nmh_nm_ne_id_in
              ,nmh_nm_ne_id_of_old
              ,nmh_nm_ne_id_of_new
              ,nmh_nm_begin_mp
              ,nmh_nm_start_date
              ,nmh_nm_type
              ,nmh_nm_obj_type
              ,nmh_nm_end_date
              )
        SELECT nm_ne_id_in
              ,nm_ne_id_of
              ,p_new_ne_id
              ,nm_begin_mp
              ,nm_start_date
              ,nm_type
              ,nm_obj_type
              ,nm_end_date
         FROM  nm_members
              ,nm_group_relations
        WHERE  nm_ne_id_of           = p_old_ne.ne_id
         AND   ngr_parent_group_type = nm_obj_type
         AND   ngr_child_group_type  = p_new_ne.ne_gty_group_type;
   --
       IF Nm3nwad.ad_data_exist (p_old_ne.ne_id )
        THEN
           Nm3nwad.do_ad_reclass (pi_new_ne_id => p_new_ne_id
                                 ,pi_old_ne_id => p_old_ne.ne_id
                          , pi_new_ne_nt_type        => l_rec_new_ne.ne_nt_type
                                , pi_new_ne_gty_group_type => l_rec_new_ne.ne_gty_group_type);

       END IF;
   --
       --end date all existing of memberships for old element
       UPDATE nm_members
        SET   nm_end_date = p_new_ne.ne_start_date
       WHERE  nm_ne_id_of = p_old_ne.ne_id;
 
      ----------------------
      --end date old element
      ----------------------
      UPDATE nm_elements
         SET ne_end_date  = p_new_ne.ne_start_date
       WHERE ne_id = p_old_ne.ne_id;
     END IF;
    END IF;

    --
    --if it is not an inclusion type then just create a new group, copy elements into the new group
    --and end date the original members and the original group
    --

    --if it is an inclusion group then we are end-datng the elements in the group.
    --all elements must be end-dated and new ones created using the some of the same columns
    --except those that are used for auto-inclusion
    --
    --The element sub-class must be allowed on the new route,
    --We assume that the node type is the same
    --
    --What is the grouping mechanism, find it and populate the grouping columns of the elements
    -- group type
    --
    -- This should set the end-date of the original route shape and recreate the new

    Nm3sdm.reshape_route ( pi_ne_id           => p_old_ne.ne_id
                         , pi_effective_date  => p_new_ne.ne_start_date
                         , pi_use_history     => 'Y' );

    --
    Nm3sdm.reshape_route ( pi_ne_id           => p_new_ne_id
                         , pi_effective_date  => p_new_ne.ne_start_date
                         , pi_use_history     => 'Y' );

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'reclassify_group' );
  --
  END reclassify_group;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION get_member_count ( p_ne_id IN nm_elements.ne_id%TYPE )
    RETURN NUMBER IS
    --
    CURSOR cs_mem_count ( c_ne_id nm_elements.ne_id%TYPE ) IS
      SELECT COUNT ( * )
        FROM nm_members
       WHERE nm_ne_id_in = c_ne_id;

    --
    retval  NUMBER;
  --
  BEGIN
    --
    OPEN cs_mem_count ( p_ne_id );

    FETCH cs_mem_count INTO retval;

    CLOSE cs_mem_count;

    --
    RETURN retval;
  --
  END get_member_count;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE remove_reclass_details ( p_job_id IN NM_RECLASS_DETAILS.nrd_job_id%TYPE ) IS
    --
    CURSOR cs_nrd ( c_job_id NM_RECLASS_DETAILS.nrd_job_id%TYPE ) IS
          SELECT 'x'
            FROM NM_RECLASS_DETAILS
           WHERE nrd_job_id = c_job_id
      FOR UPDATE OF nrd_job_id NOWAIT;
  --
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'remove_reclass_details' );

    --
    -- Lock and delete the specified NM_RECLASS_DETAILS records
    --
    FOR cs_rec IN cs_nrd ( p_job_id )
    LOOP
      --
      DELETE FROM NM_RECLASS_DETAILS
            WHERE CURRENT OF cs_nrd;
    --
    END LOOP;

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'remove_reclass_details' );
  --
  END remove_reclass_details;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE ins_nrd ( p_rec_nrd IN NM_RECLASS_DETAILS%ROWTYPE ) IS
  BEGIN
    --
    IF g_gis_call
    THEN
      INSERT INTO NM_RECLASS_DETAILS ( nrd_job_id
                                     , nrd_old_ne_id
                                     , nrd_new_ne_id
                                     , nrd_timestamp )
           VALUES ( p_rec_nrd.nrd_job_id
                  , p_rec_nrd.nrd_old_ne_id
                  , p_rec_nrd.nrd_new_ne_id
                  , NVL ( p_rec_nrd.nrd_timestamp, SYSDATE ) );
    END IF;
  --
  END ins_nrd;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE move_flexible_cols ( p_old_rec IN     nm_elements%ROWTYPE
                               , p_new_rec IN OUT nm_elements%ROWTYPE ) IS
    --
    CURSOR cs_ntc ( c_nt NM_TYPES.nt_type%TYPE ) IS
      SELECT ntc_column_name
        FROM NM_TYPE_COLUMNS
       WHERE ntc_nt_type = c_nt;

    --
    l_been_in_loop  BOOLEAN := FALSE;
  --
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'move_flexible_cols' );
    --
    -- Copy the values into the global variables
    g_dyn_rec_ne   := p_old_rec;
    g_dyn_rec_ne2  := p_new_rec;
    --
    g_block        := 'BEGIN';

    FOR col_rec IN cs_ntc ( p_new_rec.ne_nt_type )
    LOOP
      l_been_in_loop  := TRUE;
      g_block         :=
        g_block ||
        CHR ( 10 ) ||
        '   nm3reclass.g_dyn_rec_ne2.' ||
        col_rec.ntc_column_name ||
        ' := nm3reclass.g_dyn_rec_ne.' ||
        col_rec.ntc_column_name ||
        ';';
    END LOOP;

    g_block        :=
      g_block ||
      CHR ( 10 ) ||
      'END;';

    --
    IF l_been_in_loop
    THEN
      -- nm_debug.debug(g_block);
      EXECUTE IMMEDIATE g_block;

      -- Move the values back from the global variables
      p_new_rec  := g_dyn_rec_ne2;
    ELSE
      NULL;
    -- nm_debug.debug('No flexible columns defined - No changes made');
    END IF;

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'move_flexible_cols' );
  --
  END move_flexible_cols;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE check_unique ( p_nt_type IN     nm_elements.ne_nt_type%TYPE
                         , p_unique  IN OUT nm_elements.ne_unique%TYPE ) IS
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'check_unique' );

    --
    IF Nm3net.is_pop_unique ( p_nt_type )
    THEN
      IF p_unique IS NOT NULL
      THEN
        -- This is not an error - a unique ref is supplied and we expect to build one - the unique is set to null
        -- nm_debug.debug(' a unique ref is supplied and we expect to build one ');
        p_unique  := NULL;
      END IF;
    ELSIF p_unique IS NULL
    THEN
      --     error - a unique ref is not supplied and we do not expect to build one.
      g_reclass_exc_code  := -20803;
      g_reclass_exc_msg   := 'No Unique reference has been supplied';
      RAISE g_reclass_exception;
    END IF;

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'check_unique' );
  --
  END check_unique;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION is_subclass_valid ( p_nt_type    VARCHAR2
                             , p_sub_class  VARCHAR2 )
    RETURN BOOLEAN IS
    --
    CURSOR cs_nsc ( c_nt_type    VARCHAR2
                  , c_sub_class  VARCHAR2 ) IS
      SELECT 1
        FROM NM_TYPE_SUBCLASS
       WHERE nsc_nw_type = c_nt_type
         AND nsc_sub_class = c_sub_class;

    --
    l_dummy   NUMBER;
    l_retval  BOOLEAN;
  --
  BEGIN
    --
    IF p_sub_class IS NULL
    THEN
      RETURN TRUE;
    END IF;

    --
    OPEN cs_nsc ( p_nt_type
                , p_sub_class );

    FETCH cs_nsc INTO l_dummy;

    l_retval  := cs_nsc%FOUND;

    CLOSE cs_nsc;

    --
    RETURN l_retval;
  --
  END is_subclass_valid;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE update_node_usages ( p_old_ne_id  NUMBER
                               , p_new_ne_id  NUMBER ) IS
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'update_node_usages' );

    --
    UPDATE nm_node_usages nnu1
       SET nnu1.nnu_leg_no      =
             ( SELECT nnu2.nnu_leg_no
                 FROM nm_node_usages nnu2
                WHERE nnu2.nnu_ne_id = p_old_ne_id
                  AND nnu2.nnu_chain = nnu1.nnu_chain
                  AND nnu2.nnu_no_node_id = nnu1.nnu_no_node_id )
     WHERE nnu1.nnu_ne_id = p_new_ne_id
       AND EXISTS
             (SELECT 1
                FROM nm_node_usages nnu2
               WHERE nnu2.nnu_ne_id = p_old_ne_id
                 AND nnu2.nnu_chain = nnu1.nnu_chain
                 AND nnu2.nnu_no_node_id = nnu1.nnu_no_node_id);

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'update_node_usages' );
  --
  END update_node_usages;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE reclassify_other_products ( pi_old_ne_id       nm_elements.ne_id%TYPE
                                      , pi_new_ne_id       nm_elements.ne_id%TYPE
                                      , pi_effective_date  DATE ) IS
    --
    PROCEDURE exec_reclass ( p_pack_proc VARCHAR2 ) IS
    BEGIN
      IF p_pack_proc IS NOT NULL
      THEN
        EXECUTE IMMEDIATE
          'BEGIN' ||
          CHR ( 10 ) ||
          '   ' ||
          p_pack_proc ||
          '(:pi_old_ne_id,:pi_new_ne_id,:pi_effective_date);' ||
          CHR ( 10 ) ||
          'END;'
          USING IN pi_old_ne_id
              , pi_new_ne_id
              , pi_effective_date;
      END IF;
    END exec_reclass;
  --
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'reclassify_other_products' );

    --
    IF Hig.is_product_licensed ( Nm3type.c_acc )
    THEN
      exec_reclass ( 'accloc.acc_reclassify' );
    END IF;

    --
    IF Hig.is_product_licensed ( Nm3type.c_str )
    THEN
      exec_reclass ( 'strrecal.str_reclassify' );
    END IF;

    --
    IF Hig.is_product_licensed ( Nm3type.c_mai )
    THEN
      exec_reclass ( 'mairecal.mai_reclassify' );
    END IF;

    --
    IF Hig.is_product_licensed ( Nm3type.c_stp )
    THEN
      exec_reclass ( 'stp_network_ops.do_reclassify' );
    END IF;

    --
    IF Hig.is_product_licensed ( Nm3type.c_enq )
    THEN
      exec_reclass ( 'enqreclass.enq_reclassify' );
    END IF;

    --
    IF Hig.is_product_licensed ( Nm3type.c_ukp )
    THEN
      /* Not using exec_reclass because there is no need for a date */
      EXECUTE IMMEDIATE
        'BEGIN' ||
        CHR ( 10 ) ||
        '   ukpreclass.reclassify( p_original_rse => :pi_old_ne_id ' ||
        CHR ( 10 ) ||
        '                         ,p_new_rse => :pi_new_ne_id); ' ||
        CHR ( 10 ) ||
        'END;'
        USING IN pi_old_ne_id
            , pi_new_ne_id;
    END IF;

    --
    -- GJ 30/11/05
    -- not actually required cos when NSG streets are reclassified they
    -- re-use the original NE_ID
    --
    --   IF Hig.is_product_licensed(Nm3type.c_swr)
    --    THEN
    --      exec_reclass ('swr_reclassify.do_reclassify');
    --   END IF;

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'reclassify_other_products' );
  --
  END reclassify_other_products;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION does_nt_scl_change_break_xsp ( p_ne_id_of      nm_members.nm_ne_id_of%TYPE
                                        , p_new_nw_type   xsp_restraints.xsr_nw_type%TYPE
                                        , p_new_subclass  nm_elements.ne_sub_class%TYPE )
    RETURN BOOLEAN IS
    --
    l_subclass_default  VARCHAR2 ( 100 )
                          := RTRIM ( LTRIM ( NM3GET.GET_NTC ( p_new_nw_type
                                                            , 'NE_SUB_CLASS'
                                                            , FALSE ).NTC_DEFAULT
                                           , '''' )
                                   , '''' );

    CURSOR cs_exists ( c_ne_id_of          nm_members.nm_ne_id_of%TYPE
                     , c_new_nw_type       xsp_restraints.xsr_nw_type%TYPE
                     , c_new_subclass      nm_elements.ne_sub_class%TYPE
                     , c_subclass_default  nm_elements.ne_sub_class%TYPE ) IS
      SELECT 1
        FROM nm_inv_items
           , nm_inv_types nit
           , nm_members
       WHERE nm_ne_id_of = c_ne_id_of
         AND nm_ne_id_in = iit_ne_id
         AND iit_inv_type = nit.nit_inv_type
         AND nit.nit_x_sect_allow_flag = 'Y'
         AND NOT EXISTS
               (SELECT 1
                  FROM xsp_restraints
                 WHERE xsr_nw_type = c_new_nw_type
                   AND xsr_ity_inv_code = iit_inv_type
                   AND xsr_scl_class = NVL ( NVL ( RTRIM ( LTRIM ( c_new_subclass
                                                                 , '''' )
                                                         , '''' )
                                                 , c_subclass_default )
                                           , xsr_scl_class )
                   AND xsr_x_sect_value = iit_x_sect);

    -- CWS 16/02/10 0109092 -- Not required as these values are ignored later. No message is required.
    /* OR NOT  EXISTS (SELECT 1
                    FROM  nm_inv_nw
                   WHERE  nin_nw_type = c_new_nw_type
                    AND   nin_nit_inv_code = iit_inv_type))*/
    --
    l_dummy             BINARY_INTEGER;
    --
    l_retval            BOOLEAN;
  --
  BEGIN
    --
    Nm_Debug.proc_start ( g_package_name
                        , 'does_subclass_change_break_xsp' );

    --
    OPEN cs_exists ( p_ne_id_of
                   , p_new_nw_type
                   , p_new_subclass
                   , l_subclass_default );

    FETCH cs_exists INTO l_dummy;

    l_retval  := cs_exists%FOUND;

    CLOSE cs_exists;

    --
    Nm_Debug.proc_end ( g_package_name
                      , 'does_subclass_change_break_xsp' );
    --
    RETURN l_retval;
  --
  END does_nt_scl_change_break_xsp;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE ins_member ( p_rec_nm IN OUT nm_members%ROWTYPE ) IS
    l_rec_nm  NM_MEMBERS_ALL%ROWTYPE;
  BEGIN
    --
    BEGIN
      Nm3ins.ins_nm ( p_rec_nm );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
        --
        -- If there's already one there
        --  then check to make that it is the same (and end-dated)
        -- If so then replace it
        --
        l_rec_nm      :=
          Nm3get.get_nm_all ( pi_nm_ne_id_in    => p_rec_nm.nm_ne_id_in
                            , pi_nm_ne_id_of    => p_rec_nm.nm_ne_id_of
                            , pi_nm_begin_mp    => p_rec_nm.nm_begin_mp
                            , pi_nm_start_date  => p_rec_nm.nm_start_date );

        IF NVL ( l_rec_nm.nm_end_mp, -1 ) != NVL ( p_rec_nm.nm_end_mp, -1 )
        OR  l_rec_nm.nm_end_date IS NULL
        OR  l_rec_nm.nm_end_date != p_rec_nm.nm_start_date
        THEN
          RAISE;
        END IF;

        Nm3del.del_nm_all ( pi_nm_ne_id_in    => p_rec_nm.nm_ne_id_in
                          , pi_nm_ne_id_of    => p_rec_nm.nm_ne_id_of
                          , pi_nm_begin_mp    => p_rec_nm.nm_begin_mp
                          , pi_nm_start_date  => p_rec_nm.nm_start_date );
        Nm3ins.ins_nm ( p_rec_nm );
    END;
  --
  END ins_member;

  --
  ---------------------------------------------------------------------------------------------------
  --
  FUNCTION ne_type_can_be_reclassed ( pi_ne_type nm_elements.ne_type%TYPE )
    RETURN BOOLEAN IS
  BEGIN
    Nm_Debug.proc_start ( p_package_name    => g_package_name
                        , p_procedure_name  => 'ne_type_can_be_reclassed' );

    Nm_Debug.proc_end ( p_package_name    => g_package_name
                      , p_procedure_name  => 'ne_type_can_be_reclassed' );

    RETURN pi_ne_type IN ('S', 'G');
  END ne_type_can_be_reclassed;

  --
  ---------------------------------------------------------------------------------------------------
  --
  PROCEDURE ins_doc_assocs ( pi_new_id      doc_assocs.das_rec_id%TYPE --varchar2
                           , pi_old_id      doc_assocs.das_rec_id%TYPE --varchar2
                           , pi_doc_id      doc_assocs.das_doc_id%TYPE DEFAULT NULL --number
                           , pi_table_name  doc_assocs.das_table_name%TYPE ) IS
  BEGIN
    IF pi_doc_id IS NULL
    THEN
      UPDATE doc_assocs
         SET das_rec_id  = pi_new_id
       WHERE das_table_name = pi_table_name
         AND das_rec_id = pi_old_id;
    ELSE
      UPDATE doc_assocs
         SET das_rec_id  = pi_new_id
       WHERE das_table_name = pi_table_name
         AND das_doc_id = NVL ( pi_doc_id, das_doc_id )
         AND das_rec_id = pi_old_id;
    END IF;
  END ins_doc_assocs;
--
---------------------------------------------------------------------------------------------------
--
END Nm3reclass;
/