DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)refresh_merge_views.sql	1.1 04/05/07
--       Module Name      : refresh_merge_views.sql
--       Date into SCCS   : 07/04/05 10:47:38
--       Date fetched Out : 07/06/13 17:07:26
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

--variables
   v_nmf_id nm_mrg_output_file.nmf_id%TYPE;
   v_nmq_id nm_mrg_query_all.nmq_id%TYPE;
   v_nmq_unique nm_mrg_query_all.nmq_unique%TYPE;
   v_compile nm3type.max_varchar2;

--get data for merge views
   CURSOR c1
   IS
      SELECT nmf_id
            ,nmq_id
            ,nmq_unique
      FROM   nm_mrg_output_file
            ,nm_mrg_query_all
      WHERE  nmf_nmq_id(+) = nmq_id;
BEGIN
   OPEN c1;

   LOOP
      FETCH c1
      INTO  v_nmf_id
           ,v_nmq_id
           ,v_nmq_unique;

      EXIT WHEN c1%NOTFOUND;

      -- drop and re-create the merge query view
      BEGIN
         --create view
         nm3mrg_view.build_view (v_nmq_id);
         --build sql to compile view
         v_compile := 'ALTER VIEW V_MRG_' || v_nmq_unique || ' COMPILE';
         --compile it
         execute immediate (v_compile);
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('Could not create view V_MRG_' || v_nmq_unique);
            DBMS_OUTPUT.put_line (SQLERRM);
      END;

      --create the procedure and output view
      BEGIN
         nm3mrg_output.create_procedure (v_nmf_id);
      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.put_line ('Could not create view MRG_OUTPUT_' || v_nmf_id || '_V');
            DBMS_OUTPUT.put_line (SQLERRM);
      END;
   END LOOP;

   CLOSE c1;
END;
/
