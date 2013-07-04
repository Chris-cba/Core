CREATE OR REPLACE PACKAGE BODY nm3asset_set AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3asset_set.pkb-arc   2.2   Jul 04 2013 15:15:40   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3asset_set.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:40  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 
--
--   Author : Kevin Angus
--
--   nm3asset_set body
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
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';

  g_package_name CONSTANT varchar2(30) := 'nm3asset_set';
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
FUNCTION create_header(pi_descr IN nm_inv_attribute_sets.nias_descr%TYPE
                      ) RETURN nm_inv_attribute_sets.nias_id%TYPE IS

  l_nias_rec nm_inv_attribute_sets%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_header');

  l_nias_rec.nias_id    := nm3seq.next_nias_id_seq;
  l_nias_rec.nias_descr := pi_descr;
  
  nm3ins.ins_nias(p_rec_nias => l_nias_rec);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_header');

  RETURN l_nias_rec.nias_id;

END create_header;
--
-----------------------------------------------------------------------------
--
FUNCTION create_set_from_pbi(pi_npq_id IN nm_pbi_query.npq_id%TYPE
                            ,pi_descr  IN nm_inv_attribute_sets.nias_descr%TYPE
                            ) RETURN nm_inv_attribute_sets.nias_id%TYPE IS

  l_nias_id nm_inv_attribute_sets.nias_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_set_from_pbi');

  --------
  --header
  --------
  l_nias_id := create_header(pi_descr => pi_descr);

  -------
  --types
  -------
  INSERT INTO
    nm_inv_attribute_set_inv_types(nsit_nias_id 
                                  ,nsit_nit_inv_type)
  SELECT
    l_nias_id,
    nqt.nqt_item_type
  FROM
    nm_pbi_query_types nqt
  WHERE
    nqt.nqt_npq_id = pi_npq_id
  AND
    nqt.nqt_item_type_type = 'I'
  GROUP BY
    nqt.nqt_item_type;
    
  ------------
  --attributes
  ------------
  INSERT INTO
    nm_inv_attribute_set_inv_attr(nsia_nsit_nias_id
                                 ,nsia_nsit_nit_inv_type
                                 ,nsia_ita_attrib_name)
  SELECT
    l_nias_id,
    nqt.nqt_item_type,
    nqa.nqa_attrib_name
  FROM
    nm_pbi_query_attribs nqa,
    nm_pbi_query_types   nqt
  WHERE
    nqt.nqt_npq_id = pi_npq_id
  AND
    nqt.nqt_item_type_type = 'I'
  AND
    nqt.nqt_npq_id = nqa.nqa_npq_id
  AND
    nqt.nqt_seq_no = nqa.nqa_nqt_seq_no
  GROUP BY
    nqt.nqt_item_type,
    nqa.nqa_attrib_name;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_set_from_pbi');

  RETURN l_nias_id;

END create_set_from_pbi;
--
-----------------------------------------------------------------------------
--
FUNCTION create_set_from_mrg(pi_nmq_id IN nm_mrg_query.nmq_id%TYPE
                            ,pi_descr  IN nm_inv_attribute_sets.nias_descr%TYPE
                            ) RETURN nm_inv_attribute_sets.nias_id%TYPE IS

  l_nias_id nm_inv_attribute_sets.nias_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_set_from_mrg');

  --------
  --header
  --------
  l_nias_id := create_header(pi_descr => pi_descr);

  -------
  --types
  -------
  INSERT INTO
    nm_inv_attribute_set_inv_types(nsit_nias_id 
                                  ,nsit_nit_inv_type)
  SELECT
    l_nias_id,
    nqt.nqt_inv_type
  FROM
    nm_mrg_query_types nqt
  WHERE
    nqt.nqt_nmq_id = pi_nmq_id
  GROUP BY
    nqt.nqt_inv_type;
    
  ------------
  --attributes
  ------------
  INSERT INTO
    nm_inv_attribute_set_inv_attr(nsia_nsit_nias_id
                                 ,nsia_nsit_nit_inv_type
                                 ,nsia_ita_attrib_name)
  SELECT
    l_nias_id,
    nqt.nqt_inv_type,
    nqa.nqa_attrib_name
  FROM
    nm_mrg_query_attribs nqa,
    nm_mrg_query_types   nqt
  WHERE
    nqt.nqt_nmq_id = pi_nmq_id
  AND
    nqt.nqt_nmq_id = nqa.nqa_nmq_id
  AND
    nqt.nqt_seq_no = nqa.nqa_nqt_seq_no
  GROUP BY
    nqt.nqt_inv_type,
    nqa.nqa_attrib_name;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_set_from_mrg');

  RETURN l_nias_id;

END create_set_from_mrg;
--
-----------------------------------------------------------------------------
--
FUNCTION create_set(pi_source_id IN number
                   ,pi_source    IN varchar2
                   ,pi_descr     IN nm_inv_attribute_sets.nias_descr%TYPE
                   ) RETURN nm_inv_attribute_sets.nias_id%TYPE IS

  l_retval nm_inv_attribute_sets.nias_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_set');

  IF pi_source = c_source_pbi
  THEN
    l_retval := create_set_from_pbi(pi_npq_id => pi_source_id
                                   ,pi_descr  => pi_descr);
    
  ELSIF pi_source = c_source_mrg
  THEN
    l_retval := create_set_from_mrg(pi_nmq_id => pi_source_id
                                   ,pi_descr  => pi_descr);
  ELSE
    --invalid source
    hig.raise_ner(pi_appl               => nm3type.c_hig
                 ,pi_id                 => 110
                 ,pi_supplementary_info => g_package_name || '.create_set(pi_source => ' || pi_source || ')');
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_set');

  RETURN l_retval;

END create_set;
--
-----------------------------------------------------------------------------
--
FUNCTION get_source_pbi RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_source_pbi');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_source_pbi');

  RETURN c_source_pbi;

END get_source_pbi;
--
-----------------------------------------------------------------------------
--
FUNCTION get_source_mrg RETURN varchar2 IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_source_mrg');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_source_mrg');

  RETURN c_source_mrg;

END get_source_mrg;
--
-----------------------------------------------------------------------------
--
END nm3asset_set;
/
