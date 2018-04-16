CREATE OR REPLACE PACKAGE BODY nm3rsc
AS
    --
    --------------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3rsc.pkb-arc   2.21   Apr 16 2018 09:23:22   Gaurav.Gaurkar  $
    --       Module Name      : $Workfile:   nm3rsc.pkb  $
    --       Date into PVCS   : $Date:   Apr 16 2018 09:23:22  $
    --       Date fetched Out : $Modtime:   Apr 16 2018 09:04:32  $
    --       PVCS Version     : $Revision:   2.21  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for the rescaling and resequencing of route members
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    --all global package variables here
    --
    g_body_sccsid    CONSTANT VARCHAR2 (30) := '"$Revision:   2.21  $"';

    --  g_body_sccsid is the SCCS ID for the package body
    --
    g_package_name   CONSTANT VARCHAR2 (30) := 'NM3RSC';
    --
    g_rsc_exception           EXCEPTION;
    g_rsc_exc_code            NUMBER;
    g_rsc_exc_msg             VARCHAR2 (2000);

    --
    -----------------------------------------------------------------------------
    --

    FUNCTION is_reversable (pi_gty IN nm_group_types_all.ngt_group_type%TYPE)
        RETURN BOOLEAN;

    FUNCTION get_rescaled_pl
        RETURN nm_placement_array;

    PROCEDURE empty_route_check (p_ne_id            IN     NUMBER,
                                 p_effective_date   IN     DATE,
                                 p_history          IN     VARCHAR2,
                                 p_empty               OUT VARCHAR2);

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
    PROCEDURE dump_rescale_write
    IS
    BEGIN
        IF nm_debug.is_debug_on
        THEN
            nm_debug.debug (
                'ne_id|s_ne_id|nm_seg_no|ne_sub_class|connect_level');

            FOR x
                IN (SELECT    a.ne_id
                           || '|'
                           || a.s_ne_id
                           || '|'
                           || a.nm_seg_no
                           || '|'
                           || a.ne_sub_class
                           || '|'
                           || a.connect_level
                               text
                      FROM nm_rescale_write a)
            LOOP
                nm_debug.debug (x.text);
            END LOOP;
        END IF;
    END dump_rescale_write;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_globals (
        pi_ne_id            IN nm_elements.ne_id%TYPE,
        pi_effective_date   IN DATE DEFAULT TRUNC (SYSDATE))
    IS
    BEGIN
        g_end_date := pi_effective_date;

        IF g_route_or_inv = 'R'
        THEN
            nm3net.get_group_units (pi_ne_id, g_route_units, g_datum_units);

            --  set the offset units so that datum units can be used in all calculations

            IF NOT is_reversable (nm3net.get_gty_type (pi_ne_id))
            THEN
                g_use_sub_class := 'Y';
            ELSE
                g_use_sub_class := 'N';
            END IF;
        ELSE
            g_use_sub_class := 'N';
        END IF;
    END set_globals;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE rescale_other_products (
        pi_nm_ne_id_in      IN nm_elements.ne_id%TYPE,
        pi_nm_ne_id_of      IN nm_elements.ne_id%TYPE DEFAULT NULL,
        pi_nm_begin_mp      IN nm_members.nm_begin_mp%TYPE DEFAULT NULL,
        pi_effective_date   IN nm_elements.ne_start_date%TYPE)
    IS
    BEGIN
        -- At present only schemes is affected by a rescale performed on a route
        -- but here is a procedure ready for when others are affected

        IF hig.is_product_licensed (nm3type.c_stp)
        THEN
            -- do str rescale
            EXECUTE IMMEDIATE
                   'BEGIN'
                || CHR (10)
                || '   stp_network_ops.do_rescale(pi_ne_id_in        => :pi_nm_ne_id_in'
                || CHR (10)
                || '                             ,pi_nm_ne_id_of     => :pi_nm_ne_id_of'
                || CHR (10)
                || '                             ,pi_begin_mp        => :pi_begin_mp'
                || CHR (10)
                || '                             ,pi_effective_date  => :pi_effective_date'
                || CHR (10)
                || '                             );'
                || CHR (10)
                || 'END;'
                USING IN pi_nm_ne_id_in,
                      pi_nm_ne_id_of,
                      pi_nm_begin_mp,
                      pi_effective_date;
        END IF;
    END rescale_other_products;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE rescale_route (
        pi_ne_id            IN nm_elements.ne_id%TYPE,
        pi_effective_date   IN DATE,
        pi_offset_st        IN NUMBER,
        pi_st_element_id    IN nm_elements.ne_id%TYPE,
        pi_use_history      IN VARCHAR2,
        pi_ne_start         IN nm_elements.ne_id%TYPE DEFAULT NULL)
    IS
        c_initial_effective_date   CONSTANT DATE
            := TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                        'DD-MON-YYYY') ;

        -- AE
        -- RAC
        -- Do we want shape history? Default it for now..
        pi_shape_history                    VARCHAR2 (1) := 'Y';
        --
        -- CWS
        --l_offset_st number := pi_offset_st;
        l_offset_st                         NUMBER;
        l_unit_id                           NUMBER;
        l_dummy                             NUMBER;
        --
        l_empty_flag                        VARCHAR2 (1);
    BEGIN
        --
        nm_debug.proc_start (g_package_name, 'rescale_route');

        IF pi_ne_start IS NOT NULL
        THEN
            nm3ctx.set_context ('RSC_START', TO_CHAR (pi_ne_start));
        ELSE
            nm3ctx.set_context ('RSC_START', NULL);
        END IF;

        --
        -- Set AU Securuty off and effective_date to value passed
        nm3ausec.set_status (nm3type.c_off);
        nm3user.set_effective_date (pi_effective_date);
        --
        -- CWS
        NM3NET.GET_GROUP_UNITS (pi_ne_id, l_unit_id, l_dummy);

        -- CWS
        SELECT NM3UNIT.GET_FORMATTED_VALUE (pi_offset_st, l_unit_id)
          INTO l_offset_st
          FROM DUAL;

        --
        --Must only check the date stuff if history is being made
        --nm_debug.debug('Check rescale');
        IF pi_use_history = 'Y'
        THEN
            check_rescale (pi_ne_id, pi_effective_date);
        END IF;

        --nm_debug.debug('Instantiate data');

        instantiate_data (pi_ne_id            => pi_ne_id,
                          pi_effective_date   => pi_effective_date);

        --nm_debug.debug( 'Starting offset '||TO_CHAR(l_offset_st ));

        --  l_offset_st := nm3unit.convert_unit( g_route_units, g_datum_units, l_offset_st );

        empty_route_check (pi_ne_id,
                           pi_effective_date,
                           pi_shape_history,
                           l_empty_flag);

        IF l_empty_flag = 'N'
        THEN
            --  set_start_points;

            connect_route (pi_ne_id, l_offset_st, pi_ne_start);

            IF pi_st_element_id IS NULL
            THEN
                update_route (pi_ne_id, pi_effective_date, pi_use_history);
            ELSE
                update_partial_route (pi_ne_id,
                                      pi_effective_date,
                                      pi_st_element_id,
                                      pi_use_history);
            END IF;

            -- AE
            -- RAC - reshape the route because the route measures have changed:
            -- default pi_shape_history to 'Y'
            IF pi_use_history = 'Y' OR pi_shape_history = 'Y'
            THEN
                nm3sdm.reshape_route (pi_ne_id, pi_effective_date, 'Y');
            ELSE
                nm3sdm.reshape_route (pi_ne_id, pi_effective_date, 'N');
            END IF;

            --
            rescale_other_products (pi_nm_ne_id_in      => pi_ne_id,
                                    pi_effective_date   => pi_effective_date);
        --
        END IF;

        -- Set AU Securuty on and effective_date back to initial value
        nm3ausec.set_status (nm3type.c_on);
        nm3user.set_effective_date (c_initial_effective_date);

        nm_debug.proc_end (g_package_name, 'rescale_route');
    --
    EXCEPTION
    
      WHEN others
       THEN
         -- Set AU Securuty on and effective_date back to initial value
         nm3ausec.set_status(nm3type.c_on);
         nm3user.set_effective_date (c_initial_effective_date);
         RAISE;
    
    END rescale_route;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION loop_check
        RETURN BOOLEAN
    IS
        dummy   INTEGER;
    BEGIN
        SELECT 1
          INTO dummy
          FROM DUAL
         WHERE     EXISTS (SELECT 1 FROM v_nm_ordered_members)    -- not empty
               AND EXISTS
                       (SELECT 1
                          FROM v_nm_ordered_members
                         WHERE NVL (has_prior, 0) != 1); -- check for no terminations

        RETURN FALSE;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RETURN TRUE;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION stranded_element_check
        RETURN BOOLEAN
    IS
        CURSOR c_stranded_element_check
        IS
            SELECT 1
              FROM DUAL
             WHERE EXISTS
                       (SELECT 1
                          FROM nm_rescale_write
                         WHERE nm_seq_no IS NULL);

        l_strand   BOOLEAN;
        l_dummy    NUMBER;
    BEGIN
        OPEN c_stranded_element_check;

        FETCH c_stranded_element_check INTO l_dummy;

        l_strand := c_stranded_element_check%NOTFOUND;

        CLOSE c_stranded_element_check;

        RETURN l_strand;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE connect_route (
        pi_ne_id       IN nm_elements.ne_id%TYPE,
        pi_offset_st   IN NUMBER,
        pi_ne_start    IN nm_elements.ne_id%TYPE DEFAULT NULL)
    IS
        CURSOR c1
        IS
                SELECT ne_id,
                       ne_length,
                       LEVEL c_level,
                       ne_sub_class,
                       s_ne_id
                  FROM nm_rescale_write
                 WHERE NVL (ne_sub_class, '1') IN ('2', '1')
            CONNECT BY     PRIOR ne_id = s_ne_id
                       AND NVL (ne_sub_class, '1') IN ('2', '1')
            START WITH s_ne_id = -1 AND NVL (ne_sub_class, '1') IN ('2', '1');

        --
        --Cursor to pick up all R carriageway, starting with each start of R
        --

        CURSOR c2 (
            c_start    nm_elements.ne_id%TYPE)
        IS
                SELECT ne_id,
                       ne_length,
                       LEVEL c_level,
                       ne_sub_class,
                       s_ne_id
                  FROM nm_rescale_write
                 WHERE NVL (ne_sub_class, '3') = '3' AND connect_level IS NULL
            CONNECT BY     PRIOR ne_id = s_ne_id
                       AND connect_level IS NULL
                       AND NVL (ne_sub_class, '3') = '3'
            START WITH ne_id = c_start;

        --
        -- get the start of all chunks which are R, those fragments that are R and are
        -- connected to S etc and those chunks which are L/S which are connected only to R
        --
        CURSOR c3
        IS
            SELECT w.ne_id      ne_id,
                   0            nm_seq_no,
                   0            ne_length,
                   pi_offset_st nm_true
              FROM nm_rescale_write w
             WHERE w.ne_sub_class = '3' AND w.s_ne_id = -1
            UNION
            SELECT w.ne_id     ne_id,
                   r.nm_seq_no nm_seq_no,
                   r.ne_length,
                   r.nm_true
              FROM nm_rescale_write w, nm_rescale_write r
             WHERE     w.ne_sub_class = '3'
                   AND w.s_ne_id = r.ne_id
                   AND r.ne_sub_class != '3'
            ORDER BY 2;

        CURSOR c4
        IS
              SELECT w.ne_id   ne_id,
                     r.nm_seq_no nm_seq_no,
                     r.ne_length,
                     r.nm_true
                FROM nm_rescale_write w, nm_rescale_write r
               WHERE w.s_ne_id = r.ne_id AND w.nm_seq_no IS NULL
            ORDER BY 2;

        CURSOR c5 (c_start nm_elements.ne_id%TYPE)
        IS
                SELECT ne_id,
                       ne_length,
                       LEVEL c_level,
                       ne_sub_class,
                       s_ne_id
                  FROM nm_rescale_write
                 WHERE nm_seq_no IS NULL
            CONNECT BY PRIOR ne_id = s_ne_id
            START WITH ne_id = c_start;

        CURSOR c6
        IS
                SELECT ne_id,
                       ne_length,
                       LEVEL c_level,
                       ne_sub_class,
                       s_ne_id
                  FROM nm_rescale_write
            CONNECT BY PRIOR ne_id = s_ne_id
            START WITH s_ne_id = -1 AND ne_id = NVL (pi_ne_start, ne_id);

        CURSOR c7
        IS
                SELECT ne_id,
                       ne_length,
                       LEVEL c_level,
                       ne_sub_class,
                       s_ne_id,
                       nm_begin_mp,
                       nm_end_mp
                  FROM nm_rescale_write
            CONNECT BY PRIOR ne_id = s_ne_id
            START WITH s_ne_id = -1;

        l_saved_sub_class   nm_elements.ne_sub_class%TYPE := '&%^';
        l_seg_no            nm_members.nm_seg_no%TYPE := 0;
        l_seq_no            nm_members.nm_seq_no%TYPE := 0;
        l_true              nm_members.nm_true%TYPE := pi_offset_st;
        l_length            nm_elements.ne_length%TYPE := 0;

        l_first             BOOLEAN := TRUE;
    BEGIN
        --  nm_debug.debug_on;

        nm_debug.debug (
               'connect route: pi_ne_id '
            || pi_ne_id
            || 'pi_offset_st '
            || pi_offset_st
            || 'pi_ne_start '
            || pi_ne_start);
        dump_rescale_write;

        IF loop_check
        THEN
            nm_debug.debug ('loop check - true ');

            IF pi_ne_start IS NOT NULL
            THEN
                nm_debug.debug ('have start ne ' || pi_ne_start);

                UPDATE nm_rescale_write
                   SET s_ne_id = -1
                 WHERE ne_id = pi_ne_start;

                --    The route may be a dual carriageway circular route - set the -1 for all elements
                --    that start at the user-defined start position

                IF g_use_sub_class = 'Y'
                THEN
                    UPDATE nm_rescale_write
                       SET s_ne_id = -1
                     WHERE ne_no_start = (SELECT ne_no_start
                                            FROM nm_rescale_read
                                           WHERE ne_id = pi_ne_start);
                END IF;
            ELSE
                nm_debug.debug ('circular route with blah ');

                RAISE_APPLICATION_ERROR (
                    -20207,
                    'Circular route with no start defined');
            END IF;
        END IF;

        --  nm_debug.debug_off;

        IF g_use_sub_class = 'Y'
        THEN
            --nm_debug.debug('using sub class - yes indeed');

            FOR irec IN c1
            LOOP
                l_seq_no := l_seq_no + 1;

                IF irec.ne_sub_class != l_saved_sub_class
                THEN
                    l_seg_no := l_seg_no + 1;
                END IF;

                IF l_seq_no > 0
                THEN
                    IF irec.s_ne_id > 0
                    THEN
                        l_true :=
                              get_true (irec.s_ne_id)
                            + nm3unit.convert_unit (
                                  g_datum_units,
                                  g_route_units,
                                  get_length (irec.s_ne_id));
                    ELSE
                        l_true := pi_offset_st;
                    END IF;
                END IF;

                UPDATE nm_rescale_write
                   SET nm_true = l_true,
                       nm_seg_no = l_seg_no,
                       nm_seq_no = l_seq_no,
                       connect_level = irec.c_level
                 WHERE ne_id = irec.ne_id;

                l_length := irec.ne_length;
                l_saved_sub_class := irec.ne_sub_class;
            END LOOP;

            --
            --  Now loop over the R carriageway
            --  Start with all the start of R in the correct sequence!
            --

            FOR s_rec IN c3
            LOOP
                l_length := s_rec.ne_length;
                l_true := s_rec.nm_true;
                l_first := TRUE;
                l_seg_no := l_seg_no + 1;

                FOR r_rec IN c2 (s_rec.ne_id)
                LOOP
                    l_seq_no := l_seq_no + 1;
                    l_true :=
                          l_true
                        + nm3unit.convert_unit (g_datum_units,
                                                g_route_units,
                                                l_length);

                    UPDATE nm_rescale_write
                       SET nm_true = l_true,
                           nm_seg_no = l_seg_no,
                           nm_seq_no = l_seq_no,
                           connect_level = r_rec.c_level
                     WHERE ne_id = r_rec.ne_id;

                    l_length := r_rec.ne_length;
                END LOOP;
            END LOOP;

            --  There may be Single or Left Cways that are stranded since they are only connected to R
            --  Process this loop if there any remaining null sequence numbers
            --
            IF stranded_element_check
            THEN
                FOR s_rec IN c4
                LOOP
                    l_length := s_rec.ne_length;
                    l_true := s_rec.nm_true;
                    l_first := TRUE;
                    l_seg_no := l_seg_no + 1;

                    FOR r_rec IN c5 (s_rec.ne_id)
                    LOOP
                        l_seq_no := l_seq_no + 1;
                        l_true :=
                              l_true
                            + nm3unit.convert_unit (g_route_units,
                                                    g_datum_units,
                                                    l_length);

                        UPDATE nm_rescale_write
                           SET nm_true = l_true,
                               nm_seg_no = l_seg_no,
                               nm_seq_no = l_seq_no,
                               connect_level = r_rec.c_level
                         WHERE ne_id = r_rec.ne_id;

                        l_length := r_rec.ne_length;
                    END LOOP;
                END LOOP;
            END IF;
        ELSE
            --nm_debug.debug('Not using sub class' );
            --  We do not use a sub-class, test if partial or not

            IF g_route_or_inv = 'R'
            THEN
                IF g_gty IS NULL OR nm3net.gty_is_partial (g_gty)
                THEN
                    --
                    --      we are dealing with a partial route or an extent

                    --nm_debug.debug('extent - r' );

                    --insert into nm_rescale_write_temp select * from nm_rescale_write ;
                    --commit ;

                    FOR irec IN c7
                    LOOP
                        l_seq_no := l_seq_no + 1;
                        l_true :=
                              l_true
                            + nm3unit.convert_unit (g_datum_units,
                                                    g_route_units,
                                                    l_length);

                        IF irec.c_level = 1
                        THEN
                            l_seg_no := l_seg_no + 1;
                        END IF;

                        UPDATE nm_rescale_write
                           SET nm_true = l_true,
                               nm_seg_no = l_seg_no,
                               nm_seq_no = l_seq_no,
                               connect_level = irec.c_level
                         WHERE ne_id = irec.ne_id;

                        l_length :=
                              NVL (irec.nm_end_mp, irec.ne_length)
                            - irec.nm_begin_mp;
                    END LOOP;
                ELSE
                    --nm_debug.debug('extent - i' );

                    FOR irec IN c6
                    LOOP
                        l_seq_no := l_seq_no + 1;
                        l_true :=
                              l_true
                            + nm3unit.convert_unit (g_datum_units,
                                                    g_route_units,
                                                    l_length);

                        IF irec.c_level = 1
                        THEN
                            l_seg_no := l_seg_no + 1;
                        END IF;

                        UPDATE nm_rescale_write
                           SET nm_true = l_true,
                               nm_seg_no = l_seg_no,
                               nm_seq_no = l_seq_no,
                               connect_level = irec.c_level
                         WHERE ne_id = irec.ne_id;

                        l_length := irec.ne_length;
                    END LOOP;
                END IF;
            ELSE
                --    rescale an inventory item - it is partial

                --nm_debug.debug('Inventory ' );

                FOR irec IN c7
                LOOP
                    l_seq_no := l_seq_no + 1;
                    l_true := l_true + l_length;

                    IF irec.c_level = 1
                    THEN
                        l_seg_no := l_seg_no + 1;
                    END IF;

                    UPDATE nm_rescale_write
                       SET nm_true = l_true,
                           nm_seg_no = l_seg_no,
                           nm_seq_no = l_seq_no,
                           connect_level = irec.c_level
                     WHERE ne_id = irec.ne_id;

                    l_length :=
                          NVL (irec.nm_end_mp, irec.ne_length)
                        - irec.nm_begin_mp;
                END LOOP;
            END IF;
        END IF;

        --create a segment tree dataset

        create_seg_tree;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_start_points
    IS
        CURSOR c1
        IS
                SELECT ne_id
                  FROM nm_rescale_write
            FOR UPDATE OF ne_id;

        l_s_ne_id   NUMBER;
    BEGIN
        FOR irec IN c1
        LOOP
            l_s_ne_id := get_start_element (irec.ne_id);

            UPDATE nm_rescale_write
               SET s_ne_id = l_s_ne_id
             WHERE CURRENT OF c1;
        END LOOP;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_start_element (pi_ne_id IN NUMBER)
        RETURN NUMBER
    IS
        CURSOR c1
        IS
              SELECT b.nnu_ne_id
                FROM nm_node_usages  a,
                     nm_rescale_read a1,
                     nm_node_usages  b,
                     nm_rescale_write b1
               WHERE     a.nnu_ne_id = a1.ne_id
                     AND b.nnu_no_node_id = a.nnu_no_node_id
                     AND b.nnu_ne_id != a.nnu_ne_id
                     AND b.nnu_ne_id = b1.ne_id
                     AND b.nnu_node_type = 'E'
                     AND a.nnu_node_type = 'S'
                     AND a1.ne_id = pi_ne_id
            ORDER BY b1.ne_sub_class,
                     DECODE (b1.nm_seq_no, 0, 99999, b1.nm_seq_no);

        --CURSOR c2 IS
        --  SELECT b.nnu_ne_id
        --  FROM nm_node_usages a, nm_rescale_read a1, nm_node_usages b, nm_rescale_write b1
        --  WHERE a.nnu_ne_id = a1.ne_id
        --  AND   b.nnu_no_node_id = a.nnu_no_node_id
        --  AND   b.nnu_ne_id != a.nnu_ne_id
        --  AND   b.nnu_ne_id = b1.ne_id
        --  AND   b.nnu_node_type = DECODE( b1.nm_cardinality, 1, 'E', -1, 'S', 'E' )
        --  AND   a.nnu_node_type = DECODE( a1.nm_cardinality, 1, 'S', -1, 'E', 'S' )
        --  AND   a1.ne_id = pi_ne_id
        --  AND   decode( a.nnu_node_type, 'S', a1.nm_begin_mp ,'E', a1.nm_end_mp ) = a.nnu_chain
        --  AND   decode( b.nnu_node_type, 'S', b1.nm_begin_mp ,'E', b1.nm_end_mp ) = b.nnu_chain
        --  order by decode( b1.s_ne_id, -1, -1, 1) asc, nm3net.route_direction( b.nnu_no_node_id, b1.nm_cardinality ) desc;

        /*
          This cursor is now coded to use subquery factoring which works around the cycle. The query is complex but should perform. It is based on the context set in the instantiate data
          subprogram. It is fully intended to support this as a stand-alone view but it is currently only working for route-types of a structure which matches the original C2 cursor code.
          Until such time that is tested outside of this scope, it needs to be coded as an in-line view.
        */


        CURSOR C2
        IS
            SELECT s_ne
              FROM (SELECT SYS_CONTEXT ('NM3SQL', 'ORDERED_ROUTE')
                               nm_ne_id_in,
                           ne_id
                               nm_ne_id_of,
                           s_ne,
                           nm_seq_no,
                           dir
                               nm_cardinality,
                           nm_begin_mp,
                           nm_end_mp,
                           start_node,
                           end_node,
                           ne_length,
                           nm_slk
                               nm_slk_stored,
                           nm_end_slk
                               nm_end_slk_stored,
                           ROW_NUMBER () OVER (ORDER BY order1)
                               nm_calc_seq_no,
                           slk
                               nm_slk_calc,
                           end_slk
                               nm_end_slk_calc,
                           whole_or_part,
                           slk_difference,
                           gap_or_ovrl_stored,
                           gap_or_ovrl_calc
                      FROM (SELECT q6.*,
                                   nm_slk - slk1
                                       slk_difference,
                                   nm_slk - NVL (p_end_slk, 0)
                                       gap_or_ovrl_stored,
                                     slk1
                                   - NVL (
                                         LAG (end_slk1, 1)
                                             OVER (ORDER BY nm_seq_no),
                                         0)
                                       gap_or_ovrl_calc
                              FROM (SELECT q5.*,
                                           slk / conversion_factor
                                               slk1,
                                           end_slk / conversion_factor
                                               end_slk1,
                                           CASE nm_begin_mp
                                               WHEN 0
                                               THEN
                                                   CASE nm_end_mp
                                                       WHEN ne_length
                                                       THEN
                                                           'W'
                                                       ELSE
                                                           'P'
                                                   END
                                               ELSE
                                                   'P'
                                           END
                                               whole_or_part
                                      FROM (WITH
                                                r_units
                                                AS
                                                    (SELECT route_unit,
                                                            datum_unit,
                                                            (SELECT CASE route_unit
                                                                        WHEN datum_unit
                                                                        THEN
                                                                            1
                                                                        ELSE
                                                                            (SELECT uc_conversion_factor
                                                                               FROM nm_unit_conversions
                                                                              WHERE     uc_unit_id_in =
                                                                                        datum_unit
                                                                                    AND uc_unit_id_out =
                                                                                        route_unit)
                                                                    END
                                                                        conversion_factor
                                                               FROM DUAL)
                                                                conversion_factor
                                                       FROM (  SELECT ru.un_unit_id
                                                                          route_unit,
                                                                      du.un_unit_id
                                                                          datum_unit
                                                                 FROM nm_elements
                                                                      r,
                                                                      nm_types
                                                                      rt,
                                                                      nm_units
                                                                      ru,
                                                                      nm_nt_groupings,
                                                                      nm_types
                                                                      dt,
                                                                      nm_units
                                                                      du
                                                                WHERE     r.ne_nt_type =
                                                                          rt.nt_type
                                                                      AND rt.nt_length_unit =
                                                                          ru.un_unit_id
                                                                      AND nng_group_type =
                                                                          R.NE_GTY_GROUP_TYPE
                                                                      AND dt.nt_type =
                                                                          nng_nt_type
                                                                      AND dt.nt_length_unit =
                                                                          du.un_unit_id
                                                                      AND ne_id =
                                                                          SYS_CONTEXT (
                                                                              'NM3SQL',
                                                                              'ORDERED_ROUTE')
                                                             GROUP BY ru.un_unit_id,
                                                                      du.un_unit_id))
                                            SELECT conversion_factor,
                                                   q4.*,
                                                   SUM (s_length)
                                                       OVER (ORDER BY order1)
                                                       AS slk,
                                                   SUM (ne_length)
                                                       OVER (ORDER BY order1)
                                                       AS end_slk,
                                                   LAG (nm_end_slk, 1)
                                                   OVER (ORDER BY nm_seq_no)
                                                       p_end_slk
                                              FROM (SELECT q3.*,
                                                           NVL (
                                                               LAG (
                                                                   ne_length,
                                                                   1)
                                                               OVER (
                                                                   ORDER BY
                                                                       order1),
                                                               0)
                                                               s_length
                                                      FROM (SELECT *
                                                              FROM (WITH
                                                                        rsc3 (s_ne,
                                                                              ne_id,
                                                                              nm_seq_no,
                                                                              dir,
                                                                              nm_begin_mp,
                                                                              nm_end_mp,
                                                                              start_node,
                                                                              end_node,
                                                                              ne_length,
                                                                              nm_slk,
                                                                              nm_end_slk,
                                                                              has_prior)
                                                                        AS
                                                                            (SELECT -1,
                                                                                    a.ne_id,
                                                                                    a.nm_seq_no,
                                                                                    a.dir_flag,
                                                                                    a.nm_begin_mp,
                                                                                    a.nm_end_mp,
                                                                                    a.start_node,
                                                                                    a.end_node,
                                                                                    a.ne_length,
                                                                                    a.nm_slk,
                                                                                    a.nm_end_slk,
                                                                                    a.has_prior
                                                                               FROM v_nm_ordered_members
                                                                                    a
                                                                              WHERE    has_prior
                                                                                           IS NULL
                                                                                    OR a.ne_id =
                                                                                       TO_NUMBER (
                                                                                           SYS_CONTEXT (
                                                                                               'NM3SQL',
                                                                                               'RSC_START'))
                                                                                    OR (    dir_flag =
                                                                                            1
                                                                                        AND nm_begin_mp >
                                                                                            0)
                                                                                    OR     (    dir_flag =
                                                                                                -1
                                                                                            AND nm_end_mp <
                                                                                                ne_length)
                                                                                       AND ROWNUM =
                                                                                           1
                                                                             UNION ALL
                                                                             SELECT a.ne_id,
                                                                                    b.ne_id,
                                                                                    b.nm_seq_no,
                                                                                    b.dir_flag,
                                                                                    b.nm_begin_mp,
                                                                                    b.nm_end_mp,
                                                                                    b.start_node,
                                                                                    b.end_node,
                                                                                    b.ne_length,
                                                                                    b.nm_slk,
                                                                                    b.nm_end_slk,
                                                                                    b.has_prior
                                                                               FROM v_nm_ordered_members
                                                                                    b
                                                                                    JOIN
                                                                                    rsc3
                                                                                    a
                                                                                        ON (a.end_node =
                                                                                            b.start_node))
                                                                            SEARCH DEPTH FIRST BY start_node,
                                                                                                  nm_seq_no SET order1
                                                                            CYCLE ne_id SET is_cycle TO 'Y' DEFAULT 'N'
                                                                    SELECT *
                                                                      FROM rsc3)
                                                             WHERE is_cycle =
                                                                   'N') q3)
                                                   q4,
                                                   r_units) q5) q6))
             WHERE nm_ne_id_of = pi_ne_id AND ROWNUM = 1;

        CURSOR c3
        IS
              SELECT b.nnu_ne_id
                FROM nm_node_usages a,
                     nm_rescale_read a1,
                     nm_node_usages b,
                     nm_rescale_read b1
               WHERE     a.nnu_ne_id = a1.ne_id
                     AND b.nnu_no_node_id = a.nnu_no_node_id
                     AND b.nnu_ne_id != a.nnu_ne_id
                     AND b.nnu_ne_id = b1.ne_id
                     AND b.nnu_node_type = 'E'
                     AND a.nnu_node_type = 'S'
                     AND a1.ne_id = pi_ne_id
                     AND a1.ne_sub_class = b1.ne_sub_class
            ORDER BY DECODE (b1.nm_seq_no, 0, 99999, b1.nm_seq_no);

        l_ne_id   NUMBER;
    BEGIN
        IF g_use_sub_class = 'Y'
        THEN
            --
            --  attempt to match the sub-class
            --
            OPEN c3;

            FETCH c3 INTO l_ne_id;

            IF c3%NOTFOUND
            THEN
                OPEN c1;

                FETCH c1 INTO l_ne_id;

                IF c1%NOTFOUND
                THEN
                    l_ne_id := -1;
                --      raise_application_error( -20001, 'No starting element found for '||to_char(pi_ne_id));
                END IF;

                CLOSE c1;
            END IF;

            CLOSE c3;
        ELSE
            UPDATE nm_rescale_write a
               SET s_ne_id = -1
             WHERE NOT EXISTS
                       (SELECT 1
                          FROM v_nm_ordered_members b
                         WHERE b.end_node =
                               DECODE (a.nm_cardinality,
                                       1, a.ne_no_start,
                                       a.ne_no_end));

            --

            OPEN c2;

            FETCH c2 INTO l_ne_id;

            IF c2%NOTFOUND
            THEN
                l_ne_id := -1;
            --    raise_application_error( -20001, 'No starting element found for '||to_char(pi_ne_id));
            END IF;

            CLOSE c2;
        END IF;

        RETURN l_ne_id;
    END get_start_element;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE update_route (pi_ne_id            IN nm_elements.ne_id%TYPE,
                            pi_effective_date   IN DATE,
                            pi_use_history         VARCHAR2)
    IS
    BEGIN
        IF pi_use_history = 'Y'
        THEN
            UPDATE nm_members
               SET nm_end_date = g_end_date
             WHERE nm_ne_id_in = pi_ne_id;

            INSERT INTO nm_members (nm_ne_id_in,
                                    nm_ne_id_of,
                                    nm_type,
                                    nm_obj_type,
                                    nm_begin_mp,
                                    nm_start_date,
                                    nm_end_date,
                                    nm_end_mp,
                                    nm_slk,
                                    nm_cardinality,
                                    nm_admin_unit,
                                    nm_seg_no,
                                    nm_seq_no,
                                    nm_true)
                SELECT pi_ne_id,
                       ne_id,
                       'G',
                       g_gty,
                       nm_begin_mp,
                       pi_effective_date,
                       NULL,
                       nm_end_mp,
                       nm_true,
                       nm_cardinality,
                       g_admin_unit,
                       nm_seg_no,
                       nm_seq_no,
                       nm_true
                  FROM nm_rescale_write;
        ELSE
            DECLARE
                CURSOR c_ne_temp
                IS
                    SELECT nm_ne_id_of
                      FROM nm_members m
                     WHERE     nm_ne_id_in = pi_ne_id
                           AND NOT EXISTS
                                   (SELECT 1
                                      FROM nm_rescale_write w
                                     WHERE w.ne_id = m.nm_ne_id_of);
            BEGIN
                nm_debug.delete_debug (TRUE);
                nm_debug.debug_on;

                FOR irec IN c_ne_temp
                LOOP
                    nm_debug.debug ('Missing ' || irec.nm_ne_id_of);
                END LOOP;
            END;

            UPDATE nm_members
               SET nm_slk = get_true (nm_ne_id_of),
                   nm_true = get_true (nm_ne_id_of),
                   nm_seq_no = get_seq_no (nm_ne_id_of),
                   nm_seg_no = get_seg_no (nm_ne_id_of)
             WHERE nm_ne_id_in = pi_ne_id;
        END IF;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE update_partial_route (
        pi_ne_id            IN nm_elements.ne_id%TYPE,
        pi_effective_date   IN DATE,
        pi_st_element_id    IN nm_elements.ne_id%TYPE,
        pi_use_history      IN VARCHAR2)
    IS
        CURSOR c1
        IS
                SELECT ne_id,
                       nm_true,
                       nm_seg_no,
                       nm_seq_no
                  FROM nm_rescale_write
            CONNECT BY PRIOR ne_id = s_ne_id
            START WITH s_ne_id = pi_st_element_id;
    BEGIN
        IF pi_use_history = 'Y'
        THEN
            UPDATE nm_members
               SET nm_end_date = g_end_date
             WHERE     nm_ne_id_in = pi_ne_id
                   AND nm_ne_id_of IN (    SELECT ne_id
                                             FROM nm_rescale_write
                                       CONNECT BY PRIOR ne_id = s_ne_id
                                       START WITH s_ne_id = pi_st_element_id);

            INSERT INTO nm_members (nm_ne_id_in,
                                    nm_ne_id_of,
                                    nm_type,
                                    nm_obj_type,
                                    nm_begin_mp,
                                    nm_start_date,
                                    nm_end_date,
                                    nm_end_mp,
                                    nm_slk,
                                    nm_cardinality,
                                    nm_admin_unit,
                                    nm_seg_no,
                                    nm_seq_no,
                                    nm_true)
                SELECT pi_ne_id,
                       ne_id,
                       'G',
                       g_gty,
                       nm_begin_mp,
                       pi_effective_date,
                       NULL,
                       nm_end_mp,
                       nm_true,
                       nm_cardinality,
                       g_admin_unit,
                       nm_seg_no,
                       nm_seq_no,
                       nm_true
                  FROM nm_rescale_write
                 WHERE ne_id IN (    SELECT b.ne_id
                                       FROM nm_rescale_write b
                                 CONNECT BY PRIOR b.ne_id = b.s_ne_id
                                 START WITH b.s_ne_id = pi_st_element_id);
        ELSE
            -- no history - just perform an update of the actual measures

            FOR irec IN c1
            LOOP
                UPDATE nm_members
                   SET nm_slk = irec.nm_true,
                       nm_true = irec.nm_true,
                       nm_seg_no = irec.nm_seg_no,
                       nm_seq_no = irec.nm_seq_no
                 WHERE nm_ne_id_in = pi_ne_id AND nm_ne_id_of = irec.ne_id;
            END LOOP;
        END IF;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE reseq_route (
        pi_ne_id      IN nm_elements.ne_id%TYPE,
        pi_ne_start   IN nm_elements.ne_id%TYPE DEFAULT NULL)
    IS
        CURSOR c1
        IS
                SELECT nm_ne_id_of
                  FROM nm_members
                 WHERE nm_ne_id_in = pi_ne_id
            FOR UPDATE OF nm_seg_no;

        l_empty_flag     VARCHAR2 (1);
        l_shape_option   VARCHAR2 (1)
            := NVL (hig.get_user_or_sys_opt ('SDORESEQ'), 'H');

        l_max_date       DATE;

        FUNCTION get_max_date
            RETURN DATE
        IS
            retval   DATE;
        BEGIN
            SELECT MAX (nm_start_date)
              INTO retval
              FROM nm_members
             WHERE nm_ne_id_in = pi_ne_id;

            RETURN retval;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                RETURN NULL;
        END;
    BEGIN
        IF pi_ne_start IS NOT NULL
        THEN
            nm3ctx.set_context ('RSC_START', TO_CHAR (pi_ne_start));
        ELSE
            nm3ctx.set_context ('RSC_START', NULL);
        END IF;

        instantiate_data (pi_ne_id => pi_ne_id, pi_effective_date => NULL);

        empty_route_check (
            pi_ne_id,
            TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                     'DD-MON-YYYY'),
            'N',
            l_empty_flag);

        IF l_empty_flag = 'N'
        THEN
            --set_start_points;

            connect_route (pi_ne_id, 0, pi_ne_start);

            FOR irec IN c1
            LOOP
                UPDATE nm_members
                   SET nm_seg_no = get_seg_no (irec.nm_ne_id_of),
                       nm_seq_no = get_seq_no (irec.nm_ne_id_of),
                       nm_true = get_true (irec.nm_ne_id_of)
                 WHERE CURRENT OF c1;
            END LOOP;

            l_max_date := get_max_date;

            -- AE Get a new shape for the resequenced route, with no history

            -- Task 0110688
            -- Use shape history on a resequence based on SDORESEQ product option
            --
            IF l_shape_option NOT IN ('H'         -- Change shape with history
                                         , 'U' -- Change shape without history
                                              , 'N'      -- No change to shape
                                                   )
            THEN
                -- Default to the old method of history when the option hasn't been set properly.
                -- It will already default to 'H' if the option is null
                l_shape_option := 'H';
            END IF;

            --
            IF l_shape_option != 'N'
            THEN
                nm3sdm.reshape_route (
                    pi_ne_id,
                    NVL (
                        l_max_date,
                        TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                                 'DD-MON-YYYY')),
                    CASE WHEN l_shape_option = 'H' THEN 'Y' ELSE 'N' END);
            END IF;
        --
        END IF;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_seg_no (pi_ne_id IN nm_elements.ne_id%TYPE)
        RETURN NUMBER
    IS
        CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE)
        IS
            SELECT nm_seg_no
              FROM nm_rescale_write
             WHERE ne_id = c_ne_id;

        retval   nm_members_all.nm_seg_no%TYPE;
    BEGIN
        OPEN c1 (pi_ne_id);

        FETCH c1 INTO retval;

        IF c1%NOTFOUND
        THEN
            CLOSE c1;

            RAISE_APPLICATION_ERROR (-20201,
                                     'Cant find the new segment number');
        END IF;

        CLOSE c1;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_seq_no (pi_ne_id IN nm_elements.ne_id%TYPE)
        RETURN NUMBER
    IS
        CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE)
        IS
            SELECT nm_seq_no
              FROM nm_rescale_write
             WHERE ne_id = c_ne_id;

        retval   nm_members_all.nm_seq_no%TYPE;
    BEGIN
        OPEN c1 (pi_ne_id);

        FETCH c1 INTO retval;

        IF c1%NOTFOUND
        THEN
            CLOSE c1;

            RAISE_APPLICATION_ERROR (-20202,
                                     'Cant find the new sequence number');
        END IF;

        CLOSE c1;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_true (pi_ne_id IN nm_elements.ne_id%TYPE)
        RETURN NUMBER
    IS
        CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE)
        IS
            SELECT nm_true
              FROM nm_rescale_write
             WHERE ne_id = c_ne_id;

        retval   nm_members_all.nm_true%TYPE;
    BEGIN
        OPEN c1 (pi_ne_id);

        FETCH c1 INTO retval;

        IF c1%NOTFOUND
        THEN
            CLOSE c1;

            RAISE_APPLICATION_ERROR (-20203,
                                     'Cant find the new true distance');
        END IF;

        CLOSE c1;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_slk (pi_ne_id IN nm_elements.ne_id%TYPE)
        RETURN NUMBER
    IS
        CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE)
        IS
            SELECT nm_slk
              FROM nm_rescale_write
             WHERE ne_id = c_ne_id;

        retval   nm_members_all.nm_true%TYPE;
    BEGIN
        OPEN c1 (pi_ne_id);

        FETCH c1 INTO retval;

        IF c1%NOTFOUND
        THEN
            CLOSE c1;

            RAISE_APPLICATION_ERROR (-20204,
                                     'Cant find the new slk distance');
        END IF;

        CLOSE c1;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_length (pi_ne_id IN nm_elements.ne_id%TYPE)
        RETURN NUMBER
    IS
        CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE)
        IS
            SELECT NVL (nm_end_mp - nm_begin_mp, ne_length)
              FROM nm_rescale_write
             WHERE ne_id = c_ne_id;

        retval   nm_members_all.nm_true%TYPE;
    BEGIN
        OPEN c1 (pi_ne_id);

        FETCH c1 INTO retval;

        IF c1%NOTFOUND
        THEN
            CLOSE c1;

            RAISE_APPLICATION_ERROR (
                -20205,
                'Cant find the length of rescaled element');
        END IF;

        CLOSE c1;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE check_rescale (pi_ne_id            IN nm_elements.ne_id%TYPE,
                             pi_effective_date   IN DATE)
    IS
        CURSOR c1 (
            c_ne_id    nm_elements.ne_id%TYPE,
            c_date     DATE)
        IS
            SELECT '1'
              FROM nm_members_all
             WHERE     nm_ne_id_in = c_ne_id
                   AND (nm_start_date >= c_date OR nm_end_date > c_date);

        l_date_check   VARCHAR2 (1);
    BEGIN
        OPEN c1 (pi_ne_id, pi_effective_date);

        FETCH c1 INTO l_date_check;

        IF c1%FOUND
        THEN
            CLOSE c1;

            RAISE_APPLICATION_ERROR (-20206,
                                     'The member dates prevent operation');
        END IF;

        CLOSE c1;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE check_rescale_member (
        pi_ne_id_in         IN nm_members.nm_ne_id_in%TYPE,
        pi_ne_id_of         IN nm_members.nm_ne_id_of%TYPE,
        pi_begin_mp         IN nm_members.nm_begin_mp%TYPE,
        pi_effective_date   IN DATE)
    IS
        CURSOR c_nm (
            p_ne_id_in         IN nm_members.nm_ne_id_in%TYPE,
            p_ne_id_of         IN nm_members.nm_ne_id_of%TYPE,
            p_begin_mp         IN nm_members.nm_begin_mp%TYPE,
            p_effective_date   IN DATE)
        IS
            SELECT 1
              FROM nm_members_all nm
             WHERE     nm.nm_ne_id_in = p_ne_id_in
                   AND nm.nm_ne_id_of = p_ne_id_of
                   AND nm.nm_begin_mp = p_begin_mp
                   AND (   nm.nm_start_date >= p_effective_date
                        OR nm.nm_end_date > p_effective_date);

        l_dummy   PLS_INTEGER;
    BEGIN
        OPEN c_nm (p_ne_id_in         => pi_ne_id_in,
                   p_ne_id_of         => pi_ne_id_of,
                   p_begin_mp         => pi_begin_mp,
                   p_effective_date   => pi_effective_date);

        FETCH c_nm INTO l_dummy;

        IF c_nm%FOUND
        THEN
            CLOSE c_nm;

            RAISE_APPLICATION_ERROR (-20206,
                                     'The member dates prevent operation');
        END IF;

        CLOSE c_nm;
    END check_rescale_member;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE instantiate_data (
        pi_ne_id            IN nm_elements.ne_id%TYPE,
        pi_effective_date   IN DATE DEFAULT TRUNC (SYSDATE))
    IS
        CURSOR c1
        IS
                SELECT ne_gty_group_type, ne_admin_unit
                  FROM nm_elements_all
                 WHERE ne_id = pi_ne_id
            FOR UPDATE OF ne_id NOWAIT;
    --CURSOR c2 IS
    --  SELECT /*+ index(n ne_pk) full ( w ) */ n.ne_id ne_id
    --  FROM nm_elements n, nm_rescale_write w
    --  WHERE n.ne_id = w.ne_id
    --  AND n.ne_type = 'D';
    --
    --CURSOR c3 ( c_ne_id nm_elements.ne_id%TYPE, c_gty nm_elements.ne_gty_group_type%TYPE ) IS
    --  SELECT ws.ne_sub_class ne_sub_class
    --  FROM nm_rescale_write w1, nm_rescale_write ws, nm_rescale_write we
    --  WHERE w1.ne_id = c_ne_id
    --  AND ws.ne_no_end    = w1.ne_no_start
    --  AND we.ne_no_start  = w1.ne_no_end
    --  AND we.ne_sub_class = ws.ne_sub_class
    --  ORDER BY ws.ne_sub_class;
    --
    BEGIN
        --
        nm3ctx.set_context ('ORDERED_ROUTE', TO_CHAR (pi_ne_id));

        --

        IF is_route (pi_ne_id)
        THEN
            --nm_debug.debug('Route');
            g_route_or_inv := 'R';
            nm3lock.lock_element_and_members (pi_ne_id, TRUE);
        ELSE
            --nm_debug.debug('Inv');

            g_route_or_inv := 'I';
            g_gty := NULL;
            g_use_sub_class := 'N';
            nm3lock.lock_inv_item_and_members (pi_ne_id, TRUE);
        END IF;

        --nm_debug.debug('Clearing the stuff out');
        --
        DELETE nm_rescale_read;

        DELETE nm_rescale_write;

        DELETE nm_rescale_seg_tree;

        --nm_debug.debug('Globals');
        set_globals (pi_ne_id, pi_effective_date);


        IF g_route_or_inv = 'R'
        THEN
            OPEN c1;

            FETCH c1 INTO g_gty, g_admin_unit;

            CLOSE c1;
        END IF;

        INSERT INTO nm_rescale_write (ne_id,
                                      ne_no_start,
                                      ne_no_end,
                                      ne_length,
                                      nm_slk,
                                      nm_true,
                                      nm_seg_no,
                                      nm_seq_no,
                                      ne_nt_type,
                                      nm_cardinality,
                                      ne_sub_class,
                                      nm_begin_mp,
                                      nm_end_mp,
                                      s_ne_id,
                                      connect_level)
            SELECT ne_id,
                   CASE dir_flag WHEN 1 THEN start_node ELSE end_node END,
                   CASE dir_flag WHEN -1 THEN start_node ELSE end_node END,
                   ne_length,
                   nm_slk,
                   NULL,
                   NULL,
                   NULL,
                   ne_nt_type,
                   dir_flag,
                   DECODE (g_use_sub_class, 'Y', nsc_seq_no, NULL),
                   nm_begin_mp,
                   nm_end_mp,
                   NVL (prior_ne, -1),
                   NULL
              FROM v_nm_ordered_members;

        INSERT INTO nm_rescale_read (ne_id,
                                     ne_no_start,
                                     ne_no_end,
                                     ne_length,
                                     nm_slk,
                                     nm_true,
                                     nm_seg_no,
                                     nm_seq_no,
                                     ne_nt_type,
                                     nm_cardinality,
                                     ne_sub_class,
                                     nm_begin_mp,
                                     nm_end_mp,
                                     s_ne_id,
                                     connect_level)
            SELECT ne_id,
                   CASE dir_flag WHEN 1 THEN start_node ELSE end_node END,
                   CASE dir_flag WHEN -1 THEN start_node ELSE end_node END,
                   ne_length,
                   nm_slk,
                   NULL,
                   NULL,
                   NULL,
                   ne_nt_type,
                   dir_flag,
                   NULL,    --DECODE( g_use_sub_class, 'Y', nsc_seq_no, NULL),
                   nm_begin_mp,
                   nm_end_mp,
                   NVL (prior_ne, -1),
                   NULL
              FROM v_nm_ordered_members;
    --problems exist with distance-breaks - they do not have a sensible sub-class.
    --set the sub-class to be a default of 'S' but if they have a start and end of L then choose L
    --and if they have a start and end of R then choose R

    --  FOR irec IN c2 LOOP
    --
    --    FOR jrec IN c3( irec.ne_id, g_gty ) LOOP
    --
    --      UPDATE nm_rescale_write
    --      SET ne_sub_class = jrec.ne_sub_class
    --      WHERE ne_id = irec.ne_id;
    --
    --      UPDATE nm_rescale_read
    --      SET ne_sub_class = jrec.ne_sub_class
    --      WHERE ne_id = irec.ne_id;
    --
    --    END LOOP;
    --  END LOOP;

    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_next_element (pi_route_id IN NUMBER, pi_ne_id IN NUMBER)
        RETURN NUMBER
    IS
        CURSOR c1 (
            c_route_id    NUMBER,
            c_ne_id       NUMBER)
        IS
            SELECT a.nnu_ne_id
              FROM nm_node_usages a, nm_members, nm_node_usages b
             WHERE     a.nnu_ne_id = nm_ne_id_of
                   AND a.nnu_no_node_id = nm3net.get_end_node (nm_ne_id_of)
                   AND a.nnu_ne_id != c_ne_id
                   AND b.nnu_ne_id = c_ne_id
                   AND b.nnu_no_node_id = a.nnu_no_node_id
                   AND nm_ne_id_in = c_route_id;

        l_ne_id   NUMBER;
    BEGIN
        OPEN c1 (pi_route_id, pi_ne_id);

        FETCH c1 INTO l_ne_id;

        IF c1%NOTFOUND
        THEN
            l_ne_id := -1;
        END IF;

        RETURN l_ne_id;
    END get_next_element;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE local_rescale (pi_ne_id_in         IN nm_elements.ne_id%TYPE,
                             pi_ne_id_of         IN nm_elements.ne_id%TYPE,
                             pi_begin_mp         IN nm_members.nm_begin_mp%TYPE,
                             pi_effective_date   IN DATE,
                             pi_use_history      IN BOOLEAN DEFAULT TRUE)
    IS
        l_ne_rec   nm_elements%ROWTYPE;
        l_nm_rec   nm_members%ROWTYPE;
        l_nmh      nm_member_history%ROWTYPE;

        l_no_id    nm_nodes.no_node_id%TYPE;

        l_slk      nm_members.nm_slk%TYPE;
    BEGIN
        IF pi_use_history
        THEN
            --check for violations of nm_members primary key if using history
            check_rescale_member (pi_ne_id_in         => pi_ne_id_in,
                                  pi_ne_id_of         => pi_ne_id_of,
                                  pi_begin_mp         => pi_begin_mp,
                                  pi_effective_date   => pi_effective_date);
        END IF;

        --lock route
        nm3lock.lock_element_and_members (pi_ne_id_in, TRUE);

        --get member ne record
        l_ne_rec := nm3net.get_ne (pi_ne_id => pi_ne_id_of);

        --get original nm record
        l_nm_rec :=
            nm3net.get_nm (pi_ne_id_in   => pi_ne_id_in,
                           pi_ne_id_of   => pi_ne_id_of,
                           pi_begin_mp   => pi_begin_mp);

        --determine which node to consider based on cardinality of member
        IF l_nm_rec.nm_cardinality = 1
        THEN
            l_no_id := l_ne_rec.ne_no_start;
        ELSE
            l_no_id := l_ne_rec.ne_no_end;
        END IF;

        --get new slk value for member
        l_slk :=
            nm3net.get_node_slk (p_ne_id        => pi_ne_id_in,
                                 p_no_node_id   => l_no_id,
                                 p_sub_class    => l_ne_rec.ne_sub_class);

        --RAC - using datum and node
        --      delivers the same value as already on the DB!
        --                               ,p_datum_ne_id => pi_ne_id_of);

        IF pi_use_history
        THEN
            --end date original nm record
            UPDATE nm_members nm
               SET nm.nm_end_date = pi_effective_date
             WHERE     nm.nm_ne_id_in = pi_ne_id_in
                   AND nm.nm_ne_id_of = pi_ne_id_of
                   AND nm.nm_begin_mp = pi_begin_mp;

            --update slk for new record
            l_nm_rec.nm_slk := l_slk;

            --update start date for new record
            l_nm_rec.nm_start_date := pi_effective_date;

            --insert new nm record
            nm3net.ins_nm (pi_rec_nm => l_nm_rec);
        ELSE
            --update slk on existing record
            UPDATE nm_members nm
               SET nm.nm_slk = l_slk
             WHERE     nm.nm_ne_id_in = pi_ne_id_in
                   AND nm.nm_ne_id_of = pi_ne_id_of
                   AND nm.nm_begin_mp = pi_begin_mp;
        END IF;

        rescale_other_products (pi_nm_ne_id_in      => pi_ne_id_in,
                                pi_nm_ne_id_of      => pi_ne_id_of,
                                pi_nm_begin_mp      => pi_begin_mp,
                                pi_effective_date   => pi_effective_date);
    END local_rescale;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION is_reversable (pi_gty IN nm_group_types_all.ngt_group_type%TYPE)
        RETURN BOOLEAN
    IS
        CURSOR c1 (c_gty nm_group_types_all.ngt_group_type%TYPE)
        IS
            SELECT gty.ngt_reverse_allowed
              FROM nm_group_types gty
             WHERE gty.ngt_group_type = c_gty;

        retval    BOOLEAN := FALSE;
        l_dummy   VARCHAR2 (1);
    BEGIN
        OPEN c1 (pi_gty);

        FETCH c1 INTO l_dummy;

        IF c1%NOTFOUND
        THEN
            l_dummy := 'N';
        END IF;

        CLOSE c1;

        IF l_dummy = 'Y'
        THEN
            retval := TRUE;
        END IF;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION is_route (p_ne_id IN nm_elements.ne_id%TYPE)
        RETURN BOOLEAN
    IS
        CURSOR c1 (c_ne_id nm_elements.ne_id%TYPE)
        IS
            SELECT 1
              FROM nm_elements
             WHERE ne_id = p_ne_id;

        retval   BOOLEAN;
        dummy    INTEGER;
    BEGIN
        OPEN c1 (p_ne_id);

        FETCH c1 INTO dummy;

        retval := c1%FOUND;

        CLOSE c1;

        RETURN retval;
    END;

    --
    -------------------------------------------------------------------------------------------
    --
    PROCEDURE rescale_temp_ne (
        p_nte_job_id   IN nm_nw_temp_extents.nte_job_id%TYPE,
        p_route_id     IN nm_elements.ne_id%TYPE DEFAULT NULL,
        p_start_ne     IN nm_elements.ne_id%TYPE DEFAULT NULL)
    IS
        retval   nm_placement_array;
    BEGIN
        --nm_debug.debug_on ;

        IF p_route_id IS NULL
        THEN
            instantiate_data_from_temp_ne (p_nte_job_id);
        ELSE
            instantiate_from_route_nte (p_nte_job_id, p_route_id);
        END IF;

        set_start_points;

        connect_route (p_nte_job_id, 0, p_start_ne);

        retval := get_rescaled_pl;
    END rescale_temp_ne;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_rescaled_pl
        RETURN nm_placement_array
    IS
        retval   nm_placement_array;

        CURSOR c1
        IS
              SELECT ne_id,
                     nm_begin_mp,
                     nm_end_mp,
                     nm_true
                FROM nm_rescale_write
            ORDER BY nm_seq_no;
    BEGIN
        retval := nm3pla.initialise_placement_array;

        FOR irec IN c1
        LOOP
            retval :=
                retval.add_element (irec.ne_id,
                                    irec.nm_begin_mp,
                                    irec.nm_end_mp,
                                    irec.nm_true);
        END LOOP;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE instantiate_data_from_temp_ne (
        p_nte_job_id   IN nm_nw_temp_extents.nte_job_id%TYPE)
    IS
        CURSOR c2
        IS
            SELECT  /*+ index(n ne_pk) full ( w ) */
                   n.ne_id ne_id
              FROM nm_elements n, nm_rescale_write w
             WHERE n.ne_id = w.ne_id AND n.ne_type = 'D';

        CURSOR c3 (
            c_ne_id    nm_elements.ne_id%TYPE,
            c_gty      nm_elements.ne_gty_group_type%TYPE)
        IS
              SELECT ws.ne_sub_class ne_sub_class
                FROM nm_rescale_write w1,
                     nm_rescale_write ws,
                     nm_rescale_write we
               WHERE     w1.ne_id = c_ne_id
                     AND ws.ne_no_end = w1.ne_no_start
                     AND we.ne_no_start = w1.ne_no_end
                     AND we.ne_sub_class = ws.ne_sub_class
            ORDER BY ws.ne_sub_class;
    BEGIN
        DELETE nm_rescale_read;

        DELETE nm_rescale_write;

        DELETE nm_rescale_seg_tree;

        --nm_debug.debug('Globals');

        g_route_or_inv := 'R';
        g_end_date := TRUNC (SYSDATE);
        set_globals_for_temp_ne (p_nte_job_id);

        --trap the dup val on index - only possible with an unsuitable temp ne - one with
        --the same element in the extent more than once.

        BEGIN
            INSERT INTO nm_rescale_write (ne_id,
                                          ne_no_start,
                                          ne_no_end,
                                          ne_length,
                                          nm_slk,
                                          nm_true,
                                          nm_seg_no,
                                          nm_seq_no,
                                          ne_nt_type,
                                          nm_cardinality,
                                          ne_sub_class,
                                          nm_begin_mp,
                                          nm_end_mp,
                                          s_ne_id,
                                          connect_level)
                SELECT ne_id,
                       ne_no_start,
                       ne_no_end,
                       ne_length,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       ne_nt_type,
                       nte_cardinality,
                       DECODE (
                           g_use_sub_class,
                           'Y', TO_CHAR (
                                    nm3net.get_sub_class_seq (g_gty,
                                                              ne_sub_class)),
                           NULL),
                       nte_begin_mp,
                       nte_end_mp,
                       NULL,
                       NULL
                  FROM nm_elements, nm_nw_temp_extents
                 WHERE ne_id = nte_ne_id_of AND nte_job_id = p_nte_job_id;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 317);
        END;

        INSERT INTO nm_rescale_read (ne_id,
                                     ne_no_start,
                                     ne_no_end,
                                     ne_length,
                                     nm_slk,
                                     nm_true,
                                     nm_seg_no,
                                     nm_seq_no,
                                     ne_nt_type,
                                     nm_cardinality,
                                     ne_sub_class,
                                     nm_begin_mp,
                                     nm_end_mp,
                                     s_ne_id,
                                     connect_level)
            SELECT ne_id,
                   ne_no_start,
                   ne_no_end,
                   ne_length,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   ne_nt_type,
                   nte_cardinality,
                   DECODE (
                       g_use_sub_class,
                       'Y', TO_CHAR (
                                nm3net.get_sub_class_seq (g_gty,
                                                          ne_sub_class)),
                       NULL),
                   nte_begin_mp,
                   nte_end_mp,
                   NULL,
                   NULL
              FROM nm_elements, nm_nw_temp_extents
             WHERE ne_id = nte_ne_id_of AND nte_job_id = p_nte_job_id;

        --problems exist with distance-breaks - they do not have a sensible sub-class.
        --set the sub-class to be a default of 'S' but if they have a start and end of L then choose L
        --and if they have a start and end of R then choose R

        FOR irec IN c2
        LOOP
            FOR jrec IN c3 (irec.ne_id, g_gty)
            LOOP
                UPDATE nm_rescale_write
                   SET ne_sub_class = jrec.ne_sub_class
                 WHERE ne_id = irec.ne_id;

                UPDATE nm_rescale_read
                   SET ne_sub_class = jrec.ne_sub_class
                 WHERE ne_id = irec.ne_id;
            END LOOP;
        END LOOP;
    END instantiate_data_from_temp_ne;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE instantiate_from_route_nte (
        p_nte_job_id   IN nm_nw_temp_extents.nte_job_id%TYPE,
        p_route_id     IN nm_elements.ne_id%TYPE)
    IS
        CURSOR c2
        IS
            SELECT  /*+ index(n ne_pk) full ( w ) */
                   n.ne_id ne_id
              FROM nm_elements n, nm_rescale_write w
             WHERE n.ne_id = w.ne_id AND n.ne_type = 'D';

        CURSOR c3 (
            c_ne_id    nm_elements.ne_id%TYPE,
            c_gty      nm_elements.ne_gty_group_type%TYPE)
        IS
              SELECT ws.ne_sub_class ne_sub_class
                FROM nm_rescale_write w1,
                     nm_rescale_write ws,
                     nm_rescale_write we
               WHERE     w1.ne_id = c_ne_id
                     AND ws.ne_no_end = w1.ne_no_start
                     AND we.ne_no_start = w1.ne_no_end
                     AND we.ne_sub_class = ws.ne_sub_class
            ORDER BY ws.ne_sub_class;
    BEGIN
        DELETE nm_rescale_read;

        DELETE nm_rescale_write;

        DELETE nm_rescale_seg_tree;

        --nm_debug.debug('Globals');

        g_route_or_inv := 'R';
        g_end_date := TRUNC (SYSDATE);
        set_globals_for_temp_ne (p_nte_job_id);

        --trap the dup val on index - only possible with an unsuitable temp ne - one with
        --the same element in the extent more than once.

        BEGIN
            INSERT INTO nm_rescale_write (ne_id,
                                          ne_no_start,
                                          ne_no_end,
                                          ne_length,
                                          nm_slk,
                                          nm_true,
                                          nm_seg_no,
                                          nm_seq_no,
                                          ne_nt_type,
                                          nm_cardinality,
                                          ne_sub_class,
                                          nm_begin_mp,
                                          nm_end_mp,
                                          s_ne_id,
                                          connect_level)
                SELECT ne_id,
                       ne_no_start,
                       ne_no_end,
                       ne_length,
                       NULL,
                       NULL,
                       NULL,
                       NULL,
                       ne_nt_type,
                       nm_cardinality,
                       DECODE (
                           g_use_sub_class,
                           'Y', TO_CHAR (
                                    nm3net.get_sub_class_seq (g_gty,
                                                              ne_sub_class)),
                           NULL),
                       nte_begin_mp,
                       nte_end_mp,
                       NULL,
                       NULL
                  FROM nm_elements, nm_nw_temp_extents, nm_members
                 WHERE     ne_id = nte_ne_id_of
                       AND ne_id = nm_ne_id_of
                       AND nm_ne_id_in = p_route_id
                       AND nte_job_id = p_nte_job_id;
        EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
                hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 317);
        END;

        INSERT INTO nm_rescale_read (ne_id,
                                     ne_no_start,
                                     ne_no_end,
                                     ne_length,
                                     nm_slk,
                                     nm_true,
                                     nm_seg_no,
                                     nm_seq_no,
                                     ne_nt_type,
                                     nm_cardinality,
                                     ne_sub_class,
                                     nm_begin_mp,
                                     nm_end_mp,
                                     s_ne_id,
                                     connect_level)
            SELECT ne_id,
                   ne_no_start,
                   ne_no_end,
                   ne_length,
                   NULL,
                   NULL,
                   NULL,
                   NULL,
                   ne_nt_type,
                   nm_cardinality,
                   DECODE (
                       g_use_sub_class,
                       'Y', TO_CHAR (
                                nm3net.get_sub_class_seq (g_gty,
                                                          ne_sub_class)),
                       NULL),
                   nte_begin_mp,
                   nte_end_mp,
                   NULL,
                   NULL
              FROM nm_elements, nm_nw_temp_extents, nm_members
             WHERE     ne_id = nte_ne_id_of
                   AND ne_id = nm_ne_id_of
                   AND nm_ne_id_in = p_route_id
                   AND nte_job_id = p_nte_job_id;

        --problems exist with distance-breaks - they do not have a sensible sub-class.
        --set the sub-class to be a default of 'S' but if they have a start and end of L then choose L
        --and if they have a start and end of R then choose R

        FOR irec IN c2
        LOOP
            FOR jrec IN c3 (irec.ne_id, g_gty)
            LOOP
                UPDATE nm_rescale_write
                   SET ne_sub_class = jrec.ne_sub_class
                 WHERE ne_id = irec.ne_id;

                UPDATE nm_rescale_read
                   SET ne_sub_class = jrec.ne_sub_class
                 WHERE ne_id = irec.ne_id;
            END LOOP;
        END LOOP;
    END instantiate_from_route_nte;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE create_seg_tree
    IS
        cannot_insert_null   EXCEPTION;
        PRAGMA EXCEPTION_INIT (cannot_insert_null, -1400);
    BEGIN
        INSERT INTO nm_rescale_seg_tree
            SELECT a.nm_seg_no,
                   b.nm_seg_no,
                   a.ne_sub_class,
                   b.ne_sub_class,
                   a.connect_level
              FROM nm_rescale_write a, nm_rescale_write b
             WHERE b.ne_id = a.s_ne_id AND b.nm_seg_no != a.nm_seg_no
            UNION
            SELECT a.nm_seg_no,
                   0,
                   a.ne_sub_class,
                   NULL,
                   1
              FROM nm_rescale_write a
             WHERE a.s_ne_id = -1;
    EXCEPTION
        WHEN cannot_insert_null
        THEN
            hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 437);
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_globals_for_temp_ne (
        p_nte_job_id   IN nm_nw_temp_extents.nte_job_id%TYPE)
    IS
        nterec   nm_nw_temp_extents%ROWTYPE;

        CURSOR c1 (c_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE)
        IS
            SELECT *
              FROM nm_nw_temp_extents
             WHERE nte_job_id = c_nte_job_id;
    BEGIN
        OPEN c1 (p_nte_job_id);

        FETCH c1 INTO nterec;

        CLOSE c1;

        --nm_debug.debug( 'globals for temp ne');
        g_datum_units :=
            nm3net.get_nt_units (nm3net.get_nt_type (nterec.nte_ne_id_of));
        g_route_units := g_datum_units;

        --nm_debug.debug( 'units = '||TO_CHAR(nm3net.get_nt_units( nm3net.get_nt_type( nterec.nte_ne_id_of ))));


        --changed below to always ignore sub class as we do not know where extent has come from
        g_use_sub_class := 'N';
    --   IF nterec.nte_route_ne_id IS NOT NULL THEN
    --     g_gty := nm3net.get_gty_type ( nterec.nte_route_ne_id );
    --     --nm_debug.debug('g_gty : '||g_gty);
    --     IF   g_gty IS NOT NULL
    --      AND NOT is_reversable ( g_gty )
    --      THEN
    --       g_use_sub_class := 'Y';
    --     ELSE
    --       g_use_sub_class := 'N';
    --     END IF;
    --   END IF;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_start (p_ne_id IN NUMBER)
    IS
        CURSOR c_start (
            c_ne   IN NUMBER)
        IS
              SELECT nm1.nm_ne_id_of,
                     nnu1.nnu_no_node_id,
                     nnu1.nnu_node_type,
                     nm1.ROWID
                FROM nm_members nm1, nm_node_usages nnu1, nm_elements g
               WHERE     nm1.nm_ne_id_of = nnu1.nnu_ne_id
                     AND nm1.nm_ne_id_in = c_ne
                     AND nnu_no_node_id = g.ne_no_start
                     AND g.ne_id = c_ne
                     AND NOT EXISTS
                             (SELECT 1
                                FROM nm_members nm2, nm_node_usages nnu2
                               WHERE     nm2.nm_ne_id_of = nnu2.nnu_ne_id
                                     AND nm2.nm_ne_id_in = c_ne
                                     AND nnu2.nnu_no_node_id =
                                         nnu1.nnu_no_node_id
                                     AND nnu2.nnu_ne_id != nnu1.nnu_ne_id)
            ORDER BY nnu1.nnu_node_type DESC;
    BEGIN
        --nm_debug.debug('Setting cardinality to zero');

        UPDATE nm_rescale_write
           SET nm_cardinality = 0, nm_seq_no = NULL;

        FOR irec IN c_start (p_ne_id)
        LOOP
            --nm_debug.debug('Setting start at '||to_char( irec.nm_ne_id_of ));

            UPDATE nm_rescale_write
               SET s_ne_id = -1,
                   nm_cardinality =
                       DECODE (irec.nnu_node_type,  'E', -1,  'S', 1)
             WHERE ne_id = irec.nm_ne_id_of;
        END LOOP;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_member_cardinality (pi_ne_id      IN NUMBER,
                                      pi_ne_start   IN NUMBER)
    IS
        CURSOR c1
        IS
            SELECT *
              FROM nm_rescale_write
             WHERE s_ne_id = -1;

        --  ORDER BY nm_cardinality DESC;

        l_nsc   nm_rescale_write%ROWTYPE;
    BEGIN
        OPEN c1;

        FETCH c1 INTO l_nsc;

        WHILE c1%FOUND
        LOOP
            --nm_debug.debug('Starting at '||to_char(l_nsc.ne_id));


            UPDATE nm_rescale_write
               SET nm_seq_no = 1
             WHERE ne_id = l_nsc.ne_id;

            set_next_nsc (l_nsc);

            FETCH c1 INTO l_nsc;
        END LOOP;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_cardinality (
        pi_ne_id          IN nm_elements.ne_id%TYPE,
        pi_ne_start       IN nm_elements.ne_id%TYPE DEFAULT NULL,
        pi_raise_errors   IN BOOLEAN DEFAULT TRUE)
    IS
        CURSOR c1
        IS
            SELECT * FROM nm_rescale_write;

        cant_set_cardinality   EXCEPTION;
    BEGIN
        --nm_debug.debug( 'Start - instantiate data');

        instantiate_data (pi_ne_id => pi_ne_id, pi_effective_date => NULL);

        --nm_debug.debug( 'set start' );

        set_start (pi_ne_id);

        --nm_debug.debug('Setting cardinality');

        set_member_cardinality (pi_ne_id, pi_ne_start);

        --nm_debug.debug( 'Performing update');

        FOR irec IN c1
        LOOP
            IF irec.nm_cardinality NOT IN (1, -1)
            THEN
                IF pi_raise_errors
                THEN
                    RAISE cant_set_cardinality;
                END IF;
            ELSE
                UPDATE nm_members a
                   SET a.nm_cardinality = irec.nm_cardinality
                 WHERE nm_ne_id_in = pi_ne_id AND nm_ne_id_of = irec.ne_id;
            END IF;
        END LOOP;
    EXCEPTION
        WHEN cant_set_cardinality
        THEN
            hig.raise_ner (pi_appl => nm3type.c_net, pi_id => 81);
    END;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION test_cardinality (p_ne_id IN NUMBER)
        RETURN BOOLEAN
    IS
        CURSOR c1
        IS
            SELECT nm_cardinality, nm_seq_no
              FROM nm_rescale_write
             WHERE ne_id = p_ne_id;

        --  and nm_cardinality != 0;
        retval          BOOLEAN;

        l_cardinality   NUMBER;
        l_seq_no        NUMBER;
    BEGIN
        OPEN c1;

        FETCH c1 INTO l_cardinality, l_seq_no;

        IF c1%FOUND
        THEN
            --  nm_debug.debug('found '||to_char(p_ne_id)||' with cardinality = '||to_char(l_cardinality));
            --  retval := c1%found;
            CLOSE c1;

            IF l_cardinality = 0
            THEN
                retval := TRUE;
            ELSE
                IF l_seq_no IS NULL
                THEN
                    retval := TRUE;
                ELSE
                    retval := FALSE;
                END IF;
            END IF;
        ELSE
            --    nm_debug.debug(' not found '||to_char(p_ne_id) );
            retval := TRUE;
        END IF;

        RETURN retval;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE set_next_nsc (p_rsc IN nm_rescale_write%ROWTYPE)
    IS
        CURSOR c_next_ne (
            c_rsc   IN nm_rescale_write%ROWTYPE)
        IS
            SELECT nrw.ne_id,
                   nrw.ne_no_start,
                   nrw.ne_no_end,
                   nnu.nnu_no_node_id,
                   nnu.nnu_node_type
              FROM nm_rescale_write nrw, nm_node_usages nnu
             WHERE     ne_id != c_rsc.ne_id
                   AND ne_id = nnu_ne_id
                   AND nnu_no_node_id =
                       DECODE (c_rsc.nm_cardinality,
                               1, c_rsc.ne_no_end,
                               -1, c_rsc.ne_no_start);

        l_nsc             nm_rescale_write%ROWTYPE;

        l_ne_id           NUMBER;
        l_ne_no_start     NUMBER;
        l_ne_no_end       NUMBER;
        l_node_id         NUMBER;
        l_nnu_node_type   VARCHAR2 (1);
        l_cardinality     NUMBER;
    BEGIN
        --  nm_debug.debug('set next rsc - old cardinality = '||to_char( p_rsc.nm_cardinality ));

        OPEN c_next_ne (p_rsc);

        FETCH c_next_ne
            INTO l_ne_id,
                 l_ne_no_start,
                 l_ne_no_end,
                 l_node_id,
                 l_nnu_node_type;

        --nm_debug.debug('Setting next '||to_char( l_ne_id ));

        WHILE c_next_ne%FOUND
        LOOP
            IF test_cardinality (l_ne_id)
            THEN
                l_cardinality :=
                      nm3net.route_direction (l_nnu_node_type,
                                              p_rsc.nm_cardinality)
                    * p_rsc.nm_cardinality;

                --nm_debug.debug( 'Update rsc');

                UPDATE nm_rescale_write
                   SET nm_cardinality = l_cardinality,
                       s_ne_id = p_rsc.ne_id,
                       nm_seq_no = 1
                 WHERE ne_id = l_ne_id;

                l_nsc.ne_id := l_ne_id;
                l_nsc.ne_no_start := l_ne_no_start;
                l_nsc.ne_no_end := l_ne_no_end;
                l_nsc.nm_cardinality := l_cardinality;
                l_nsc.s_ne_id := p_rsc.ne_id;

                --      nm_debug.debug('Going recursive with '||to_char(l_ne_id));

                set_next_nsc (l_nsc);
            END IF;

            FETCH c_next_ne
                INTO l_ne_id,
                     l_ne_no_start,
                     l_ne_no_end,
                     l_node_id,
                     l_nnu_node_type;
        END LOOP;

        IF c_next_ne%ISOPEN
        THEN
            CLOSE c_next_ne;
        END IF;
    END;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE get_datums_for_resize (
        pi_ne_id           IN     nm_elements.ne_id%TYPE,
        po_ne_id_arr          OUT nm3type.tab_number,
        po_ne_length_arr      OUT nm3type.tab_number)
    IS
    BEGIN
        nm_debug.proc_start (p_package_name     => g_package_name,
                             p_procedure_name   => 'get_datums_for_resize');

            SELECT ne.ne_id, ne.ne_length
              BULK COLLECT INTO po_ne_id_arr, po_ne_length_arr
              FROM nm_elements ne, nm_members nm
             WHERE nm.nm_ne_id_in = pi_ne_id AND nm.nm_ne_id_of = ne.ne_id
          ORDER BY nm.nm_seq_no
        FOR UPDATE OF ne_length NOWAIT;

        nm_debug.proc_end (p_package_name     => g_package_name,
                           p_procedure_name   => 'get_datums_for_resize');
    END get_datums_for_resize;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE resize_route (
        pi_ne_id      IN nm_elements_all.ne_id%TYPE,
        pi_new_size   IN NUMBER,
        pi_ne_start   IN nm_elements.ne_id%TYPE DEFAULT NULL)
    IS
        e_invalid_element   EXCEPTION;
        e_partial           EXCEPTION;

        l_ne_rec            nm_elements%ROWTYPE;

        l_new_length        NUMBER;

        l_current_length    NUMBER;

        l_length_LEFT       NUMBER;

        l_ne_id_arr         nm3type.tab_number;
        l_ne_length_arr     nm3type.tab_number;
    BEGIN
        nm_debug.proc_start (p_package_name     => g_package_name,
                             p_procedure_name   => 'resize_route');

        l_ne_rec := nm3get.get_ne (pi_ne_id => pi_ne_id);

        IF NOT nm3net.element_is_a_group (pi_ne_type => l_ne_rec.ne_type)
        THEN
            RAISE e_invalid_element;
        END IF;

        IF nm3net.gty_is_partial (pi_gty => l_ne_rec.ne_gty_group_type)
        THEN
            RAISE e_partial;
        END IF;

        --lock the route and its members
        nm3lock.lock_element_and_members (p_ne_id                 => pi_ne_id,
                                          p_lock_ele_for_update   => TRUE);

        --set units and such
        set_globals (pi_ne_id);

        --get current length by summing the lengths of the member datums
        l_current_length := nm3net.get_ne_length (pi_ne_id);

        IF pi_new_size IS NOT NULL
        THEN
            --work out new length in terms of the datum units
            l_new_length :=
                nm3unit.convert_unit (p_un_id_in    => g_route_units,
                                      p_un_id_out   => g_datum_units,
                                      p_value       => pi_new_size);
            l_length_LEFT := l_new_length;

            --get arrays of the datum ids and their lengths
            get_datums_for_resize (pi_ne_id           => pi_ne_id,
                                   po_ne_id_arr       => l_ne_id_arr,
                                   po_ne_length_arr   => l_ne_length_arr);

            --work out new length for each datum
            FOR i IN 1 .. l_ne_id_arr.COUNT
            LOOP
                l_ne_length_arr (I) :=
                    nm3unit.get_formatted_value (
                          (l_ne_length_arr (I) / l_current_length)
                        * l_new_length,
                        g_datum_units);

                l_length_LEFT := l_length_LEFT - l_ne_length_arr (I);
            END LOOP;

            IF l_length_LEFT <> 0
            THEN
                --if there is an extra portion left over due to rounding then add this onto
                --the last element so that the total length will be correct
                l_ne_length_arr (l_ne_length_arr.COUNT) :=
                    nm3unit.get_formatted_value (
                          l_ne_length_arr (l_ne_length_arr.COUNT)
                        + l_length_LEFT,
                        g_datum_units);
            END IF;

            --now recalibrate the datums to the new lengths
            FOR i IN 1 .. L_NE_ID_ARR.COUNT
            LOOP
                IF l_ne_length_arr (i) <> 0
                THEN
                    nm3recal.recalibrate_section (
                        pi_ne_id               => L_NE_ID_ARR (i),
                        pi_begin_mp            => 0,
                        pi_new_length_to_end   => l_ne_length_arr (i));
                END IF;
            END LOOP;

            --rescale the route to updates slks
            rescale_route (
                pi_ne_id =>
                    pi_ne_id,
                pi_effective_date =>
                    TO_DATE (SYS_CONTEXT ('NM3CORE', 'EFFECTIVE_DATE'),
                             'DD-MON-YYYY'),
                pi_offset_st =>
                    0,
                pi_st_element_id =>
                    NULL,
                pi_use_history =>
                    'N',
                pi_ne_start =>
                    pi_ne_start);
        END IF;

        nm_debug.proc_end (p_package_name     => g_package_name,
                           p_procedure_name   => 'resize_route');
    EXCEPTION
        WHEN e_invalid_element
        THEN
            hig.raise_ner (
                pi_appl =>
                    'NET',
                pi_id =>
                    283,
                pi_supplementary_info =>
                       'nm3rsc.resize_route(pi_ne_id = '
                    || TO_CHAR (pi_ne_id)
                    || ')');
        WHEN e_partial
        THEN
            hig.raise_ner (
                pi_appl =>
                    'NET',
                pi_id =>
                    182,
                pi_supplementary_info =>
                       'nm3rsc.resize_route(pi_ne_id = '
                    || TO_CHAR (pi_ne_id)
                    || ')');
    END resize_route;

    --
    -----------------------------------------------------------------------------
    --
    PROCEDURE empty_route_check (p_ne_id            IN     NUMBER,
                                 p_effective_date   IN     DATE,
                                 p_history          IN     VARCHAR2,
                                 p_empty               OUT VARCHAR2)
    IS
        l_dummy   NUMBER;
    BEGIN
        p_empty := 'N';

        SELECT 1
          INTO l_dummy
          FROM nm_rescale_write
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            p_empty := 'Y';

            --  no members, need to remove any spatial representation

            IF p_history = 'Y'
            THEN
                nm3sdm.reshape_route (p_ne_id, p_effective_date, 'Y');
            ELSE
                nm3sdm.reshape_route (p_ne_id, p_effective_date, 'N');
            END IF;
    END;
--
-----------------------------------------------------------------------------
--
END nm3rsc;
/
