create or replace package body lb_nw_cons as
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/lb_nw_cons.pkb-arc   1.0   Jan 31 2019 15:40:26   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_nw_cons.pkb  $
   --       Date into PVCS   : $Date:   Jan 31 2019 15:40:26  $
   --       Date fetched Out : $Modtime:   Jan 31 2019 15:32:52  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_get';

   g_tol                     NUMBER := 0.00000001;

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

   FUNCTION get_aggr_constraint (p_inv_type IN VARCHAR2)
      --, p_nlt_ids in int_array_type )
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (2000) := '1=1';
   BEGIN
      SELECT nvl(LISTAGG (get_constraint (ninc_id), ' AND ')
                WITHIN GROUP (ORDER BY 1), '1=1')
        INTO retval
        FROM (  SELECT ninc_nlt_id,
                       ninc_inv_type,
                       ninc_id,
                       COUNT (*),
                       get_constraint (ninc_id) constraint_list
                  FROM nm_inv_nw_constraints
                 WHERE ninc_inv_type = p_inv_type
              GROUP BY ninc_inv_type, ninc_nlt_id, ninc_id);

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN '1 = 1';
   END;

FUNCTION get_constraint (p_ninc_id IN INTEGER)
   RETURN VARCHAR2
IS
   retval   VARCHAR2 (2000);
BEGIN
   BEGIN
      SELECT    ' case ne_nt_type when '
             || ''''
             || nncc_nw_type
             || ''''
             || ' then '
             || nncc_column_name
             || ' else '
             || ''''
             || '1'
             || ''''
             || ' end = case ne_nt_type when '
             || ''''
             || nncc_nw_type
             || ''''
             || ' then '
             || ''''||nncc_value||''''
             || ' else '
             || ''''
             || '1'
             || ''''
             || ' end '
        INTO retval
        FROM nm_inv_nw_constraints, nm_nw_cons_columns
       WHERE ninc_id = p_ninc_id AND ninc_nnc_id = nncc_nnc_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         retval := ' 1 = 1';
   END;

   RETURN retval;
END;

FUNCTION validate_inv_nw_constraint (
   p_rpt_tab   IN lb_rpt_tab)
   RETURN VARCHAR2
IS
   retval            VARCHAR2 (10);
   l_dummy           INTEGER;
   constraint_code   VARCHAR2 (2000);
   validation_sql    VARCHAR2 (2000);
BEGIN
   BEGIN
      SELECT LISTAGG (get_constraint (ninc_id), ' AND ')
                WITHIN GROUP (ORDER BY 1)
        INTO constraint_code
        FROM (  SELECT ninc_nlt_id,
                       ninc_inv_type,
                       ninc_id,
                       COUNT (*),
                       get_constraint (ninc_id) constraint_list
                  FROM nm_inv_nw_constraints, TABLE (p_rpt_tab) t
                 WHERE     t.obj_type = ninc_inv_type
                       AND t.refnt_type = ninc_nlt_id
              GROUP BY ninc_inv_type, ninc_nlt_id, ninc_id);

      --
      validation_sql :=
            'select 1  from dual '
         || 'where exists ( select 1 from table(:b_rpt_tab) t '
         || 'where not exists ( '
         || ' select ne_id, ne_nt_type '
         || ' from nm_elements, nm_linear_types '
         || ' where t.refnt_type = nlt_id '
         || ' and ne_nt_type = nlt_nt_type '
         || ' and ne_id = t.refnt '
         || ' and '
         || constraint_code
         || '))';
      nm_debug.debug (validation_sql);

      EXECUTE IMMEDIATE validation_sql INTO l_dummy USING p_rpt_tab;

      retval := 'FALSE';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         retval := 'TRUE';
   END;

   RETURN retval;
END;
end;
/
