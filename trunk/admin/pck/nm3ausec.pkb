CREATE OR REPLACE PACKAGE BODY nm3ausec
AS
   --
   --   PVCS Identifiers :-
   --
   --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3ausec.pkb-arc   2.14   Jul 06 2016 12:18:06   Rob.Coupe  $
   --       Module Name      : $Workfile:   nm3ausec.pkb  $
   --       Date into PVCS   : $Date:   Jul 06 2016 12:18:06  $
   --       Date fetched Out : $Modtime:   Jul 06 2016 12:16:20  $
   --       PVCS Version     : $Revision:   2.14  $
   --       Based on
   --
   --   Author : Rob Coupe
   --
   --   NM3 Admin Unit Security package body
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --
   --all global package variables here
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '"$Revision:   2.14  $"';

   --  g_body_sccsid is the SCCS ID for the package body
   --
   g_package_name   CONSTANT VARCHAR2 (30) := 'nm3ausec';
   --
   g_au_sec_exception        EXCEPTION;
   g_au_sec_exc_code         NUMBER;
   g_au_sec_exc_msg          VARCHAR2 (2000);
   --
   g_security_status         VARCHAR2 (3) := nm3type.c_on;
   --
   g_last_admin_type         nm_au_types.nat_admin_type%TYPE;
   g_last_admin_unit         nm_admin_units.nau_admin_unit%TYPE;
   --

   g_use_group_security      hig_option_values.HOV_VALUE%TYPE;

   -----------------------------------------------------------------------------
   --
   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE clear_nm_au_security_temp
   IS
   BEGIN
      DELETE FROM nm_au_security_temp;
   END clear_nm_au_security_temp;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE ins_nast (p_rec_nast nm_au_security_temp%ROWTYPE)
   IS
   BEGIN
      --
      -- create global temp records here
      --
      INSERT INTO nm_au_security_temp (nast_ne_id,
                                       nast_au_id,
                                       nast_ne_of,
                                       nast_nm_begin,
                                       nast_nm_end,
                                       nast_nm_type,
                                       nast_admin_type)
           VALUES (p_rec_nast.nast_ne_id,
                   p_rec_nast.nast_au_id,
                   p_rec_nast.nast_ne_of,
                   p_rec_nast.nast_nm_begin,
                   p_rec_nast.nast_nm_end,
                   p_rec_nast.nast_nm_type,
                   p_rec_nast.nast_admin_type);
   --
   END ins_nast;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION check_au (p_id IN NUMBER, p_au IN NUMBER)
      RETURN NUMBER
   IS
      --
      CURSOR c1 (
         c_nm_ne_id_in    NUMBER,
         c_admin_unit     NUMBER)
      IS
         SELECT /*+ RULE*/
                a.nm_admin_unit
           FROM nm_members a,
                nm_members b,
                nm_admin_units a_au,
                nm_admin_units b_au
          WHERE     b.nm_ne_id_of = a.nm_ne_id_of
                AND b.nm_ne_id_in = c_nm_ne_id_in
                AND a_au.nau_admin_unit = a.nm_admin_unit
                AND b_au.nau_admin_unit = b.nm_admin_unit
                AND a_au.nau_admin_type = b_au.nau_admin_type -- We must check for the same au type
                --    AND   get_au_type(a.nm_admin_unit) = get_au_type(b.nm_admin_unit)
                AND a.nm_admin_unit != c_admin_unit;

      --
      retval   NUMBER;
   --
   BEGIN
      --

      OPEN c1 (p_id, p_au);

      FETCH c1 INTO retval;

      CLOSE c1;

      RETURN retval;
   --
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN NULL;
   END check_au;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_unit_code (p_au IN NUMBER)
      RETURN VARCHAR2
   IS
      --
      CURSOR c1
      IS
         SELECT nau_unit_code
           FROM nm_admin_units
          WHERE nau_admin_unit = p_au;

      --
      retval   nm_admin_units.nau_unit_code%TYPE;
   --
   BEGIN
      OPEN c1;

      FETCH c1 INTO retval;

      CLOSE c1;

      RETURN retval;
   END get_unit_code;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE check_each_au
   IS
      --
      l_au            NUMBER;

      --
      CURSOR c1 (
         c_use_group_security   IN VARCHAR2)
      IS
         WITH member1
              AS (SELECT nast_ne_id,
                         nast_au_id,
                         nast_ne_of,
                         nast_nm_begin,
                         nast_nm_end,
                         nm_ne_id_in,
                         nm_ne_id_of,
                         nm_begin_mp,
                         nm_end_mp,
                         nm_admin_unit,
                         ne_length,
                         CASE
                            WHEN NOT EXISTS
                                        (SELECT 1
                                           FROM nm_admin_groups
                                          WHERE     nag_parent_admin_unit =
                                                       nm_admin_unit
                                                AND nag_child_admin_unit =
                                                       nast_au_id
                                         UNION ALL
                                         SELECT 1
                                           FROM nm_admin_groups
                                          WHERE     nag_child_admin_unit =
                                                       nm_admin_unit
                                                AND nag_parent_admin_unit =
                                                       nast_au_id)
                            THEN
                               'TRUE'
                            WHEN EXISTS
                                    (SELECT 1
                                       FROM nm_admin_groups
                                      WHERE     nag_parent_admin_unit =
                                                   nm_admin_unit
                                            AND nag_child_admin_unit =
                                                   nast_au_id
                                     UNION ALL
                                     SELECT 1
                                       FROM nm_admin_groups
                                      WHERE     nag_child_admin_unit =
                                                   nm_admin_unit
                                            AND nag_parent_admin_unit =
                                                   nast_au_id)
                            THEN
                               'FALSE'
                            ELSE
                               'NONE'
                         END
                            AU_CONFLICT,
                         CASE
                            WHEN nm_begin_mp = nm_end_mp THEN 'POINT'
                            ELSE 'LINE'
                         END
                            PNT_OR_LINE
                    FROM nm_au_security_temp,
                         nm_au_types_full,
                         nm_members,
                         nm_elements,
                         nm_admin_units
                   WHERE     nat_exclusive = 'Y'
                         AND ne_id = nm_ne_id_of
                         AND nat_admin_type = nast_admin_type
                         AND nm_ne_id_of = nast_ne_of
                         AND nm_admin_unit = nau_admin_unit
                         AND nau_admin_type = nast_admin_type
                         AND nm_end_mp >= nast_nm_begin
                         AND nm_begin_mp <= nast_nm_end
                         AND (   (    c_use_group_security = 'N'
                                  AND NAST_NM_TYPE = 'I'
                                  AND nm_type = 'I')
                              OR c_use_group_security = 'Y')),
              member2
              AS (SELECT t1.*,
                         NVL (
                            (SELECT au_conflict
                               FROM member1
                              WHERE     nm_ne_id_of = nast_ne_of
                                    AND nm_end_mp = nast_nm_begin
                                    AND nm_end_mp > nm_begin_mp
                                    AND ROWNUM = 1),
                            'NONE')
                            prior_line_conflict,
                         NVL (
                            (SELECT au_conflict
                               FROM member1
                              WHERE     nm_ne_id_of = nast_ne_of
                                    AND nm_end_mp = nast_nm_begin
                                    AND nm_end_mp = nm_begin_mp
                                    AND ROWNUM = 1),
                            'NONE')
                            prior_pt_conflict,
                         NVL (
                            (SELECT au_conflict
                               FROM member1
                              WHERE     nm_ne_id_of = nast_ne_of
                                    AND nm_begin_mp = nast_nm_end
                                    AND nm_end_mp > nm_begin_mp
                                    AND ROWNUM = 1),
                            'NONE')
                            next_line_conflict,
                         NVL (
                            (SELECT au_conflict
                               FROM member1
                              WHERE     nm_ne_id_of = nast_ne_of
                                    AND nm_begin_mp = nast_nm_end
                                    AND nm_end_mp = nm_begin_mp
                                    AND ROWNUM = 1),
                            'NONE')
                            next_pt_conflict
                    FROM member1 t1)
           SELECT nm_admin_unit
             FROM member2
            WHERE (   (    nast_ne_of = nm_ne_id_of
                       AND nast_nm_begin < nm_end_mp
                       AND nast_nm_end > nm_begin_mp
                       AND au_conflict = 'TRUE')    -- point or linear overlap
                   OR (    nast_nm_begin = nast_nm_end
                       AND nast_nm_begin = 0
                       AND next_line_conflict = 'TRUE') -- point start of datum with adjoining conflict
                   OR (    nast_nm_begin = nast_nm_end
                       AND nast_nm_end = ne_length
                       AND prior_line_conflict = 'TRUE') -- point end of datum with adjoining conflict
                   OR (    nast_nm_begin = nast_nm_end
                       AND nast_nm_begin != 0
                       AND nast_nm_end != ne_length
                       AND prior_line_conflict = 'TRUE'
                       AND next_line_conflict = 'TRUE') -- point location between two linear conflicts
                   OR (    nast_nm_begin != nast_nm_end
                       AND prior_line_conflict IN ('FALSE')       --, 'NONE' )
                       AND next_line_conflict IN ('FALSE', 'NONE')
                       AND prior_pt_conflict = 'TRUE') -- linear placement trapping an illegal point itemadmin-unit between two lines at the start of the affected member
                   OR (    nast_nm_begin != nast_nm_end
                       AND next_line_conflict IN ('FALSE')        --, 'NONE' )
                       AND prior_line_conflict IN ('FALSE', 'NONE')
                       AND next_pt_conflict = 'TRUE') -- linear placement trapping an illegal point itemadmin-unit between two lines at the end of the affected member
                                                     )
         ORDER BY DECODE (nm_admin_unit, nast_au_id, 2, 1);

      --
      -- look for an au element of the same type over the whole extent,
      -- excluding the record being inserted/updated
      --
      CURSOR c2 (
         c_use_group_security   IN VARCHAR2)
      IS
         SELECT /*+ RULE*/
                c.nm_admin_unit
           FROM nm_members c, nm_au_security_temp nast, nm_admin_units au
          WHERE     au.nau_admin_unit = c.nm_admin_unit
                AND au.NAU_ADMIN_TYPE = nast.nast_admin_type -- We must check for the same au type
                AND c.nm_ne_id_of = nast.nast_ne_of -- at the location provided from before trg
                AND (   (c_use_group_security = 'Y' AND nm_type = 'I')
                     OR c_use_group_security = 'N')
                AND c.nm_begin_mp <= nast.nast_nm_begin
                AND c.nm_end_mp >= nast.nast_nm_end -- overlapping with the whole of existing data
                AND EXISTS
                       (SELECT 1
                          FROM nm_admin_groups -- where the existing AU could be a parent
                         WHERE     nag_parent_admin_unit = c.nm_admin_unit
                               AND nag_child_admin_unit = nast.nast_au_id)
                AND c.nm_ne_id_in != nast.nast_ne_id; -- ignoring the record just being ins/upd

      --
      l_gaps_exist    BOOLEAN := FALSE;

      --
      CURSOR cs_nast_exists
      IS
         SELECT 1
           FROM DUAL
          WHERE EXISTS (SELECT 1 FROM nm_au_security_temp);

      --
      CURSOR cs_not_privvy
      IS
         SELECT 1
           FROM DUAL
          WHERE EXISTS
                   (SELECT 1
                      FROM nm_au_security_temp
                     WHERE nast_nm_type != 'G');

      --
      l_dummy         PLS_INTEGER;
      --
      nothing_to_do   EXCEPTION;

      --


      FUNCTION check_fragmented_memberships
         RETURN BOOLEAN
      IS
         -- there may not be an existing membership that spans the whole
         -- proposed location of new item - but overall there could be
         -- a number without gaps that do - so check for this
         CURSOR c_memb
         IS
              SELECT c.nm_begin_mp,
                     c.nm_end_mp,
                     nast.nast_nm_begin,
                     nast.nast_nm_end
                FROM nm_members c, nm_admin_units nau, nm_au_security_temp nast
               WHERE     nau.nau_admin_type = nast.nast_admin_type -- We must check for the same au type
                     AND nau_admin_unit = c.nm_admin_unit
                     AND c.nm_ne_id_of = nast.nast_ne_of -- at the location provided from before trg
                     AND nast.nast_nm_begin <= c.nm_end_mp
                     AND nast.nast_nm_end >= c.nm_begin_mp
                     AND EXISTS
                            (SELECT 1
                               FROM nm_admin_groups -- where the existing AU could be a parent
                              WHERE     nag_parent_admin_unit = c.nm_admin_unit
                                    AND nag_child_admin_unit = nast.nast_au_id)
                     AND c.nm_ne_id_in != nast.nast_ne_id -- ignoring the record just being ins/upd
            ORDER BY 1, 2;

         l_tab_begin_mp        nm3type.tab_number;
         l_tab_end_mp          nm3type.tab_number;
         l_tab_nast_begin_mp   nm3type.tab_number;
         l_tab_nast_end_mp     nm3type.tab_number;
      BEGIN
         OPEN c_memb;

         FETCH c_memb
            BULK COLLECT INTO l_tab_begin_mp,
                 l_tab_end_mp,
                 l_tab_nast_begin_mp,
                 l_tab_nast_end_mp;

         CLOSE c_memb;


         IF l_tab_begin_mp.COUNT = 0
         THEN
            RETURN (FALSE);
         ELSIF    (l_tab_begin_mp (1) > l_tab_nast_begin_mp (1))
               OR l_tab_end_mp (l_tab_end_mp.COUNT) <
                     l_tab_nast_end_mp (l_tab_nast_end_mp.COUNT)
         THEN
            -------------------------------------------------------------
            -- start positition is less that the overall start
            -- OR
            -- end position is greater than the overall end
            -- if so then placement at this position is not allowed
            ------------------------------------------------------------
            RETURN (FALSE);
         ELSE
            FOR i IN 2 .. l_tab_begin_mp.COUNT
            LOOP
               -- check that there are no gaps between previous and current membership
               -- if so then placement at this position is not allowed

               --        nm_debug.debug('Compare '||to_char(l_tab_begin_mp(i))||' with '||to_char(l_tab_end_mp(i-1)));
               IF l_tab_begin_mp (i) > l_tab_end_mp (i - 1)
               THEN
                  RETURN (FALSE);
               END IF;
            END LOOP;
         END IF;

         RETURN (TRUE);
      END check_fragmented_memberships;
   BEGIN
      --RAC - use a select into as use of hig.get_sysopt violates the pragma

      BEGIN
         SELECT hov_value
           INTO g_use_group_security
           FROM hig_option_values
          WHERE hov_id = 'USEGRPSEC';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            g_use_group_security := 'Y';
      END;

      -- If security is switched off for this operation
      -- nm_debug.debug('   IF get_status = nm3type.c_off');
      IF get_status = nm3type.c_off
      THEN
         RAISE nothing_to_do;
      END IF;

      --
      -- Check to make sure there are some rows in nm_au_security_temp first
      -- nm_debug.debug('   OPEN  cs_nast_exists;');
      OPEN cs_nast_exists;

      FETCH cs_nast_exists INTO l_dummy;

      IF cs_nast_exists%NOTFOUND
      THEN
         CLOSE cs_nast_exists;

         RAISE nothing_to_do;
      END IF;

      -- nm_debug.debug('   CLOSE cs_nast_exists;');
      CLOSE cs_nast_exists;

      --
      -- With the proposed aus stored against each element in the temp. table, first we need
      -- to check if the proposed locations are already populated with an au of this type.
      -- Check if one of this type which is in a different tree already exists.
      --
--    nm_debug.debug ('   OPEN  c1;');

      OPEN c1 (g_use_group_security);

--    nm_debug.debug ('   FETCH c1 INTO l_au');

--      FOR irec IN (SELECT * FROM nm_au_security_temp)
--      LOOP
--         nm_debug.debug (
--               'RC> '
--            || irec.nast_ne_id
--            || ','
--            || irec.nast_au_id
--            || ','
--            || irec.nast_ne_of
--            || ','
--            || irec.nast_nm_begin
--            || ','
--            || irec.nast_nm_end);
--      END LOOP;

      FETCH c1 INTO l_au;

--    nm_debug.debug ('   IF c1%FOUND - AU = ' || l_au);

      IF c1%FOUND
      THEN
         CLOSE c1;

         hig.raise_ner (pi_appl                 => nm3type.c_net,
                        pi_id                   => 234,
                        pi_supplementary_info   => get_unit_code (l_au));
      --      g_au_sec_exc_code  := -20902;
      --      g_au_sec_exc_msg   := 'Location already designated to '||get_unit_code(l_au);
      --      RAISE g_au_sec_exception;
      END IF;

      --   nm_debug.debug('   CLOSE c1;');
      CLOSE c1;

      --
      --OK, no au of this type outside of the proposed au tree.
      --Is there no admin unit of this type at any position on the proposed location?
      --If not then this is a virgin location and the user must be unrestricted in order
      --to perform this operation
      --
      -- dbms_output.put_line( 'test for gaps');
      -- nm_debug.debug('   OPEN  c2;');
      OPEN c2 (g_use_group_security);

      -- nm_debug.debug('   FETCH c2 INTO l_au;');
      FETCH c2 INTO l_au;

      -- nm_debug.debug('   l_gaps_exist := c2%NOTFOUND;');
      l_gaps_exist := c2%NOTFOUND;

      -- nm_debug.debug('   CLOSE c2;');
      CLOSE c2;

      --
      -- nm_debug.debug('   IF l_gaps_exist');
      IF l_gaps_exist
      THEN
         --    dbms_output.put_line( 'gaps' );
         IF NOT SYS_CONTEXT ('NM3CORE', 'UNRESTRICTED_INVENTORY') = 'TRUE'
         THEN
            --       dbms_output.put_line( 'NOT privvy');
            -- Check to make sure that this is a Network membership operation

            l_dummy := NULL;                                     -- initialise

            OPEN cs_not_privvy;

            FETCH cs_not_privvy INTO l_dummy;

            CLOSE cs_not_privvy;

            IF l_dummy IS NOT NULL
            THEN   -- If this is not a network membership operation then error
               ---------------------------------------------------------
               -- GJ 03-DEC-2004
               -- there may not be a single member that spans the whole
               -- of the proposed placement for the membership - but
               -- the fragemented members may overlap/join up to
               -- give an overall lenght that would allow placement
               -- therefore call function to check for this
               ---------------------------------------------------------
               --RAC - HE Data Access - no need to check for gaps - any user can place an asset over any new network with no assets or with non-exclusive admin-types
               -- so not needed
               --            IF NOT check_fragmented_memberships THEN
               --                 hig.raise_ner (pi_appl               => nm3type.c_net
               --                               ,pi_id                 => 235
               --                               );
               --            END IF;
               NULL;
            END IF;
         ELSE
            --       dbms_output.put_line( 'privvy');
            NULL;
         END IF;
      ELSE
         NULL;
      --   dbms_output.put_line( 'No gaps' );
      END IF;
   --
   EXCEPTION
      --
      WHEN nothing_to_do
      THEN
         NULL;
      --
      WHEN g_au_sec_exception
      THEN
         Raise_Application_Error (g_au_sec_exc_code, g_au_sec_exc_msg);
   --
   END check_each_au;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_au_mode (p_user   IN VARCHAR2,
                         p_au     IN nm_admin_units.nau_admin_unit%TYPE)
      RETURN VARCHAR2
   IS
      --2
      CURSOR c1
      IS
           SELECT nua_mode
             FROM nm_user_aus, hig_users, nm_admin_groups
            WHERE     nua_user_id = hus_user_id
                  AND hus_username = p_user
                  AND nua_admin_unit = nag_parent_admin_unit
                  AND nag_child_admin_unit = p_au
         ORDER BY nua_mode;

      --
      retval   nm_user_aus.nua_mode%TYPE;
   --
   BEGIN
      OPEN c1;

      FETCH c1 INTO retval;

      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         --    Return NULL;  -- RC - security fixes for HA - no need to check the mode as this is handled by FGAC
         hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 236);
      --raise_application_error( -20901, 'You should not be here');
      END IF;

      --
      RETURN retval;
   --
   END get_au_mode;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_au_mode (pi_user_id   IN hig_users.hus_user_id%TYPE,
                         pi_au        IN nm_admin_units.nau_admin_unit%TYPE)
      RETURN nm_user_aus.nua_mode%TYPE
   IS
      CURSOR cs_au_mode (
         p_user_id    hig_users.hus_user_id%TYPE,
         p_au         nm_admin_units.nau_admin_unit%TYPE)
      IS
           SELECT nua.nua_mode
             FROM nm_user_aus nua, nm_admin_groups nag
            WHERE     nua.nua_user_id = p_user_id
                  AND nua.nua_admin_unit = nag.nag_parent_admin_unit
                  AND nag.nag_child_admin_unit = p_au
         ORDER BY nua.nua_mode;

      l_found    BOOLEAN;

      l_retval   nm_user_aus.nua_mode%TYPE;
   BEGIN
      nm_debug.proc_start (p_package_name     => g_package_name,
                           p_procedure_name   => 'get_au_mode');

      OPEN cs_au_mode (p_user_id => pi_user_id, p_au => pi_au);

      FETCH cs_au_mode INTO l_retval;

      l_found := cs_au_mode%FOUND;

      CLOSE cs_au_mode;

      IF NOT (l_found)
      THEN
         l_retval := NULL;
      --you should not be here! (RC - now handled by FGAC)
      --    hig.raise_ner(pi_appl => nm3type.c_net
      --                 ,pi_id   => 236);
      END IF;

      nm_debug.proc_end (p_package_name     => g_package_name,
                         p_procedure_name   => 'get_au_mode');

      RETURN l_retval;
   END get_au_mode;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION do_locations_exist (p_ne_id IN NUMBER)
      RETURN BOOLEAN
   IS
      --
      CURSOR c1
      IS
         SELECT 1
           FROM nm_members
          WHERE nm_ne_id_in = p_ne_id;

      --
      retval   BOOLEAN;
      l_val    NUMBER;
   --
   BEGIN
      --
      OPEN c1;

      FETCH c1 INTO l_val;

      retval := c1%FOUND;

      CLOSE c1;

      --
      RETURN retval;
   --
   END do_locations_exist;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_au_type (p_au IN NUMBER)
      RETURN VARCHAR2
   IS
      --
      CURSOR c1
      IS
         SELECT nau_admin_type
           FROM nm_admin_units
          WHERE nau_admin_unit = p_au;

      --
      retval   nm_admin_units.nau_admin_type%TYPE;
   --
   BEGIN
      --
      OPEN c1;

      FETCH c1 INTO retval;

      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         hig.raise_ner (pi_appl => nm3type.c_hig, pi_id => 88);
      --      raise_application_error(-20904,'Invalid admin unit');
      END IF;

      --
      CLOSE c1;

      --
      RETURN retval;
   --
   END get_au_type;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_inv_au_type (p_inv_type IN nm_inv_types.nit_inv_type%TYPE)
      RETURN VARCHAR2
   IS
      --
      CURSOR c1 (c_inv_type nm_inv_types.nit_inv_type%TYPE)
      IS
         SELECT nit_admin_type
           FROM nm_admin_units, nm_inv_types
          WHERE nau_admin_type = nit_admin_type AND nit_inv_type = c_inv_type;

      --
      retval   nm_admin_units.nau_admin_type%TYPE;
   --
   BEGIN
      --
      OPEN c1 (p_inv_type);

      FETCH c1 INTO retval;

      IF c1%NOTFOUND
      THEN
         CLOSE c1;

         hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 237);
      --      raise_application_error(-20901, 'The admin type is not correct');
      END IF;

      --
      CLOSE c1;

      --
      RETURN retval;
   --
   END get_inv_au_type;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE debug_au_sec_temp
   IS
      --
      l_ne_unique      VARCHAR2 (100);
      l_been_in_loop   BOOLEAN := FALSE;
   --
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'debug_au_sec_temp');

      --
      FOR cs_rec IN (SELECT * FROM nm_au_security_temp)
      LOOP
         l_been_in_loop := TRUE;
         l_ne_unique := NULL;

         BEGIN
            l_ne_unique :=
               nm3net.get_ne_unique (cs_rec.nast_ne_id) || '(Element)';
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;

         IF l_ne_unique IS NULL
         THEN
            BEGIN
               l_ne_unique :=
                     nm3inv.get_inv_primary_key (cs_rec.nast_ne_id)
                  || '(Inventory)';
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      -- nm_debug.debug('------------');
      -- nm_debug.debug('NAST_NE_ID    : '||cs_rec.NAST_NE_ID||' ('||l_ne_unique||')');
      -- nm_debug.debug('NAST_AU_ID    : '||cs_rec.NAST_AU_ID||' ('||nm3ausec.get_unit_code(cs_rec.NAST_AU_ID)||','||nm3ausec.get_au_mode(USER,cs_rec.NAST_AU_ID)||','||nm3ausec.GET_AU_TYPE(cs_rec.NAST_AU_ID)||')');
      -- nm_debug.debug('NAST_NE_OF    : '||cs_rec.NAST_NE_OF||' ('||nm3net.get_ne_unique(cs_rec.NAST_NE_OF)||')');
      -- nm_debug.debug('NAST_NM_BEGIN : '||cs_rec.NAST_NM_BEGIN);
      -- nm_debug.debug('NAST_NM_END   : '||cs_rec.NAST_NM_END);
      END LOOP;

      --
      --IF l_been_in_loop
      --THEN
      -- nm_debug.debug('------------');
      --ELSE
      -- nm_debug.debug('No rows in nm_au_security_temp');
      --END IF;
      --
      nm_debug.proc_end (g_package_name, 'debug_au_sec_temp');
   --
   END debug_au_sec_temp;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_status
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_security_status;
   END get_status;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE set_status (p_status IN VARCHAR2)
   IS
   BEGIN
      IF p_status NOT IN (nm3type.c_on, nm3type.c_off)
      THEN
         hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 238);
      --      RAISE_APPLICATION_ERROR(-20001,'Invalid security status');
      END IF;

      g_security_status := p_status;

      --
      -- Switch the Xattr validation off with security
      --
      IF p_status = nm3type.c_off
      THEN
         nm3inv_xattr.deactivate_xattr_validation;
      ELSE
         nm3inv_xattr.activate_xattr_validation;
      END IF;
   END set_status;

   --
   -----------------------------------------------------------------------------
   --
   PROCEDURE check_each_nm_row (p_rec IN rec_each_nm)
   IS
      --
      l_rec_nast             nm_au_security_temp%ROWTYPE;
      --
      c_inserting   CONSTANT BOOLEAN
                                := (p_rec.trigger_mode = nm3type.c_inserting) ;
      c_updating    CONSTANT BOOLEAN
                                := (p_rec.trigger_mode = nm3type.c_updating) ;
      --
      l_ner_id               nm_errors.ner_id%TYPE;
      --
      l_end_loc_only         nm_inv_types.nit_end_loc_only%TYPE;
   --
   BEGIN
      --
      --Check the admin unit values and make sure the user has the au mode for this particular access
      --
      --
      IF c_updating AND p_rec.nm_admin_unit_new != p_rec.nm_admin_unit_old
      THEN                             -- Do not allow update to NM_ADMIN_UNIT
         hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 239);
      --      g_au_sec_exc_code  := -20904;
      --      g_au_sec_exc_msg   := 'You may not update the admin unit';
      --      RAISE g_au_sec_exception;
      END IF;

      --
      IF g_security_status = nm3type.c_off
      THEN
         -- If AU security is off for this operation then exit this procedure
         RETURN;
      END IF;

      --
      IF NOT SYS_CONTEXT ('NM3CORE', 'UNRESTRICTED_INVENTORY') = 'TRUE'
      THEN
         -- Set the exception variables
         IF c_updating
         THEN
            l_ner_id := 240;
            g_au_sec_exc_code := -20902;
            g_au_sec_exc_msg := 'You may not change this record';
         ELSE
            l_ner_id := 241;
            g_au_sec_exc_code := -20903;
            g_au_sec_exc_msg := 'You may not create data with this admin unit';
         END IF;

         --
         --RAC - should always find a row - else other locking/tests would have failed earlier in the process.Belt and braces though - if
         --the member is visible and the asset type is not, then the user has no role on the asset type and hence cannot perform the change

         BEGIN
            IF p_rec.nm_type_new = 'I'
            THEN
               SELECT nit_end_loc_only
                 INTO l_end_loc_only
                 FROM nm_inv_types
                WHERE nit_inv_type = p_rec.nm_obj_type;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               hig.raise_ner (
                  pi_appl                 => nm3type.c_net,
                  pi_id                   => l_ner_id,
                  pi_supplementary_info   => get_unit_code (
                                               p_rec.nm_admin_unit_new));
         END;

         --
         IF    (p_rec.nm_type_new = 'I' AND l_end_loc_only = 'N')
            OR p_rec.nm_type_new = 'G'
         THEN
            IF (    nm3ausec.get_au_mode (
                       SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME'),
                       p_rec.nm_admin_unit_new) != nm3type.c_normal
                AND nm3ausec.get_au_mode (
                       SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME'),
                       nm3get.get_ne (p_rec.nm_ne_id_of).ne_admin_unit) !=
                       nm3type.c_normal)
            THEN
               hig.raise_ner (
                  pi_appl                 => nm3type.c_net,
                  pi_id                   => l_ner_id,
                  pi_supplementary_info   => get_unit_code (
                                               p_rec.nm_admin_unit_new));
            --         RAISE g_au_sec_exception;
            END IF;
         END IF;

         -- Reset the exception variables
         l_ner_id := NULL;
         g_au_sec_exc_code := NULL;
         g_au_sec_exc_msg := NULL;
      --
      END IF;

      BEGIN
         SELECT hov_value
           INTO g_use_group_security
           FROM hig_option_values
          WHERE hov_id = 'USEGRPSEC';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            g_use_group_security := 'Y';
      END;

      --
      --Now we are here, everything is OK, check that the au is exclusive etc
      --If inserting, we need to check the location has correct aus,
      --If updating, then only if the begin or end mp have changed do we need to
      --check the au over the location.
      --
      IF (   (g_use_group_security = 'N' AND p_rec.nm_type_new = 'I')
          OR g_use_group_security = 'Y')
      THEN
         IF    c_inserting
            OR (c_updating AND p_rec.nm_begin_mp_new != p_rec.nm_begin_mp_old)
            OR (    c_updating
                AND NVL (p_rec.nm_end_mp_new, -1) !=
                       NVL (p_rec.nm_end_mp_old, -1))
         THEN
            l_rec_nast.nast_ne_id := p_rec.nm_ne_id_in;
            l_rec_nast.nast_au_id := p_rec.nm_admin_unit_new;
            l_rec_nast.nast_ne_of := p_rec.nm_ne_id_of;
            l_rec_nast.nast_nm_begin := p_rec.nm_begin_mp_new;
            l_rec_nast.nast_nm_end :=
               NVL (p_rec.nm_end_mp_new,
                    nm3net.get_datum_element_length (p_rec.nm_ne_id_of));
            l_rec_nast.nast_nm_type := p_rec.nm_type_new;

            IF p_rec.nm_admin_unit_new != NVL (g_last_admin_unit, -1)
            THEN
               g_last_admin_unit := p_rec.nm_admin_unit_new;
               g_last_admin_type := get_au_type (g_last_admin_unit);
            END IF;

            l_rec_nast.nast_admin_type := g_last_admin_type;
            nm3ausec.ins_nast (l_rec_nast);
         END IF;
      END IF;
   --
   --The after insert/update statement level trigger will do the rest
   --
   EXCEPTION
      --
      WHEN g_au_sec_exception
      THEN
         Raise_Application_Error (g_au_sec_exc_code, g_au_sec_exc_msg);
   --
   END check_each_nm_row;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_highest_au_of_au_type (
      p_au_type    nm_admin_units.nau_admin_type%TYPE DEFAULT NULL,
      p_user       VARCHAR2 DEFAULT SYS_CONTEXT ('NM3_SECURITY_CTX',
                                                 'USERNAME'),
      p_mode       VARCHAR2 DEFAULT nm3type.c_normal)
      RETURN nm_admin_units.nau_admin_unit%TYPE
   IS
      --
      CURSOR cs_highest_au (
         c_au_type    nm_admin_units.nau_admin_type%TYPE,
         c_user       VARCHAR2,
         c_mode       VARCHAR2)
      IS
           SELECT nau_admin_unit, nau_level
             FROM nm_admin_units, nm_user_aus, hig_users
            WHERE     hus_username = p_user
                  AND hus_user_id = nua_user_id
                  AND nua_mode = p_mode
                  AND nua_admin_unit = nau_admin_unit
                  AND nau_admin_type = NVL (c_au_type, nau_admin_type)
         ORDER BY nau_level;

      --
      l_admin_unit   nm_admin_units.nau_admin_type%TYPE;
      l_nau_level    nm_admin_units.nau_level%TYPE;
   --
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_highest_au_of_au_type');

      --
      OPEN cs_highest_au (p_au_type, p_user, p_mode);

      FETCH cs_highest_au INTO l_admin_unit, l_nau_level;

      IF cs_highest_au%NOTFOUND
      THEN
         CLOSE cs_highest_au;

         hig.raise_ner (pi_appl                 => nm3type.c_net,
                        pi_id                   => 242,
                        pi_supplementary_info   => p_au_type);
      --      g_au_sec_exc_code := -20918;
      --      g_au_sec_exc_msg  := 'No admin unit found for this user of the correct Admin Type';
      --      RAISE g_au_sec_exception;
      END IF;

      CLOSE cs_highest_au;

      --
      nm_debug.proc_end (g_package_name, 'get_highest_au_of_au_type');
      --
      RETURN l_admin_unit;
   --
   EXCEPTION
      --
      WHEN g_au_sec_exception
      THEN
         Raise_Application_Error (g_au_sec_exc_code, g_au_sec_exc_msg);
   --
   END get_highest_au_of_au_type;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_nau_unit_code (
      p_nau_admin_unit   IN nm_admin_units.nau_admin_unit%TYPE)
      RETURN nm_admin_units.nau_unit_code%TYPE
   IS
      --
      CURSOR cs_nau (c_nau_admin_unit nm_admin_units.nau_admin_unit%TYPE)
      IS
         SELECT nau_unit_code
           FROM nm_admin_units
          WHERE nau_admin_unit = c_nau_admin_unit;

      --
      l_nau_unit_code   nm_admin_units.nau_unit_code%TYPE := NULL;
   --
   BEGIN
      --
      OPEN cs_nau (p_nau_admin_unit);

      FETCH cs_nau INTO l_nau_unit_code;

      CLOSE cs_nau;

      --
      RETURN l_nau_unit_code;
   --
   END get_nau_unit_code;
--
----------------------------------------------------------------------------------------------
--
END nm3ausec;
/
