CREATE OR REPLACE PACKAGE BODY nm3job AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3job.pkb-arc   2.4   Jul 04 2013 16:11:40   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3job.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:11:40  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       PVCS Version     : $Revision:   2.4  $

--       Based on SCCS Version     : 1.19
--
--
--   Author : Jonathan Mills
--
--   NM3 Job Management package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
-- g_body_sccsid is the SCCS ID for the package body

   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.4  $"';
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3job';

  CURSOR cs_remaining_njos(p_njc_job_id nm_job_operations.njo_njc_job_id%TYPE
                          ,p_status     nm_job_operations.njo_status%TYPE
                          ) IS
    SELECT
      njo_id
    FROM
      nm_job_operations
    WHERE
      njo_njc_job_id = p_njc_job_id
    AND
      njo_status = p_status
    ORDER BY
      njo_seq;
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
FUNCTION get_next_njo_id RETURN nm_job_operations.njo_id%TYPE IS

  l_retval nm_job_operations.njo_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_next_njo_id');

  SELECT
    njo_id_seq.NEXTVAL
  INTO
    l_retval
  FROM
    dual;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_next_njo_id');

  RETURN l_retval;

END get_next_njo_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_njc_job_id RETURN nm_job_control.njc_job_id%TYPE IS

  l_retval nm_job_control.njc_job_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_next_njc_job_id');

  SELECT
    njc_job_id_seq.NEXTVAL
  INTO
    l_retval
  FROM
    dual;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_next_njc_job_id');

  RETURN l_retval;

END get_next_njc_job_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_initial_status RETURN nm_job_control.njc_status%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_initial_status');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_initial_status');

  RETURN c_not_started;

END get_initial_status;
--
-----------------------------------------------------------------------------
--
FUNCTION get_njo (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                 ,pi_njo_id         IN nm_job_operations.njo_id%TYPE
                 ) RETURN nm_job_operations%ROWTYPE IS
--
   CURSOR cs_njo (c_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                 ,c_njo_id         IN nm_job_operations.njo_id%TYPE
                 ) IS
   SELECT *
    FROM  nm_job_operations
   WHERE  njo_njc_job_id = c_njo_njc_job_id
    AND   njo_id         = c_njo_id;
--
   l_found  boolean;
   l_retval nm_job_operations%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_njo');
--
   OPEN  cs_njo (pi_njo_njc_job_id,pi_njo_id);
   FETCH cs_njo INTO l_retval;
   l_found := cs_njo%FOUND;
   CLOSE cs_njo;
--
   IF NOT l_found
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 67
                   ,pi_supplementary_info => 'NM_JOB_OPERATIONS:'||pi_njo_njc_job_id||':'||pi_njo_id
                   );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_njo');
--
   RETURN l_retval;
--
END get_njo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_njv (pi_njv_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                     ,pi_njv_njo_id     IN nm_job_operations.njo_id%TYPE
                     ) RETURN tab_rec_njv IS
--
   CURSOR cs_njv (c_njv_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                 ,c_njv_njo_id     IN nm_job_operations.njo_id%TYPE
                 ) IS
   SELECT *
    FROM  nm_job_operation_data_values
   WHERE  njv_njc_job_id = c_njv_njc_job_id
    AND   njv_njo_id     = c_njv_njo_id
   ORDER BY njv_nod_data_item;
--
   l_retval tab_rec_njv;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_njv');
--
   FOR cs_rec IN cs_njv (pi_njv_njc_job_id,pi_njv_njo_id)
    LOOP
      l_retval(cs_njv%rowcount) := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_tab_njv');
--
   RETURN l_retval;
--
END get_tab_njv;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tab_njv (pi_tab_rec_njv tab_rec_njv
                        ,pi_level       pls_integer DEFAULT nm_debug.c_default_level
                        ) IS
BEGIN
--
   FOR i IN 1..pi_tab_rec_njv.COUNT
    LOOP
      nm_debug.DEBUG('njv_nmo_operation('||i||') : '||pi_tab_rec_njv(i).njv_nmo_operation,pi_level);
      nm_debug.DEBUG('njv_nod_data_item('||i||') : '||pi_tab_rec_njv(i).njv_nod_data_item,pi_level);
      nm_debug.DEBUG('njv_value('||i||')         : '||pi_tab_rec_njv(i).njv_value,pi_level);
   END LOOP;
--
END debug_tab_njv;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_njo_njv (pi_operation   varchar2
                           ,pi_rec_njo     nm_job_operations%ROWTYPE
                           ,pi_tab_rec_njv tab_rec_njv
                           ) IS
--
   l_tab_rec_nod tab_rec_nod;
--
   l_njv_invalid EXCEPTION;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_njo_njv');
--
   IF pi_operation != pi_rec_njo.njo_nmo_operation
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 265
                    ,pi_supplementary_info => pi_rec_njo.njo_seq
                    );
   END IF;
--
   l_tab_rec_nod := get_tab_nod (pi_rec_njo.njo_nmo_operation);
--
   IF l_tab_rec_nod.COUNT != pi_tab_rec_njv.COUNT
    THEN
      RAISE l_njv_invalid;
   END IF;
--
   FOR i IN 1..l_tab_rec_nod.COUNT
    LOOP
      IF l_tab_rec_nod(i).nod_data_item != pi_tab_rec_njv(i).njv_nod_data_item
       THEN
         RAISE l_njv_invalid;
      END IF;
      --
      -- Validate the data types
      --
      IF    l_tab_rec_nod(i).nod_data_type = nm3type.c_number
       THEN
         IF NOT nm3flx.is_numeric (pi_tab_rec_njv(i).njv_value)
          THEN
            RAISE l_njv_invalid;
         END IF;
      ELSIF l_tab_rec_nod(i).nod_data_type = nm3type.c_date
       THEN
         IF   pi_tab_rec_njv(i).njv_value IS NOT NULL
          AND hig.date_convert (pi_tab_rec_njv(i).njv_value) IS NULL
          THEN
            RAISE l_njv_invalid;
         END IF;
      END IF;
      --
      IF l_tab_rec_nod(i).nod_mandatory = 'Y'
       AND pi_tab_rec_njv(i).njv_value IS NULL
       THEN
         hig.raise_ner(pi_appl               => nm3type.c_net
                      ,pi_id                 => 50
                      ,pi_supplementary_info => pi_rec_njo.njo_seq||':'||l_tab_rec_nod(i).nod_data_item
                      );
      END IF;
      --
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'validate_njo_njv');
--
EXCEPTION
--
   WHEN l_njv_invalid
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 266
                    ,pi_supplementary_info => pi_rec_njo.njo_seq
                    );
--
END validate_njo_njv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_nod (pi_nod_nmo_operation IN nm_operation_data.nod_nmo_operation%TYPE
                     ) RETURN tab_rec_nod IS
--
   CURSOR cs_nod (c_nod_nmo_operation IN nm_operation_data.nod_nmo_operation%TYPE
                 ) IS
   SELECT *
    FROM  nm_operation_data
   WHERE  nod_nmo_operation = c_nod_nmo_operation
   ORDER BY nod_data_item;
--
   l_retval tab_rec_nod;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_nod');
--
   FOR cs_rec IN cs_nod (pi_nod_nmo_operation)
    LOOP
      l_retval(cs_nod%rowcount) := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_tab_nod');
--
   RETURN l_retval;
--
END get_tab_nod;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmo_by_proc_name (p_nmo_proc_name nm_operations.nmo_proc_name%TYPE
                              ) RETURN nm_operations%ROWTYPE IS
--
   CURSOR cs_nmo (c_nmo_proc_name nm_operations.nmo_proc_name%TYPE
                 ) IS
   SELECT *
    FROM  nm_operations
   WHERE  UPPER(nmo_proc_name) = c_nmo_proc_name;
--
   l_found  boolean;
   l_retval nm_operations%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmo_by_proc_name');
--
   OPEN  cs_nmo (UPPER(p_nmo_proc_name));
   FETCH cs_nmo INTO l_retval;
   l_found := cs_nmo%FOUND;
   CLOSE cs_nmo;
--
   IF NOT l_found
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 67
                   ,pi_supplementary_info => 'NM_OPERATIONS:'||p_nmo_proc_name
                   );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nmo_by_proc_name');
--
   RETURN l_retval;
--
END get_nmo_by_proc_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE split_inv_for_njc (pi_njc_job_id nm_job_control.njc_job_id%TYPE) IS
--
   l_rec_njc    nm_job_control%ROWTYPE;
   l_njc_rowid  ROWID;
   l_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;
   l_npe_job_id nm_nw_persistent_extents.npe_job_id%TYPE;
   l_rec_njt    nm_job_types%ROWTYPE;
--
   c_eff_date   CONSTANT date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
BEGIN
--
   nm_debug.proc_end(g_package_name,'split_inv_for_njc');
--
   l_rec_njc   := get_njc  (pi_njc_job_id);
   l_njc_rowid := lock_njc (pi_njc_job_id);
   l_rec_njt   := get_njt  (l_rec_njc.njc_njt_type);
--
   nm3user.set_effective_date(l_rec_njc.njc_effective_date);
--
   nm3extent.create_temp_ne (pi_source_id  => l_rec_njc.njc_route_ne_id
                            ,pi_source     => nm3extent.c_route
                            ,pi_begin_mp   => l_rec_njc.njc_route_begin_mp
                            ,pi_end_mp     => l_rec_njc.njc_route_end_mp
                            ,po_job_id     => l_nte_job_id
                            );
--
   nm3inv_temp.make_copy (pi_njc_job_id       => pi_njc_job_id
                         ,pi_nte_job_id       => l_nte_job_id
                         ,pi_inv_type         => l_rec_njt.njt_inv_type
                         ,pi_include_children => TRUE
                         ,pi_effective_date   => l_rec_njc.njc_effective_date
                         );
--
   l_npe_job_id := nm3extent.create_npe_from_nte (l_nte_job_id);

   nm3extent.lock_persistent_extent_datums(pi_npe_job_id => l_npe_job_id);
--
   UPDATE nm_job_control
    SET   njc_npe_job_id = l_npe_job_id
   WHERE  ROWID          = l_njc_rowid;
--
   nm3user.set_effective_date(c_eff_date);
--
   nm_debug.proc_end(g_package_name,'split_inv_for_njc');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date(c_eff_date);
      RAISE;
--
END split_inv_for_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_njc (pi_njc_job_id nm_job_control.njc_job_id%TYPE) IS
--
   CURSOR cs_njo (c_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE) IS
   SELECT njo_id
    FROM  nm_job_operations
   WHERE  njo_njc_job_id = c_njo_njc_job_id
   ORDER BY njo_seq;
--
   l_tab_njo_id nm3type.tab_number;
   l_rec_njc    nm_job_control%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_njc');
--
   l_rec_njc := get_njc (pi_njc_job_id);
--
   IF l_rec_njc.njc_status != c_not_started
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 271
                    ,pi_supplementary_info => l_rec_njc.njc_status
                    );
   END IF;
--
   OPEN  cs_njo (pi_njc_job_id);
   FETCH cs_njo BULK COLLECT INTO l_tab_njo_id;
   CLOSE cs_njo;
--
   IF l_tab_njo_id.COUNT = 0
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_hig
                   ,pi_id                 => 67
                   ,pi_supplementary_info => 'NM_JOB_OPERATIONS:'||pi_njc_job_id
                   );
   END IF;
--
   FOR i IN 1..l_tab_njo_id.COUNT
    LOOP
      execute_njo (pi_njo_njc_job_id => pi_njc_job_id
                  ,pi_njo_id         => l_tab_njo_id(i)
                  );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'execute_njc');
--
END execute_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_njo (pi_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE
                      ,pi_njo_id         nm_job_operations.njo_id%TYPE
                      ) IS
--
   CURSOR cs_check_previous (c_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE
                            ,c_njo_seq        nm_job_operations.njo_seq%TYPE
                            ,c_status         nm_job_operations.njo_status%TYPE
                            ) IS
   SELECT 1
    FROM  nm_job_operations
   WHERE  njo_njc_job_id = c_njo_njc_job_id
    AND   njo_seq        < c_njo_seq
    AND   njo_status    != c_status;
--
   CURSOR cs_check_subsequent (c_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE
                              ,c_njo_seq        nm_job_operations.njo_seq%TYPE
                              ,c_status         nm_job_operations.njo_status%TYPE DEFAULT NULL
                              ) IS
   SELECT 1
    FROM  nm_job_operations
   WHERE  njo_njc_job_id = c_njo_njc_job_id
    AND   njo_seq        > c_njo_seq
    AND  (njo_status    != c_status OR c_status IS NULL);
--
   l_dummy       pls_integer;
   l_found       boolean;
--
   l_rec_njo     nm_job_operations%ROWTYPE;
   l_rec_njc     nm_job_control%ROWTYPE;
   l_rec_nmo     nm_operations%ROWTYPE;
   l_block       varchar2(32767);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_njo');
--
   l_rec_njc := get_njc (pi_njo_njc_job_id);
--
   IF l_rec_njc.njc_status = c_not_started
    THEN
      validate_all_njo  (pi_njc_job_id => pi_njo_njc_job_id);
      nm3job.split_inv_for_njc (pi_njo_njc_job_id);
      set_njc_status_in_progress(pi_njo_njc_job_id);
   END IF;
--
   l_rec_njo := get_njo (pi_njo_njc_job_id => pi_njo_njc_job_id
                        ,pi_njo_id         => pi_njo_id
                        );
--
   IF l_rec_njo.njo_status != c_not_started
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 271
                    ,pi_supplementary_info => l_rec_njo.njo_status
                    );
   END IF;
--
   OPEN  cs_check_previous (c_njo_njc_job_id => pi_njo_njc_job_id
                           ,c_njo_seq        => l_rec_njo.njo_seq
                           ,c_status         => c_complete
                           );
   FETCH cs_check_previous INTO l_dummy;
   l_found := cs_check_previous%FOUND;
   CLOSE cs_check_previous;
   IF l_found
    THEN -- There are ones which should have already been sone which are not flagged as complete
      hig.raise_ner (nm3type.c_net, 270);
   END IF;
   --
   OPEN  cs_check_subsequent (c_njo_njc_job_id => pi_njo_njc_job_id
                             ,c_njo_seq        => l_rec_njo.njo_seq
                             ,c_status         => c_not_started
                             );
   FETCH cs_check_subsequent INTO l_dummy;
   l_found := cs_check_subsequent%FOUND;
   CLOSE cs_check_subsequent;
   IF l_found
    THEN -- There are ones which should be after this one which are not NOT_STARTED
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 271
                    );
   END IF;
--
   validate_njo_mp_against_njc (pi_njo_begin_mp   => l_rec_njo.njo_begin_mp
                               ,pi_njo_end_mp     => l_rec_njo.njo_end_mp
                               ,pi_njo_njc_job_id => l_rec_njo.njo_njc_job_id
                               );
--
   set_njo_status_in_progress(pi_njo_njc_job_id,pi_njo_id);
--
   l_rec_nmo := get_nmo (pi_nmo_operation  => l_rec_njo.njo_nmo_operation);
--
   l_block   :=            'DECLARE'
                ||CHR(10)||'   l_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE := :pi_njo_njc_job_id;'
                ||CHR(10)||'   l_njo_id         nm_job_operations.njo_id%TYPE         := :pi_njo_id;'
                ||CHR(10)||'BEGIN'
                ||CHR(10)||'   '||l_rec_nmo.nmo_proc_name||' (l_njo_njc_job_id,l_njo_id);'
                ||CHR(10)||'END;';
   EXECUTE IMMEDIATE l_block USING pi_njo_njc_job_id, pi_njo_id;
--
   set_njo_status_complete (pi_njo_njc_job_id,pi_njo_id);
--
   --
   -- Look to see if there are any more
   --
   OPEN  cs_check_subsequent (c_njo_njc_job_id => pi_njo_njc_job_id
                             ,c_njo_seq        => l_rec_njo.njo_seq
                             );
   FETCH cs_check_subsequent INTO l_dummy;
   l_found := cs_check_subsequent%FOUND;
   CLOSE cs_check_subsequent;
   --
   IF NOT l_found
    THEN -- This is the last one - mark the job as complete and put the inventory back
      set_njc_status_complete (pi_njo_njc_job_id);
      nm3inv_temp.restore_inventory(pi_njo_njc_job_id);
   END IF;
--
   nm_debug.proc_end(g_package_name,'execute_njo');
--
END execute_njo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmo (pi_nmo_operation nm_operations.nmo_operation%TYPE
                 ) RETURN nm_operations%ROWTYPE IS
--
   CURSOR cs_nmo IS
   SELECT *
    FROM  nm_operations
   WHERE  nmo_operation    = pi_nmo_operation;
--
   l_found  boolean;
   l_retval nm_operations%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nmo');
--
   OPEN  cs_nmo;
   FETCH cs_nmo INTO l_retval;
   l_found := cs_nmo%FOUND;
   CLOSE cs_nmo;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'NM_OPERATIONS'
                    );
   END IF;
--
   nm_debug.proc_start(g_package_name,'get_nmo');
--
   RETURN l_retval;
--
END get_nmo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_njc (pi_njc_job_id nm_job_control.njc_job_id%TYPE
                 ) RETURN nm_job_control%ROWTYPE IS
--
   CURSOR cs_njc IS
   SELECT *
    FROM  nm_job_control
   WHERE  njc_job_id = pi_njc_job_id;
--
   l_found  boolean;
   l_retval nm_job_control%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_njc');
--
   OPEN  cs_njc;
   FETCH cs_njc INTO l_retval;
   l_found := cs_njc%FOUND;
   CLOSE cs_njc;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'NM_JOB_CONTROL'
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_njc');
--
   RETURN l_retval;
--
END get_njc;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_njc (pi_njc_job_id nm_job_control.njc_job_id%TYPE
                  ) RETURN ROWID IS
--
   CURSOR cs_njc IS
   SELECT ROWID
    FROM  nm_job_control
   WHERE  njc_job_id = pi_njc_job_id
   FOR UPDATE NOWAIT;
--
   l_found  boolean;
   l_retval ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njc');
--
   OPEN  cs_njc;
   FETCH cs_njc INTO l_retval;
   l_found := cs_njc%FOUND;
   CLOSE cs_njc;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'NM_JOB_CONTROL'
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njc');
--
   RETURN l_retval;
--
END lock_njc;
--
-----------------------------------------------------------------------------
--
FUNCTION lock_njo (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                  ,pi_njo_id         IN nm_job_operations.njo_id%TYPE
                  ) RETURN ROWID IS
--
   CURSOR cs_njo IS
   SELECT ROWID
    FROM  nm_job_operations
   WHERE  njo_njc_job_id = pi_njo_njc_job_id
    AND   njo_id         = pi_njo_id
   FOR UPDATE NOWAIT;
--
   l_found  boolean;
   l_retval ROWID;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_njo');
--
   OPEN  cs_njo;
   FETCH cs_njo INTO l_retval;
   l_found := cs_njo%FOUND;
   CLOSE cs_njo;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'NM_JOB_OPERATIONS'
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'lock_njo');
--
   RETURN l_retval;
--
END lock_njo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_njt (pi_njt_type nm_job_types.njt_type%TYPE) RETURN nm_job_types%ROWTYPE IS
--
   CURSOR cs_njt IS
   SELECT *
    FROM  nm_job_types
   WHERE  njt_type = pi_njt_type;
--
   l_found  boolean;
   l_retval nm_job_types%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_njt');
--
   OPEN  cs_njt;
   FETCH cs_njt INTO l_retval;
   l_found := cs_njt%FOUND;
   CLOSE cs_njt;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'nm_job_types'
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_njt');
--
   RETURN l_retval;
--
END get_njt;
--
-----------------------------------------------------------------------------
--
FUNCTION get_njv (pi_njv_njc_job_id    nm_job_operation_data_values.njv_njc_job_id%TYPE
                 ,pi_njv_njo_id        nm_job_operation_data_values.njv_njo_id%TYPE
                 ,pi_njv_nod_data_item nm_job_operation_data_values.njv_nod_data_item%TYPE
                 ) RETURN nm_job_operation_data_values%ROWTYPE IS
--
   CURSOR cs_njv IS
   SELECT *
    FROM  nm_job_operation_data_values
   WHERE  njv_njc_job_id    = pi_njv_njc_job_id
    AND   njv_njo_id        = pi_njv_njo_id
    AND   njv_nod_data_item = pi_njv_nod_data_item;
--
   l_found  boolean;
   l_retval nm_job_operation_data_values%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_njv');
--
   OPEN  cs_njv;
   FETCH cs_njv INTO l_retval;
   l_found := cs_njv%FOUND;
   CLOSE cs_njv;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'nm_job_operation_data_values'
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_njv');
--
   RETURN l_retval;
--
END get_njv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nod (pi_nod_nmo_operation nm_operation_data.nod_nmo_operation%TYPE
                 ,pi_nod_data_item     nm_operation_data.nod_data_item%TYPE
                 ) RETURN nm_operation_data%ROWTYPE IS
--
   CURSOR cs_nod IS
   SELECT *
    FROM  nm_operation_data
   WHERE  nod_nmo_operation = pi_nod_nmo_operation
    AND   nod_data_item     = pi_nod_data_item;
--
   l_found  boolean;
   l_retval nm_operation_data%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_nod');
--
   OPEN  cs_nod;
   FETCH cs_nod INTO l_retval;
   l_found := cs_nod%FOUND;
   CLOSE cs_nod;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'nm_operation_data'
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_nod');
--
   RETURN l_retval;
--
END get_nod;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_njv_value(pi_operation IN nm_operations.nmo_operation%TYPE
                            ,pi_data_item IN nm_operation_data.nod_data_item%TYPE
                            ,pi_value     IN nm_job_operation_data_values.njv_value%TYPE
                            ) IS

  e_numeric_invalid   EXCEPTION;
  e_date_invalid      EXCEPTION;
  e_missing_mandatory EXCEPTION;
  l_nod_rec nm_operation_data%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_njv_value');

  l_nod_rec := get_nod(pi_nod_nmo_operation => pi_operation
                      ,pi_nod_data_item     => pi_data_item);

  IF l_nod_rec.nod_data_type = nm3type.c_number
  THEN
    IF NOT nm3flx.is_numeric(pi_value)
    THEN
      RAISE e_numeric_invalid;
    END IF;

  ELSIF l_nod_rec.nod_data_type = nm3type.c_date
  THEN
    IF   pi_value IS NOT NULL
     AND hig.date_convert(pi_value) IS NULL
    THEN
       RAISE e_date_invalid;
    END IF;
  END IF;
--
  IF l_nod_rec.nod_mandatory = 'Y'
   AND pi_value IS NULL
   THEN
     RAISE e_missing_mandatory;
  END IF;
--   IF l_nod_rec.nod_query_sql IS NOT NULL
--   THEN
--
--   END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_njv_value');

EXCEPTION
  WHEN e_numeric_invalid
  THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 111);

  WHEN e_date_invalid
  THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 148);
  WHEN e_missing_mandatory
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 50);
END validate_njv_value;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_njv_value(pi_njv_njc_job_id    IN nm_job_operation_data_values.njv_njc_job_id%TYPE
                          ,pi_njv_njo_id        IN nm_job_operation_data_values.njv_njo_id%TYPE
                          ,pi_njv_nod_data_item IN nm_job_operation_data_values.njv_nod_data_item%TYPE
                          ,pi_value             IN nm_job_operation_data_values.njv_value%TYPE
                          ) IS

  l_njv_rec nm_job_operation_data_values%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'update_njv_value');

  l_njv_rec := get_njv(pi_njv_njc_job_id    => pi_njv_njc_job_id
                      ,pi_njv_njo_id        => pi_njv_njo_id
                      ,pi_njv_nod_data_item => pi_njv_nod_data_item);

  validate_njv_value(pi_operation => l_njv_rec.njv_nmo_operation
                    ,pi_data_item => pi_njv_nod_data_item
                    ,pi_value     => pi_value);

  UPDATE
    nm_job_operation_data_values njv
  SET
    njv.njv_value = pi_value
  WHERE
    njv.njv_njc_job_id = pi_njv_njc_job_id
  AND
    njv.njv_njo_id = pi_njv_njo_id
  AND
    njv.njv_nod_data_item = pi_njv_nod_data_item;

  IF SQL%rowcount <> 1
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 266);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'update_njv_value');

END update_njv_value;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_njv (p_rec_njv IN OUT nm_job_operation_data_values%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_njv');
--
   INSERT INTO nm_job_operation_data_values
            (njv_njc_job_id
            ,njv_njo_id
            ,njv_nmo_operation
            ,njv_nod_data_item
            ,njv_date_created
            ,njv_date_modified
            ,njv_created_by
            ,njv_modified_by
            ,njv_value
            )
     VALUES (p_rec_njv.njv_njc_job_id
            ,p_rec_njv.njv_njo_id
            ,p_rec_njv.njv_nmo_operation
            ,p_rec_njv.njv_nod_data_item
            ,p_rec_njv.njv_date_created
            ,p_rec_njv.njv_date_modified
            ,p_rec_njv.njv_created_by
            ,p_rec_njv.njv_modified_by
            ,p_rec_njv.njv_value
            )
   RETURNING njv_njc_job_id
            ,njv_njo_id
            ,njv_nmo_operation
            ,njv_nod_data_item
            ,njv_date_created
            ,njv_date_modified
            ,njv_created_by
            ,njv_modified_by
            ,njv_value
      INTO   p_rec_njv.njv_njc_job_id
            ,p_rec_njv.njv_njo_id
            ,p_rec_njv.njv_nmo_operation
            ,p_rec_njv.njv_nod_data_item
            ,p_rec_njv.njv_date_created
            ,p_rec_njv.njv_date_modified
            ,p_rec_njv.njv_created_by
            ,p_rec_njv.njv_modified_by
            ,p_rec_njv.njv_value;
--
   nm_debug.proc_end(g_package_name,'ins_njv');
--
END ins_njv;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_njvs_for_job_operation(pi_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                                       ,pi_njo_id IN nm_job_operations.njo_id%TYPE
                                       ) IS

  l_njo_rec nm_job_operations%ROWTYPE;

  l_nod_rec_tab tab_rec_nod;

  l_njv_rec nm_job_operation_data_values%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_njvs_for_job_operation');

  l_njo_rec := get_njo(pi_njo_njc_job_id => pi_job_id
                      ,pi_njo_id         => pi_njo_id);

  l_nod_rec_tab := get_tab_nod(pi_nod_nmo_operation => l_njo_rec.njo_nmo_operation);

  l_njv_rec.njv_njc_job_id    := pi_job_id;
  l_njv_rec.njv_njo_id        := pi_njo_id;
  l_njv_rec.njv_nmo_operation := l_njo_rec.njo_nmo_operation;
  l_njv_rec.njv_value         := NULL;

  FOR l_i IN 1..l_nod_rec_tab.COUNT
  LOOP
    l_njv_rec.njv_nod_data_item := l_nod_rec_tab(l_i).nod_data_item;

    ins_njv(p_rec_njv => l_njv_rec);
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_njvs_for_job_operation');

END create_njvs_for_job_operation;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_njc_status (pi_njc_job_id IN nm_job_control.njc_job_id%TYPE
                            ,pi_njc_status IN nm_job_control.njc_status%TYPE
                            ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'update_njc_status');
--
   l_rowid := lock_njc (pi_njc_job_id);
--
   UPDATE nm_job_control
    SET   njc_status = pi_njc_status
   WHERE  ROWID      = l_rowid;
--
   nm_debug.proc_end(g_package_name,'update_njc_status');
--
END update_njc_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_njo_status (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                            ,pi_njo_id         IN nm_job_operations.njo_id%TYPE
                            ,pi_njo_status     IN nm_job_operations.njo_status%TYPE
                            ) IS
   l_rowid ROWID;
BEGIN
--
   nm_debug.proc_start(g_package_name,'update_njo_status');
--
   l_rowid := lock_njo (pi_njo_njc_job_id,pi_njo_id);
--
   UPDATE nm_job_operations
    SET   njo_status = pi_njo_status
   WHERE  ROWID      = l_rowid;
--
   nm_debug.proc_end(g_package_name,'update_njo_status');
--
END update_njo_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njc_status_in_progress (pi_njc_job_id IN nm_job_control.njc_job_id%TYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_njc_status_in_progress');
--
   update_njc_status (pi_njc_job_id,c_in_progress);
--
   nm_debug.proc_end(g_package_name,'set_njc_status_in_progress');
--
END set_njc_status_in_progress;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njc_status_complete    (pi_njc_job_id IN nm_job_control.njc_job_id%TYPE) IS
BEGIN
   update_njc_status (pi_njc_job_id,c_complete);
END set_njc_status_complete;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njc_status_error       (pi_njc_job_id IN nm_job_control.njc_job_id%TYPE) IS
BEGIN
   update_njc_status (pi_njc_job_id,c_error);
END set_njc_status_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njc_status_not_started (pi_njc_job_id IN nm_job_control.njc_job_id%TYPE) IS
BEGIN
   update_njc_status (pi_njc_job_id,c_not_started);
END set_njc_status_not_started;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njo_status_in_progress
                            (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                            ,pi_njo_id         IN nm_job_operations.njo_id%TYPE
                            ) IS
BEGIN
   validate_njo (pi_njo_njc_job_id => pi_njo_njc_job_id
                ,pi_njo_id         => pi_njo_id
                );
   update_njo_status (pi_njo_njc_job_id => pi_njo_njc_job_id
                     ,pi_njo_id         => pi_njo_id
                     ,pi_njo_status     => c_in_progress
                     );
END set_njo_status_in_progress;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njo_status_complete
                            (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                            ,pi_njo_id         IN nm_job_operations.njo_id%TYPE
                            ) IS
BEGIN
   update_njo_status (pi_njo_njc_job_id => pi_njo_njc_job_id
                     ,pi_njo_id         => pi_njo_id
                     ,pi_njo_status     => c_complete
                     );
END set_njo_status_complete;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njo_status_error
                            (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                            ,pi_njo_id         IN nm_job_operations.njo_id%TYPE
                            ) IS
BEGIN
   update_njo_status (pi_njo_njc_job_id => pi_njo_njc_job_id
                     ,pi_njo_id         => pi_njo_id
                     ,pi_njo_status     => c_error
                     );
END set_njo_status_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_njo_status_not_started
                            (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                            ,pi_njo_id         IN nm_job_operations.njo_id%TYPE
                            ) IS
BEGIN
   update_njo_status (pi_njo_njc_job_id => pi_njo_njc_job_id
                     ,pi_njo_id         => pi_njo_id
                     ,pi_njo_status     => c_not_started
                     );
END set_njo_status_not_started;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_next_njo(pi_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                          ) IS

  e_no_more_njos EXCEPTION;

  l_next_njo nm_job_operations.njo_id%TYPE;

  l_found boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'execute_next_njo');

  --get next operation that has not been started
  OPEN cs_remaining_njos(p_njc_job_id => pi_njc_job_id
                        ,p_status     => c_not_started);
    FETCH cs_remaining_njos INTO l_next_njo;
    l_found := cs_remaining_njos%FOUND;
  CLOSE cs_remaining_njos;

  --check in case there are no more operations
  IF NOT l_found
  THEN
    RAISE e_no_more_njos;
  END IF;

  --execute the next operation
  execute_njo(pi_njo_njc_job_id => pi_njc_job_id
             ,pi_njo_id         => l_next_njo);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'execute_next_njo');

EXCEPTION
  WHEN e_no_more_njos
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 272);

END execute_next_njo;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_remaining_njos(pi_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE
                                ) IS

  e_no_more_njos EXCEPTION;

  l_njo_tab nm3type.tab_number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'execute_remaining_njos');

  OPEN cs_remaining_njos(p_njc_job_id => pi_njc_job_id
                        ,p_status     => c_not_started);
    FETCH cs_remaining_njos BULK COLLECT INTO l_njo_tab;
  CLOSE cs_remaining_njos;

  --check in case there are no more operations
  IF l_njo_tab.COUNT = 0
  THEN
    RAISE e_no_more_njos;
  END IF;

  FOR l_i IN 1..l_njo_tab.COUNT
  LOOP
    execute_njo(pi_njo_njc_job_id => pi_njc_job_id
               ,pi_njo_id         => l_njo_tab(l_i));
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'execute_remaining_njos');

EXCEPTION
  WHEN e_no_more_njos
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 272);

END execute_remaining_njos;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_in_progress RETURN hig_codes.hco_code%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_c_in_progress');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_c_in_progress');

  RETURN c_in_progress;

END get_c_in_progress;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_complete RETURN hig_codes.hco_code%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_c_complete');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_c_complete');

  RETURN c_complete;

END get_c_complete;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_error RETURN hig_codes.hco_code%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_c_error');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_c_error');

  RETURN c_error;

END get_c_error;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_not_started RETURN hig_codes.hco_code%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_c_not_started');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_c_not_started');

  RETURN c_not_started;

END get_c_not_started;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_njo_mp_against_njc (pi_njo_begin_mp   nm_job_operations.njo_begin_mp%TYPE
                                      ,pi_njo_end_mp     nm_job_operations.njo_end_mp%TYPE
                                      ,pi_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE
                                      ) IS
--
   l_rec_njc       nm_job_control%ROWTYPE;
   l_nte_job_id    nm_nw_temp_extents.nte_job_id%TYPE;
   l_extent_length number;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'validate_njo_mp_against_njc');
--
   IF  pi_njo_begin_mp >= pi_njo_end_mp
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 276
                    ,pi_supplementary_info => pi_njo_begin_mp||' >= '||pi_njo_end_mp
                    );
   END IF;
--
   l_rec_njc := get_njc (pi_njo_njc_job_id);
--
   IF l_rec_njc.njc_npe_job_id IS NOT NULL
    THEN
      -- There is a NPE associated - use the length of that
      l_extent_length := nm3extent.get_npe_length(l_rec_njc.njc_npe_job_id);
   ELSE
      -- There's not one there yet - create a temp ne and get the length from there
      nm3extent.create_temp_ne (pi_source_id   => l_rec_njc.njc_route_ne_id
                               ,pi_source      => nm3extent.c_route
                               ,pi_begin_mp    => l_rec_njc.njc_route_begin_mp
                               ,pi_end_mp      => l_rec_njc.njc_route_end_mp
                               ,po_job_id      => l_nte_job_id
                               );
      l_extent_length := nm3extent.get_nte_length(l_nte_job_id);
   END IF;
--
   IF    pi_njo_begin_mp > l_extent_length
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 277
                    ,pi_supplementary_info => pi_njo_begin_mp||' > '||l_extent_length
                    );
   ELSIF pi_njo_end_mp   > l_extent_length
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 278
                    ,pi_supplementary_info => pi_njo_end_mp||' > '||l_extent_length
                    );
   END IF;
--
   nm_debug.proc_end   (g_package_name, 'validate_njo_mp_against_njc');
--
END validate_njo_mp_against_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_njc_mp_against_njo (pi_rec_njc nm_job_control%ROWTYPE) IS
--
   l_nte_job_id    nm_nw_temp_extents.nte_job_id%TYPE;
   l_extent_length number;
--
   CURSOR cs_njo_mp (c_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE) IS
   SELECT njo_begin_mp
         ,njo_end_mp
    FROM  nm_job_operations
   WHERE  njo_njc_job_id = c_njo_njc_job_id;
--
   l_tab_begin_mp nm3type.tab_number;
   l_tab_end_mp   nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'validate_njc_mp_against_njo');
--
   IF   pi_rec_njc.njc_route_begin_mp >= pi_rec_njc.njc_route_end_mp
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 276
                    ,pi_supplementary_info =>  pi_rec_njc.njc_route_begin_mp||' >= '||pi_rec_njc.njc_route_end_mp
                    );
   END IF;
--
   IF pi_rec_njc.njc_npe_job_id IS NOT NULL
    THEN
      -- There is a NPE associated - use the length of that
      l_extent_length := nm3extent.get_npe_length(pi_rec_njc.njc_npe_job_id);
   ELSE
      -- There's not one there yet - create a temp ne and get the length from there
      nm3extent.create_temp_ne (pi_source_id   => pi_rec_njc.njc_route_ne_id
                               ,pi_source      => nm3extent.c_route
                               ,pi_begin_mp    => pi_rec_njc.njc_route_begin_mp
                               ,pi_end_mp      => pi_rec_njc.njc_route_end_mp
                               ,po_job_id      => l_nte_job_id
                               );
      l_extent_length := nm3extent.get_nte_length(l_nte_job_id);
   END IF;
--
   OPEN  cs_njo_mp (pi_rec_njc.njc_job_id);
   FETCH cs_njo_mp BULK COLLECT INTO l_tab_begin_mp, l_tab_end_mp;
   CLOSE cs_njo_mp;
--
   FOR i IN 1..l_tab_begin_mp.COUNT
    LOOP
      IF    l_tab_begin_mp(i) > l_extent_length
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 277
                       ,pi_supplementary_info => l_tab_begin_mp(i)||' > '||l_extent_length
                       );
      ELSIF l_tab_end_mp(i)   > l_extent_length
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 278
                       ,pi_supplementary_info => l_tab_end_mp(i)||' > '||l_extent_length
                       );
      END IF;
   END LOOP;
--
   nm_debug.proc_end   (g_package_name, 'validate_njc_mp_against_njo');
--
END validate_njc_mp_against_njo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_max_seq_for_njc(pi_njc_job_id IN nm_job_control.njc_job_id%TYPE
                             ) RETURN nm_job_operations.njo_seq%TYPE IS

  l_retval nm_job_operations.njo_seq%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_max_seq_for_njc');

  SELECT
    MAX(njo_seq)
  INTO
    l_retval
  FROM
    nm_job_operations njo
  WHERE
    njo.njo_njc_job_id = pi_njc_job_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_max_seq_for_njc');

  RETURN NVL(l_retval, 0);

END get_max_seq_for_njc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_njc_unique(pi_njc_job_id IN nm_job_control.njc_job_id%TYPE
                               ,pi_njt_type   IN nm_job_types.njt_type%TYPE
                               ,pi_username   IN user_users.username%TYPE DEFAULT Sys_Context('NM3_SECURITY_CTX','USERNAME')
                                ) RETURN nm_job_control.njc_unique%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_default_njc_unique');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_default_njc_unique');

  RETURN pi_njt_type || ' ' || SUBSTR(pi_username, 1, 12) || ' ' || SUBSTR(TO_CHAR(pi_njc_job_id), 1, 12);

END get_default_njc_unique;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_and_run_njc (pi_njc_unique         IN     nm_job_control.njc_unique%TYPE         DEFAULT NULL
                            ,pi_njc_njt_type       IN     nm_job_control.njc_njt_type%TYPE
                            ,pi_njc_job_descr      IN     nm_job_control.njc_job_descr%TYPE      DEFAULT NULL
                            ,pi_njc_route_ne_id    IN     nm_job_control.njc_route_ne_id%TYPE
                            ,pi_njc_route_begin_mp IN     nm_job_control.njc_route_begin_mp%TYPE
                            ,pi_njc_route_end_mp   IN     nm_job_control.njc_route_end_mp%TYPE
                            ,pi_njc_effective_date IN     nm_job_control.njc_effective_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                            ,pi_tab_rec_njo        IN     tab_rec_njo
                            ,pi_tab_rec_njv        IN     tab_rec_njv
                            ,po_njc_job_id            OUT nm_job_control.njc_job_id%TYPE
                            ) IS
--
   l_rec_njc nm_job_control%ROWTYPE;
   l_rec_njo nm_job_operations%ROWTYPE;
   l_rec_njv nm_job_operation_data_values%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name, 'build_and_run_njc');
--
   po_njc_job_id                     := get_next_njc_job_id;
--
   l_rec_njc.njc_job_id              := po_njc_job_id;
   l_rec_njc.njc_unique              := pi_njc_unique;
   IF l_rec_njc.njc_unique IS NULL
    THEN
      l_rec_njc.njc_unique           := get_default_njc_unique (l_rec_njc.njc_job_id, pi_njc_njt_type);
   END IF;
   l_rec_njc.njc_njt_type            := pi_njc_njt_type;
   l_rec_njc.njc_job_descr           := NVL(pi_njc_job_descr,l_rec_njc.njc_unique);
   l_rec_njc.njc_status              := get_c_not_started;
   l_rec_njc.njc_route_ne_id         := pi_njc_route_ne_id;
   l_rec_njc.njc_route_begin_mp      := pi_njc_route_begin_mp;
   l_rec_njc.njc_route_end_mp        := pi_njc_route_end_mp;
   l_rec_njc.njc_npe_job_id          := NULL;
   l_rec_njc.njc_effective_date      := pi_njc_effective_date;
--
   ins_njc (l_rec_njc);
--
   FOR i IN 1..pi_tab_rec_njo.COUNT
    LOOP
      l_rec_njo                      := pi_tab_rec_njo (i);
      l_rec_njo.njo_njc_job_id       := l_rec_njc.njc_job_id;
      l_rec_njo.njo_status           := get_c_not_started;
      ins_njo (l_rec_njo);

      FOR j IN 1..pi_tab_rec_njv.COUNT
       LOOP
         l_rec_njv := pi_tab_rec_njv (j);
         IF l_rec_njv.njv_njo_id = l_rec_njo.njo_id
          THEN
            l_rec_njv.njv_njc_job_id    := l_rec_njc.njc_job_id;
            l_rec_njv.njv_nmo_operation := l_rec_njo.njo_nmo_operation;
            ins_njv (l_rec_njv);
         END IF;
      END LOOP;
   END LOOP;
--
   execute_njc (po_njc_job_id);
--
   nm_debug.proc_end(g_package_name, 'build_and_run_njc');
--
END build_and_run_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_and_run_njc (pi_njc_unique         IN     nm_job_control.njc_unique%TYPE         DEFAULT NULL
                            ,pi_njc_njt_type       IN     nm_job_control.njc_njt_type%TYPE
                            ,pi_njc_job_descr      IN     nm_job_control.njc_job_descr%TYPE      DEFAULT NULL
                            ,pi_njc_route_ne_id    IN     nm_job_control.njc_route_ne_id%TYPE
                            ,pi_njc_route_begin_mp IN     nm_job_control.njc_route_begin_mp%TYPE
                            ,pi_njc_route_end_mp   IN     nm_job_control.njc_route_end_mp%TYPE
                            ,pi_njc_effective_date IN     nm_job_control.njc_effective_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                            ,pi_tab_rec_njo        IN     tab_rec_njo
                            ,pi_tab_rec_njv        IN     tab_rec_njv
                            ) IS
   l_njc_job_id nm_job_control.njc_job_id%TYPE;
BEGIN
   build_and_run_njc (pi_njc_unique         => pi_njc_unique
                     ,pi_njc_njt_type       => pi_njc_njt_type
                     ,pi_njc_job_descr      => pi_njc_job_descr
                     ,pi_njc_route_ne_id    => pi_njc_route_ne_id
                     ,pi_njc_route_begin_mp => pi_njc_route_begin_mp
                     ,pi_njc_route_end_mp   => pi_njc_route_end_mp
                     ,pi_njc_effective_date => pi_njc_effective_date
                     ,pi_tab_rec_njo        => pi_tab_rec_njo
                     ,pi_tab_rec_njv        => pi_tab_rec_njv
                     ,po_njc_job_id         => l_njc_job_id
                     );
END build_and_run_njc;
--
-----------------------------------------------------------------------------
--
FUNCTION  build_and_run_njc (pi_njc_unique         IN     nm_job_control.njc_unique%TYPE         DEFAULT NULL
                            ,pi_njc_njt_type       IN     nm_job_control.njc_njt_type%TYPE
                            ,pi_njc_job_descr      IN     nm_job_control.njc_job_descr%TYPE      DEFAULT NULL
                            ,pi_njc_route_ne_id    IN     nm_job_control.njc_route_ne_id%TYPE
                            ,pi_njc_route_begin_mp IN     nm_job_control.njc_route_begin_mp%TYPE
                            ,pi_njc_route_end_mp   IN     nm_job_control.njc_route_end_mp%TYPE
                            ,pi_njc_effective_date IN     nm_job_control.njc_effective_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                            ,pi_tab_rec_njo        IN     tab_rec_njo
                            ,pi_tab_rec_njv        IN     tab_rec_njv
                            ) RETURN nm_job_control.njc_job_id%TYPE IS
   l_njc_job_id nm_job_control.njc_job_id%TYPE;
BEGIN
   build_and_run_njc (pi_njc_unique         => pi_njc_unique
                     ,pi_njc_njt_type       => pi_njc_njt_type
                     ,pi_njc_job_descr      => pi_njc_job_descr
                     ,pi_njc_route_ne_id    => pi_njc_route_ne_id
                     ,pi_njc_route_begin_mp => pi_njc_route_begin_mp
                     ,pi_njc_route_end_mp   => pi_njc_route_end_mp
                     ,pi_njc_effective_date => pi_njc_effective_date
                     ,pi_tab_rec_njo        => pi_tab_rec_njo
                     ,pi_tab_rec_njv        => pi_tab_rec_njv
                     ,po_njc_job_id         => l_njc_job_id
                     );
   RETURN l_njc_job_id;
END build_and_run_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_njc (p_rec_njc IN OUT nm_job_control%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_njc');
--
   INSERT INTO nm_job_control
            (njc_job_id
            ,njc_unique
            ,njc_njt_type
            ,njc_job_descr
            ,njc_status
            ,njc_date_created
            ,njc_date_modified
            ,njc_created_by
            ,njc_modified_by
            ,njc_route_ne_id
            ,njc_route_begin_mp
            ,njc_route_end_mp
            ,njc_npe_job_id
            ,njc_effective_date
            )
     VALUES (p_rec_njc.njc_job_id
            ,p_rec_njc.njc_unique
            ,p_rec_njc.njc_njt_type
            ,p_rec_njc.njc_job_descr
            ,p_rec_njc.njc_status
            ,p_rec_njc.njc_date_created
            ,p_rec_njc.njc_date_modified
            ,p_rec_njc.njc_created_by
            ,p_rec_njc.njc_modified_by
            ,p_rec_njc.njc_route_ne_id
            ,p_rec_njc.njc_route_begin_mp
            ,p_rec_njc.njc_route_end_mp
            ,p_rec_njc.njc_npe_job_id
            ,p_rec_njc.njc_effective_date
            )
   RETURNING njc_job_id
            ,njc_unique
            ,njc_njt_type
            ,njc_job_descr
            ,njc_status
            ,njc_date_created
            ,njc_date_modified
            ,njc_created_by
            ,njc_modified_by
            ,njc_route_ne_id
            ,njc_route_begin_mp
            ,njc_route_end_mp
            ,njc_npe_job_id
            ,njc_effective_date
      INTO   p_rec_njc.njc_job_id
            ,p_rec_njc.njc_unique
            ,p_rec_njc.njc_njt_type
            ,p_rec_njc.njc_job_descr
            ,p_rec_njc.njc_status
            ,p_rec_njc.njc_date_created
            ,p_rec_njc.njc_date_modified
            ,p_rec_njc.njc_created_by
            ,p_rec_njc.njc_modified_by
            ,p_rec_njc.njc_route_ne_id
            ,p_rec_njc.njc_route_begin_mp
            ,p_rec_njc.njc_route_end_mp
            ,p_rec_njc.njc_npe_job_id
            ,p_rec_njc.njc_effective_date;
--
   nm_debug.proc_end(g_package_name,'ins_njc');
--
END ins_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_njo (p_rec_njo IN OUT nm_job_operations%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_njo');
--
   INSERT INTO nm_job_operations
            (njo_njc_job_id
            ,njo_id
            ,njo_nmo_operation
            ,njo_seq
            ,njo_status
            ,njo_date_created
            ,njo_date_modified
            ,njo_created_by
            ,njo_modified_by
            ,njo_begin_mp
            ,njo_end_mp
            )
     VALUES (p_rec_njo.njo_njc_job_id
            ,p_rec_njo.njo_id
            ,p_rec_njo.njo_nmo_operation
            ,p_rec_njo.njo_seq
            ,p_rec_njo.njo_status
            ,p_rec_njo.njo_date_created
            ,p_rec_njo.njo_date_modified
            ,p_rec_njo.njo_created_by
            ,p_rec_njo.njo_modified_by
            ,p_rec_njo.njo_begin_mp
            ,p_rec_njo.njo_end_mp
            )
   RETURNING njo_njc_job_id
            ,njo_id
            ,njo_nmo_operation
            ,njo_seq
            ,njo_status
            ,njo_date_created
            ,njo_date_modified
            ,njo_created_by
            ,njo_modified_by
            ,njo_begin_mp
            ,njo_end_mp
      INTO   p_rec_njo.njo_njc_job_id
            ,p_rec_njo.njo_id
            ,p_rec_njo.njo_nmo_operation
            ,p_rec_njo.njo_seq
            ,p_rec_njo.njo_status
            ,p_rec_njo.njo_date_created
            ,p_rec_njo.njo_date_modified
            ,p_rec_njo.njo_created_by
            ,p_rec_njo.njo_modified_by
            ,p_rec_njo.njo_begin_mp
            ,p_rec_njo.njo_end_mp;
--
   nm_debug.proc_end(g_package_name,'ins_njo');
--
END ins_njo;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_all_njo (pi_njc_job_id nm_job_control.njc_job_id%TYPE) IS
--
   CURSOR cs_njo (c_njc_job_id nm_job_operations.njo_njc_job_id%TYPE) IS
   SELECT njo_id
    FROM  nm_job_operations
   WHERE  njo_njc_job_id = c_njc_job_id
   ORDER BY njo_seq;
--
   l_tab_njo_id nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_all_njo');
--
   OPEN  cs_njo (pi_njc_job_id);
   FETCH cs_njo BULK COLLECT INTO l_tab_njo_id;
   CLOSE cs_njo;
--
   FOR i IN 1..l_tab_njo_id.COUNT
    LOOP
      validate_njo (pi_njo_njc_job_id => pi_njc_job_id
                   ,pi_njo_id         => l_tab_njo_id(i)
                   );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'validate_all_njo');
--
END validate_all_njo;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_njo (pi_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE
                       ,pi_njo_id         nm_job_operations.njo_id%TYPE
                       ) IS
--
   l_tab_rec_njv tab_rec_njv;
   l_rec_njo     nm_job_operations%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_njo');
--
   l_rec_njo := get_njo (pi_njo_njc_job_id => pi_njo_njc_job_id
                        ,pi_njo_id         => pi_njo_id
                        );
--
   validate_njo_mp_against_njc (pi_njo_begin_mp   => l_rec_njo.njo_begin_mp
                               ,pi_njo_end_mp     => l_rec_njo.njo_end_mp
                               ,pi_njo_njc_job_id => l_rec_njo.njo_njc_job_id
                               );
--
   l_tab_rec_njv := get_tab_njv (pi_njv_njc_job_id => pi_njo_njc_job_id
                                ,pi_njv_njo_id     => pi_njo_id
                                );
--
   validate_njo_njv (pi_operation   => l_rec_njo.njo_nmo_operation
                    ,pi_rec_njo     => l_rec_njo
                    ,pi_tab_rec_njv => l_tab_rec_njv
                    );
--
   nm_debug.proc_end(g_package_name,'validate_njo');
--
END validate_njo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_active_nw_locking_jobs RETURN nm3type.tab_number IS

  l_retval nm3type.tab_number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_active_nw_locking_jobs');
  SELECT
    njc.njc_npe_job_id
  BULK COLLECT INTO
    l_retval
  FROM
    nm_job_control njc,
    nm_job_types   njt
  WHERE
    njc.njc_njt_type = njt.njt_type
  AND
    njt.njt_nw_lock = 'Y'
  AND
    njc.njc_npe_job_id IS NOT NULL
  AND
    njc.njc_status NOT IN (c_not_started, c_complete);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_active_nw_locking_jobs');

  RETURN l_retval;

END get_active_nw_locking_jobs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_active_inv_locking_jobs(pi_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE
                                    ,pi_inv_type  IN nm_inv_types.nit_inv_type%TYPE DEFAULT NULL
                                    ) RETURN nm3type.tab_number IS

  l_inv_type nm_inv_types.nit_inv_type%TYPE;

  l_inv_category nm_inv_types.nit_category%TYPE;

  l_retval nm3type.tab_number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_active_inv_locking_jobs');

  IF pi_inv_type IS NOT NULL
  THEN
    l_inv_type := pi_inv_type;
  ELSE
    l_inv_type := nm3inv.get_inv_type_all(p_ne_id => pi_iit_ne_id);
  END IF;

--RAC swapped get_inv_type for nm3get.get_nit_all to cater for recalibrate - which operates on all member data included end-dated ones.
--l_inv_category := nm3inv.get_inv_type(pi_inv_type => l_inv_type).nit_category;

  l_inv_category := NM3GET.GET_NIT_ALL(pi_nit_inv_type => l_inv_type ).nit_category;

  --get jobs that lock this inv category
  SELECT
    njc.njc_job_id
  BULK COLLECT INTO
    l_retval
  FROM
    nm_job_control njc,
    nm_job_types   njt
  WHERE
    njc.njc_njt_type = njt.njt_type
  AND
    njc.njc_status NOT IN (c_not_started, c_complete)
  AND
    njt.njt_inv_lock = l_inv_category;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_active_inv_locking_jobs');

  RETURN l_retval;

END get_active_inv_locking_jobs;
--
-----------------------------------------------------------------------------
--
FUNCTION job_is_affecting_element(pi_njc_job_id IN nm_job_control.njc_job_id%TYPE
                                 ,pi_ne_id      IN nm_elements.ne_id%TYPE
                                 ) RETURN boolean IS

  l_dummy pls_integer;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'job_is_affecting_element');

  BEGIN
    SELECT
       1
    INTO
      l_dummy
    FROM
      dual
    WHERE
      EXISTS(SELECT
               1
             FROM
               nm_nw_persistent_extents npe
             WHERE
               npe.npe_job_id = pi_njc_job_id
             AND
               npe.npe_ne_id_of = pi_ne_id);

    l_retval := TRUE;

  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := FALSE;

    END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'job_is_affecting_element');

  RETURN l_retval;

END job_is_affecting_element;
--
-----------------------------------------------------------------------------
--
FUNCTION job_is_affecting_inv_item(pi_njc_job_id IN nm_job_control.njc_job_id%TYPE
                                  ,pi_iit_ne_id  IN nm_inv_items.iit_ne_id%TYPE
                                  ) RETURN boolean IS

  l_dummy pls_integer;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'job_is_affecting_inv_item');

  BEGIN
    SELECT
      1
    INTO
      l_dummy
    FROM
      dual
    WHERE
      EXISTS(SELECT
               1
             FROM
               nm_temp_inv_items_list til
             WHERE
               til.til_njc_job_id = pi_njc_job_id
             AND
               til.til_iit_ne_id = pi_iit_ne_id);

    l_retval := TRUE;

  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := FALSE;

  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'v');

  RETURN l_retval;

END job_is_affecting_inv_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_job_element_lock(pi_ne_id IN nm_elements.ne_id%TYPE
                                ) IS

  e_item_locked EXCEPTION;

  l_job_id_tab nm3type.tab_number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_job_element_lock');

  l_job_id_tab := get_active_nw_locking_jobs;

  FOR l_i IN 1..l_job_id_tab.COUNT
  LOOP
    IF job_is_affecting_element(pi_njc_job_id => l_job_id_tab(l_i)
                               ,pi_ne_id      => pi_ne_id)
    THEN
      RAISE e_item_locked;
    END IF;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_job_element_lock');

EXCEPTION
  WHEN e_item_locked
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 280);

END check_job_element_lock;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_job_inv_item_lock(pi_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE
                                 ,pi_inv_type  IN nm_inv_types.nit_inv_type%TYPE DEFAULT NULL
                                 ) IS

  e_item_locked EXCEPTION;

  l_job_id_tab nm3type.tab_number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_job_inv_item_lock');


  l_job_id_tab := get_active_inv_locking_jobs(pi_iit_ne_id => pi_iit_ne_id
                                             ,pi_inv_type  => pi_inv_type);

  FOR l_i IN 1..l_job_id_tab.COUNT
  LOOP
    IF job_is_affecting_inv_item(pi_njc_job_id => l_job_id_tab(l_i)
                                ,pi_iit_ne_id  => pi_iit_ne_id)
    THEN
      RAISE e_item_locked;
    END IF;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_job_inv_item_lock');

EXCEPTION
  WHEN e_item_locked
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 280);

END check_job_inv_item_lock;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_job_member_lock(pi_nm_type     IN nm_members.nm_type%TYPE
                               ,pi_nm_ne_id_in IN nm_members.nm_ne_id_in%TYPE
                               ,pi_nm_ne_id_of IN nm_members.nm_ne_id_of%TYPE
                               ) IS

  e_item_locked EXCEPTION;

  l_job_id_tab nm3type.tab_number;

  l_dummy pls_integer;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_job_member_lock');

  IF pi_nm_type = 'G'
  THEN
    check_job_element_lock(pi_ne_id => pi_nm_ne_id_of);

  ELSIF pi_nm_type = 'I'
  THEN
    IF nm3homo.g_homo_touch_flag
    THEN
      check_job_inv_item_lock(pi_iit_ne_id => pi_nm_ne_id_in);
    END IF;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_job_member_lock');

EXCEPTION
  WHEN e_item_locked
  THEN
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 280);

END check_job_member_lock;
--
-----------------------------------------------------------------------------
--
END nm3job;
/
