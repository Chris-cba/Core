CREATE OR REPLACE PACKAGE BODY nm3disco AS
--
-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3disco.pkb-arc   2.3   Jul 04 2013 15:33:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3disco.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:33:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version :  1.2
--
--   Author : Kevin Angus
--
--   nm3disco body
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
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.3  $';

  g_package_name            CONSTANT varchar2(30) := 'nm3disco';

   c_run_mode_option         CONSTANT hig_options.hop_id%TYPE := 'DISCO_MODE';
   c_web_run_mode_option     CONSTANT hig_options.hop_id%TYPE := 'DISCWEBMOD';
   c_web_host_option         CONSTANT hig_options.hop_id%TYPE := 'DISWEBHOST';
   c_web_path_option         CONSTANT hig_options.hop_id%TYPE := 'DISWEBPATH';
   c_web_brand_img_option    CONSTANT hig_options.hop_id%TYPE := 'DISBRNDIMG';
   c_web_frame_style_option  CONSTANT hig_options.hop_id%TYPE := 'DISFRMSTYL';
   c_web_win_width_option    CONSTANT hig_options.hop_id%TYPE := 'DISWINWDTH';
   c_web_win_height_option   CONSTANT hig_options.hop_id%TYPE := 'DISWINHGHT';
   c_password_visible_option CONSTANT hig_options.hop_id%TYPE := 'DISPWDVIS';

  c_run_mode_web            CONSTANT hig_option_values.hov_value%TYPE := 'WEB';
  c_web_run_mode_viewer     CONSTANT hig_option_values.hov_value%TYPE := 'VIEWER';
  c_run_mode_local          CONSTANT hig_option_values.hov_value%TYPE := 'LOCAL';

  c_ui_web                  CONSTANT varchar2(3) := 'WEB';

  c_ampersand               CONSTANT varchar2(1) := CHR(38);

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
FUNCTION get_run_command(pi_module         IN hig_modules.hmo_module%TYPE
                        ,pi_param_name     IN varchar2 DEFAULT NULL
                        ,pi_param_value    IN varchar2 DEFAULT NULL
                        ,pi_user_interface IN varchar2
                        ,pi_disco_exe      IN varchar2
                        ,pi_user           IN hig_users.hus_username%TYPE
                        ,pi_password       IN varchar2
                        ,pi_tns            IN varchar2
                        ) RETURN varchar2 IS

   e_invalid_run_mode EXCEPTION;
   e_local_on_web     EXCEPTION;
   e_no_web_path      EXCEPTION;
   e_no_exe_name      EXCEPTION;

   c_connect         CONSTANT varchar2(2000) := pi_user || '/' || pi_password || '@' || pi_tns;

   c_browser_command CONSTANT varchar2(2000) := nm3web.get_browser_cmd;

   l_run_mode varchar2(10);

   l_connector varchar2(1) := '?';

  l_disco_host nm3type.max_varchar2;
   l_disco_path nm3type.max_varchar2;

   l_web_brand_image_path nm3type.max_varchar2;
   l_web_frame_style      nm3type.max_varchar2;
   l_web_win_width        nm3type.max_varchar2;
   l_web_win_height       nm3type.max_varchar2;
   l_web_run_viewer       BOOLEAN;

   l_disco_command nm3type.max_varchar2;
--
   l_connect VARCHAR2(30);
   l_opendb  VARCHAR2(30);
   l_module  hig_modules.hmo_filename%TYPE;
--
BEGIN
  --------------------------------------------------------
  --get run mode, first looking at user option then system
  --------------------------------------------------------
  l_run_mode := hig.get_user_or_sys_opt(pi_option => c_run_mode_option);

   IF l_run_mode IS NULL
   THEN
     RAISE e_invalid_run_mode;
   END IF;

  IF l_run_mode = c_run_mode_web
  THEN
    ------------------------
    --run Discoverer via web
    ------------------------
    l_disco_host           := hig.get_sysopt(p_option_id => c_web_host_option);
    l_disco_path           := hig.get_sysopt(p_option_id => c_web_path_option);
    l_web_brand_image_path := hig.get_sysopt(p_option_id => c_web_brand_img_option);
    l_web_run_viewer       := hig.get_sysopt(p_option_id => c_web_run_mode_option) = c_web_run_mode_viewer;

    l_web_frame_style      := hig.get_user_or_sys_opt(pi_option => c_web_frame_style_option);
    l_web_win_width        := hig.get_user_or_sys_opt(pi_option => c_web_win_width_option);
    l_web_win_height       := hig.get_user_or_sys_opt(pi_option => c_web_win_height_option);

    IF l_disco_host IS NULL
       OR l_disco_path IS NULL
    THEN
      RAISE e_no_web_path;
    END IF;
--
    IF l_web_run_viewer
     THEN
       l_connect := 'us';
       l_opendb  := 'wb';
    ELSE
       l_connect := 'connect';
       l_opendb  := 'opendb';
    END IF;
--
    l_disco_command :=    l_disco_host
                       || l_disco_path;
--
    IF INSTR(l_disco_command,'?',1,1) != 0
     THEN
      l_connector := c_ampersand;
    END IF;
--
    IF NVL(hig.get_sysopt(p_option_id => c_password_visible_option), 'Y') = 'Y'
    THEN
      l_disco_command :=    l_disco_command
                         || l_connector ||l_connect|| '=' || c_connect;
      l_connector := c_ampersand;
    END IF;

    IF   l_web_run_viewer
     AND UPPER(nm3flx.left(pi_module,LENGTH(Sys_Context('NM3_SECURITY_CTX','USERNAME')))) = Sys_Context('NM3_SECURITY_CTX','USERNAME')
     THEN
       l_module := SUBSTR(pi_module,LENGTH(Sys_Context('NM3_SECURITY_CTX','USERNAME'))+2);
    ELSE
       l_module := pi_module;
    END IF;
    l_disco_command :=    l_disco_command
                       || l_connector ||l_opendb|| '=' || l_module;

    IF pi_param_name IS NOT NULL
      THEN
       l_disco_command :=    l_disco_command
                          || c_ampersand || 'param_' || pi_param_name || '=' || pi_param_value;
    END IF;

    IF l_web_frame_style IS NOT NULL
    THEN
      l_disco_command :=    l_disco_command
                          || c_ampersand || 'FrameDisplayStyle=' || l_web_frame_style;
    END IF;

    IF l_web_win_width IS NOT NULL
    THEN
      l_disco_command :=    l_disco_command
                          || c_ampersand || 'WindowWidth=' || l_web_win_width;
    END IF;

    IF l_web_win_height IS NOT NULL
    THEN
      l_disco_command :=    l_disco_command
                          || c_ampersand || 'WindowHeight=' || l_web_win_height;
    END IF;

    IF l_web_brand_image_path IS NOT NULL
    THEN
      l_disco_command :=    l_disco_command
                          || c_ampersand || 'BrandImage=' || l_web_brand_image_path;
    END IF;

     l_disco_command := nm3web.string_to_url(pi_str              => l_disco_command
                                           ,pi_leave_ampersands => TRUE);

    IF pi_user_interface <> c_ui_web
    THEN
      l_disco_command :=    c_browser_command
                         || '"'
                         || l_disco_command
                         || '"';
    END IF;

  ELSIF l_run_mode = c_run_mode_local
  THEN
     IF pi_user_interface = c_ui_web
     THEN
       RAISE e_local_on_web;
     END IF;

     ------------------------------
     --run discoverer client server
     ------------------------------
    IF pi_disco_exe IS NULL
    THEN
      RAISE e_no_exe_name;
    END IF;

    l_disco_command :=    pi_disco_exe || ' '|| pi_module
                       || ' /connect ' || c_connect;

      IF pi_param_name IS NOT NULL
      THEN
         l_disco_command :=    l_disco_command
                            || ' /PARAMETER ' || pi_param_name || ' ' || pi_param_value;
      END IF;
  ELSE
     RAISE e_invalid_run_mode;
  END IF;

  RETURN l_disco_command;

EXCEPTION
  WHEN e_invalid_run_mode
  THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 127);

  WHEN e_local_on_web
  THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 128);

  WHEN e_no_web_path
  THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 129);

  WHEN e_no_exe_name
  THEN
    hig.raise_ner(pi_appl => nm3type.c_hig
                 ,pi_id   => 130);

END;
--
-----------------------------------------------------------------------------
--
END nm3disco;
/
