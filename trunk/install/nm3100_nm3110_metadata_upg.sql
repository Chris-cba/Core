REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)nm3100_nm3110_metadata_upg.sql	1.21 07/08/04

SET FEEDBACK OFF
--
DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
     Null;
END;
/
----------------------------------------------------------------------------
--Call a proc in nm_debug to instantiate it before calling metadata scripts.
--
--If this is not done any inserts into hig_option_values may fail due to
-- mutating trigger when nm_debug checks DEBUGAUTON.
----------------------------------------------------------------------------
BEGIN
  nm_debug.debug_off;
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
   --
   -- NM_ERRORS
   --
   l_tab_ner_id    nm3type.tab_number;
   l_tab_ner_descr nm3type.tab_varchar2000;
   l_tab_appl      nm3type.tab_varchar30;
   --
   l_tab_dodgy_ner_id    nm3type.tab_number;
   l_tab_dodgy_ner_appl  nm3type.tab_varchar30;
   l_tab_dodgy_descr_old nm3type.tab_varchar2000;
   l_tab_dodgy_descr_new nm3type.tab_varchar2000;
   --
   l_current_type  nm_errors.ner_appl%TYPE;
   --
   PROCEDURE add_ner (p_ner_id    number
                     ,p_ner_descr varchar2
                     ,p_app       varchar2 DEFAULT l_current_type
                     ) IS
      c_count CONSTANT pls_integer := l_tab_ner_id.COUNT+1;
   BEGIN
      l_tab_ner_id(c_count)    := p_ner_id;
      l_tab_ner_descr(c_count) := p_ner_descr;
      l_tab_appl(c_count)      := p_app;
   END add_ner;
   --
   PROCEDURE add_dodgy (p_ner_id        number
                       ,p_ner_descr_old varchar2
                       ,p_ner_descr_new varchar2
                       ,p_app           varchar2 DEFAULT l_current_type
                       ) IS
      c_count CONSTANT pls_integer := l_tab_dodgy_ner_id.COUNT+1;
   BEGIN
      l_tab_dodgy_ner_id(c_count)    := p_ner_id;
      l_tab_dodgy_descr_old(c_count) := p_ner_descr_old;
      l_tab_dodgy_descr_new(c_count) := NVL(p_ner_descr_new,p_ner_descr_old);
      l_tab_dodgy_ner_appl(c_count)  := p_app;
   END add_dodgy;
   --
BEGIN
   --
   -- HIG errors
   --
   l_current_type := nm3type.c_hig;
   --
   add_ner(210, 'Switch Route Theme?');
   add_ner(211, 'Cannot Set Route Theme - Invalid Theme Type');
   add_ner(213, 'Assertion failed');
   add_ner(214, 'Value cannot be NULL');
   add_ner(215, 'Detail');
   add_ner(216, 'Close');
   add_ner(217, 'Select All');
   add_ner(218, 'Inverse Selection');
   add_ner(219, 'Refresh');   
   add_ner(220, 'You can only send email as your own user'); 
   add_ner(221, 'All mail messages should have at least 1 "TO" recipient');
   add_ner(222, 'Favourite cannot have the name as parent folder');   
   --
   -- NET errors
   --
   l_current_type := nm3type.c_net;
   --
   --add_ner(356, 'Inventory types used for group attributes must be continuous.');
   --
   --
   -- Fix dodgy NM_ERRORS records
   --
   l_current_type := nm3type.c_net;
   
   add_dodgy (p_ner_id        => 210
             ,p_ner_descr_old => 'No Unique Seq specified when network type is pop_unique'
             ,p_ner_descr_new => 'Warning: No Unique Seq specified when network type is pop_unique. Element uniques will be defaulted to the ne_id');

  add_dodgy (p_ner_id        => 115
             ,p_ner_descr_old => 'Only datum elements and base network routes can be reclassified.'
             ,p_ner_descr_new => 'Only datum elements and groups of sections can be reclassified.');

   FORALL i IN 1..l_tab_ner_id.COUNT
      INSERT INTO nm_errors
            (ner_appl
            ,ner_id
            ,ner_descr
            )
      SELECT l_tab_appl(i)
            ,l_tab_ner_id(i)
            ,l_tab_ner_descr(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  nm_errors
                         WHERE  ner_id   = l_tab_ner_id(i)
                          AND   ner_appl = l_tab_appl(i)
                        )
       AND   l_tab_ner_descr(i) IS NOT NULL;
   --
   FORALL i IN 1..l_tab_dodgy_ner_id.COUNT
      UPDATE nm_errors
       SET   ner_descr = l_tab_dodgy_descr_new (i)
      WHERE  ner_id    = l_tab_dodgy_ner_id(i)
       AND   ner_appl  = l_tab_dodgy_ner_appl(i)
       AND   ner_descr = l_tab_dodgy_descr_old(i);
   --
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
--  hig_sequence_associations
--   (hsa_table_name        VARCHAR2(30) NOT NULL
--   ,hsa_column_name       VARCHAR2(30) NOT NULL
--   ,hsa_sequence_name     VARCHAR2(30) NOT NULL
--
   l_tab_hsa_table_name     nm3type.tab_varchar30;
   l_tab_hsa_column_name    nm3type.tab_varchar30;
   l_tab_hsa_sequence_name  nm3type.tab_varchar30;
--
   PROCEDURE add_hsa (p_table VARCHAR2, p_col VARCHAR2, p_seq VARCHAR2) IS
      c_count CONSTANT PLS_INTEGER := l_tab_hsa_table_name.COUNT+1;
   BEGIN
      l_tab_hsa_table_name(c_count)    := p_table;
      l_tab_hsa_column_name(c_count)   := p_col;
      l_tab_hsa_sequence_name(c_count) := p_seq;
   END add_hsa;
--
BEGIN
--
   --add_hsa ('DOC_ACTIONS','DAC_ID','DAC_ID_SEQ');
    add_hsa('NM_ELEMENTS_ALL','NE_UNIQUE','ESU_ID_SEQ');
    add_hsa('NM_NSG_EXPORT','NXP_ID','NXP_ID_SEQ');
--
   FORALL i IN 1..l_tab_hsa_table_name.COUNT
      INSERT INTO hig_sequence_associations
            (hsa_table_name
            ,hsa_column_name
            ,hsa_sequence_name
            )
      SELECT l_tab_hsa_table_name(i)
            ,l_tab_hsa_column_name(i)
            ,l_tab_hsa_sequence_name(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_sequence_associations
                         WHERE  hsa_table_name  = l_tab_hsa_table_name(i)
                          AND   hsa_column_name = l_tab_hsa_column_name(i)
                        );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
--  HIG_CHECK_CONSTRAINT_ASSOCS
--
   l_tab_hcca_constraint_name nm3type.tab_varchar30;
   l_tab_hcca_table_name      nm3type.tab_varchar30;
   l_tab_hcca_ner_appl        nm3type.tab_varchar30;
   l_tab_hcca_ner_id          nm3type.tab_number;
--
   PROCEDURE add_hcca (p_hcca_constraint_name VARCHAR2
                      ,p_hcca_table_name      VARCHAR2
                      ,p_hcca_ner_appl        VARCHAR2
                      ,p_hcca_ner_id          VARCHAR2
                      ) IS
      c_count CONSTANT PLS_INTEGER := l_tab_hcca_constraint_name.COUNT+1;
   BEGIN
      l_tab_hcca_constraint_name(c_count) := p_hcca_constraint_name;
      l_tab_hcca_table_name(c_count)      := p_hcca_table_name;
      l_tab_hcca_ner_appl(c_count)        := p_hcca_ner_appl;
      l_tab_hcca_ner_id(c_count)          := p_hcca_ner_id;
   END add_hcca;
--
BEGIN
--
   add_hcca('HUF_CONNECT_LOOP_CHK', 'HIG_USER_FAVOURITES', nm3type.c_hig, 222);
   add_hcca('HSTF_CONNECT_LOOP_CHK', 'HIG_STANDARD_FAVOURITES', nm3type.c_hig, 222);
   add_hcca('HSF_CONNECT_LOOP_CHK', 'HIG_SYSTEM_FAVOURITES', nm3type.c_hig, 222);   
--
   FORALL i IN 1..l_tab_hcca_constraint_name.COUNT
      INSERT INTO hig_check_constraint_assocs
            (hcca_constraint_name
            ,hcca_table_name
            ,hcca_ner_appl
            ,hcca_ner_id
            )
      SELECT l_tab_hcca_constraint_name(i)
            ,l_tab_hcca_table_name(i)
            ,l_tab_hcca_ner_appl(i)
            ,l_tab_hcca_ner_id(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_check_constraint_assocs
                         WHERE  hcca_constraint_name = l_tab_hcca_constraint_name(i)
                        );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
--  HIG_MODULES and HIG_MODULE_ROLES
--
   TYPE tab_rec_module IS TABLE OF hig_modules%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_hmo     hig_modules%ROWTYPE;
   l_tab_rec_hmo tab_rec_module;
--
   l_tab_hmr_module nm3type.tab_varchar30;
   l_tab_hmr_role   nm3type.tab_varchar30;
   l_tab_hmr_mode   nm3type.tab_varchar30;
--
   l_hmo_count      PLS_INTEGER := 0;
   l_hmr_count      PLS_INTEGER := 0;
--
   PROCEDURE add_hmo IS
   BEGIN
      l_hmo_count := l_hmo_count + 1;
      l_tab_rec_hmo(l_hmo_count) := l_rec_hmo;
   END add_hmo;
--
   PROCEDURE add_hmr (p_role   VARCHAR2
                     ,p_mode   VARCHAR2
                     ,p_module VARCHAR2 DEFAULT l_rec_hmo.hmo_module
                     ) IS
   BEGIN
      l_hmr_count := l_hmr_count + 1;
      l_tab_hmr_module(l_hmr_count) := UPPER(p_module);
      l_tab_hmr_role(l_hmr_count)   := UPPER(p_role);
      l_tab_hmr_mode(l_hmr_count)   := UPPER(p_mode);
   END add_hmr;
--
BEGIN
--
  l_rec_hmo.hmo_module           := 'DOCWEB0010';
  l_rec_hmo.hmo_title            := 'Run Query';
  l_rec_hmo.hmo_filename         := 'dm3query.list_queries';
  l_rec_hmo.hmo_module_type      := 'WEB';
  l_rec_hmo.hmo_fastpath_opts    := Null;
  l_rec_hmo.hmo_fastpath_invalid := 'N';
  l_rec_hmo.hmo_use_gri          := 'N';
  l_rec_hmo.hmo_application      := 'DOC';
  l_rec_hmo.hmo_menu             := Null;
  add_hmo;
  add_hmr ('WEB_USER',nm3type.c_normal);
  
  l_rec_hmo.hmo_module           := 'NM0600';
  l_rec_hmo.hmo_title            := 'Maintain Element XRefs';
  l_rec_hmo.hmo_filename         := 'nm0600';
  l_rec_hmo.hmo_module_type      := 'FMX';
  l_rec_hmo.hmo_fastpath_opts    := Null;
  l_rec_hmo.hmo_fastpath_invalid := 'N';
  l_rec_hmo.hmo_use_gri          := 'N';
  l_rec_hmo.hmo_application      := 'NET';
  l_rec_hmo.hmo_menu             := 'FORM';
  add_hmo;
  add_hmr ('NET_ADMIN',nm3type.c_normal);
  
  l_rec_hmo.hmo_module           := 'NSG0020';
  l_rec_hmo.hmo_title            := 'NSG Export';
  l_rec_hmo.hmo_filename         := 'nsg0020';
  l_rec_hmo.hmo_module_type      := 'FMX';
  l_rec_hmo.hmo_fastpath_opts    := Null;
  l_rec_hmo.hmo_fastpath_invalid := 'N';
  l_rec_hmo.hmo_use_gri          := 'N';
  l_rec_hmo.hmo_application      := 'NSG';
  l_rec_hmo.hmo_menu             := 'FORM';
  add_hmo;
  add_hmr ('NSG_USER',nm3type.c_normal);
  add_hmr ('NSG_ADMIN',nm3type.c_normal);
  
  l_rec_hmo.hmo_module           := 'NSG0021';
  l_rec_hmo.hmo_title            := 'NSG Export Log';
  l_rec_hmo.hmo_filename         := 'nsg0021';
  l_rec_hmo.hmo_module_type      := 'FMX';
  l_rec_hmo.hmo_fastpath_opts    := Null;
  l_rec_hmo.hmo_fastpath_invalid := 'N';
  l_rec_hmo.hmo_use_gri          := 'N';
  l_rec_hmo.hmo_application      := 'NSG';
  l_rec_hmo.hmo_menu             := 'FORM';
  add_hmo;
  add_hmr ('NSG_USER',nm3type.c_normal);
  add_hmr ('NSG_ADMIN',nm3type.c_normal);
  
  l_rec_hmo.hmo_module           := 'HIG1903';
  l_rec_hmo.hmo_title            := 'Mail Message Administration';
  l_rec_hmo.hmo_filename         := 'hig1903';
  l_rec_hmo.hmo_module_type      := 'FMX';
  l_rec_hmo.hmo_fastpath_opts    := Null;
  l_rec_hmo.hmo_fastpath_invalid := 'N';
  l_rec_hmo.hmo_use_gri          := 'N';
  l_rec_hmo.hmo_application      := nm3type.c_hig;
  l_rec_hmo.hmo_menu             := 'FORM';
  add_hmo;
  add_hmr ('HIG_ADMIN',nm3type.c_normal);
  
  l_rec_hmo := nm3get.get_hmo(pi_hmo_module => 'HIG1807');
--
  l_rec_hmo.hmo_module           := l_rec_hmo.hmo_module||'A';
  l_rec_hmo.hmo_title            := l_rec_hmo.hmo_title||' - Administer System Favs';
  l_rec_hmo.hmo_fastpath_invalid := 'Y';
  add_hmo;
--     
   FOR i IN 1..l_hmo_count
    LOOP
      l_rec_hmo := l_tab_rec_hmo(i);
      INSERT INTO hig_modules
            (hmo_module
            ,hmo_title
            ,hmo_filename
            ,hmo_module_type
            ,hmo_fastpath_opts
            ,hmo_fastpath_invalid
            ,hmo_use_gri
            ,hmo_application
            ,hmo_menu
            )
      SELECT l_rec_hmo.hmo_module
            ,l_rec_hmo.hmo_title
            ,l_rec_hmo.hmo_filename
            ,l_rec_hmo.hmo_module_type
            ,l_rec_hmo.hmo_fastpath_opts
            ,l_rec_hmo.hmo_fastpath_invalid
            ,l_rec_hmo.hmo_use_gri
            ,l_rec_hmo.hmo_application
            ,l_rec_hmo.hmo_menu
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_rec_hmo.hmo_module
                       );
   END LOOP;
--
   FORALL i IN 1..l_hmr_count
      INSERT INTO hig_module_roles
            (hmr_module
            ,hmr_role
            ,hmr_mode
            )
      SELECT l_tab_hmr_module(i)
            ,l_tab_hmr_role(i)
            ,l_tab_hmr_mode(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_module_roles
                        WHERE  hmr_module = l_tab_hmr_module(i)
                         AND   hmr_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_roles
                        WHERE  hro_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_tab_hmr_module(i)
                       );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- HIG_DOMAINS and HIG_CODES
--
   l_tab_hdo_domain     nm3type.tab_varchar30;
   l_tab_hdo_product    nm3type.tab_varchar30;
   l_tab_hdo_title      nm3type.tab_varchar2000;
   l_tab_hdo_code_len   nm3type.tab_number;
--
   l_tab_hco_domain     nm3type.tab_varchar30;
   l_tab_hco_code       nm3type.tab_varchar30;
   l_tab_hco_meaning    nm3type.tab_varchar2000;
   l_tab_hco_system     nm3type.tab_varchar4;
   l_tab_hco_seq        nm3type.tab_number;
   l_tab_hco_start_date nm3type.tab_date;
   l_tab_hco_end_date   nm3type.tab_date;
--
   l_hdo_count        PLS_INTEGER := 0;
   l_hco_count        PLS_INTEGER := 0;
--
   PROCEDURE add_hdo (p_domain   VARCHAR2
                     ,p_product  VARCHAR2
                     ,p_title    VARCHAR2
                     ,p_code_len NUMBER
                     ) IS
   BEGIN
      l_hdo_count := l_hdo_count + 1;
      l_tab_hdo_domain(l_hdo_count)   := UPPER(p_domain);
      l_tab_hdo_product(l_hdo_count)  := UPPER(p_product);
      l_tab_hdo_title(l_hdo_count)    := p_title;
      l_tab_hdo_code_len(l_hdo_count) := p_code_len;
   END add_hdo;
--
   PROCEDURE add_hco (p_domain     VARCHAR2
                     ,p_code       VARCHAR2
                     ,p_meaning    VARCHAR2
                     ,p_system     VARCHAR2 DEFAULT 'Y'
                     ,p_seq        NUMBER   DEFAULT NULL
                     ,p_start_date DATE     DEFAULT NULL
                     ,p_end_date   DATE     DEFAULT NULL
                     ) IS
   BEGIN
      l_hco_count := l_hco_count + 1;
      l_tab_hco_domain(l_hco_count)     := UPPER(p_domain);
      l_tab_hco_code(l_hco_count)       := p_code;
      l_tab_hco_meaning(l_hco_count)    := p_meaning;
      l_tab_hco_system(l_hco_count)     := p_system;
      l_tab_hco_seq(l_hco_count)        := p_seq;
      l_tab_hco_start_date(l_hco_count) := p_start_date;
      l_tab_hco_end_date(l_hco_count)   := p_end_date;
   END add_hco;
--
BEGIN
--
   add_hco('PBI_CONDITION','NOT BETWEEN','Not Between','Y', 208);
--   
   add_hco('HISTORY_OPERATION','L','Rescale','Y', 5);
   add_hco('HISTORY_OPERATION','N','Reclass','Y', 6);
--   
--
-- added for JM 696841
--
   add_hco ('USER_OPTIONS','WEBMENUMOD','Module that HTML forms "Main Menu" link takes you to','Y',37);
   add_hco ('USER_OPTIONS','WEBTOPIMG','Image displayed in the top frame on the HTML forms','Y',38);
   add_hco ('USER_OPTIONS','WEBMAINIMG','Image displayed in the main menu on the HTML forms','Y',39);
   add_hco ('USER_OPTIONS','WEBMAINURL','URL which HTML main menu image takes you to','Y',40);   
--   
-- Added for DCD Inspections
--
   add_hco ('USER_OPTIONS','DCDEXPATH','Directory where DCD downloads are created','Y',41);   
-- 
--
-- Added for JM for CSV Loader changes
--  
   add_hco('GAZ_QRY_FIXED_COLS_I','IIT_PEO_INVENT_BY_ID','Inspected By','Y',1007);

   --
   add_hco('GAZ_QRY_FIXED_COLS_E', 'NE_DESCR', 'Description', 'Y', 1000);

   FORALL i IN 1..l_hdo_count
      INSERT INTO hig_domains
            (hdo_domain
            ,hdo_product
            ,hdo_title
            ,hdo_code_length
            )
      SELECT l_tab_hdo_domain(i)
            ,l_tab_hdo_product(i)
            ,l_tab_hdo_title(i)
            ,l_tab_hdo_code_len(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hdo_domain(i)
                       );
   FORALL i IN 1..l_hco_count
      INSERT INTO hig_codes
            (hco_domain
            ,hco_code
            ,hco_meaning
            ,hco_system
            ,hco_seq
            ,hco_start_date
            ,hco_end_date
            )
      SELECT l_tab_hco_domain(i)
            ,l_tab_hco_code(i)
            ,l_tab_hco_meaning(i)
            ,l_tab_hco_system(i)
            ,l_tab_hco_seq(i)
            ,l_tab_hco_start_date(i)
            ,l_tab_hco_end_date(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_codes
                        WHERE  hco_domain = l_tab_hco_domain(i)
                         AND   hco_code   = l_tab_hco_code(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hco_domain(i)
                       );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- HIG_OPTION_LIST and HIG_OPTION_VALUES
--
   l_tab_hol_id         nm3type.tab_varchar30;
   l_tab_hol_product    nm3type.tab_varchar30;
   l_tab_hol_name       nm3type.tab_varchar30;
   l_tab_hol_remarks    nm3type.tab_varchar2000;
   l_tab_hol_domain     nm3type.tab_varchar30;
   l_tab_hol_datatype   nm3type.tab_varchar30;
   l_tab_hol_mixed_case nm3type.tab_varchar30;
   l_tab_hov_value      nm3type.tab_varchar2000;
--
   c_y_or_n CONSTANT    hig_domains.hdo_domain%TYPE := 'Y_OR_N';
--
   PROCEDURE add (p_hol_id         VARCHAR2
                 ,p_hol_product    VARCHAR2
                 ,p_hol_name       VARCHAR2
                 ,p_hol_remarks    VARCHAR2
                 ,p_hol_domain     VARCHAR2 DEFAULT Null
                 ,p_hol_datatype   VARCHAR2 DEFAULT nm3type.c_varchar
                 ,p_hol_mixed_case VARCHAR2 DEFAULT 'N'
                 ,p_hov_value      VARCHAR2 DEFAULT NULL
                 ) IS
      c_count PLS_INTEGER := l_tab_hol_id.COUNT+1;
   BEGIN
      l_tab_hol_id(c_count)         := p_hol_id;
      l_tab_hol_product(c_count)    := p_hol_product;
      l_tab_hol_name(c_count)       := p_hol_name;
      l_tab_hol_remarks(c_count)    := p_hol_remarks;
      l_tab_hol_domain(c_count)     := p_hol_domain;
      l_tab_hol_datatype(c_count)   := p_hol_datatype;
      l_tab_hol_mixed_case(c_count) := p_hol_mixed_case;
      l_tab_hov_value(c_count)      := p_hov_value;
   END add;
BEGIN


--
-- added for JM 696841
--
   add (p_hol_id         => 'WEBMENUMOD'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'HTML Main Menu Module'
       ,p_hol_remarks    => 'Module to which the HTML forms "Main Menu" link takes you to'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'NMWEB0000'
       );

   add (p_hol_id         => 'WEBTOPIMG'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'Image for top frame'
       ,p_hol_remarks    => 'Image which is displayed in the top frame on the HTML forms'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => nm3web.get_download_url('exor_small.gif')
       );

   add (p_hol_id         => 'WEBMAINIMG'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'Image for main menu'
       ,p_hol_remarks    => 'Image which is displayed in the main menu (NMWEB0000) on the HTML forms'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => nm3web.get_download_url('exor.gif')
       );

   add (p_hol_id         => 'WEBMAINURL'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'URL for image in main menu'
       ,p_hol_remarks    => 'URL which image (displayed in the main menu (NMWEB0000) on the HTML forms) takes you to'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => 'http://www.exorcorp.com/'
       );

-- NSG
   add (p_hol_id         => 'NSGDATA'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'System uses NSG data'
       ,p_hol_remarks    => 'This option is set to "Y" if the system is using an NSG network.'
       ,p_hol_domain     => 'Y_OR_N'
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'N'
       );

-- DCD Inspections
   add (p_hol_id         => 'DCDEXPATH'
       ,p_hol_product    => nm3type.c_net
       ,p_hol_name       => 'DCD download directory'
       ,p_hol_remarks    => 'Directory where DCD downloads are created'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => 'E:\UTL_FILE\'
       );
       
-- JM - changes for nm3inv_sde
   add (p_hol_id         => 'SDESERVER'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'SDE Server'
       ,p_hol_remarks    => 'Server on which SDE is running'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => Null
       );
--
   add (p_hol_id         => 'SDEINST'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'SDE instance name'
       ,p_hol_remarks    => 'The name of the SDE instance'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => Null
       );       
       
------------------------------------------------------------------------------------------------------------------------

   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_list
            (hol_id
            ,hol_product
            ,hol_name
            ,hol_remarks
            ,hol_domain
            ,hol_datatype
            ,hol_mixed_case
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hol_product(i)
            ,l_tab_hol_name(i)
            ,l_tab_hol_remarks(i)
            ,l_tab_hol_domain(i)
            ,l_tab_hol_datatype(i)
            ,l_tab_hol_mixed_case(i)
        FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_option_list
                         WHERE  hol_id = l_tab_hol_id(i)
                        );
--
   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_values
            (hov_id
            ,hov_value
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hov_value(i)
        FROM dual
      WHERE  l_tab_hov_value(i) IS NOT NULL
       AND   NOT EXISTS (SELECT 1
                          FROM  hig_option_values
                         WHERE  hov_id = l_tab_hol_id(i)
                        );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- ****************
-- *  GRI_PARAMS  *
-- ****************
--
   TYPE tab_rec_grp IS TABLE OF gri_params%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_grp     gri_params%ROWTYPE;
   l_tab_rec_grp tab_rec_grp;
--
   l_grp_count      PLS_INTEGER := 0;
--
   PROCEDURE add_grp IS
   BEGIN
      l_grp_count := l_grp_count + 1;
      l_tab_rec_grp(l_grp_count) := l_rec_grp;
   END add_grp;
--
BEGIN
--

--  l_rec_grp.gp_param            := 'P_TEXT_PARAM_1';
--  l_rec_grp.gp_param_type       := 'CHAR';
--  l_rec_grp.gp_table            := Null;
--  l_rec_grp.gp_column           := Null;
--  l_rec_grp.gp_descr_column     := Null;
--  l_rec_grp.gp_shown_column     := Null;
--  l_rec_grp.gp_shown_type       := Null;
--  l_rec_grp.gp_descr_type       := Null;
--  l_rec_grp.gp_order            := Null;
--  l_rec_grp.gp_case             := Null;
--  l_rec_grp.gp_gaz_restriction  := Null;
--  add_grp;

   FOR i IN 1..l_grp_count
    LOOP
      l_rec_grp := l_tab_rec_grp(i);
      INSERT INTO gri_params
            (
             gp_param
            ,gp_param_type
            ,gp_table
            ,gp_column
            ,gp_descr_column
            ,gp_shown_column
            ,gp_shown_type
            ,gp_descr_type
            ,gp_order
            ,gp_case
            ,gp_gaz_restriction
            )
      SELECT
            l_rec_grp.gp_param
          , l_rec_grp.gp_param_type
          , l_rec_grp.gp_table
          , l_rec_grp.gp_column
          , l_rec_grp.gp_descr_column
          , l_rec_grp.gp_shown_column
          , l_rec_grp.gp_shown_type
          , l_rec_grp.gp_descr_type
          , l_rec_grp.gp_order
          , l_rec_grp.gp_case
          , l_rec_grp.gp_gaz_restriction
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  gri_params
                        WHERE  gp_param = l_rec_grp.gp_param
                       );
   END LOOP;
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- ****************
-- *  GRI_MODULES *
-- ****************
--
   TYPE tab_rec_grm IS TABLE OF gri_modules%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_grm     gri_modules%ROWTYPE;
   l_tab_rec_grm tab_rec_grm;
--
   l_grm_count      PLS_INTEGER := 0;
--
   PROCEDURE add_grm IS
   BEGIN
      l_grm_count := l_grm_count + 1;
      l_tab_rec_grm(l_grm_count) := l_rec_grm;
   END add_grm;
--
BEGIN
--
--  l_rec_grm.grm_module       := 'HIG2100';
--  l_rec_grm.grm_module_type  := 'SQL';
--  l_rec_grm.grm_module_path  := '$PROD_HOME\bin';
--  l_rec_grm.grm_file_type    := 'lis';
--  l_rec_grm.grm_tag_flag     := 'N';
--  l_rec_grm.grm_tag_table    := Null;
--  l_rec_grm.grm_tag_column   := Null;
--  l_rec_grm.grm_tag_where    := Null;
--  l_rec_grm.grm_linesize     := 132;
--  l_rec_grm.grm_pagesize     := 66;
--  l_rec_grm.grm_pre_process  := Null;
--  add_grm;
--
   FOR i IN 1..l_grm_count
    LOOP
      l_rec_grm := l_tab_rec_grm(i);
      INSERT INTO gri_modules
            (
             grm_module
            ,grm_module_type
            ,grm_module_path
            ,grm_file_type
            ,grm_tag_flag
            ,grm_tag_table
            ,grm_tag_column
            ,grm_tag_where
            ,grm_linesize
            ,grm_pagesize
            ,grm_pre_process
            )
      SELECT
             l_rec_grm.grm_module
            ,l_rec_grm.grm_module_type
            ,l_rec_grm.grm_module_path
            ,l_rec_grm.grm_file_type
            ,l_rec_grm.grm_tag_flag
            ,l_rec_grm.grm_tag_table
            ,l_rec_grm.grm_tag_column
            ,l_rec_grm.grm_tag_where
            ,l_rec_grm.grm_linesize
            ,l_rec_grm.grm_pagesize
            ,l_rec_grm.grm_pre_process
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  gri_modules
                        WHERE  grm_module = l_rec_grm.grm_module
                       );
   END LOOP;
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- **********************
-- *  GRI_MODULE_PARAMS *
-- **********************
--
   TYPE tab_rec_gmp IS TABLE OF gri_module_params%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_gmp     gri_module_params%ROWTYPE;
   l_tab_rec_gmp tab_rec_gmp;
--
   l_gmp_count      PLS_INTEGER := 0;
--
   PROCEDURE add_gmp IS
   BEGIN
      l_gmp_count := l_gmp_count + 1;
      l_tab_rec_gmp(l_gmp_count) := l_rec_gmp;
   END add_gmp;
--
BEGIN
--
--  l_rec_gmp.gmp_module           := 'HIG2100';
--  l_rec_gmp.gmp_param            := 'P_TEXT_PARAM_1';
--  l_rec_gmp.gmp_seq              := 10;
--  l_rec_gmp.gmp_param_descr      := 'Organisation Name';
--  l_rec_gmp.gmp_mandatory        := 'Y';
--  l_rec_gmp.gmp_no_allowed       := 1;
--  l_rec_gmp.gmp_where            := Null;
--  l_rec_gmp.gmp_tag_restriction  := 'N';
--  l_rec_gmp.gmp_tag_where        := Null;
--  l_rec_gmp.gmp_default_table    := Null;
--  l_rec_gmp.gmp_default_column   := Null;
--  l_rec_gmp.gmp_default_where    := Null;
--  l_rec_gmp.gmp_visible          := 'Y';
--  l_rec_gmp.gmp_gazetteer        := 'N';
--  l_rec_gmp.gmp_lov              := 'N';
--  l_rec_gmp.gmp_val_global       := 'N';
--  l_rec_gmp.gmp_wildcard         := 'N';
--  l_rec_gmp.gmp_hint_text        := 'Organisation Name';
--  l_rec_gmp.gmp_allow_partial    := 'N';
--  add_gmp;
--
   FOR i IN 1..l_gmp_count
    LOOP
      l_rec_gmp := l_tab_rec_gmp(i);
      INSERT INTO gri_module_params
            (
             gmp_module
            ,gmp_param
            ,gmp_seq
            ,gmp_param_descr
            ,gmp_mandatory
            ,gmp_no_allowed
            ,gmp_where
            ,gmp_tag_restriction
            ,gmp_tag_where
            ,gmp_default_table
            ,gmp_default_column
            ,gmp_default_where
            ,gmp_visible
            ,gmp_gazetteer
            ,gmp_lov
            ,gmp_val_global
            ,gmp_wildcard
            ,gmp_hint_text
            ,gmp_allow_partial
            )
      SELECT
            l_rec_gmp.gmp_module
           ,l_rec_gmp.gmp_param
           ,l_rec_gmp.gmp_seq
           ,l_rec_gmp.gmp_param_descr
           ,l_rec_gmp.gmp_mandatory
           ,l_rec_gmp.gmp_no_allowed
           ,l_rec_gmp.gmp_where
           ,l_rec_gmp.gmp_tag_restriction
           ,l_rec_gmp.gmp_tag_where
           ,l_rec_gmp.gmp_default_table
           ,l_rec_gmp.gmp_default_column
           ,l_rec_gmp.gmp_default_where
           ,l_rec_gmp.gmp_visible
           ,l_rec_gmp.gmp_gazetteer
           ,l_rec_gmp.gmp_lov
           ,l_rec_gmp.gmp_val_global
           ,l_rec_gmp.gmp_wildcard
           ,l_rec_gmp.gmp_hint_text
           ,l_rec_gmp.gmp_allow_partial
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  gri_module_params
                        WHERE  gmp_module = l_rec_gmp.gmp_module
                        AND    gmp_param  = l_rec_gmp.gmp_param
                       );
   END LOOP;
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- ****************************
-- *  HIG_STANDARD_FAVOURITES *
-- ****************************
--
   TYPE tab_rec_hstf IS TABLE OF hig_standard_favourites%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_hstf     hig_standard_favourites%ROWTYPE;
   l_tab_rec_hstf tab_rec_hstf;
--
   l_hstf_count      PLS_INTEGER := 0;
--
   PROCEDURE add_hstf IS
   BEGIN
      l_hstf_count := l_hstf_count + 1;
      l_tab_rec_hstf(l_hstf_count) := l_rec_hstf;
   END add_hstf;
--
BEGIN
---------------------
-- Favourites for HIG
---------------------
    l_rec_hstf.hstf_parent   := 'HIG_REFERENCE_MAIL';
    l_rec_hstf.hstf_child    := 'HIG1903';
    l_rec_hstf.hstf_descr    := 'Mail Message Administration';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 3;           
    add_hstf;
--
---------------------
-- Favourites for MAI
---------------------
--
    l_rec_hstf.hstf_parent   := 'MAI_WORKS';
    l_rec_hstf.hstf_child    := 'MAI3805';
    l_rec_hstf.hstf_descr    := 'Gang/Crew Allocation';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 4;           
    add_hstf;
--
    l_rec_hstf.hstf_parent   := 'MAI_LOADERS';
    l_rec_hstf.hstf_child    := 'MAI_GMIS_LOADERS';
    l_rec_hstf.hstf_descr    := 'GMIS Interface';
    l_rec_hstf.hstf_type     := 'F';       
    l_rec_hstf.hstf_order    := Null;           
    add_hstf;
--
    l_rec_hstf.hstf_parent   := 'MAI_GMIS_LOADERS';
    l_rec_hstf.hstf_child    := 'MAI2530';
    l_rec_hstf.hstf_descr    := 'Create Route and Defect Files for GMIS Inspections';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 10;           
    add_hstf;
--
    l_rec_hstf.hstf_parent   := 'MAI_GMIS_LOADERS';
    l_rec_hstf.hstf_child    := 'MAIWEB2540';
    l_rec_hstf.hstf_descr    := 'GMIS Survey File Loader';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 11;           
    add_hstf;
--
    l_rec_hstf.hstf_parent   := 'MAI_GMIS_LOADERS';
    l_rec_hstf.hstf_child    := 'MAI2550';
    l_rec_hstf.hstf_descr    := 'Correct GMIS Load File Errors';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 12;           
    add_hstf;

--
---------------------
-- Favourites for NSG
---------------------
--
    l_rec_hstf.hstf_parent   := 'FAVOURITES';
    l_rec_hstf.hstf_child    := 'NSG';
    l_rec_hstf.hstf_descr    := 'NSG data manager';
    l_rec_hstf.hstf_type     := 'F';       
    l_rec_hstf.hstf_order    := 14;           
    add_hstf;
--
    l_rec_hstf.hstf_parent   := 'NSG';
    l_rec_hstf.hstf_child    := 'NSG_DATA';
    l_rec_hstf.hstf_descr    := 'Data';
    l_rec_hstf.hstf_type     := 'F';       
    l_rec_hstf.hstf_order    := 1;           
    add_hstf;
--    
    l_rec_hstf.hstf_parent   := 'NSG';
    l_rec_hstf.hstf_child    := 'NSG_DATA';
    l_rec_hstf.hstf_descr    := 'Data';
    l_rec_hstf.hstf_type     := 'F';       
    l_rec_hstf.hstf_order    := 1;           
    add_hstf;
--    
    l_rec_hstf.hstf_parent   := 'NSG';
    l_rec_hstf.hstf_child    := 'NSG_IMPORT_EXPORT';
    l_rec_hstf.hstf_descr    := 'Import/Export';
    l_rec_hstf.hstf_type     := 'F';       
    l_rec_hstf.hstf_order    := 2;           
    add_hstf;
--    
    l_rec_hstf.hstf_parent   := 'NSG_DATA';
    l_rec_hstf.hstf_child    := 'NSG0030';
    l_rec_hstf.hstf_descr    := 'Cross References';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 1;           
    add_hstf;
--    
    l_rec_hstf.hstf_parent   := 'NSG_IMPORT_EXPORT';
    l_rec_hstf.hstf_child    := 'NSG0020';
    l_rec_hstf.hstf_descr    := 'Export';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 1;           
    add_hstf;
--    
    l_rec_hstf.hstf_parent   := 'NSG_IMPORT_EXPORT';
    l_rec_hstf.hstf_child    := 'NSG0021';
    l_rec_hstf.hstf_descr    := 'Export Log';
    l_rec_hstf.hstf_type     := 'M';       
    l_rec_hstf.hstf_order    := 2;           
    add_hstf;
--

   FOR i IN 1..l_hstf_count
    LOOP
      l_rec_hstf := l_tab_rec_hstf(i);
      INSERT INTO hig_standard_favourites
            (
             hstf_parent
            ,hstf_child
            ,hstf_descr
            ,hstf_type
            ,hstf_order
            )
      SELECT
            l_rec_hstf.hstf_parent
           ,l_rec_hstf.hstf_child
           ,l_rec_hstf.hstf_descr
           ,l_rec_hstf.hstf_type
           ,l_rec_hstf.hstf_order
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_standard_favourites
                        WHERE  hstf_parent = l_rec_hstf.hstf_parent
                        AND    hstf_child  = l_rec_hstf.hstf_child
                       );
   END LOOP;
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
BEGIN

--
-- ******************
-- *  MISCELLANEOUS *
-- ******************
--
--
-- added for JM 697140 
--

  INSERT INTO nm_upload_file_gateways
        (NUFG_TABLE_NAME
        )
  SELECT 'NM_LOAD_FILES'
   FROM  dual
  WHERE  NOT EXISTS (SELECT 1
                      FROM  nm_upload_file_gateways
                     WHERE  NUFG_TABLE_NAME = 'NM_LOAD_FILES'
                    );

  INSERT INTO nm_upload_file_gateway_cols
      (nufgc_nufg_table_name
      ,nufgc_seq
      ,nufgc_column_name
      ,nufgc_column_datatype
      )
  SELECT 'NM_LOAD_FILES'
      ,1
      ,'NLF_ID'
      ,'NUMBER'
   FROM  dual
  WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_upload_file_gateway_cols
                    WHERE  nufgc_nufg_table_name = 'NM_LOAD_FILES'
                    AND   nufgc_seq             = 1
                  );

				  
 INSERT INTO nm_upload_file_gateways
      (NUFG_TABLE_NAME
      )
  SELECT 'NM_LOAD_BATCHES'
   FROM  dual
  WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_upload_file_gateways
                   WHERE  NUFG_TABLE_NAME = 'NM_LOAD_BATCHES'
                  );


  INSERT INTO nm_upload_file_gateway_cols
      (nufgc_nufg_table_name
      ,nufgc_seq
      ,nufgc_column_name
      ,nufgc_column_datatype
      )
  SELECT 'NM_LOAD_BATCHES'
      ,1
      ,'NLB_BATCH_NO'
      ,'NUMBER'
  FROM  dual
  WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_upload_file_gateway_cols
                   WHERE  nufgc_nufg_table_name = 'NM_LOAD_BATCHES'
                    AND   nufgc_seq             = 1
                  );


  INSERT INTO DOC_GATEWAYS ( DGT_TABLE_NAME
                           , DGT_TABLE_DESCR
                           , DGT_PK_COL_NAME
                           , DGT_LOV_DESCR_LIST
                           , DGT_LOV_FROM_LIST ) 
                    SELECT   'NM_INV_ITEMS'
                           , 'Inventory Items'
                           , 'IIT_NE_ID'
                           , 'IIT_INV_TYPE||''-''||DECODE(IIT_X_SECT,Null,Null,IIT_X_SECT||''-'')||IIT_PRIMARY_KEY'
                           , 'NM_INV_ITEMS'
                 FROM DUAL
                 WHERE NOT EXISTS (SELECT 1 FROM DOC_GATEWAYS WHERE DGT_TABLE_NAME = 'NM_INV_ITEMS');
				  
  COMMIT;

--
-- Ensure 209/210 nm_errors for HIG are correct
--
DELETE FROM NM_ERRORS WHERE NER_ID = 210 AND NER_APPL='HIG';

DELETE FROM NM_ERRORS WHERE NER_ID = 209 AND NER_APPL='HIG';

INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 210, NULL, 'Switch Route Theme ?');

INSERT INTO NM_ERRORS ( NER_APPL, NER_ID, NER_HER_NO, NER_DESCR ) VALUES ( 
'HIG', 209, NULL, 'The file containing exor product version numbers could not be found.  Please check the ''EXOR_VERSION'' registry setting');
--
DELETE FROM NM_ERRORS
 WHERE NER_APPL = 'HIG'
  AND  NER_ID = 230;
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       )
SELECT 
        'HIG'
       ,230
       ,null
       ,'Inconsistency detected between licenced product versions on the database and in the Exor Product Version Numbers File.' FROM DUAL;
--
 
COMMIT;


--
-- Ensure value of product option is set to 'Y'
--
UPDATE hig_option_values 
SET    hov_value = 'Y'
WHERE  hov_id = 'SDODATEVW';

COMMIT;
 
END;
/
--
-------------------------------------------------------------------------------------------------
--
SET FEEDBACK ON


