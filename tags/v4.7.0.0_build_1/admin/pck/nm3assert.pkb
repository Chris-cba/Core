CREATE OR REPLACE PACKAGE BODY nm3assert AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3assert.pkb-arc   2.2   Jul 04 2013 15:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3assert.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--
--   Author : Kevin Angus
--
--   nm3assert body
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

  g_package_name CONSTANT varchar2(30) := 'nm3assert';
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
PROCEDURE isnotnull(pi_val IN varchar2
                   ,pi_msg IN varchar2 DEFAULT NULL
                    ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'isnotnull');

  condition(pi_condition  => pi_val IS NOT NULL
           ,pi_ner_appl   => nm3type.c_hig
           ,pi_ner_id     => 214
           ,pi_suppl_info => pi_msg);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'isnotnull');

END isnotnull;
--
-----------------------------------------------------------------------------
--
PROCEDURE inrange(pi_val      IN date
                 ,pi_low_val  IN date
                 ,pi_high_val IN date
                 ,pi_msg      IN varchar2 DEFAULT NULL
                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inrange');

  condition(pi_condition  => TRUNC(pi_val) BETWEEN TRUNC(pi_low_val) AND TRUNC(pi_high_val)
           ,pi_ner_appl   => nm3type.c_net
           ,pi_ner_id     => 29
           ,pi_suppl_info => pi_msg || ': ' || TO_CHAR(pi_val, nm3type.c_default_date_format)
                             || ' (' || TO_CHAR(pi_low_val, nm3type.c_default_date_format)
                             || ' -> '
                             || TO_CHAR(pi_high_val, nm3type.c_default_date_format) || ')');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inrange');

END inrange;
--
-----------------------------------------------------------------------------
--
PROCEDURE inrange(pi_val      IN number
                 ,pi_low_val  IN number
                 ,pi_high_val IN number
                 ,pi_msg      IN varchar2 DEFAULT NULL
                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inrange');

  condition(pi_condition  => pi_val BETWEEN pi_low_val AND pi_high_val
           ,pi_ner_appl   => nm3type.c_net
           ,pi_ner_id     => 29
           ,pi_suppl_info => pi_msg || ': ' || TO_CHAR(pi_val)
                             || ' (' || TO_CHAR(pi_low_val)
                             || ' -> '
                             || TO_CHAR(pi_high_val) || ')');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inrange');

END inrange;
--
-----------------------------------------------------------------------------
--
PROCEDURE condition(pi_condition  IN boolean
                   ,pi_ner_appl   IN nm_errors.ner_appl%TYPE DEFAULT g_default_ner_appl
                   ,pi_ner_id     IN nm_errors.ner_id%TYPE DEFAULT g_default_ner_id
                   ,pi_suppl_info IN varchar2 DEFAULT NULL
                   ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'condition');

  IF NOT pi_condition
    OR pi_condition IS NULL
  THEN
    hig.raise_ner(pi_appl               => pi_ner_appl
                 ,pi_id                 => pi_ner_id
                 ,pi_supplementary_info => pi_suppl_info);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'condition');

END condition;
--
-----------------------------------------------------------------------------
--
END nm3assert;
/
