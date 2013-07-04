CREATE OR REPLACE PACKAGE BODY nm3va AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3va.pkb-arc   2.2   Jul 04 2013 16:35:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3va.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--   Author : Kevin Angus
--
--   nm3va body
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

  g_package_name CONSTANT varchar2(30) := 'nm3va';
  
  c_rgb_to_percent_factor CONSTANT number := 100/255;
  c_percent_to_rgb_factor CONSTANT number := 1/c_rgb_to_percent_factor;
  
  c_default_nfp_id CONSTANT nm_fill_patterns.nfp_id%TYPE := 'TRANSPARENT';
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
FUNCTION get_default_settings RETURN t_nva_tab IS

  l_retval t_nva_tab;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_default_settings');

  FOR l_rec IN (SELECT
                  *
                FROM
                  nm_visual_attributes)
  LOOP
    l_retval(l_retval.COUNT + 1) := l_rec;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_default_settings');

  RETURN l_retval;

END get_default_settings;
--
-----------------------------------------------------------------------------
--
FUNCTION get_intensities_from_va_colour(pi_va_colour IN t_va_colour
                                       ,pi_scale     IN boolean DEFAULT TRUE
                                       ) RETURN t_rgb_rec IS

  l_retval t_rgb_rec;
  
  l_va_colour varchar2(100) := UPPER(pi_va_colour);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_intensities_from_va_colour');
  
  IF pi_va_colour IS NOT NULL
  THEN
    l_retval.red   := TRUNC(SUBSTR(l_va_colour, 2, INSTR(l_va_colour, 'G') - 2));
    l_retval.green := TRUNC(SUBSTR(l_va_colour, INSTR(l_va_colour, 'G') +  1, INSTR(l_va_colour, 'B') - (INSTR(l_va_colour, 'G') + 1)));
    l_retval.blue  := TRUNC(SUBSTR(l_va_colour, INSTR(l_va_colour, 'B') + 1));
    
    IF pi_scale
    THEN
      l_retval.red   := l_retval.red   * c_rgb_to_percent_factor;
      l_retval.green := l_retval.green * c_rgb_to_percent_factor;
      l_retval.blue  := l_retval.blue  * c_rgb_to_percent_factor;
    END IF;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_intensities_from_va_colour');
  
  RETURN l_retval;
  
END get_intensities_from_va_colour;
--
-----------------------------------------------------------------------------
--
FUNCTION get_va_colour_from_intensities(pi_rgb_rec IN t_rgb_rec
                                       ,pi_scale   IN boolean DEFAULT TRUE
                                       ) RETURN t_va_colour IS

  l_rgb_rec t_rgb_rec;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_va_colour_from_intensities');
                     
  IF pi_scale
  THEN
    l_rgb_rec.red   := TRUNC(pi_rgb_rec.red   * c_percent_to_rgb_factor);
    l_rgb_rec.green := TRUNC(pi_rgb_rec.green * c_percent_to_rgb_factor);
    l_rgb_rec.blue  := TRUNC(pi_rgb_rec.blue  * c_percent_to_rgb_factor);
  ELSE
    l_rgb_rec.red   := pi_rgb_rec.red;
    l_rgb_rec.green := pi_rgb_rec.green;
    l_rgb_rec.blue  := pi_rgb_rec.blue;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_va_colour_from_intensities');
  
  RETURN    'r' || l_rgb_rec.red
         || 'g' || l_rgb_rec.green
         || 'b' || l_rgb_rec.blue;

END get_va_colour_from_intensities;
--
-----------------------------------------------------------------------------
--
FUNCTION scale_va_colour_to_rgb(pi_va_colour IN varchar2
                               ) RETURN t_va_colour IS

  l_rgb_rec t_rgb_rec;

  l_retval t_va_colour;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'scale_va_colour_to_rgb');

  l_rgb_rec := get_intensities_from_va_colour(pi_va_colour => pi_va_colour
                                             ,pi_scale     => FALSE);

  l_retval := get_va_colour_from_intensities(pi_rgb_rec => l_rgb_rec);
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'scale_va_colour_to_rgb');

  RETURN l_retval;

END scale_va_colour_to_rgb;
--
-----------------------------------------------------------------------------
--
FUNCTION scale_va_colour_to_pcnt(pi_va_colour IN varchar2
                                ) RETURN t_va_colour IS

  l_rgb_rec t_rgb_rec;

  l_retval t_va_colour;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'scale_va_colour_to_pcnt');

  l_rgb_rec := get_intensities_from_va_colour(pi_va_colour => pi_va_colour);

  l_retval := get_va_colour_from_intensities(pi_rgb_rec => l_rgb_rec
                                            ,pi_scale   => FALSE);
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'scale_va_colour_to_pcnt');

  RETURN l_retval;

END scale_va_colour_to_pcnt;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_nfp_id RETURN nm_fill_patterns.nfp_id%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_default_nfp_id');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_default_nfp_id');

  RETURN c_default_nfp_id;

END get_default_nfp_id;
--
-----------------------------------------------------------------------------
--
END nm3va;
/
