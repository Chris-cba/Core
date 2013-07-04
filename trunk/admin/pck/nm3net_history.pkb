CREATE OR REPLACE PACKAGE BODY nm3net_history AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3net_history.pkb-arc   2.1   Jul 04 2013 16:19:16   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3net_history.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:19:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       PVCS Version     : $Revision:   2.1  $
--       Based on
--
--
--   Author : Kevin Angus
--
--   nm3net_history body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"$Revision:   2.1  $"';

  g_package_name CONSTANT varchar2(30) := 'nm3net_history';
  
  c_nl constant varchar2(1) := chr(10);
  
  -----------
  --variables
  -----------
  g_audit_member_edits boolean := TRUE;
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
--                    ,
FUNCTION value_has_changed(pi_old_value in number
                          ,pi_new_value in number
                          ) RETURN boolean IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'value_has_changed');
                     
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'value_has_changed');

  return     (pi_old_value is null and pi_new_value is not null)
          OR (pi_old_value is NOT null and pi_new_value is null)
          OR (pi_old_value <> pi_new_value);

END value_has_changed;
--
-----------------------------------------------------------------------------
--
PROCEDURE audit_member_mp_edit(pi_nm_ne_id_in   in nm_members_all.nm_ne_id_in%type
                              ,pi_nm_ne_id_of   in nm_members_all.nm_ne_id_of%type
                              ,pi_nm_begin_mp   in nm_members_all.nm_begin_mp%TYPE
                              ,pi_nm_start_date in nm_members_all.nm_start_date%type
                              ) IS

  l_neh_rec nm_element_history%rowtype;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'audit_member_mp_edit');

  --create history record
  l_neh_rec.neh_id             := nm3seq.next_neh_id_seq;
  l_neh_rec.neh_ne_id_old      := pi_nm_ne_id_in;
  l_neh_rec.neh_ne_id_new      := pi_nm_ne_id_in;
  l_neh_rec.neh_operation      := c_neh_op_edit;
  l_neh_rec.neh_effective_date := pi_nm_start_date;
  l_neh_rec.neh_old_ne_length  := NULL;
  l_neh_rec.neh_new_ne_length  := NULL;
  l_neh_rec.neh_param_1        := pi_nm_ne_id_of;
  l_neh_rec.neh_param_2        := pi_nm_begin_mp;
   
  nm3ins.ins_neh(p_rec_neh => l_neh_rec);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'audit_member_mp_edit');

END audit_member_mp_edit;
--
-----------------------------------------------------------------------------
--
PROCEDURE cascade_neh_delete(pi_neh_id        in nm_element_history.neh_id%type
                            ,pi_neh_ne_id_old in nm_element_history.neh_ne_id_old%type
                            ,pi_neh_ne_id_new in nm_element_history.neh_ne_id_new%type
                            ) IS

  l_sql nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'cascade_neh_delete');

  -----------------------
  --delete member history
  -----------------------
  delete
    nm_member_history nmh
  where
    nmh.nmh_nm_ne_id_of_old = pi_neh_ne_id_old
  and
    nmh.nmh_nm_ne_id_of_new = pi_neh_ne_id_new;
    
  -----------------------------
  --delete ACC location history
  -----------------------------
  if hig.is_product_licensed(pi_product => nm3type.c_acc)
  then
    l_sql :=            'DELETE'
             || c_nl || '  acc_location_history alh'
             || c_nl || 'WHERE'
             || c_nl || '  alh.alh_ne_id_old = :p_ne_id_old'
             || c_nl || 'AND'
             || c_nl || '  alh.alh_ne_id_new = :p_ne_id_new';
  
    execute immediate l_sql using pi_neh_ne_id_old, pi_neh_ne_id_new;
  end if;
  
  -----------------------------
  --delete STP location history
  -----------------------------
  if hig.is_product_licensed(pi_product => nm3type.c_stp)
  then
    l_sql :=            'DELETE'
             || c_nl || '  stp_scheme_loc_datum_history ssldh'
             || c_nl || 'WHERE'
             || c_nl || '  ssldh.ssldh_ne_id_old = :p_ne_id_old'
             || c_nl || 'AND'
             || c_nl || '  ssldh.ssldh_ne_id_new = :p_ne_id_new';
  
    execute immediate l_sql using pi_neh_ne_id_old, pi_neh_ne_id_new;
  end if;
  
  -----------------------------
  --delete STR location history
  -----------------------------
  if hig.is_product_licensed(pi_product => nm3type.c_str)
  then
    l_sql :=            'DELETE'
             || c_nl || '  road_int_history rih'
             || c_nl || 'WHERE'
             || c_nl || '  rih.rih_ne_id_old = :p_ne_id_old'
             || c_nl || 'AND'
             || c_nl || '  rih.rih_ne_id_new = :p_ne_id_new';
  
    execute immediate l_sql using pi_neh_ne_id_old, pi_neh_ne_id_new;
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'cascade_neh_delete');

END cascade_neh_delete;
--
-----------------------------------------------------------------------------
--
FUNCTION get_history_for_element(pi_ne_id in nm_elements.ne_id%type
                                ) RETURN t_neh_rec_arr IS

  l_retval t_neh_rec_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_history_for_element');

  select
    neh.*
  bulk collect into
    l_retval  
  from
    nm_element_history neh
  where
    neh.neh_ne_id_old = pi_ne_id
  order by
    neh.neh_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_history_for_element');

  RETURN l_retval;

END get_history_for_element;
--
-----------------------------------------------------------------------------
--
FUNCTION get_neh_for_closing_op(pi_ne_id in nm_elements.ne_id%type
                                ) RETURN t_neh_rec_arr IS

  l_retval t_neh_rec_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_neh_for_closing_op');

  select
    neh.*
  bulk collect into
    l_retval
  from
    nm_element_history neh
  where
    neh.neh_ne_id_old = pi_ne_id
  and
    neh.neh_ne_id_old <> neh.neh_ne_id_new
  order by
    neh.neh_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_neh_for_closing_op');

  RETURN l_retval;

END get_neh_for_closing_op;
--
-----------------------------------------------------------------------------
--
FUNCTION get_neh_for_non_closing_ops(pi_ne_id nm_elements.ne_id%TYPE
                                    ) RETURN t_neh_rec_arr IS

  l_retval t_neh_rec_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_neh_for_non_closing_ops');

  SELECT
    neh.*
  BULK COLLECT INTO
    l_retval
  FROM
    nm_element_history neh
  WHERE
    neh.neh_ne_id_old = pi_ne_id
  AND
    neh.neh_operation IN (c_neh_op_recalibrate
                         ,c_neh_op_shift)
  order by
    neh.neh_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_neh_for_non_closing_ops');

  RETURN l_retval;

END get_neh_for_non_closing_ops;
--
-----------------------------------------------------------------------------
--
FUNCTION auditing_member_edits RETURN boolean IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'auditing_member_edits');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'auditing_member_edits');

  RETURN g_audit_member_edits;

END auditing_member_edits;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_auditing_member_edits(pi_setting IN boolean DEFAULT TRUE
                                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_auditing_member_edits');

  g_audit_member_edits := NVL(pi_setting, TRUE);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_auditing_member_edits');

END set_auditing_member_edits;
--
-----------------------------------------------------------------------------
--
FUNCTION edit_creates_new_element(pi_neh_operation in nm_element_history.neh_operation%type
                                 ) RETURN boolean IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'edit_creates_new_element');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'edit_creates_new_element');

  return pi_neh_operation in (c_neh_op_split
                             ,c_neh_op_merge
                             ,c_neh_op_replace
                             ,c_neh_op_close
                             ,c_neh_op_reclassify
                             ,c_neh_op_reverse);

END edit_creates_new_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_edited_datums_in_nte(pi_nte_id               IN     nm_nw_temp_extents.nte_job_id%TYPE
                                  ,po_edited_ne_id_arr        OUT nm3net_history.t_neh_ne_id_old_arr
                                  ,po_edited_operation_arr    out nm3net_history.t_neh_operation_arr
                                  ,po_edited_date_arr         OUT nm3net_history.t_neh_effective_date_arr
                                  ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_edited_datums_in_nte');

  SELECT DISTINCT
    neh.neh_ne_id_old,
    neh.neh_effective_date,
    neh.neh_operation
  BULK COLLECT INTO
    po_edited_ne_id_arr,
    po_edited_date_arr,
    po_edited_operation_arr
  FROM
    nm_nw_temp_extents nte,
    nm_element_history neh
  WHERE
    nte.nte_job_id = pi_nte_id
  AND
    nte.nte_ne_id_of = neh.neh_ne_id_old
  AND
    neh.neh_operation IN (c_neh_op_split
                         ,c_neh_op_merge
                         ,c_neh_op_replace
                         ,c_neh_op_close
                         ,c_neh_op_reclassify
                         ,c_neh_op_reverse);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_edited_datums_in_nte');

END get_edited_datums_in_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION nte_has_non_blocking_edits(pi_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                                   ) RETURN boolean IS

  l_edited_ne_id_arr     nm3net_history.t_neh_ne_id_old_arr;
  l_edited_operation_arr nm3net_history.t_neh_operation_arr;
  l_edited_date_arr      nm3net_history.t_neh_effective_date_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'nte_has_non_blocking_edits');

  get_edited_datums_in_nte(pi_nte_id               => pi_nte_job_id
                          ,po_edited_ne_id_arr     => l_edited_ne_id_arr
                          ,po_edited_operation_arr => l_edited_operation_arr
                          ,po_edited_date_arr      => l_edited_date_arr);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'nte_has_non_blocking_edits');

  RETURN l_edited_ne_id_arr.count > 0;

END nte_has_non_blocking_edits;
--
-----------------------------------------------------------------------------
--
FUNCTION nte_has_blocking_edits(pi_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                               ) RETURN BOOLEAN IS

  l_retval BOOLEAN;

  l_int PLS_INTEGER;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'nte_has_blocking_edits');

  BEGIN
    SELECT
      1
    INTO
      l_int
    FROM
      dual
    WHERE
      EXISTS (SELECT
                1
              FROM
                nm_nw_temp_extents nte,
                nm_element_history neh
              WHERE
                nte.nte_job_id = pi_nte_job_id
              AND
                nte.nte_ne_id_of = neh.neh_ne_id_old
              AND
                neh.neh_operation IN (c_neh_op_recalibrate
                                     ,c_neh_op_shift
                                     ,c_neh_op_edit));

    l_retval := TRUE;
    
  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := FALSE;  
  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'nte_has_blocking_edits');

  RETURN l_retval;

END nte_has_blocking_edits;
--
-----------------------------------------------------------------------------
--
function group_has_blocking_edits(pi_ne_id in nm_elements.ne_id%type
                                 ) return boolean IS

 l_retval boolean;
 
 l_int PLS_INTEGER;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'group_has_blocking_edits');

  BEGIN
    SELECT
      1
    INTO
      l_int
    FROM
      dual
    WHERE
      EXISTS (SELECT
                1
              FROM
                nm_element_history neh,
                nm_members         nm
              WHERE
                neh.neh_ne_id_old = pi_ne_id
              and
                neh.neh_operation = c_neh_op_edit
              AND
                nm.nm_ne_id_in = pi_ne_id
              and
                neh.neh_param_1 = nm.nm_ne_id_of
              and
                neh.neh_param_2 = nm.nm_begin_mp);

    l_retval := TRUE;
    
  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := FALSE;  
  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'group_has_blocking_edits');

  return l_retval;

END group_has_blocking_edits;
--
-----------------------------------------------------------------------------
--
END nm3net_history;
/


