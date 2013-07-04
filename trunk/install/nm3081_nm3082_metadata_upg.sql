REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM '@(#)nm3081_nm3082_metadata_upg.sql	1.5 11/18/03'
--
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
   add_ner(188, 'User Created. Do you want to view this user?');
   add_ner(189, 'SDE data not present - cloning is not possible');
   add_ner(190, 'SDE Layer generator failure');
   add_ner(191, 'SDE Table registration id generator failure');
   add_ner(192, 'Theme is not related to a network');
   add_ner(193, 'Point location data not found - clone is not possible');
   add_ner(194, 'No base theme is available');
   add_ner(195, 'No datum theme found');
   add_ner(196, 'Layer table not found' );
   add_ner(197, 'SDO Metadata for layer  not found' );
   add_ner(198, 'Geometry not found - ');
   add_ner(199, 'Element shapes not connected');
   add_ner(201, 'Only one element has shape - merge prevented');
   add_ner(202, 'points are the same - no distance between them');
   add_ner(203, 'points are not on same network element');
   add_ner(204, 'Lengths of element and shape are inconsistent' );
   add_ner(205, 'Single part asset shapes are not supported yet');
   add_ner(206, 'Load Aborted. Metadata changes have been made since the edif file was generated.');
   add_ner(207, 'Load Aborted. Error found during MapCapture Load.');
   add_ner(208, 'Inventory Update conflict. Changes have been made to the inventory in the database.');

   --
   -- NET errors
   --
   l_current_type := nm3type.c_net;
   --
   add_ner(345, 'A parent inclusion group type can only have one child network type');
   add_ner(346, 'A column that is displayed and used to build the unique must be mandatory');
   add_ner(347, 'The unique for this element will be populated automatically');
   add_ner(348, 'Elements and inventory items of these types cannot be linked');
   add_ner(349, 'This group type is not associated with an inventory type');
   add_ner(350, 'This element has no associated inventory item');
   add_ner(351, 'The value you have entered is not unique across all network types.' || Chr(10) || Chr(10) || 'Please use the Gazetteer to select a specific item.');
   add_ner(352, 'You cannot specify a Unique Format for a column with no Unique Sequence set');
   add_ner(353, 'Value must be an NM_ELEMENTS column, something that can be selected from DUAL or something that can be selected from NM_ELEMENTS (with column names as bind variables).');
   add_ner(354, 'All bind variables must be named after NM_ELEMENTS columns');
   add_ner(355, 'Cannot locate inventory - the item has future locations which would be affected.');
   --
   -- Fix dodgy NM_ERRORS records
   --
   l_current_type := nm3type.c_hig;
   add_dodgy (p_ner_id        => 126
             ,p_ner_descr_old => 'You should not be here.'
             ,p_ner_descr_new => 'You do not have privileges to perform this action');

   l_current_type := nm3type.c_net;
   add_dodgy (p_ner_id        => 236
             ,p_ner_descr_old => 'You should not be here'
             ,p_ner_descr_new => 'You do not have privileges to perform this action');


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
--   add_hcca ('NTC_UNIQUE_SEQ_MAND_CHK', 'NM_TYPE_COLUMNS', nm3type.c_net, 346);
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
   l_rec_hmo.hmo_module           := 'NM0511';
   l_rec_hmo.hmo_title            := 'Reconcile MapCapture Load Errors';
   l_rec_hmo.hmo_filename         := 'nm0511';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr('NET_ADMIN',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'NM0580';
   l_rec_hmo.hmo_title            := 'Create MapCapture Metadata File';
   l_rec_hmo.hmo_filename         := 'nm0580';
   l_rec_hmo.hmo_module_type      := 'SQL';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := NULL;
   add_hmo;
   add_hmr('NET_ADMIN',nm3type.c_normal);
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
   add_hco ('CSV_PROCESS_SUBTYPE','F','Produce Log Files','Y',3);
--
   add_hdo ('MC_INV_LD_ERR_STATUS',nm3type.c_hig,'MapCapture Inventory Loader Error Status',1);
   add_hco ('MC_INV_LD_ERR_STATUS','0','No Error','Y',1);
   add_hco ('MC_INV_LD_ERR_STATUS','1','General Error','Y',2);
   add_hco ('MC_INV_LD_ERR_STATUS','2','Conflict','Y',3);
   add_hco ('MC_INV_LD_ERR_STATUS','3','Conflict Resolved','Y',4); 
--   
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
   add (p_hol_id         => 'MAPCAP_DIR'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'The MapCapture Load directory'
       ,p_hol_remarks    => 'The directory on the server where MapCapture survey files will be placed ready for loading into NM3.'
       ,p_hol_domain     => NULL
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => NULL
       );
       
   add (p_hol_id         => 'MAPCAP_INT'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'MapCapture load proces timeout'
       ,p_hol_remarks    => 'The interval (in minutes) between MapCapture loads.'
       ,p_hol_domain     => NULL
       ,p_hol_datatype   => nm3type.c_number
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => NULL
       );
    
   add (p_hol_id         => 'MAPCAP_EML'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'MapCapture email address'
       ,p_hol_remarks    => 'The email group id the MapCapture loader will send emails to.'
       ,p_hol_domain     => NULL
       ,p_hol_datatype   => nm3type.c_number
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => NULL
       );
       

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
--
--

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
l_rec_grm.grm_module       := 'NM0580';
l_rec_grm.grm_module_type  := 'SQL';
l_rec_grm.grm_module_path  := '$PROD_HOME\bin';
l_rec_grm.grm_file_type    := 'lis';
l_rec_grm.grm_tag_flag     := 'N';
l_rec_grm.grm_tag_table    := Null;
l_rec_grm.grm_tag_column   := Null;
l_rec_grm.grm_tag_where    := Null;
l_rec_grm.grm_linesize     := 132;
l_rec_grm.grm_pagesize     := 66;
l_rec_grm.grm_pre_process  := Null;
add_grm;


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

-- Adding hig_option for MapCapture group

DECLARE
l_mc_group nm_mail_groups%ROWTYPE;
BEGIN
  l_mc_group.nmg_id   := nm3seq.next_nmg_id_seq;
  l_mc_group.nmg_name := 'MapCapture Loader Admin';

  INSERT INTO NM_MAIL_GROUPS ( NMG_ID, NMG_NAME )
  SELECT l_mc_group.nmg_id, l_mc_group.nmg_name
  FROM DUAL
  WHERE NOT EXISTS (SELECT 1
                    FROM NM_MAIL_GROUPS
                    WHERE NMG_NAME = l_mc_group.nmg_name);

  INSERT INTO HIG_OPTION_VALUES ( HOV_ID, HOV_VALUE ) 
  SELECT 'MAPCAP_EML', l_mc_group.nmg_id
  FROM   DUAL
  WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                    WHERE HOV_ID = 'MAPCAP_EML'); 
END;
/

INSERT INTO NM_LOAD_DESTINATIONS
       (NLD_ID
       ,NLD_TABLE_NAME
       ,NLD_TABLE_SHORT_NAME
       ,NLD_INSERT_PROC
       ,NLD_VALIDATION_PROC
       )
SELECT
       nm3seq.next_nld_id_seq
      ,'NM_LD_MC_ALL_INV_TMP'
      ,'MIT'
      ,'NM3MAPCAPTURE_INS_INV.INS_INV'
      ,NULL
FROM  DUAL
WHERE NOT EXISTS (SELECT 1
                  FROM NM_LOAD_DESTINATIONS
                  WHERE NLD_TABLE_NAME = 'NM_LD_MC_ALL_INV_TMP');
/
--
SET FEEDBACK ON
