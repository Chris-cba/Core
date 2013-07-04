CREATE OR REPLACE PACKAGE BODY nm3inv_xattr AS
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_xattr.pkb-arc   2.3   Jul 04 2013 16:08:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_xattr.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:08:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       PVCS Version     : $Revision:   2.3  $
--
--   Author : Rob Coupe
--
--   Xattr Validation package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.3  $"';
-- g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'NM3INV_XATTR';
--
   g_xiv_sysopt      CONSTANT  BOOLEAN        := NVL(hig.get_sysopt('XITEMVALID'),'N') = 'Y';
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
PROCEDURE process_xattr IS


--cursor to deal with all dependent item type rules

CURSOR c_get_indep_types( c_obj_type nm_members.nm_obj_type%TYPE ) IS
  SELECT nxl_rule_id, nxl_indep_type, nxl_existence_flag, nxr_error_id,
         nxl_conditional, nxl_indep_condition, nxl_dep_condition
  FROM nm_x_location_rules, nm_x_rules
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxl_dep_type = c_obj_type;

-- cursor to deal with all existence rules based on an independent item type
-- that is, where removal of the independent leaves stranded dependencies

CURSOR c_get_dep_types_at_end_date( c_obj_type nm_members.nm_obj_type%TYPE ) IS
  SELECT nxl_rule_id, nxl_dep_type, nxl_existence_flag, nxr_error_id,
         nxl_conditional, nxl_indep_condition, nxl_dep_condition
  FROM nm_x_location_rules, nm_x_rules
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxl_indep_type = c_obj_type
  AND   nxl_existence_flag = 'Y';

CURSOR c_get_dep_types( c_obj_type nm_members.nm_obj_type%TYPE ) IS
  SELECT nxl_rule_id, nxl_dep_type, nxl_existence_flag, nxr_error_id,
         nxl_conditional, nxl_indep_condition, nxl_dep_condition
  FROM nm_x_location_rules, nm_x_rules
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxl_indep_type = c_obj_type
  AND   nxl_existence_flag = 'N';

CURSOR c_get_nw_types( c_obj_type nm_members.nm_obj_type%TYPE ) IS
  SELECT nxn_rule_id, nxn_dep_type, nxn_existence_flag, nxr_error_id,
         nxn_conditional, nxn_indep_condition, nxn_dep_condition
  FROM nm_x_nw_rules, nm_x_rules
  WHERE nxn_rule_id = nxr_rule_id
  AND   nxn_dep_type = c_obj_type;


x_error_no number;
x_exception EXCEPTION;

l_loc_xattr loc_xattr;

BEGIN
--nm_debug.debug_on;
--nm_debug.debug('Process_xattr');
--nm_debug.debug('No of records affected = '|| TO_CHAR(nm3inv_xattr.g_tab_loc_idx_xattr));

  x_error_no := NULL;

  IF nm3inv_xattr.g_tab_loc_idx_xattr > 0 THEN

--  nm_debug.debug( 'Xattr - processing '||TO_CHAR(nm3inv_xattr.g_tab_loc_idx_xattr)||'records');

    FOR xrec IN 1..nm3inv_xattr.g_tab_loc_idx_xattr LOOP

      IF nm3inv_xattr.g_tab_rec_xattr(xrec).dep_class = 'D' THEN

--
--      nm_debug.debug( 'Xattr - dep - record '||TO_CHAR(xrec)||' '||nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type );

        FOR obrec IN c_get_indep_types( nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type ) LOOP
--
--        The item is dependent on the (non)existence of other items?
--
--
          l_loc_xattr := nm3inv_xattr.g_tab_rec_xattr(xrec);
          l_loc_xattr.nm_obj_type := obrec.nxl_indep_type;

--        nm_debug.debug( get_dep_location_query( obrec.nxl_rule_id, l_loc_xattr ) );

          IF NOT check_x_location_rule( obrec.nxl_existence_flag,
                                     nm3inv_xattr.g_tab_rec_xattr(xrec),
                                     get_dep_location_query( obrec.nxl_rule_id, l_loc_xattr ) ) THEN
            x_error_no := obrec.nxr_error_id;
                RAISE x_exception;
          END IF;
--
        END LOOP;

      ELSIF nm3inv_xattr.g_tab_rec_xattr(xrec).dep_class = 'I' THEN
--
--
--       nm_debug.debug( 'Xattr - indep - record '||TO_CHAR(xrec)||' '||nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type );
--       nm_debug.debug( 'Check dependencies over '||TO_CHAR(nm3inv_xattr.g_tab_rec_xattr(xrec).nm_ne_id_of)||' from '||
--                        TO_CHAR(nm3inv_xattr.g_tab_rec_xattr(xrec).nm_begin_mp)||' to '||
--                        TO_CHAR(nm3inv_xattr.g_tab_rec_xattr(xrec).nm_end_mp));

        IF nm3inv_xattr.g_tab_rec_xattr(xrec).op = 'C' then

          FOR obrec IN c_get_dep_types_at_end_date( nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type ) LOOP
  --
  --        The item has dependencies
  --
  --
            l_loc_xattr := nm3inv_xattr.g_tab_rec_xattr(xrec);
            l_loc_xattr.nm_obj_type := obrec.nxl_dep_type;

--          nm_debug.debug(get_indep_location_query( obrec.nxl_rule_id, l_loc_xattr,
--                                                   nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type,
--                                                   nm3inv_xattr.g_tab_rec_xattr(xrec).op ));

            IF NOT check_x_location_rule( 'N',
                                       nm3inv_xattr.g_tab_rec_xattr(xrec),
                                       get_indep_location_query( obrec.nxl_rule_id, l_loc_xattr,
                                                                 nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type,
                                                                 nm3inv_xattr.g_tab_rec_xattr(xrec).op ) ) THEN
              x_error_no := obrec.nxr_error_id;
              RAISE x_exception;
            END IF;
  --
          END LOOP;
        ELSE
          FOR obrec IN c_get_dep_types( nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type ) LOOP
  --
  --        The item has dependencies
  --
  --
            l_loc_xattr := nm3inv_xattr.g_tab_rec_xattr(xrec);
            l_loc_xattr.nm_obj_type := obrec.nxl_dep_type;

--          nm_debug.debug(get_indep_location_query( obrec.nxl_rule_id, l_loc_xattr,
--                                                   nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type,
--                                                   nm3inv_xattr.g_tab_rec_xattr(xrec).op ));

            IF NOT check_x_location_rule( 'N',
                                       nm3inv_xattr.g_tab_rec_xattr(xrec),
                                       get_indep_location_query( obrec.nxl_rule_id, l_loc_xattr,
                                                                 nm3inv_xattr.g_tab_rec_xattr(xrec).nm_obj_type,
                                                                 nm3inv_xattr.g_tab_rec_xattr(xrec).op ) ) THEN
              x_error_no := obrec.nxr_error_id;
              RAISE x_exception;
            END IF;
  --
          END LOOP;
        END IF;

      ELSIF nm3inv_xattr.g_tab_rec_xattr(xrec).dep_class = 'N' THEN


--      nm_debug.debug( 'Xattr - NW dep - record '||TO_CHAR(xrec)||' '||nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type );

        FOR obrec IN c_get_nw_types( nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type ) LOOP
--
--        The item is dependent on the (non)existence of nw data
--
--        nm_debug.debug( get_nw_item_query( obrec.nxn_rule_id, nm3inv_xattr.g_tab_rec_xattr(xrec).nm_ne_id_in));

          IF NOT check_x_item_rule(obrec.nxn_existence_flag,
                                   get_nw_item_query( obrec.nxn_rule_id, nm3inv_xattr.g_tab_rec_xattr(xrec).nm_ne_id_in)) THEN

            x_error_no := obrec.nxr_error_id;
                RAISE x_exception;
          END IF;

        END LOOP;


      END IF;
--
    END LOOP;

  ELSE
  -- nm_debug.debug(' Nothing to validate ');
    NULL;
  END IF;


-- nm_debug.debug_off;
  EXCEPTION
--
   WHEN x_exception
    THEN
      Raise_Application_Error( -20760, nm3inv_xattr_gen.get_error_string(x_error_no));
--      nm_debug.debug('exception '||nm3inv_xattr_gen.get_error_string(x_error_no));
--      nm_debug.debug_off;

END process_xattr;
--
-----------------------------------------------------------------------------
PROCEDURE clear_loc_xattr IS
BEGIN
  --nm_debug.debug('Xattr - Setting the idx to zero');
  g_tab_loc_idx_xattr := 0;

END clear_loc_xattr;
--
-----------------------------------------------------------------------------
PROCEDURE clear_inv_xattr IS
BEGIN
  --nm_debug.debug('Xattr - Setting the idx to zero');
  g_tab_item_idx_xattr := 0;

END clear_inv_xattr;
--
-----------------------------------------------------------------------------
FUNCTION location_rule( pi_dep_class IN varchar2, pi_obj_type IN nm_members_all.nm_obj_type%TYPE) RETURN varchar2 IS

CURSOR c_is_dep(c_obj_type nm_members_all.nm_obj_type%TYPE ) IS
 SELECT 1 FROM nm_x_location_rules
 WHERE nxl_dep_type  = c_obj_type;

CURSOR c_has_dep(c_obj_type nm_members_all.nm_obj_type%TYPE ) IS
 SELECT 1 FROM nm_x_location_rules
 WHERE nxl_indep_type  = c_obj_type;

CURSOR c_dep_type(c_obj_type nm_members_all.nm_obj_type%TYPE ) IS
  SELECT 1 FROM nm_x_location_rules,
                nm_x_rules, nm_x_driving_conditions
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxd_rule_id = nxr_rule_id
  AND   nxl_dep_condition = nxd_if_condition;

CURSOR c_indep_type(c_obj_type nm_members_all.nm_obj_type%TYPE ) IS
  SELECT 1 FROM nm_x_location_rules,
                nm_x_rules,
                                nm_x_driving_conditions
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxd_rule_id = nxr_rule_id
  AND   nxl_indep_condition = nxd_if_condition;


retval  varchar2(13);
l_dummy integer;

BEGIN
  IF pi_dep_class = 'D' THEN
    OPEN c_is_dep( pi_obj_type );
    FETCH c_is_dep INTO l_dummy;
    IF c_is_dep%FOUND THEN
      retval := 'UNCONDITIONAL';
      CLOSE c_is_dep;
    ELSE
      CLOSE c_is_dep;
      OPEN c_dep_type( pi_obj_type );
      FETCH c_dep_type INTO l_dummy;
          IF c_dep_type%FOUND THEN
        retval := 'CONDITIONAL';
        CLOSE c_dep_type;
          ELSE
        retval := 'NONE';
        CLOSE c_dep_type;
          END IF;
    END IF;
  ELSIF pi_dep_class = 'I' THEN
    OPEN c_has_dep( pi_obj_type );
    FETCH c_has_dep INTO l_dummy;
    IF c_has_dep%FOUND THEN
      retval := 'UNCONDITIONAL';
      CLOSE c_has_dep;
    ELSE
      CLOSE c_has_dep;
      OPEN c_indep_type( pi_obj_type );
      FETCH c_indep_type INTO l_dummy;
      IF c_indep_type%FOUND THEN
        retval := 'CONDITIONAL';
        CLOSE c_indep_type;
          ELSE
        retval := 'NONE';
        CLOSE c_indep_type;
      END IF;
        END IF;
  END IF;

  RETURN retval;
END location_rule;

--
FUNCTION get_inv_condition_text( pi_nxic_id IN nm_x_inv_conditions.nxic_id%TYPE ) RETURN varchar2 IS

nxcrow nm_x_inv_conditions%ROWTYPE;

CURSOR c1 IS
  SELECT *
  FROM nm_x_inv_conditions
  WHERE nxic_id = pi_nxic_id;

retval varchar2(2000);

BEGIN
  OPEN c1;
  FETCH c1 INTO nxcrow;
  CLOSE c1;

  retval := nxcrow.nxic_column_name||' '||
            nxcrow.nxic_condition||' '||
            nxcrow.nxic_value_list;

  RETURN retval;
END;
--

FUNCTION get_loc_constraint( pi_rule_id IN nm_x_location_rules.nxl_rule_id%TYPE ) RETURN varchar2 IS

nxlocrow nm_x_location_rules%ROWTYPE;

CURSOR c1 IS
  SELECT *
  FROM nm_x_location_rules
  WHERE nxl_rule_id = pi_rule_id;

--ic_id = pi_nxic_id;

retval varchar2(2000);

BEGIN
  OPEN c1;
  FETCH c1 INTO nxlocrow;
  CLOSE c1;

  retval := '';
  IF nxlocrow.nxl_operator IS NOT NULL THEN
    retval := nxlocrow.nxl_indep_type||'.'||nxlocrow.nxl_indep_attr||' '||
              nxlocrow.nxl_operator||' '||
              nxlocrow.nxl_dep_type||'.'||nxlocrow.nxl_dep_attr;
  END IF;

  RETURN retval;
END;
--


FUNCTION get_dep_location_query( pi_rule_id nm_x_location_rules.nxl_rule_id%TYPE,
                             pi_loc_xattr IN loc_xattr ) RETURN varchar2 IS

nxlobj vnm_x_location_rules%ROWTYPE;
retval varchar2(2000);
lf     varchar2(1) := CHR(10);

BEGIN

  SELECT * INTO nxlobj
  FROM vnm_x_location_rules
  WHERE nxl_rule_id = pi_rule_id;


--nm_debug.debug('get_dep_location_query ');


  IF nxlobj.nxl_conditional = 'N' AND nxlobj.nxl_xsp_match = 'N' THEN

    retval := 'select nm_ne_id_in, nm_obj_type, nm_ne_id_of, nm_begin_mp, nm_end_mp '||lf||
              'from nm_members '||lf||
              'where nm_obj_type   = '||''''||pi_loc_xattr.nm_obj_type||''''||lf||
              'and   nm_ne_id_of   = '||pi_loc_xattr.nm_ne_id_of||lf||
              'and   nm_begin_mp   < '||pi_loc_xattr.nm_end_mp||lf||
              'and   nm_end_mp     > '||pi_loc_xattr.nm_begin_mp||lf||
              'order by 3,4';
  ELSE

--  we need to use an alias for two joins to the inv table

    retval := 'select nm_ne_id_in, nm_obj_type, nm_ne_id_of, nm_begin_mp, nm_end_mp '||lf||
                  'from nm_members ';

    IF nxlobj.nxl_indep_condition IS NOT NULL OR nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval ||', nm_inv_items '||nxlobj.nxl_indep_type;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL OR nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval ||', nm_inv_items '||nxlobj.nxl_dep_type;
    END IF;

    retval := retval ||lf||
              'where nm_obj_type   = '||''''||pi_loc_xattr.nm_obj_type||''''||lf||
              'and   nm_ne_id_of   = '||pi_loc_xattr.nm_ne_id_of||lf||
              'and   nm_begin_mp   < '||pi_loc_xattr.nm_end_mp||lf||
              'and   nm_end_mp     > '||pi_loc_xattr.nm_begin_mp||lf;

    IF nxlobj.nxl_indep_condition IS NOT NULL OR
       nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
              'and  '||nxlobj.nxl_indep_type||'.iit_ne_id = nm_ne_id_in'||lf;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL OR
       nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.iit_ne_id = '||pi_loc_xattr.nm_ne_id_in||lf;
    END IF;

    IF nxlobj.nxl_indep_condition IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_indep_type||'.'||get_inv_condition_text(nxlobj.nxl_indep_condition)||lf;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.'||get_inv_condition_text(nxlobj.nxl_dep_condition)||lf;
    END IF;

    IF nxlobj.nxl_constraint IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_constraint||lf;
    END IF;

    IF nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
              'and '||nxlobj.nxl_dep_type||'.IIT_X_SECT = '||nxlobj.nxl_indep_type||'.IIT_X_SECT'||lf;
    END IF;

    retval := retval||'order by 3,4';

  END IF;
  RETURN retval;
END;

-----------------------------------------------------------------------------

FUNCTION get_indep_location_query( pi_rule_id nm_x_location_rules.nxl_rule_id%TYPE,
                                   pi_loc_xattr IN loc_xattr,
                                   pi_indep_type in nm_members.nm_obj_type%TYPE,
                                   pi_op varchar2 ) RETURN varchar2 IS

nxlobj vnm_x_location_rules%ROWTYPE;
retval varchar2(2000);
lf     varchar2(1) := CHR(10);

BEGIN

  SELECT * INTO nxlobj
  FROM vnm_x_location_rules
  WHERE nxl_rule_id = pi_rule_id;

--nm_debug.debug( 'get_indep_location_query '||pi_loc_xattr.nm_obj_type );

--nm_debug.debug( 'Conditional = '||nxlobj.nxl_conditional||' xsp match = '||nxlobj.nxl_xsp_match );

  IF nxlobj.nxl_conditional = 'N' AND nxlobj.nxl_xsp_match = 'N' THEN

    if is_type_multi_allowed( pi_indep_type ) then

      retval := 'select d.nm_ne_id_in, d.nm_obj_type, d.nm_ne_id_of, d.nm_begin_mp, d.nm_end_mp '||lf||
                    'from nm_members d'||lf||
                            'where d.nm_obj_type   = '||''''||pi_loc_xattr.nm_obj_type||''''||lf||
                            'and   d.nm_ne_id_of   = '||pi_loc_xattr.nm_ne_id_of||lf||
                            'and   d.nm_begin_mp   < '||pi_loc_xattr.nm_end_mp||lf||
                            'and   d.nm_end_mp     > '||pi_loc_xattr.nm_begin_mp||lf||
                            'and not exists ( select 1 from nm_members ind2, nm_inv_items i2'||lf||
                            'where i2.iit_ne_id = ind2.nm_ne_id_in'||lf||
                            'and   i2.iit_ne_id != '||pi_loc_xattr.nm_ne_id_in||lf||
                            'and   i2.iit_inv_type = '||''''||pi_indep_type||''''||lf||
                            'and   ind2.nm_ne_id_of = '||pi_loc_xattr.nm_ne_id_of||lf||
                            'and   ind2.nm_begin_mp  <= d.nm_begin_mp'||lf||
                            'and   ind2.nm_end_mp    >= d.nm_end_mp )'||lf||
                            'order by 1,3,4';


    else
--
--  we are modifying the only object of its type - just check for a single dependent
--

      retval := 'select nm_ne_id_in, nm_obj_type, nm_ne_id_of, nm_begin_mp, nm_end_mp '||lf||
                    'from nm_members '||lf||
                            'where nm_obj_type   = '||''''||pi_loc_xattr.nm_obj_type||''''||lf||
                            'and   nm_ne_id_of   = '||pi_loc_xattr.nm_ne_id_of||lf||
                            'and   nm_begin_mp   < '||pi_loc_xattr.nm_end_mp||lf||
                            'and   nm_end_mp     > '||pi_loc_xattr.nm_begin_mp||lf||
                            'order by 1,3,4';

    END IF;

  ELSE

--  we may need to use an alias for two joins to the inv table


    retval := 'select d.nm_ne_id_in, d.nm_obj_type, d.nm_ne_id_of, d.nm_begin_mp, d.nm_end_mp '||lf||
                  'from nm_members d';

    IF nxlobj.nxl_dep_condition IS NOT NULL OR nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval ||', nm_inv_items '||nxlobj.nxl_dep_type;
    END IF;

    IF nxlobj.nxl_indep_condition IS NOT NULL OR nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval ||', nm_inv_items '||nxlobj.nxl_indep_type;
    END IF;

    retval := retval ||lf||
            'where d.nm_obj_type   = '||''''||pi_loc_xattr.nm_obj_type||''''||lf||
            'and   d.nm_ne_id_of   = '||pi_loc_xattr.nm_ne_id_of||lf||
            'and   d.nm_begin_mp   < '||pi_loc_xattr.nm_end_mp||lf||
            'and   d.nm_end_mp     > '||pi_loc_xattr.nm_begin_mp||lf;

    IF nxlobj.nxl_indep_condition IS NOT NULL OR
       nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
              'and  '||nxlobj.nxl_indep_type||'.iit_ne_id = '||pi_loc_xattr.nm_ne_id_in||lf;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL OR
       nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.iit_ne_id = d.nm_ne_id_in '||lf;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL THEN
        retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.'||get_inv_condition_text(nxlobj.nxl_dep_condition)||lf;
    END IF;

    IF nxlobj.nxl_constraint IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_constraint||lf;
    END IF;

    IF nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
             ' and '||nxlobj.nxl_dep_type||'.IIT_X_SECT = '||nxlobj.nxl_indep_type||'.IIT_X_SECT'||lf;
    END IF;

    if is_type_multi_allowed( pi_indep_type ) then
      retval := retval||
              'and not exists ( select 1 from nm_members ind2, nm_inv_items i2'||lf||
              'where i2.iit_ne_id = ind2.nm_ne_id_in'||lf;

      if nxlobj.nxl_indep_condition IS NOT NULL then
        retval := retval||
                'and i2.'||get_inv_condition_text(nxlobj.nxl_indep_condition)||lf;
      end if;

      retval := retval||
              'and   i2.iit_end_chain is not null'||lf||
              'and   i2.iit_ne_id != '||pi_loc_xattr.nm_ne_id_in||lf||
              'and   i2.iit_inv_type = '||''''||pi_indep_type||''''||lf||
              'and   ind2.nm_ne_id_of = '||pi_loc_xattr.nm_ne_id_of||lf||
              'and   ind2.nm_begin_mp <= d.nm_begin_mp'||lf||
              'and   ind2.nm_end_mp   >= d.nm_end_mp )';
    end if;

    retval := retval||'order by 1,3,4';

--  nm_debug.debug( retval);

  END IF;
  RETURN retval;
END;

-----------------------------------------------------------------------------

PROCEDURE process_item_xattr IS

--cursor to deal with all dependent item type rules

CURSOR c_get_indep_types( c_obj_type nm_members.nm_obj_type%TYPE ) IS
  SELECT nxl_rule_id, nxl_indep_type, nxl_existence_flag, nxr_error_id,
         nxl_conditional, nxl_indep_condition, nxl_dep_condition
  FROM nm_x_location_rules, nm_x_rules
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxl_dep_type = c_obj_type
  AND   nxl_existence_flag = 'N';

-- cursor to deal with all existence rules based on an independent item type
-- that is, where modification to the independent leaves stranded dependencies

CURSOR c_get_dep_types( c_obj_type nm_members.nm_obj_type%TYPE)  IS
  SELECT nxl_rule_id, nxl_dep_type, nxl_existence_flag, nxr_error_id,
         nxl_conditional, nxl_indep_condition, nxl_dep_condition
  FROM nm_x_location_rules, nm_x_rules
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxl_indep_type = c_obj_type
  AND   nxl_existence_flag = 'N';

-- cursor to deal with all existence rules based on nw

CURSOR c_get_nw_types( c_obj_type nm_members.nm_obj_type%TYPE ) IS
  SELECT nxn_rule_id, nxn_indep_nw_type, nxn_existence_flag, nxr_error_id,
         nxn_conditional, nxn_indep_condition, nxn_dep_condition
  FROM nm_x_nw_rules, nm_x_rules
  WHERE nxn_rule_id = nxr_rule_id
  AND   nxn_dep_type = c_obj_type
  AND   nxn_existence_flag = 'N';

-- cursor to deal with cases where the independent item has been end-dated

CURSOR c_get_dep_types_at_end_date( c_obj_type nm_members.nm_obj_type%TYPE)  IS
  SELECT nxl_rule_id, nxl_dep_type, nxl_existence_flag, nxr_error_id,
         nxl_conditional, nxl_indep_condition, nxl_dep_condition
  FROM nm_x_location_rules, nm_x_rules
  WHERE nxl_rule_id = nxr_rule_id
  AND   nxl_indep_type = c_obj_type
  AND   nxl_existence_flag = 'Y';


x_error_no number;
x_exception EXCEPTION;

cur_string varchar2(2000);

BEGIN
--nm_debug.debug_on;
--nm_debug.debug( 'process_item_xattr');
--nm_debug.debug('No of records affected = '|| TO_CHAR(nm3inv_xattr.g_tab_item_idx_xattr));

  x_error_no := NULL;

  IF nm3inv_xattr.g_tab_item_idx_xattr > 0 THEN

--  nm_debug.debug( 'Xattr - processing '||TO_CHAR(nm3inv_xattr.g_tab_item_idx_xattr)||'records');

    FOR xrec IN 1..nm3inv_xattr.g_tab_item_idx_xattr LOOP

      IF nm3inv_xattr.g_tab_loc_item_xattr(xrec).dep_class = 'D' THEN
--
--      nm_debug.debug( 'Xattr - dep - record '||TO_CHAR(xrec)||' '||nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type );

        FOR obrec IN c_get_indep_types( nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type ) LOOP
--
--        The item is dependent on the (non)existence of other items?
--
          cur_string := get_indep_item_query( obrec.nxl_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id );
--        nm_debug.debug( cur_string );

          IF NOT check_x_item_rule(obrec.nxl_existence_flag,
                                   get_indep_item_query( obrec.nxl_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id )) THEN

            x_error_no := obrec.nxr_error_id;
            RAISE x_exception;
          END IF;

        END LOOP;

     ELSIF nm3inv_xattr.g_tab_loc_item_xattr(xrec).dep_class = 'I' THEN
--
--     nm_debug.debug( 'Xattr - indep - record '||TO_CHAR(xrec)||' '||nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type );

--      if the end-date on the independent data has been set then we need to make sure that no dependents exist
--      over its extent. Otherwise, check all non-existence rules.

--      nm_debug.debug( nm3inv_xattr.g_tab_loc_item_xattr(xrec).op );
        if nm3inv_xattr.g_tab_loc_item_xattr(xrec).op != 'C' then

          FOR obrec IN c_get_dep_types( nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type) LOOP
--
--          The item has dependencies
--
            cur_string := get_dep_item_query( obrec.nxl_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id );

--          nm_debug.debug( 'Item has dependencies - rule '||to_char(obrec.nxl_rule_id)||' Item '||
--                          to_char(nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id) );
--          nm_debug.debug( cur_string );


            IF NOT check_x_item_rule(obrec.nxl_existence_flag,
                                     get_dep_item_query( obrec.nxl_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id )) THEN

              x_error_no := obrec.nxr_error_id;
              RAISE x_exception;
            END IF;
--
          END LOOP;

        ELSE

          trap_indep_end_date( nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id );

          FOR obrec IN c_get_dep_types_at_end_date( nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type) LOOP
--
--          The item has been end dated
--
            cur_string := get_dep_item_query( obrec.nxl_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id );

            nm_debug.debug( 'Item has dependencies - rule '||to_char(obrec.nxl_rule_id)||' Item '||
                            to_char(nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id) );
            nm_debug.debug( cur_string );


            IF NOT check_x_item_rule(obrec.nxl_existence_flag,
                                     get_dep_item_query_at_end_date( obrec.nxl_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id )) THEN

              x_error_no := obrec.nxr_error_id;
              RAISE x_exception;
            END IF;
--
          END LOOP;

        END IF;

      ELSIF nm3inv_xattr.g_tab_loc_item_xattr(xrec).dep_class = 'N' THEN

--      nm_debug.debug( 'Xattr - NW dep - record '||TO_CHAR(xrec)||' '||nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type );

        FOR obrec IN c_get_nw_types( nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_inv_type ) LOOP
--
--        The item is dependent on the (non)existence of nw data
--
          cur_string := get_nw_item_query( obrec.nxn_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id );
--        nm_debug.debug( cur_string );

          IF NOT check_x_item_rule(obrec.nxn_existence_flag,
                                   get_nw_item_query( obrec.nxn_rule_id, nm3inv_xattr.g_tab_loc_item_xattr(xrec).iit_ne_id )) THEN

            x_error_no := obrec.nxr_error_id;
            RAISE x_exception;
          END IF;

        END LOOP;

      END IF;
--
    END LOOP;

  ELSE
--  nm_debug.debug(' Nothing to validate ');
    NULL;
  END IF;


-- nm_debug.debug_off;
  EXCEPTION
--
   WHEN x_exception
    THEN
      Raise_Application_Error( -20760, nm3inv_xattr_gen.get_error_string(x_error_no));
    -- nm_debug.debug('exception '||nm3inv_xattr_gen.get_error_string(x_error_no));
    -- nm_debug.debug_off;

END process_item_xattr;

-----------------------------------------------------------------------------


FUNCTION  check_type( pi_inv_type IN nm_inv_types.nit_inv_type%TYPE,
                      pi_i_or_d IN varchar2 ) RETURN boolean IS

CURSOR c_is_dep ( c_inv_type nm_inv_types.nit_inv_type%TYPE ) IS
  SELECT 1
  FROM nm_x_location_rules
  WHERE nxl_dep_type   = c_inv_type;

CURSOR c_is_indep ( c_inv_type nm_inv_types.nit_inv_type%TYPE ) IS
  SELECT 1
  FROM nm_x_location_rules
  WHERE nxl_indep_type = c_inv_type;

CURSOR c_is_nw_dep ( c_inv_type nm_inv_types.nit_inv_type%TYPE ) IS
  SELECT 1
  FROM nm_x_nw_rules
  WHERE nxn_dep_type = c_inv_type;

retval   boolean;
l_dummy  integer;

BEGIN

  IF pi_i_or_d = 'I' THEN

    OPEN c_is_indep (pi_inv_type);
    FETCH c_is_indep INTO l_dummy;
    retval := c_is_indep%FOUND;
    CLOSE c_is_indep;

  ELSIF pi_i_or_d = 'D' THEN

    OPEN c_is_dep (pi_inv_type);
    FETCH c_is_dep INTO l_dummy;
    retval := c_is_dep%FOUND;
    CLOSE c_is_dep;

  ELSIF pi_i_or_d = 'N' THEN

    OPEN c_is_nw_dep (pi_inv_type);
    FETCH c_is_nw_dep INTO l_dummy;
    retval := c_is_nw_dep%FOUND;
    CLOSE c_is_nw_dep;
  END IF;

  RETURN retval;
END;
--

PROCEDURE deactivate_xattr_validation IS
BEGIN
   g_xattr_active       := FALSE;
   g_tab_item_idx_xattr := 0;
   g_tab_loc_idx_xattr  := 0;
END;

PROCEDURE activate_xattr_validation IS
BEGIN
   g_xattr_active := g_xiv_sysopt;
--   nm_debug.debug_on;
END;


PROCEDURE ins_nxc( p_loc_xattr loc_xattr ) IS
--PRAGMA autonomous_transaction;
BEGIN
/*
  insert into nm_x_location_check
  ( nxc_ne_id_in,
    nxc_ne_id_of,
    nxc_obj_type ,
    nxc_begin_mp ,
    nxc_end_mp   ,
    nxc_dep_class )
  values
  ( p_loc_xattr.nm_ne_id_in
   ,p_loc_xattr.nm_ne_id_of
   ,p_loc_xattr.nm_obj_type
   ,p_loc_xattr.nm_begin_mp
   ,p_loc_xattr.nm_end_mp
   ,p_loc_xattr.dep_class );
*/
  NULL;
END;

--------------------------------------------------------------------------------------------------------------
FUNCTION check_x_location_rule( pi_exist   IN varchar2,
                                pi_mem_rec IN loc_xattr,
                                pi_cur     IN varchar2 ) RETURN boolean IS

retval     boolean := FALSE;

-- This is a dummy cursor, used for the cursor rowtype variable

CURSOR c_loc_xattr( c_nm_ne_id_in nm_members.nm_ne_id_in%TYPE
                   ,c_obj_type    nm_members.nm_obj_type%TYPE
                   ,c_nm_ne_id_of nm_members.nm_ne_id_in%TYPE
                   ,c_nm_begin_mp nm_members.nm_begin_mp%TYPE
                   ,c_nm_end_mp   nm_members.nm_end_mp%TYPE
                              ) IS
  SELECT nm_ne_id_in, nm_obj_type, nm_ne_id_of, nm_begin_mp, nm_end_mp
  FROM nm_members
  WHERE nm_obj_type   = c_obj_type
  AND   nm_ne_id_of   = c_nm_ne_id_of
  AND   nm_begin_mp   < c_nm_end_mp
  AND   nm_end_mp     > c_nm_begin_mp
  ORDER BY 1,3,4;

l_ucrec    c_loc_xattr%ROWTYPE;

TYPE       refcurtyp IS REF CURSOR;
cond_cur   refcurtyp;

l_loc_xattr loc_xattr;

l_found    boolean := FALSE;
l_max_chk  boolean := FALSE;
l_end_mp   nm_members.nm_end_mp%TYPE;
l_max_mp   nm_members.nm_end_mp%TYPE := 0;


BEGIN

-- nm_debug.debug('Check -'|| pi_cur );
  OPEN cond_cur FOR pi_cur;

  LOOP

    FETCH cond_cur INTO l_ucrec;

    EXIT WHEN cond_cur%NOTFOUND;

      IF pi_exist = 'N' THEN
  --
  --    here, there is inv item rule checking on non-existence - there is data inside the loop so fail
  --
        l_found := TRUE;
        retval  := FALSE;
        EXIT;
      ELSE
  --
  --    here, we need to check that the indep item type exists over the whole span of the dependent type.
  --
        IF NOT l_found AND l_ucrec.nm_begin_mp > pi_mem_rec.nm_begin_mp THEN
  --      start of indep item is greater than start of dependent
          retval := FALSE;
          EXIT;
        ELSE
          l_found := TRUE;
          IF l_ucrec.nm_begin_mp > NVL(l_end_mp, l_ucrec.nm_begin_mp + 1) THEN
  --        break between last one and this one
            retval := FALSE;
            EXIT;
          END IF;
  --
  --      The last record and the current one touch or overlap - ie no gaps, just check the ends
  --
          IF pi_mem_rec.nm_end_mp <= l_ucrec.nm_end_mp THEN
  --        the end of the indep item covers the dependent item - exit since its OK
            l_max_chk := TRUE;
            retval := TRUE;
            EXIT;
          ELSE
  --        store the last end meaure and go and get the next independent item
            l_end_mp := l_ucrec.nm_end_mp;
            l_max_mp := GREATEST( l_max_mp, l_end_mp );
            l_max_chk := FALSE;

          END IF;
        END IF;

      END IF;
    END LOOP;

--  if the existence flag is Y then check that the loop has been executed

    IF pi_exist = 'Y' AND NOT l_found  THEN
      retval := FALSE;
    ELSIF pi_exist = 'N' AND NOT l_found THEN
      retval := TRUE;
    END IF;

    CLOSE cond_cur;
  RETURN retval;

END;

----------------------------------------------------------------------------------------------------------------
FUNCTION check_indep_end_date( pi_ne_id IN nm_members.nm_ne_id_in%TYPE ) RETURN nm_x_errors.nxe_id%TYPE IS

CURSOR c1( c_ne_id nm_members.nm_ne_id_in%TYPE ) IS
  SELECT e.nxr_error_id
  FROM nm_x_location_rules r,
     nm_members i, nm_members d,
     nm_x_rules e
  WHERE i.nm_ne_id_in = c_ne_id
  AND   d.nm_ne_id_of = i.nm_ne_id_of
  AND   d.nm_begin_mp < i.nm_end_mp
  AND   d.nm_end_mp   > i.nm_begin_mp
  AND   d.nm_obj_type = r.nxl_dep_type
  AND   r.nxl_indep_type = i.nm_obj_type
  AND   r.nxl_existence_flag = 'Y'
  AND   r.nxl_rule_id = e.nxr_rule_id;

l_error nm_x_errors.nxe_id%TYPE;
l_found boolean := FALSE;

BEGIN
  IF g_xattr_active
   THEN
     OPEN c1( pi_ne_id );
     FETCH c1 INTO l_error;
     l_found := c1%FOUND;
     CLOSE c1;
  END IF;

  IF l_found THEN
    RETURN l_error;
  ELSE
    RETURN NULL;
  END IF;
END;

----------------------------------------------------------------------------------------------------------------
PROCEDURE trap_indep_end_date( pi_ne_id IN nm_members.nm_ne_id_in%TYPE ) IS

l_error nm_x_errors.nxe_id%TYPE;

BEGIN
-- nm_debug.debug_on;
-- nm_debug.debug('end dating -'||to_char(pi_ne_id));

  l_error := check_indep_end_date( pi_ne_id );

  IF l_error IS NOT NULL THEN

      Raise_Application_Error( -20760, nm3inv_xattr_gen.get_error_string(l_error));
  END IF;
END;

----------------------------------------------------------------------------------------------------------------

FUNCTION is_valid_for_reclass( pi_ne_id IN nm_members.nm_ne_id_in%TYPE, pi_dest_nw_type nm_types.nt_type%TYPE ) RETURN boolean IS

retval boolean := TRUE;

CURSOR c_is_element_valid ( c_ne_id nm_members.nm_ne_id_in%TYPE,
                            c_nw_type nm_types.nt_type%TYPE ) IS
  SELECT 1
  FROM nm_members dloc, nm_members iloc,
       nm_x_location_rules
  WHERE dloc.nm_ne_id_of = c_ne_id
  AND   dloc.nm_obj_type = nxl_dep_type
  AND   iloc.nm_ne_id_of = c_ne_id
  AND   iloc.nm_obj_type = nxl_indep_type
  AND EXISTS ( SELECT 1 FROM nm_inv_nw nw_dep
               WHERE nw_dep.nin_nit_inv_code = nxl_dep_type
               AND   nw_dep.nin_nw_type = c_nw_type )
  AND NOT EXISTS ( SELECT 1 FROM nm_inv_nw nw_indep
               WHERE nw_indep.nin_nit_inv_code = nxl_indep_type
               AND   nw_indep.nin_nw_type = c_nw_type );

CURSOR c_is_route_valid ( c_ne_id nm_members.nm_ne_id_in%TYPE,
                          c_nw_type nm_types.nt_type%TYPE ) IS
  SELECT 1
  FROM nm_members dloc, nm_members r, nm_members iloc,
       nm_x_location_rules
  WHERE r.nm_ne_id_in = c_ne_id
  AND   dloc.nm_ne_id_of = r.nm_ne_id_of
  AND   dloc.nm_obj_type = nxl_dep_type
  AND   iloc.nm_ne_id_of = r.nm_ne_id_of
  AND   iloc.nm_obj_type = nxl_indep_type
  AND EXISTS ( SELECT 1 FROM nm_inv_nw nw_dep
               WHERE nw_dep.nin_nit_inv_code = nxl_dep_type
               AND   nw_dep.nin_nw_type = c_nw_type )
  AND NOT EXISTS ( SELECT 1 FROM nm_inv_nw nw_indep
               WHERE nw_indep.nin_nit_inv_code = nxl_indep_type
               AND   nw_indep.nin_nw_type = c_nw_type );

l_dummy integer;

BEGIN

  IF nm3inv_xattr.g_xattr_active THEN

    IF nm3net.is_nt_datum(nm3net.get_nt_type( pi_ne_id )) = 'Y' THEN
      OPEN  c_is_element_valid( pi_ne_id, pi_dest_nw_type );
      FETCH c_is_element_valid INTO l_dummy;
      retval := c_is_element_valid%NOTFOUND;
      CLOSE c_is_element_valid;
    ELSE
      OPEN  c_is_route_valid ( pi_ne_id, pi_dest_nw_type );
      FETCH c_is_route_valid INTO l_dummy;
      retval := c_is_route_valid%NOTFOUND;
      CLOSE c_is_route_valid;
    END IF;
  END IF;

  RETURN retval;

END;

--------------------------------------------------------------------------------------------------------
FUNCTION is_nt_valid_for_reclass ( pi_ne_id IN nm_members.nm_ne_id_in%TYPE,
                                   pi_dest_nw_type nm_types.nt_type%TYPE ) RETURN boolean IS


CURSOR c1( c_nt nm_types.nt_type%TYPE ) IS
SELECT * FROM nm_x_nw_rules
WHERE nxn_existence_flag = 'N'
AND   nxn_indep_nw_type = c_nt;
TYPE       refcurtyp IS REF CURSOR;
cond_cur   refcurtyp;

cur_string_st varchar2(2000);
cur_string    varchar2(2000);
lf            varchar2(1) := CHR(10);
retval        boolean := TRUE;
dummy         integer;

BEGIN

--nm_debug.debug_on;

  IF nm3inv_xattr.g_xattr_active THEN

  -- nm_debug.debug('Active');

    IF nm3net.is_nt_datum(nm3net.get_nt_type( pi_ne_id )) = 'Y' THEN

      cur_string_st := 'select 1 from dual where exists ( select 1'||lf||
                    'from nm_members ldep, nm_inv_items dep, nm_elements'||lf||
                    'where ldep.nm_ne_id_of = '||TO_CHAR(pi_ne_id)||lf||
                    'and   ne_id = ldep.nm_ne_id_of'||lf||
                    'and   dep.iit_ne_id = ldep.nm_ne_id_in'||lf;

      FOR irec IN c1( pi_dest_nw_type) LOOP

        cur_string := cur_string_st||'and   ldep.nm_obj_type =  '||''''||irec.nxn_dep_type||''''||lf;

        IF irec.nxn_dep_condition IS NOT NULL THEN
          cur_string := cur_string||'and '||nm3inv_xattr.get_inv_condition_text( irec.nxn_dep_condition );
        END IF;

        IF irec.nxn_indep_condition IS NOT NULL THEN
          cur_string := cur_string||'and '||irec.nxn_indep_condition||lf;
        END IF;

        cur_string := cur_string||')';

      -- nm_debug.debug( cur_string );

        OPEN cond_cur FOR cur_string;

        FETCH cond_cur INTO dummy;

        IF cond_cur%FOUND THEN
          CLOSE cond_cur;
          retval := FALSE;
          EXIT;
        ELSE
          CLOSE cond_cur;
        END IF;

      END LOOP;

    ELSE

      cur_string_st := 'select 1 from dual where exists ( select 1'||lf||
                    'from nm_members ldep, nm_members lind, nm_inv_items dep, nm_elements'||lf||
                    'where lind.nm_ne_id_in = '||TO_CHAR(pi_ne_id)||lf||
                    'and   lind.nm_ne_id_of   = ldep.nm_ne_id_of'||lf||
                    'and   ne_id = lind.nm_ne_id_of'||lf||
                    'and   lind.nm_begin_mp  < ldep.nm_end_mp'||lf||
                    'and   nvl(lind.nm_end_mp, ne_length )  > ldep.nm_begin_mp'||lf||
                    'and   dep.iit_ne_id = ldep.nm_ne_id_in'||lf;

      FOR irec IN c1( pi_dest_nw_type) LOOP

        cur_string := cur_string_st||'and   ldep.nm_obj_type =  '||''''||irec.nxn_dep_type||''''||lf;

        IF irec.nxn_dep_condition IS NOT NULL THEN
          cur_string := cur_string||'and '||nm3inv_xattr.get_inv_condition_text( irec.nxn_dep_condition );
        END IF;

        IF irec.nxn_indep_condition IS NOT NULL THEN
          cur_string := cur_string||'and '||irec.nxn_indep_condition||lf;
        END IF;

        cur_string := cur_string||')';

      -- nm_debug.debug( cur_string );

        OPEN cond_cur FOR cur_string;

        FETCH cond_cur INTO dummy;

        IF cond_cur%FOUND THEN
          CLOSE cond_cur;
          retval := FALSE;
          EXIT;
        ELSE
          CLOSE cond_cur;
        END IF;

      END LOOP;

    END IF;
  ELSE
  -- nm_debug.debug('Inactive');
    Null;
  END IF;

  RETURN retval;
END;


---------------------------------------------------------------------------------------------------
FUNCTION get_dep_item_query( pi_rule_id nm_x_location_rules.nxl_rule_id%TYPE,
                             pi_item_id nm_inv_items.iit_ne_id%TYPE ) RETURN varchar2 IS

nxlobj vnm_x_location_rules%ROWTYPE;
retval  varchar2(2000);
lf      varchar2(1) := CHR(10);
l_dep   boolean := FALSE;

BEGIN

--
-- This program is intended to assemble the query necessary to check a dependency against a known
-- changed independent item/attribute. It operates over the whole extent of the independent item.

--
  SELECT * INTO nxlobj
  FROM vnm_x_location_rules
  WHERE nxl_rule_id = pi_rule_id;


--  we need to use an alias for two joins to the inv table

    retval := 'select 1 from dual where exists ( select 1 '||lf||
              'from nm_members ldep, nm_members lind ';

    retval := retval ||', nm_inv_items '||nxlobj.nxl_indep_type;

    IF nxlobj.nxl_dep_condition IS NOT NULL OR nxlobj.nxl_constraint IS NOT NULL OR nxlobj.nxl_xsp_match = 'Y'THEN
      l_dep := TRUE;
      retval := retval ||', nm_inv_items '||nxlobj.nxl_dep_type;
--    nm_debug.debug('dep added to criteria');
    ELSE
      l_dep := FALSE;
    END IF;

    retval := retval ||lf||
              'where '||nxlobj.nxl_indep_type||'.iit_ne_id = '||TO_CHAR( pi_item_id )||lf||
              'and   ldep.nm_obj_type  = '||''''||nxlobj.nxl_dep_type||''''||lf||
              'and   lind.nm_ne_id_of   = ldep.nm_ne_id_of'||lf||
              'and   lind.nm_begin_mp  < ldep.nm_end_mp'||lf||
              'and   lind.nm_end_mp    > ldep.nm_begin_mp'||lf||
              'and  '||nxlobj.nxl_indep_type||'.iit_ne_id = lind.nm_ne_id_in'||lf;

    IF l_dep  THEN
      retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.iit_ne_id = ldep.nm_ne_id_in'||lf;
    END IF;

    IF nxlobj.nxl_indep_condition IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_indep_type||'.'||get_inv_condition_text(nxlobj.nxl_indep_condition)||lf;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL THEN
       retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.'||get_inv_condition_text(nxlobj.nxl_dep_condition)||lf;
    END IF;

    IF nxlobj.nxl_constraint IS NOT NULL THEN
       retval := retval||
              'and  '||nxlobj.nxl_constraint||lf;
    END IF;

    IF nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
              'and '||nxlobj.nxl_dep_type||'.iit_x_sect = '||nxlobj.nxl_indep_type||'.iit_x_sect'||lf;
    END IF;


    retval := retval||' )';

  RETURN retval;
END;

----------------------------------------------------------------------------------------------------------------

FUNCTION get_dep_item_query_at_end_date( pi_rule_id nm_x_location_rules.nxl_rule_id%TYPE,
                                         pi_item_id nm_inv_items.iit_ne_id%TYPE ) RETURN varchar2 IS

nxlobj vnm_x_location_rules%ROWTYPE;
retval  varchar2(2000);
lf      varchar2(1) := CHR(10);
l_dep   boolean := FALSE;

BEGIN

--
-- This program is intended to assemble the query necessary to check a dependency against a known
-- changed independent item/attribute. It operates over the whole extent of the independent item.

--
  SELECT * INTO nxlobj
  FROM vnm_x_location_rules
  WHERE nxl_rule_id = pi_rule_id;


    retval := 'select 1 from dual where exists ( select 1 '||lf||
              'from nm_members ldep, nm_members lind ';


    retval := retval ||lf||
              'where ldep.nm_obj_type  = '||''''||nxlobj.nxl_dep_type||''''||lf||
              'and   lind.nm_ne_id_of   = ldep.nm_ne_id_of'||lf||
              'and   lind.nm_begin_mp  < ldep.nm_end_mp'||lf||
              'and   lind.nm_end_mp    > ldep.nm_begin_mp'||lf||
              'and  '||to_char( pi_item_id)||' = ldep.nm_ne_id_in'||lf;

    retval := retval||' )';

  RETURN retval;
END;

----------------------------------------------------------------------------------------------------------------

FUNCTION get_nw_item_query( pi_rule_id nm_x_nw_rules.nxn_rule_id%TYPE,
                            pi_item_id nm_inv_items.iit_ne_id%TYPE ) RETURN varchar2 IS

nxlobj nm_x_nw_rules%ROWTYPE;
retval varchar2(2000);
lf     varchar2(1) := CHR(10);

BEGIN

--
-- This program is intended to assemble the query necessary to check a dependency against a known
-- changed independent item/attribute. It operates over the whole extent of the independent item.

--
  SELECT * INTO nxlobj
  FROM nm_x_nw_rules
  WHERE nxn_rule_id = pi_rule_id;


--  we need to use an alias for two joins to the inv table

    retval := 'select 1 from dual where exists ( select 1 '||lf||
                  'from nm_members ldep, nm_members lind ';

    IF nxlobj.nxn_indep_condition IS NOT NULL THEN
      retval := retval ||', nm_elements '||nxlobj.nxn_indep_nw_type;
        END IF;


        IF nxlobj.nxn_dep_condition IS NOT NULL  THEN
      retval := retval ||', nm_inv_items '||nxlobj.nxn_dep_type;
        END IF;

    retval := retval ||lf||
                          'where '||nxlobj.nxn_dep_type||'.iit_ne_id = '||TO_CHAR( pi_item_id )||lf||
              'and   lind.nm_obj_type  = '||''''||nxlobj.nxn_indep_nw_type||''''||lf||
                          'and   lind.nm_ne_id_of   = ldep.nm_ne_id_of'||lf||
                          'and   lind.nm_begin_mp  < ldep.nm_end_mp'||lf||
                          'and   nvl(lind.nm_end_mp, '||TO_CHAR(large)||')    > ldep.nm_begin_mp'||lf;

    IF nxlobj.nxn_indep_condition IS NOT NULL THEN
          retval := retval||
                  'and  '||nxlobj.nxn_indep_nw_type||'.ne_id = lind.nm_ne_id_in'||lf;
    END IF;

    IF nxlobj.nxn_dep_condition IS NOT NULL THEN
          retval := retval||
                  'and  '||nxlobj.nxn_dep_type||'.iit_ne_id = ldep.nm_ne_id_in'||lf;
    END IF;

    IF nxlobj.nxn_indep_condition IS NOT NULL THEN
          retval := retval||
                  'and  '||nxlobj.nxn_indep_condition||lf;
    END IF;

        IF nxlobj.nxn_dep_condition IS NOT NULL THEN
          retval := retval||
              'and  '||nxlobj.nxn_dep_type||'.'||get_inv_condition_text(nxlobj.nxn_dep_condition)||lf;
    END IF;

    retval := retval||' )';

  RETURN retval;
END;


----------------------------------------------------------------------------------------------------------------

FUNCTION get_indep_item_query( pi_rule_id nm_x_location_rules.nxl_rule_id%TYPE,
                               pi_item_id nm_inv_items.iit_ne_id%TYPE ) RETURN varchar2 IS

nxlobj vnm_x_location_rules%ROWTYPE;
retval varchar2(2000);
lf     varchar2(1) := CHR(10);

BEGIN

--
-- This program is intended to assemble the query necessary to check a dependency against a known
-- changed dependent item/attribute. It operates over the whole extent of the dependent item.

--
  SELECT * INTO nxlobj
  FROM vnm_x_location_rules
  WHERE nxl_rule_id = pi_rule_id;


--  we need to use an alias for two joins to the inv table

    retval := 'select 1 from dual where exists ( select 1 '||lf||
                  'from nm_members ldep, nm_members lind ';

    IF nxlobj.nxl_indep_condition IS NOT NULL OR nxlobj.nxl_constraint IS NOT NULL THEN
      retval := retval ||', nm_inv_items '||nxlobj.nxl_indep_type;
    END IF;


    IF nxlobj.nxl_dep_condition IS NOT NULL OR nxlobj.nxl_constraint IS NOT NULL THEN
      retval := retval ||', nm_inv_items '||nxlobj.nxl_dep_type;
    END IF;

    retval := retval ||lf||
            'where '||nxlobj.nxl_dep_type||'.iit_ne_id = '||TO_CHAR( pi_item_id )||lf||
            'and   lind.nm_obj_type  = '||''''||nxlobj.nxl_indep_type||''''||lf||
            'and   ldep.nm_ne_id_of  = lind.nm_ne_id_of'||lf||
            'and   ldep.nm_begin_mp  < lind.nm_end_mp'||lf||
            'and   ldep.nm_end_mp    > lind.nm_begin_mp'||lf;

    IF nxlobj.nxl_indep_condition IS NOT NULL OR
       nxlobj.nxl_constraint IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_indep_type||'.iit_ne_id = lind.nm_ne_id_in'||lf;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL OR
       nxlobj.nxl_constraint IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.iit_ne_id = ldep.nm_ne_id_in'||lf;
    END IF;

    IF nxlobj.nxl_indep_condition IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_indep_type||'.'||get_inv_condition_text(nxlobj.nxl_indep_condition)||lf;
    END IF;

    IF nxlobj.nxl_dep_condition IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_dep_type||'.'||get_inv_condition_text(nxlobj.nxl_dep_condition)||lf;
    END IF;

    IF nxlobj.nxl_constraint IS NOT NULL THEN
      retval := retval||
              'and  '||nxlobj.nxl_constraint||lf;
    END IF;

    IF nxlobj.nxl_xsp_match = 'Y' THEN
      retval := retval||
              'and '||nxlobj.nxl_dep_type||'.iit_x_sect = '||nxlobj.nxl_indep_type||'.iit_x_sect'||lf;
    END IF;

    retval := retval||' )';

  RETURN retval;
END;


----------------------------------------------------------------------------------------------------------------
FUNCTION check_x_item_rule( pi_exist   IN varchar2,
                            pi_cur     IN varchar2 ) RETURN boolean IS

retval     boolean := FALSE;

TYPE       refcurtyp IS REF CURSOR;
cond_cur   refcurtyp;

c_return   integer;
l_found    boolean := TRUE;

BEGIN

--nm_debug.debug('Checking exists='||pi_exist||' in cursor '||pi_cur);

  OPEN cond_cur FOR pi_cur;
  FETCH cond_cur INTO c_return;

  IF cond_cur%FOUND THEN
    l_found := TRUE;
--  nm_debug.debug('FOUND');
  ELSE
    l_found := FALSE;
--  nm_debug.debug('NOT FOUND');
  END IF;

  IF l_found AND pi_exist = 'N' THEN
  --
  --here, there is inv item rule checking on non-existence
  --
    retval  := FALSE;
--  nm_debug.debug('Non-exist and found - raise error');
  ELSIF NOT l_found AND pi_exist = 'Y' THEN
  --
  --here, there is no satisfying data and we need some.
  --
    retval := FALSE;
--  nm_debug.debug('exist and not found - raise error');
  ELSE
--  nm_debug.debug('No problem - found '||nm3flx.boolean_to_char(l_found));
    retval := TRUE;
  END IF;
  CLOSE cond_cur;
  RETURN retval;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE parse_nw_indep_condition(pi_condition IN nm_x_nw_rules.nxn_indep_condition%TYPE
                                  ) IS

  c_nl CONSTANT varchar2(1) := CHR(10);

  l_cs pls_integer := dbms_sql.open_cursor;

  l_stmt varchar2(32767);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'parse_nw_indep_condition');

  IF pi_condition IS NOT NULL
  THEN
    l_stmt :=            'SELECT'
              || c_nl || '  1'
              || c_nl || 'FROM'
              || c_nl || '  nm_elements'
              || c_nl || 'WHERE'
              || c_nl || '  (' || pi_condition || ')';

    BEGIN
      dbms_sql.parse(c             => l_cs
                    ,STATEMENT     => l_stmt
                    ,language_flag => dbms_sql.native);
    EXCEPTION
      WHEN others
      THEN
        hig.raise_ner(pi_appl               => nm3type.c_hig
                     ,pi_id                 => 30
                     ,pi_supplementary_info =>    c_nl || c_nl
                                               || nm3flx.parse_error_message(pi_msg => SQLERRM));
    END;
  END IF;

  IF dbms_sql.is_open(c => l_cs)
  THEN
    dbms_sql.close_cursor(c => l_cs);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'parse_nw_indep_condition');

END parse_nw_indep_condition;
--

FUNCTION is_type_multi_allowed ( pi_nit_type in nm_members.nm_obj_type%TYPE ) return boolean is

retval  boolean := FALSE;
dummy   integer;

cursor c1 ( c_inv_type nm_members.nm_obj_type%TYPE ) is
  select 1 from nm_inv_types
  where nit_inv_type = c_inv_type
  and   (nit_exclusive = 'N'
  or     nit_x_sect_allow_flag = 'Y');

begin
  open c1( pi_nit_type );
  fetch c1 into dummy;
  retval := c1%found;
  close c1;
  return retval;
end;

--
-----------------------------------------------------------------------------
--

PROCEDURE x_item_check_pl ( pi_obj_type     in nm_members.nm_obj_type%TYPE
                           ,pi_nm_ne_id_in  in nm_members.nm_ne_id_in%TYPE
                           ,pi_pl           in nm_placement_array ) is

l_pl  nm_placement;

begin

--nm_debug.debug_on;
--nm_debug.debug( 'X item check over placement array' );
--nm3pla.dump_placement_array( pi_pl );
--if not nm3inv_xattr.g_xattr_active then
--  nm_debug.debug('Not active!!!');
--end if;

  if nm3inv_xattr.g_xattr_active then

    if  nm3inv_xattr.location_rule('D', pi_obj_type ) != 'NONE' then

      for i IN 1..pi_pl.placement_count loop

        l_pl := pi_pl.get_entry(i);

        nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := pi_nm_ne_id_in;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := pi_obj_type;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := l_pl.pl_ne_id;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := l_pl.pl_start;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := l_pl.pl_end;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'D';
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op                := 'C';

      end loop;
    end if;

--
    if nm3inv_xattr.location_rule('I', pi_obj_type ) != 'NONE' then

      for i IN 1..pi_pl.placement_count loop

        l_pl := pi_pl.get_entry(i);

        nm3inv_xattr.g_tab_loc_idx_xattr := nvl(nm3inv_xattr.g_tab_loc_idx_xattr,0) + 1;

        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_in       := pi_nm_ne_id_in;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_obj_type       := pi_obj_type;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_ne_id_of       := l_pl.pl_ne_id;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_begin_mp       := l_pl.pl_start;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).nm_end_mp         := l_pl.pl_end;
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).dep_class         := 'I';
        nm3inv_xattr.g_tab_rec_xattr(nm3inv_xattr.g_tab_loc_idx_xattr).op                := 'C';

      end loop;

    end if;
  end if;

  process_xattr;

--
END;


--
-----------------------------------------------------------------------------
--
----------------------------------------------------------------------------------------------------------------
-- Main segment, activate or deactivate according to system option
--
----------------------------------------------------------------------------------------------------------------

BEGIN
   --
   -- activate now sets the boolean based on the system option
   --
   activate_xattr_validation;
END nm3inv_xattr;
/

