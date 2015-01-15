CREATE OR REPLACE PACKAGE BODY lb_load
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_load.pkb-arc   1.2   Jan 15 2015 20:26:58   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_load.pkb  $
--       Date into PVCS   : $Date:   Jan 15 2015 20:26:58  $
--       Date fetched Out : $Modtime:   Jan 15 2015 20:25:54  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   Location Bridge package for loading LRS placements
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   1.2  $';
  
   g_package_name    CONSTANT  varchar2(30)   := 'lb_load';

   --
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

   --
   PROCEDURE lb_load (p_obj_Rpt       IN     lb_RPt_tab,
                      p_start_date    IN     DATE,
                      p_security_id   IN     INTEGER,
                      p_xsp           IN     VARCHAR2,
                      p_loc_error        OUT lb_loc_error_tab);

   --
   FUNCTION validate_xsp_on_RPt_tab (pi_xsp       IN VARCHAR2,
                                     pi_rpt_tab      lb_RPt_tab)
      RETURN lb_loc_error_tab;


   FUNCTION ld_nal (
      p_nal_nit_type     IN nm_asset_locations_all.nal_nit_type%TYPE,
      p_nal_asset_id     IN nm_asset_locations_all.nal_asset_id%TYPE,
      p_nal_descr        IN nm_asset_locations_all.nal_descr%TYPE,
      p_nal_jxp          IN nm_asset_locations_all.nal_jxp%TYPE,
      p_nal_primary      IN nm_asset_locations_all.nal_primary%TYPE,
      p_nal_start_date   IN nm_asset_locations_all.nal_start_date%TYPE,
      p_nal_security     IN nm_asset_locations_all.nal_security_key%TYPE)
      RETURN INTEGER
   IS
      retval   INTEGER;
   BEGIN
      INSERT INTO nm_asset_locations_all (nal_nit_type,
                                          nal_asset_id,
                                          nal_descr,
                                          nal_jxp,
                                          nal_primary,
                                          nal_security_key,
                                          nal_start_date)
           VALUES (p_nal_nit_type,
                   p_nal_asset_id,
                   p_nal_descr,
                   p_nal_jxp,
                   p_nal_primary,
                   p_nal_security,
                   p_nal_start_date)
        RETURNING nal_id
             INTO retval;

      RETURN retval;
   END;

   --
   PROCEDURE lb_ld_RPt (
      pi_nal_id         IN nm_asset_locations_all.nal_id%TYPE,
      pi_nal_nit_type   IN nm_asset_locations_all.nal_nit_type%TYPE,
      pi_refnt          IN v_nm_nlt_refnts.ne_id%TYPE,
      pi_g_i_d          IN v_nm_nlt_data.nlt_g_i_d%TYPE,
      pi_nlt_id         IN v_nm_nlt_refnts.nlt_id%TYPE,
      pi_start_m        IN NUMBER,
      pi_end_m          IN NUMBER,
      pi_unit           IN nm_units.un_unit_id%TYPE,
      pi_xsp            IN VARCHAR2,
      pi_start_date     IN nm_asset_locations_all.nal_start_date%TYPE,
      pi_security_id    IN nm_asset_locations_all.nal_security_key%TYPE)
   IS
      loc_error    lb_loc_error_tab;
      l_g_i_d      VARCHAR2 (1);
      l_load_tab   lb_rpt_tab;
   BEGIN
      --
      IF pi_g_i_d IS NULL
      THEN
         SELECT nlt_g_i_d
           INTO l_g_i_d
           FROM nm_linear_types
          WHERE nlt_id = pi_nlt_id;
      ELSE
         l_g_i_d := pi_g_i_d;
      END IF;

      --
      IF l_g_i_d = 'D'
      THEN
         lb_load (lb_ops.merge_lb_rpt_tab (pi_nal_id,
                                           pi_nal_nit_type,
                                           LB_RPT_TAB (LB_RPt (pi_refnt,
                                                               pi_nlt_id,
                                                               NULL,
                                                               NULL,
                                                               NULL,
                                                               NULL,
                                                               1,
                                                               pi_start_m,
                                                               pi_end_m,
                                                               pi_unit)),
                                           10),
                  pi_start_date,
                  pi_security_id,
                  pi_xsp,
                  loc_error);
      ELSE
         lb_load (lb_ops.merge_lb_rpt_tab (
                     pi_nal_id,
                     pi_nal_nit_type,
                     get_lb_rpt_d_tab (LB_RPT_TAB (LB_RPt (pi_refnt,
                                                           pi_nlt_id,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           NULL,
                                                           1,
                                                           pi_start_m,
                                                           pi_end_m,
                                                           pi_unit))),
                     10),
                  pi_start_date,
                  pi_security_id,
                  pi_xsp,
                  loc_error);
      END IF;
   END;

   --
   PROCEDURE lb_load (p_obj_Rpt       IN     lb_RPt_tab,
                      p_start_date    IN     DATE,
                      p_security_id   IN     INTEGER,
                      p_xsp           IN     VARCHAR2,
                      p_loc_error        OUT lb_loc_error_tab)
   IS
      l_loc_tab   int_array_type;
      l_err_tab   lb_loc_error_tab;
   BEGIN
      l_err_tab := validate_xsp_on_RPt_tab(PI_XSP => p_xsp, PI_RPT_TAB => p_obj_Rpt );
      if l_err_tab.count is not null and l_err_tab.count > 0 then
--        if l_err_tab(1).error_code is not null then 
           raise_application_error(-20001, 'XSP is invalid - count = '||l_err_tab.count);
--        end if;
      end if;
      
      declare
        problem varchar2(7) := NULL;
      begin
         select 'Problem' into problem from nm_inv_types 
         where exists ( select 1 from table (p_obj_Rpt) t
                        where start_m != end_m
                        and t.obj_type = nit_inv_type
                        and nit_pnt_or_cont = 'P' );
         raise_application_error ( -20002, 'Asset type has a point reference - line events not allowed' );
      exception
        when no_data_found then
          NULL;
      end;                                            

      
      FORALL i IN 1 .. p_obj_Rpt.COUNT
         INSERT INTO nm_locations_all (nm_ne_id_of,
                                       nm_obj_type,
                                       nm_ne_id_in,
                                       nm_begin_mp,
                                       nm_start_date,
                                       nm_end_mp,
                                       nm_type,
                                       nm_security_id,
                                       nm_x_sect_st,
                                       nm_x_sect_end,
                                       nm_dir_flag,
                                       nm_nlt_id,
                                       nm_offset_st,
                                       nm_offset_end
                                       )
                 VALUES (
                           p_obj_Rpt (i).refnt,
                           p_obj_Rpt (i).obj_type,
                           p_obj_Rpt (i).obj_id,
                           p_obj_Rpt (i).start_m,
                           p_start_date,
                           p_obj_Rpt (i).end_m,
                           'I',
                           (select case lb_security_type
                                when 'INHERIT' then 
                                  ( select ne_admin_unit from nm_elements where ne_id = p_obj_Rpt (i).refnt )
                                 else p_security_id                                 
                                 end
                                 from LB_INV_SECURITY where lb_exor_inv_type = p_obj_Rpt (i).obj_type ),
                           p_xsp,
                           p_xsp,
                           p_obj_Rpt (i).dir_flag,
                           p_obj_Rpt (i).refnt_type,
                           (SELECT nwx_offset * p_obj_Rpt (i).dir_flag
                              FROM nm_nw_xsp, nm_elements
                             WHERE     nwx_nw_type = ne_nt_type
                                   AND ne_id = p_obj_Rpt (i).refnt
                                   AND nwx_x_sect = p_xsp
                                   AND nwx_nsc_sub_class = ne_sub_class
                            UNION ALL
                            SELECT nwx_offset * p_obj_Rpt (i).dir_flag
                              FROM nm_members,
                                   nm_elements,
                                   nm_nt_groupings,
                                   nm_linear_types,
                                   nm_nw_xsp
                             WHERE     ne_id = nm_ne_id_in
                                   AND nm_ne_id_of = p_obj_Rpt (i).refnt
                                   AND nm_type = 'G'
                                   AND nng_group_type = nm_obj_type
                                   AND nng_nt_type = nlt_nt_type
                                   AND nlt_id = p_obj_Rpt (i).refnt_type
                                   AND nwx_nw_type = ne_nt_type
                                   AND nwx_x_sect = p_xsp
                                   AND nwx_nsc_sub_class = ne_sub_class),
                           (SELECT nwx_offset * p_obj_Rpt (i).dir_flag
                              FROM nm_nw_xsp, nm_elements
                             WHERE     nwx_nw_type = ne_nt_type
                                   AND ne_id = p_obj_Rpt (i).refnt
                                   AND nwx_x_sect = p_xsp
                                   AND nwx_nsc_sub_class = ne_sub_class))
           RETURNING nm_loc_id
                BULK COLLECT INTO l_loc_tab;

      --      FOR i IN 1 .. l_loc_tab.COUNT
      --      LOOP
      --         DBMS_OUTPUT.put_line ('ID  ' || TO_CHAR (l_loc_tab (i)));
      --      END LOOP;

      --
      INSERT INTO nm_location_geometry (nlg_loc_id,
                                        nlg_obj_type,
                                        nlg_geometry)
         SELECT nm_loc_id,
                nm_obj_type,
                SDO_LRS.OFFSET_GEOM_SEGMENT (geoloc,
                                             nm_begin_mp,
                                             nm_end_mp,
                                             NVL (nm_offset_st, 0),
                                             0.005)
           FROM nm_locations_all, v_lb_nlt_geometry
          WHERE     nm_ne_id_of = ne_id
                AND nm_loc_id IN (SELECT t.COLUMN_VALUE
                                    FROM TABLE (l_loc_tab) t);
   END;

   PROCEDURE delete_asset_location (
      pi_nal_asset_id   IN INTEGER,
      pi_nal_nit_type   IN VARCHAR2,
      pi_nal_jxp        IN VARCHAR2 DEFAULT NULL)
   IS
   BEGIN
      DELETE FROM nm_location_geometry
            WHERE EXISTS
                     (SELECT 1
                        FROM nm_asset_locations_all, nm_locations_all
                       WHERE     nal_asset_id = pi_nal_asset_id
                             AND nal_id = nm_ne_id_in
                             AND nal_nit_type = nm_obj_type
                             AND nal_nit_type = pi_nal_nit_type
                             AND nlg_loc_id = nm_loc_id
                             AND DECODE (pi_nal_jxp,
                                         NULL, '&^%$',
                                         pi_nal_jxp) =
                                    DECODE (pi_nal_jxp,
                                            NULL, '&^%$',
                                            nal_jxp));

      DELETE FROM nm_locations_all
            WHERE EXISTS
                     (SELECT 1
                        FROM nm_asset_locations_all
                       WHERE     nal_asset_id = pi_nal_asset_id
                             AND nal_id = nm_ne_id_in
                             AND nal_nit_type = nm_obj_type
                             AND nal_nit_type = pi_nal_nit_type
                             AND DECODE (pi_nal_jxp,
                                         NULL, '&^%$',
                                         pi_nal_jxp) =
                                    DECODE (pi_nal_jxp,
                                            NULL, '&^%$',
                                            nal_jxp));

      DELETE FROM nm_asset_locations_all
            WHERE     nal_asset_id = pi_nal_asset_id
                  AND nal_nit_type = pi_nal_nit_type
                  AND DECODE (pi_nal_jxp, NULL, '&^%$', pi_nal_jxp) =
                         DECODE (pi_nal_jxp, NULL, '&^%$', nal_jxp);
   END;

   PROCEDURE delete_location (pi_nal_id IN INTEGER)
   IS
   BEGIN
      DELETE FROM nm_location_geometry
            WHERE EXISTS
                     (SELECT 1
                        FROM nm_asset_locations_all, nm_locations_all
                       WHERE     nal_id = pi_nal_id
                             AND nal_id = nm_ne_id_in
                             AND nal_nit_type = nm_obj_type
                             AND nlg_loc_id = nm_loc_id);


      DELETE FROM nm_locations_all
            WHERE EXISTS
                     (SELECT 1
                        FROM nm_asset_locations_all
                       WHERE     nal_id = pi_nal_id
                             AND nal_id = nm_ne_id_in
                             AND nal_nit_type = nm_obj_type);
   END;


   PROCEDURE close_asset_location (
      pi_nal_asset_id   IN INTEGER,
      pi_nal_nit_type   IN VARCHAR2,
      pi_end_date       IN DATE,
      pi_nal_jxp        IN VARCHAR2 DEFAULT NULL)
   IS
   BEGIN
      UPDATE nm_locations_all
         SET nm_end_date = pi_end_date
       WHERE EXISTS
                (SELECT 1
                   FROM nm_asset_locations_all
                  WHERE     nal_asset_id = pi_nal_asset_id
                        AND nal_id = nm_ne_id_in
                        AND nal_nit_type = nm_obj_type
                        AND nal_nit_type = pi_nal_nit_type
                        AND DECODE (pi_nal_jxp, NULL, '&^%$', pi_nal_jxp) =
                               DECODE (pi_nal_jxp, NULL, '&^%$', nal_jxp));

      UPDATE nm_asset_locations_all
         SET nal_end_date = pi_end_date
       WHERE     nal_asset_id = pi_nal_asset_id
             AND nal_nit_type = pi_nal_nit_type
             AND DECODE (pi_nal_jxp, NULL, '&^%$', pi_nal_jxp) =
                    DECODE (pi_nal_jxp, NULL, '&^%$', nal_jxp);
   END;

   PROCEDURE close_location (pi_nal_id IN INTEGER, pi_end_date IN DATE)
   IS
   BEGIN
      UPDATE nm_locations_all
         SET nm_end_date = pi_end_date
       WHERE EXISTS
                (SELECT 1
                   FROM nm_asset_locations_all
                  WHERE     nal_id = pi_nal_id
                        AND nal_id = nm_ne_id_in
                        AND nal_nit_type = nm_obj_type);
   END;

   --

   FUNCTION validate_xsp_on_RPt_tab (pi_xsp       IN VARCHAR2,
                                     pi_rpt_tab      lb_RPt_tab --, return_code OUT integer
                                                               )
      RETURN lb_loc_error_tab
   AS
      retval   lb_loc_error_tab;
   BEGIN
      SELECT CAST (
                COLLECT (lb_loc_error (refnt, -99, 'No XSP Value')) AS lb_loc_error_tab)
        INTO retval
        FROM TABLE (pi_rpt_tab)
       WHERE     NOT EXISTS
                        (SELECT 1
                           FROM nm_elements, xsp_restraints
                          WHERE     ne_id = refnt
                                AND ne_sub_class = xsr_scl_class
                                AND obj_type = xsr_ity_inv_code
                                AND xsr_nw_type = ne_nt_type
                                AND xsr_x_sect_value = pi_xsp)
             AND NOT EXISTS
                        (SELECT 1
                           FROM nm_elements, xsp_restraints, nm_members
                          WHERE     nm_ne_id_of = refnt
                                AND nm_ne_id_in = ne_id
                                AND ne_sub_class = xsr_scl_class
                                AND obj_type = xsr_ity_inv_code
                                AND xsr_nw_type = ne_nt_type
                                AND xsr_x_sect_value = pi_xsp)
             AND exists ( select 1 from nm_inv_types
                          where nit_inv_type = obj_type
                          and nit_x_sect_allow_flag = 'Y'
                          and pi_xsp is not null ) ;  

      --  if retval.count >0 then
      --    return_code := 0;
      --  end if;
      RETURN retval;
   EXCEPTION
      WHEN OTHERS
      THEN
         --    return_code := 1;
         raise_application_error (-20001, 'Problem in XSP validation');
   END;
--
                                      
END lb_load;
/