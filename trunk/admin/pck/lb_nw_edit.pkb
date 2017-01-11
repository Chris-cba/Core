CREATE OR REPLACE PACKAGE BODY EXOR.lb_nw_edit
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_nw_edit.pkb-arc   1.0   Jan 11 2017 18:00:26   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_nw_edit.pkb  $
   --       Date into PVCS   : $Date:   Jan 11 2017 18:00:26  $
   --       Date fetched Out : $Modtime:   Jan 11 2017 17:59:00  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Network Edit package - performing updates to linear locations during network changes
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_get';
   
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
   
   PROCEDURE generate_datum_geoms (p_transaction_id   IN INTEGER,
                                   p_ne1              IN INTEGER,
                                   p_ne2              IN INTEGER);

   PROCEDURE lb_unsplit (p_edit_tab lb_edit_transaction_tab);

   PROCEDURE lb_unmerge (p_edit_tab lb_edit_transaction_tab);

   PROCEDURE lb_unreplace (p_edit_tab lb_edit_transaction_tab);

   PROCEDURE lb_unclose (p_edit_tab lb_edit_transaction_tab);

   PROCEDURE close_current (p_ne1              IN INTEGER,
                            p_ne2              IN INTEGER,
                            p_transaction_id   IN INTEGER,
                            p_effective_date   IN DATE);

   PROCEDURE delete_current (p_edit_tab lb_edit_transaction_tab);

   PROCEDURE reinstate (p_edit_tab lb_edit_transaction_tab);

  PROCEDURE check_forward_dates( p_ne in INTEGER, p_effective_date in date );

  PROCEDURE check_overhangs( p_ne in INTEGER, p_start_m in number, p_shift_m in number, p_effective_date in date, p_length in number );
   
   --
   PROCEDURE lb_split (p_ne               IN INTEGER,
                       p_split_m          IN NUMBER,
                       p_ne1              IN INTEGER,
                       p_ne2              IN INTEGER,
                       p_effective_date   IN DATE,
                       p_transaction_id   IN INTEGER)
   IS
   BEGIN
      nm_debug.debug ('close original locations');

      close_current (p_ne,
                     NULL,
                     p_transaction_id,
                     p_effective_date);

      nm_debug.debug ('insert new locations');

      INSERT INTO nm_locations_all (nm_ne_id_of,
                                    nm_obj_type,
                                    nm_ne_id_in,
                                    nm_begin_mp,
                                    nm_end_mp,
                                    nm_start_date,
                                    nm_end_date,
                                    nm_type,
                                    nm_dir_flag,
                                    nm_seq_no,
                                    nm_seg_no,
                                    nm_x_sect_st,
                                    nm_offset_st,
                                    transaction_id,
                                    nm_x_sect_end,
                                    nm_offset_end,
                                    nm_nlt_id)
         SELECT CASE WHEN nm_begin_mp < p_split_m THEN p_ne1 ELSE p_ne2 END,
                nm_obj_type,
                nm_ne_id_in,
                CASE
                   WHEN nm_begin_mp < p_split_m THEN nm_begin_mp
                   ELSE nm_begin_mp - p_split_m
                END,
                CASE
                   WHEN nm_end_mp < p_split_m
                   THEN
                      nm_end_mp
                   ELSE
                      CASE
                         WHEN nm_begin_mp < p_split_m THEN p_split_m
                         ELSE nm_end_mp - p_split_m
                      END
                END
                   END,
                p_effective_date,
                NULL,
                nm_type,
                nm_dir_flag,
                nm_seq_no,
                nm_seg_no,
                nm_x_sect_st,
                nm_offset_st,
                p_transaction_id,
                nm_x_sect_end,
                nm_offset_end,
                nm_nlt_id
           FROM nm_locations_all
          WHERE     nm_ne_id_of = p_ne
                AND transaction_id = p_transaction_id
                AND nm_end_date = p_effective_date
         UNION ALL
         SELECT p_ne2,
                nm_obj_type,
                nm_ne_id_in,
                0,
                nm_end_mp - p_split_m,
                p_effective_date,
                NULL,
                nm_type,
                nm_dir_flag,
                nm_seq_no,
                nm_seg_no,
                nm_x_sect_st,
                nm_offset_st,
                p_transaction_id,
                nm_x_sect_end,
                nm_offset_end,
                nm_nlt_id
           FROM nm_locations_all
          WHERE     nm_ne_id_of = p_ne
                AND nm_begin_mp < p_split_m
                AND nm_end_mp > p_split_m
                AND transaction_id = p_transaction_id
                AND nm_end_date = p_effective_date;

      nm_debug.debug ('insert geoms');

      generate_datum_geoms (p_transaction_id   => p_transaction_id,
                            p_ne1              => p_ne1,
                            p_ne2              => p_ne2);

      nm_debug.debug ('end of lb_split procedure');
   END;

   PROCEDURE lb_merge (p_ne1              IN INTEGER,
                       p_ne2              IN INTEGER,
                       p_ne               IN INTEGER,
                       p_effective_date   IN DATE,
                       p_transaction_id   IN INTEGER)
   IS
   BEGIN
      nm_debug.debug ('close original locations');

      close_current (p_ne1,
                     p_ne2,
                     p_transaction_id,
                     p_effective_date);


      UPDATE nm_locations_all
         SET nm_end_date = p_effective_date,
             transaction_id = p_transaction_id,
             nm_status = 1
       WHERE nm_ne_id_of IN (p_ne1, p_ne2) AND nm_end_date IS NULL;

      nm_debug.debug ('insert new locations');

      INSERT INTO nm_locations_all (nm_loc_id,
                                    nm_ne_id_in,
                                    nm_obj_type,
                                    nm_ne_id_of,
                                    nm_type,
                                    nm_begin_mp,
                                    nm_start_date,
                                    nm_end_date,
                                    nm_end_mp,
                                    nm_dir_flag,
                                    nm_seq_no,
                                    nm_seg_no,
                                    nm_x_sect_st,
                                    nm_x_sect_end,
                                    nm_offset_st,
                                    nm_offset_end,
                                    transaction_id,
                                    nm_nlt_id)
         SELECT nm_loc_id_seq.NEXTVAL,
                inv_id,
                inv_type,
                p_ne,
                'I',
                new_inv_start,
                p_effective_date,
                NULL,
                new_inv_end,
                new_direction,
                orderby,
                1,
                nm_x_sect_st,
                nm_x_sect_end,
                nm_offset_st,
                nm_offset_end,
                p_transaction_id,
                nm_nlt_id
           FROM (SELECT t5.*,
                        CASE
                           WHEN orderby = 1
                           THEN
                              CASE relative_dir
                                 WHEN 1 THEN inv_start
                                 ELSE ne_length - inv_end + next_ne_length
                              END
                           ELSE
                              CASE
                                 WHEN prior_dir_flag = 1
                                 THEN
                                    CASE relative_dir
                                       WHEN 1
                                       THEN
                                          inv_start + prior_ne_length
                                       ELSE
                                            ne_length
                                          - inv_end
                                          + next_ne_length
                                    END
                                 ELSE
                                    CASE relative_dir
                                       WHEN 1 THEN ne_length - inv_end
                                       ELSE inv_start
                                    END
                              END
                        END
                           new_inv_start,
                        CASE
                           WHEN orderby = 1
                           THEN
                              CASE relative_dir
                                 WHEN 1 THEN inv_end
                                 ELSE ne_length - inv_start + next_ne_length
                              END
                           ELSE
                              CASE
                                 WHEN prior_dir_flag = 1
                                 THEN
                                    CASE relative_dir
                                       WHEN 1
                                       THEN
                                          inv_end + prior_ne_length
                                       ELSE
                                            ne_length
                                          - inv_start
                                          + prior_ne_length
                                    END
                                 ELSE
                                    CASE relative_dir
                                       WHEN 1 THEN ne_length - inv_start
                                       ELSE inv_end
                                    END
                              END
                        END
                           new_inv_end,
                        CASE
                           WHEN orderby = 1 THEN relative_dir
                           ELSE relative_dir * prior_dir_flag
                        END
                           new_direction,
                        CASE
                           WHEN orderby = 1
                           THEN
                              CASE relative_dir
                                 WHEN 1 THEN nm_offset_st
                                 ELSE nm_offset_end
                              END
                           ELSE
                              CASE
                                 WHEN prior_dir_flag = 1
                                 THEN
                                    CASE relative_dir
                                       WHEN 1 THEN nm_offset_st
                                       ELSE nm_offset_end
                                    END
                                 ELSE
                                    CASE relative_dir
                                       WHEN 1 THEN nm_offset_st
                                       ELSE nm_offset_end
                                    END
                              END
                        END
                           new_offset_st,
                        CASE
                           WHEN orderby = 1
                           THEN
                              CASE relative_dir
                                 WHEN 1 THEN nm_offset_end
                                 ELSE nm_offset_st
                              END
                           ELSE
                              CASE
                                 WHEN prior_dir_flag = 1
                                 THEN
                                    CASE relative_dir
                                       WHEN 1 THEN nm_offset_end
                                       ELSE nm_offset_st
                                    END
                                 ELSE
                                    CASE relative_dir
                                       WHEN 1 THEN nm_offset_end
                                       ELSE nm_offset_st
                                    END
                              END
                        END
                           new_offset_end
                   FROM (WITH ne_data
                              AS (SELECT orderby,
                                         ne_id,
                                         ne_unique,
                                         ne_no_start,
                                         ne_no_end,
                                         ne_length,
                                         relative_dir
                                    FROM (SELECT t1.*,
                                                 CASE orderby
                                                    WHEN 1
                                                    THEN
                                                       CASE ne_no_start
                                                          WHEN next_start_node
                                                          THEN
                                                             -1
                                                          WHEN next_end_node
                                                          THEN
                                                             -1
                                                          ELSE
                                                             CASE ne_no_end
                                                                WHEN next_start_node
                                                                THEN
                                                                   1
                                                                WHEN next_end_node
                                                                THEN
                                                                   1
                                                                ELSE
                                                                   99
                                                             END
                                                       END
                                                    ELSE
                                                       CASE ne_no_start
                                                          WHEN prior_start_node
                                                          THEN
                                                             1
                                                          WHEN prior_end_node
                                                          THEN
                                                             1
                                                          ELSE
                                                             CASE ne_no_end
                                                                WHEN prior_start_node
                                                                THEN
                                                                   -1
                                                                WHEN prior_end_node
                                                                THEN
                                                                   -1
                                                                ELSE
                                                                   99
                                                             END
                                                       END
                                                 END
                                                    relative_dir
                                            FROM (SELECT ne_id,
                                                         ne_no_start,
                                                         ne_no_end,
                                                         ne_length,
                                                         ne_unique,
                                                         orderby,
                                                         LEAD (
                                                            ne_no_start,
                                                            1)
                                                         OVER (
                                                            ORDER BY orderby)
                                                            next_start_node,
                                                         LEAD (
                                                            ne_no_end,
                                                            1)
                                                         OVER (
                                                            ORDER BY orderby)
                                                            next_end_node,
                                                         LAG (
                                                            ne_no_start,
                                                            1)
                                                         OVER (
                                                            ORDER BY orderby)
                                                            prior_start_node,
                                                         LAG (
                                                            ne_no_end,
                                                            1)
                                                         OVER (
                                                            ORDER BY orderby)
                                                            prior_end_node
                                                    FROM (SELECT ne_id,
                                                                 ne_no_start,
                                                                 ne_no_end,
                                                                 ne_length,
                                                                 ne_unique,
                                                                 CASE ne_id
                                                                    WHEN p_ne1
                                                                    THEN
                                                                       1
                                                                    ELSE
                                                                       2
                                                                 END
                                                                    orderby
                                                            FROM nm_elements
                                                           WHERE ne_id IN
                                                                    (p_ne1,
                                                                     p_ne2)))
                                                 t1))
                         SELECT t4.*,
                                CASE
                                   WHEN     prior_node = start_node
                                        AND CASE prior_dir_flag
                                               WHEN 1 THEN prior_inv_end
                                               ELSE prior_inv_start
                                            END =
                                               CASE prior_dir_flag
                                                  WHEN 1 THEN prior_ne_length
                                                  ELSE 0
                                               END
                                        AND CASE relative_dir
                                               WHEN 1 THEN inv_start
                                               ELSE inv_end
                                            END =
                                               CASE relative_dir
                                                  WHEN 1 THEN 0
                                                  ELSE ne_length
                                               END
                                   THEN
                                      1
                                   ELSE
                                      -1
                                END
                                   cnct
                           FROM (SELECT t3.*,
                                        SUM (ne_length)
                                           OVER (PARTITION BY inv_id)
                                           new_length,
                                        LAG (
                                           ne_id,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby, inv_start)
                                           prior_ne_id,
                                        LAG (
                                           end_node,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           prior_node,
                                        LAG (
                                           ne_length,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           prior_ne_length,
                                        LAG (
                                           inv_start,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           prior_inv_start,
                                        LAG (
                                           inv_end,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           prior_inv_end,
                                        LAG (
                                           relative_dir,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           prior_dir_flag,
                                        LEAD (
                                           ne_length,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           next_ne_length,
                                        LEAD (
                                           inv_start,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           next_inv_start,
                                        LEAD (
                                           inv_end,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           next_inv_end,
                                        LEAD (
                                           relative_dir,
                                           1)
                                        OVER (PARTITION BY inv_id
                                              ORDER BY orderby)
                                           next_dir_flag
                                   FROM (SELECT t2.*,
                                                CASE relative_dir
                                                   WHEN 1 THEN ne_no_start
                                                   ELSE ne_no_end
                                                END
                                                   start_node,
                                                CASE relative_dir
                                                   WHEN -1 THEN ne_no_start
                                                   ELSE ne_no_end
                                                END
                                                   end_node
                                           FROM (SELECT t1.*
                                                   FROM (  SELECT i.nm_ne_id_in
                                                                     inv_id,
                                                                  i.nm_obj_type
                                                                     inv_type,
                                                                  i.nm_begin_mp
                                                                     inv_start,
                                                                  i.nm_end_mp
                                                                     inv_end,
                                                                  e.ne_id,
                                                                  e.ne_length,
                                                                  e.ne_no_start,
                                                                  e.ne_no_end,
                                                                  e.relative_dir,
                                                                  nm_dir_flag,
                                                                  nm_offset_st,
                                                                  nm_offset_end,
                                                                  nm_x_sect_st,
                                                                  nm_x_sect_end,
                                                                  nm_nlt_id,
                                                                  COUNT (
                                                                     *)
                                                                  OVER (
                                                                     PARTITION BY i.nm_ne_id_in)
                                                                     ic,
                                                                  orderby
                                                             FROM nm_locations_all
                                                                  i,
                                                                  ne_data e
                                                            WHERE     e.ne_id =
                                                                         i.nm_ne_id_of
                                                                  AND i.nm_type =
                                                                         'I'
                                                                  --                                                 AND i.nm_ne_id_in = 1268208
                                                                  AND i.nm_ne_id_of =
                                                                         e.ne_id
                                                                  AND nm_end_date
                                                                         IS NULL
                                                         ORDER BY orderby) t1)
                                                t2) t3) t4) t5) t6;

      --
      nm_debug.debug ('insert geoms');

      generate_datum_geoms (p_transaction_id   => p_transaction_id,
                            p_ne1              => p_ne,
                            p_ne2              => NULL);

      nm_debug.debug ('end of lb_split procedure');
   END;

   PROCEDURE lb_replace (p_ne1              IN INTEGER,
                         p_ne2              IN INTEGER,
                         p_effective_date   IN DATE,
                         p_transaction_id   IN INTEGER)
   IS
   BEGIN
      close_current (p_ne1,
                     NULL,
                     p_transaction_id,
                     p_effective_date);

      INSERT INTO nm_locations_all (nm_ne_id_of,
                                    nm_obj_type,
                                    nm_ne_id_in,
                                    nm_begin_mp,
                                    nm_end_mp,
                                    nm_start_date,
                                    nm_end_date,
                                    nm_type,
                                    nm_dir_flag,
                                    nm_seq_no,
                                    nm_seg_no,
                                    nm_x_sect_st,
                                    nm_offset_st,
                                    transaction_id,
                                    nm_x_sect_end,
                                    nm_offset_end,
                                    nm_nlt_id)
         SELECT p_ne2,
                nm_obj_type,
                nm_ne_id_in,
                nm_begin_mp,
                nm_end_mp,
                p_effective_date,
                NULL,
                nm_type,
                nm_dir_flag,
                nm_seq_no,
                nm_seg_no,
                nm_x_sect_st,
                nm_offset_st,
                p_transaction_id,
                nm_x_sect_end,
                nm_offset_end,
                nm_nlt_id
           FROM nm_locations_all
          WHERE     nm_ne_id_of = p_ne1
                AND transaction_id = p_transaction_id
                AND nm_end_date = p_effective_date;

      generate_datum_geoms (p_transaction_id   => p_transaction_id,
                            p_ne1              => p_ne2,
                            p_ne2              => NULL);
   END;


   PROCEDURE lb_recalibrate (p_ne_id_of            IN NUMBER,
                             p_original_length     IN NUMBER,
                             p_start_m             IN NUMBER,
                             p_new_length_to_end   IN NUMBER,
                             p_transaction_id      IN INTEGER)
   AS
   BEGIN
      UPDATE nm_locations_all
         SET nm_begin_mp =
                LEAST (
                   ROUND (
                      CASE
                         WHEN nm_begin_mp >= p_start_m
                         THEN
                              p_start_m
                            +   (nm_begin_mp - p_start_m)
                              * (  p_new_length_to_end
                                 / (p_original_length - p_start_m))
                         ELSE
                            nm_begin_mp
                      END,
                      3),
                   p_start_m + p_new_length_to_end),
             nm_end_mp =
                LEAST (
                   ROUND (
                      CASE
                         WHEN nm_end_mp >= p_start_m
                         THEN
                              p_start_m
                            +   (nm_end_mp - p_start_m)
                              * (  p_new_length_to_end
                                 / (p_original_length - p_start_m))
                         ELSE
                            nm_end_mp
                      END,
                      3),
                   p_start_m + p_new_length_to_end),
             transaction_id = p_transaction_id
       WHERE nm_ne_id_of = p_ne_id_of;
   END;

   PROCEDURE lb_shift (p_ne               IN INTEGER,
                       p_start_m          IN NUMBER,
                       p_shift_m          IN NUMBER,
                       p_length           IN NUMBER,
                       p_transaction_id   IN INTEGER)
   IS
   l_dummy integer := 0;
   BEGIN
      BEGIN
      select 1 into l_dummy --'Problem in LB Shift - Operation results in measure greater than element length'
      from nm_locations_all
      where ( (nm_end_mp + p_shift_m > p_length and nm_end_mp > p_start_m )
      OR    (nm_begin_mp + p_shift_m > p_length and nm_end_mp > p_start_m))
      and nm_ne_id_of = p_ne;

      if l_dummy = 1 then
        raise_application_error(  -20056, 'Shift causes overhang of LB data at end of element');
      end if;
      EXCEPTION
        WHEN NO_DATA_FOUND then
          NULL;
      END;
       
      l_dummy := 0;
      
      BEGIN
      select 1 into l_dummy --'Problem in LB Shift - Operation results in measure greater than element length'
      from nm_locations_all
      where nm_begin_mp + p_shift_m < 0
      and nm_ne_id_of = p_ne;

      if l_dummy = 1 then
        raise_application_error(  -20056, 'Shift causes overhang of LB data at beginning of element');
      end if;
      EXCEPTION
        WHEN NO_DATA_FOUND then
          NULL;
      END;

      update nm_locations_all
      set nm_begin_mp = case when nm_begin_mp <= p_start_m then nm_begin_mp
                             when nm_begin_mp = 0 and nm_end_mp > 0 then nm_begin_mp
                             when nm_begin_mp = p_length then nm_begin_mp
                             else case when nm_begin_mp >  p_start_m then nm_begin_mp + p_shift_m
                                       else nm_begin_mp
                                  end
                        end,
          nm_end_mp = case when nm_end_mp <= p_start_m then nm_end_mp
                             when nm_end_mp = p_length then nm_end_mp
                             else case when nm_end_mp >  p_start_m then nm_end_mp + p_shift_m
                                       else nm_end_mp
                                  end
                        end,
          transaction_id = p_transaction_id
      where nm_ne_id_of = p_ne;                                         
   END;


   PROCEDURE lb_close (p_ne               IN INTEGER,
                       p_effective_date   IN DATE,
                       p_transaction_id   IN INTEGER)
   IS
   BEGIN
      NULL;
   END;

   PROCEDURE lb_undo (p_neh_id IN INTEGER)
   IS
      l_transaction_id   INTEGER;
   BEGIN
      SELECT transaction_id
        INTO l_transaction_id
        FROM lb_element_history
       WHERE neh_id = p_neh_id;

      lb_undo (p_transaction_id => l_transaction_id);
   END;

   --

   PROCEDURE lb_undo (p_ne_id IN INTEGER)
   IS
      l_transaction_id   INTEGER;
   BEGIN
      SELECT transaction_id
        INTO l_transaction_id
        FROM lb_element_history l, nm_element_history e
       WHERE e.neh_id = l.neh_id AND e.neh_ne_id_new = p_ne_id;

      lb_undo (p_transaction_id => l_transaction_id);
   END;

   --

   PROCEDURE lb_undo (p_transaction_id IN INTEGER)
   IS
      l_edit_tab   lb_edit_transaction_tab;
   BEGIN
      SELECT CAST (
                COLLECT (lb_edit_transaction (e.neh_id,
                                              neh_ne_id_old,
                                              neh_ne_id_new,
                                              neh_operation,
                                              neh_effective_date,
                                              neh_old_ne_length,
                                              neh_new_ne_length,
                                              neh_param_1,
                                              neh_param_2,
                                              transaction_id,
                                              prior_transaction_id)) AS lb_edit_transaction_tab)
        INTO l_edit_tab
        FROM nm_element_history e, lb_element_history l
       WHERE e.neh_id = l.neh_id AND l.transaction_id = p_transaction_id;

      IF l_edit_tab (1).t_op = c_split
      THEN
         lb_unsplit (l_edit_tab);
      ELSIF l_edit_tab (1).t_op = c_merge
      THEN
         lb_unmerge (l_edit_tab);
      ELSIF l_edit_tab (1).t_op = c_replace
      THEN
         lb_unreplace (l_edit_tab);
      ELSIF l_edit_tab (1).t_op = c_close
      THEN
         lb_unclose (l_edit_tab);
      END IF;
   END;

   PROCEDURE generate_datum_geoms (p_transaction_id   IN INTEGER,
                                   p_ne1              IN INTEGER,
                                   p_ne2              IN INTEGER)
   IS
   BEGIN
      INSERT INTO nm_location_geometry (nlg_location_type,
                                        nlg_nal_id,
                                        nlg_obj_type,
                                        nlg_loc_id,
                                        nlg_geometry)
         SELECT 'N',
                nm_ne_id_in,
                nm_obj_type,
                nm_loc_id,
                SDO_LRS.offset_geom_segment (geoloc,
                                             nm_begin_mp,
                                             nm_end_mp,
                                             nm_offset_st,
                                             0.005)
           FROM nm_locations_all, V_LB_NLT_GEOMETRY
          WHERE     nm_nlt_id = nlt_id
                AND ne_id = nm_ne_id_of
                AND ne_id IN (p_ne1, p_ne2)
                AND transaction_id = p_transaction_id
                AND nm_end_date IS NULL;
   END;

   PROCEDURE lb_unsplit (p_edit_tab lb_edit_transaction_tab)
   IS
   BEGIN
      delete_current (p_edit_tab);
      reinstate (p_edit_tab);
   END;

   PROCEDURE lb_unmerge (p_edit_tab lb_edit_transaction_tab)
   IS
   BEGIN
      delete_current (p_edit_tab);
      reinstate (p_edit_tab);
   END;

   PROCEDURE lb_unreplace (p_edit_tab lb_edit_transaction_tab)
   IS
   BEGIN
      delete_current (p_edit_tab);
      reinstate (p_edit_tab);
   END;

   PROCEDURE lb_unclose (p_edit_tab lb_edit_transaction_tab)
   IS
   BEGIN
      reinstate (p_edit_tab);
   END;

   --

   PROCEDURE close_current (p_ne1              IN INTEGER,
                            p_ne2              IN INTEGER,
                            p_transaction_id   IN INTEGER,
                            p_effective_date   IN DATE)
   IS
   BEGIN
      UPDATE nm_locations_all
         SET nm_end_date = p_effective_date,
             transaction_id = p_transaction_id,
             nm_status = 1
       WHERE nm_ne_id_of IN (p_ne1, p_ne2) AND nm_end_date IS NULL;
   END;


   PROCEDURE delete_current (p_edit_tab lb_edit_transaction_tab)
   IS
   BEGIN
      DELETE FROM nm_location_geometry
            WHERE nlg_loc_id IN
                     (SELECT nm_loc_id
                        FROM nm_locations_all
                       WHERE     nm_end_date IS NULL
                             AND transaction_id IN
                                    (SELECT t.t_id
                                       FROM TABLE (p_edit_tab) t));

      DELETE FROM nm_locations_all
            WHERE     nm_end_date IS NULL
                  AND transaction_id IN (SELECT t.t_id
                                           FROM TABLE (p_edit_tab) t);
   END;

   PROCEDURE reinstate (p_edit_tab lb_edit_transaction_tab)
   IS
   BEGIN
      UPDATE nm_locations_all
         SET nm_end_date = NULL,
             transaction_id =
                (SELECT prior_t_id
                   FROM TABLE (p_edit_tab) t
                  WHERE t_edit_id = transaction_id AND t_new_ne = nm_ne_id_of)
       WHERE transaction_id IN (SELECT t.t_id
                                  FROM TABLE (p_edit_tab) t);
   END;

   PROCEDURE log_transaction (p_transaction_id   IN INTEGER,
                              p_neh_id           IN INTEGER)
   IS
   BEGIN
      INSERT INTO lb_element_history (transaction_id,
                                      neh_id,
                                      prior_transaction_id)
         SELECT p_transaction_id, p_neh_id, l2.transaction_id
           --               e1.neh_id, e1.neh_ne_id_old, e1.neh_ne_id_new, e2.neh_id, e2.neh_ne_id_old, e2.neh_ne_id_new,  l1.transaction_id, l2.transaction_id
           FROM nm_element_history e1,
                lb_element_history l2,
                nm_element_history e2
          WHERE     e1.neh_id = p_neh_id
                AND l2.neh_id(+) = e2.neh_id
                AND e2.neh_ne_id_new(+) = e1.neh_ne_id_old;
   END;

  PROCEDURE check_operation( p_op in VARCHAR2, p_ne in INTEGER, p_start_m in number, p_shift_m in number, p_effective_date in date, p_length in number ) is
  BEGIN
  
    CASE p_op
       when c_split  then
          check_forward_dates( p_ne, p_effective_date );
       when c_merge  then
          check_forward_dates( p_ne, p_effective_date );
       when c_replace then
          check_forward_dates( p_ne, p_effective_date );
       when c_close then
          check_forward_dates( p_ne, p_effective_date );
       when c_undo then
          check_forward_dates( p_ne, p_effective_date );
       when c_shift then
          check_overhangs( p_ne, p_start_m, p_shift_m, p_effective_date, p_length );
       when c_recalibrate then
          check_overhangs( p_ne, p_start_m, p_shift_m, p_effective_date, p_length );
    END CASE;
   
   END;

  PROCEDURE check_forward_dates( p_ne in INTEGER, p_effective_date in date ) is
  l_dummy integer;
  BEGIN
     BEGIN
        select 1 into l_dummy
        from nm_locations_all
        where nm_ne_id_of = p_ne
        and nm_start_date > p_effective_date;
     EXCEPTION
        WHEN NO_DATA_FOUND then NULL;
     END;
     
     if l_dummy = 1 then
       hig.raise_ner( 'NET', 378 );
     end if;

  END;

  PROCEDURE check_overhangs( p_ne in INTEGER, p_start_m in number, p_shift_m in number, p_effective_date in date, p_length in number ) is
  l_dummy integer;
  BEGIN
     BEGIN
      select 1 into l_dummy --'Problem in LB Shift - Operation results in measure greater than element length'
      from nm_locations_all
      where ( (nm_end_mp + p_shift_m > p_length and nm_end_mp > p_start_m )
      OR    (nm_begin_mp + p_shift_m > p_length and nm_end_mp > p_start_m))
      and nm_ne_id_of = p_ne;

      if l_dummy = 1 then
        raise_application_error(  -20056, 'Shift causes overhang of LB data at end of element');
      end if;
      EXCEPTION
        WHEN NO_DATA_FOUND then
          NULL;
      END;
       
      l_dummy := 0;
      
      BEGIN
      select 1 into l_dummy --'Problem in LB Shift - Operation results in measure greater than element length'
      from nm_locations_all
      where nm_begin_mp + p_shift_m < 0
      and nm_ne_id_of = p_ne;

      if l_dummy = 1 then
        raise_application_error(  -20056, 'Shift causes overhang of LB data at beginning of element');
      end if;
      EXCEPTION
        WHEN NO_DATA_FOUND then
          NULL;
      END;
  END;

END;
/
