CREATE OR REPLACE PACKAGE BODY lb_seg
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_seg.pkb-arc   1.0   Jan 15 2015 22:56:42   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_seg.pkb  $
   --       Date into PVCS   : $Date:   Jan 15 2015 22:56:42  $
   --       Date fetched Out : $Modtime:   Jan 15 2015 22:56:20  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for network segmentation
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_seg';

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

   PROCEDURE set_fixed_length_seg (pi_nlt_type in integer,
                                   pi_ne_id                  IN INTEGER,
                                   pi_fixed_length           IN NUMBER,
                                   pi_fixed_length_unit_id   IN INTEGER)
   AS
   l_length NUMBER;
   BEGIN
      select pi_fixed_length*nvl(uc_conversion_factor, 1) 
      into l_length
      from nm_unit_conversions, nm_linear_types 
      where nlt_id = pi_nlt_type
      and uc_unit_id_in (+) = pi_fixed_length_unit_id
      and uc_unit_id_out (+) = nlt_units;
--      
      nm3ctx.set_context ('NLT_DATA_NLT_ID', to_char(pi_nlt_type));
      nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (pi_ne_id));
      nm3ctx.set_context ('NLT_FIXED_LENGTH', TO_CHAR (l_length));
      nm3ctx.set_context ('NLT_FIXED_LENGTH_UNIT_ID', TO_CHAR (pi_fixed_length_unit_id));
   END;

   --

   FUNCTION get_nth_fixed_length_seg (pi_N IN INTEGER)
      RETURN lb_rpt_tab
   IS
      retval   lb_RPT_tab;
   BEGIN
      SELECT lb_seg_tab
        INTO retval
        FROM v_lb_seg_fixed_lengths
       WHERE seg_part_id = pi_N;

      RETURN retval;
   END;

   --
   FUNCTION get_random_fixed_length_seg
      RETURN lb_rpt_tab
   IS
      retval   lb_rpt_tab;
   BEGIN
      RETURN retval;
   END;
END;
/
