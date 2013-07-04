--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3210_nm3220_metadata_upg.sql	1.36 02/07/06
--       Module Name      : nm3210_nm3220_metadata_upg.sql
--       Date into SCCS   : 06/02/07 16:44:54
--       Date fetched Out : 07/06/13 13:58:04
--       SCCS Version     : 1.36
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
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

--
-- Remove the reserved errors for derived assets
--
delete from nm_errors
where ner_appl = 'NET'
and   ner_id IN (400,401,402,403,404,405,406,407,408,409,411,412,413,414,415,416,417,418,419,420)
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
   l_tab_ner_cause nm3type.tab_varchar2000;
   --
   l_current_type  nm_errors.ner_appl%TYPE;
   --
   PROCEDURE add_ner (p_ner_id    number
                     ,p_ner_descr varchar2
                     ,p_cause     varchar2 DEFAULT NULL
                     ,p_app       varchar2 DEFAULT l_current_type
                     ) IS

      c_count CONSTANT pls_integer := l_tab_ner_id.COUNT+1;

   BEGIN

      l_tab_ner_id(c_count)    := p_ner_id;
      l_tab_ner_descr(c_count) := p_ner_descr;
      l_tab_ner_cause(c_count) := p_cause;
      l_tab_appl(c_count)      := p_app;

   END add_ner;
   --
BEGIN

   --
   -- HIG errors
   --
   l_current_type := 'HIG';
   --
   add_ner(261, 'Gaps/Overlaps are not permitted');
   add_ner(262, 'Element cannot be linked to a record of the given type','Associated Data rules are not in place to support linking this network element to this asset type');
   add_ner(263, 'Read Permission not granted on directory','You are not permitted to read data from the specified directory');
   add_ner(264, 'Write Permission not granted on directory','You are not permitted to write data to the specified directory');
   add_ner(265, 'Wildcards (%) are not permitted');
   --
   -- NET errors
   --
   l_current_type := 'NET';
   --
   add_ner(422, 'Inventory attribute query not applicable for inventory of this category');
   add_ner(423, 'Cross Reference is not permitted - please check the Cross Reference Rules','Network/Group type of element 1 is not compatible with Network/Group type of element 2');

 
   --
   -- Composite Inventory Errors
   --
   add_ner(400, 'Inventory Category not valid');
   add_ner(401, 'Derived Asset Type must be exclusive');
   add_ner(402, 'XSP is not allowed for derived asset types');
   add_ner(403, 'Merge Query results are not from query asociated with derived asset type');
   add_ner(404, 'Admin Type of derived asset type is different that the admin type of the asset type it is being derived from');
   add_ner(405, 'Admin Unit cannot be derived using this derivation');
   add_ner(406, 'Specified derived admin unit not found');
   add_ner(407, 'Specified derived admin unit is of an incorrect admin type');
   add_ner(408, 'Refresh is already underway for this type');
   add_ner(409, 'Table has outstanding locks. Cannot proceed.');
   add_ner(411, 'Asset table has records locked.'||CHR(10)||'Derived asset refresh cannot proceed because of the possibility of stale data.');
   add_ner(412, 'Identical job already exists. Cannot create job');
   add_ner(413, 'Refresh Interval is greater than rebuild interval. Only rebuild will take place');
   
   --
   -- PT: module nm0535 Bulk Asset Update
   add_ner(424, 'This will update the selected inventory items');
   add_ner(425, 'No items selected for update');


   FORALL i IN 1..l_tab_ner_id.COUNT
      INSERT INTO nm_errors
            (ner_appl
            ,ner_id
            ,ner_descr
  	    ,ner_cause
            )
      SELECT l_tab_appl(i)
            ,l_tab_ner_id(i)
            ,l_tab_ner_descr(i)
            ,l_tab_ner_cause(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  nm_errors
                         WHERE  ner_id   = l_tab_ner_id(i)
                          AND   ner_appl = l_tab_appl(i)
                        )
       AND   l_tab_ner_descr(i) IS NOT NULL;

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
   l_domain           hig_domains.hdo_domain%TYPE;
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
   l_domain := 'GAZ_QRY_FIXED_COLS_I';
   add_hco(l_domain,'IIT_PRIMARY_KEY','Primary Key','Y',1100);

   l_domain := 'XREF_REL_TYPE';
   add_hdo(l_domain,'NET','Cross Reference Relationship Type',30);

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
   c_xval CONSTANT VARCHAR2(4) := 'XVAL';
   c_web  CONSTANT VARCHAR2(3) := 'WEB';
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
   l_rec_hmo.hmo_module           := 'CALENDAR';
   l_rec_hmo.hmo_title            := 'Calendar';
   l_rec_hmo.hmo_filename         := 'calendar';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'Y';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'HIG1895';
   l_rec_hmo.hmo_title            := 'Directories';
   l_rec_hmo.hmo_filename         := 'hig1895';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
   add_hmr ('HIG_USER','READONLY');
--
   l_rec_hmo.hmo_module           := 'HIG3664';
   l_rec_hmo.hmo_title            := 'Financial Years';
   l_rec_hmo.hmo_filename         := 'hig3664';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
   add_hmr ('HIG_USER','READONLY');
--
   l_rec_hmo.hmo_module           := 'NM0420';
   l_rec_hmo.hmo_title            := 'Derived Asset Setup';
   l_rec_hmo.hmo_filename         := 'nm0420';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'AST';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0573';
   l_rec_hmo.hmo_title            := 'Asset Grid';
   l_rec_hmo.hmo_filename         := 'nm0573';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'Y';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'AST';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0005';
   l_rec_hmo.hmo_title            := 'Network Cross Reference Rules';
   l_rec_hmo.hmo_filename         := 'nm0005';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('NET_ADMIN','NORMAL');
   add_hmr ('NET_USER','READONLY');
--
   l_rec_hmo.hmo_module           := 'NMWEB0043';
   l_rec_hmo.hmo_title            := 'Upload file to Oracle Directory';
   l_rec_hmo.hmo_filename         := 'nm3file.web_download_from_dir';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NMWEB0044';
   l_rec_hmo.hmo_title            := 'Download from Oracle Directory';
   l_rec_hmo.hmo_filename         := 'nm3file.web_download_from_dir';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr ('WEB_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'GRI0260';
   l_rec_hmo.hmo_title            := 'GRI Saved Parameters';
   l_rec_hmo.hmo_filename         := 'gri0260';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
   add_hmr ('HIG_USER','READONLY');   

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
--
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
-- HIG_STANDARD_FAVOUTRITES
--

   l_hstf_parent  nm3type.tab_VARCHAR30;
   l_hstf_child   nm3type.tab_VARCHAR30;
   l_hstf_descr   nm3type.tab_VARCHAR80;
   l_hstf_type    nm3type.tab_VARCHAR1;
   l_hstf_order   nm3type.tab_NUMBER;

--
--
   PROCEDURE add (p_hstf_parent  VARCHAR2
                 ,p_hstf_child   VARCHAR2
                 ,p_hstf_descr   VARCHAR2
                 ,p_hstf_type    VARCHAR2
                 ,p_hstf_order   NUMBER) IS

	c_count PLS_INTEGER := l_hstf_child.COUNT+1;

   BEGIN

        l_hstf_parent(c_count) :=  p_hstf_parent;
        l_hstf_child(c_count)  :=  p_hstf_child;
        l_hstf_descr(c_count)  :=  p_hstf_descr;
        l_hstf_type(c_count)   :=  p_hstf_type;
        l_hstf_order(c_count)  :=  p_hstf_order;

   END add;
--
--
BEGIN
--
   add (p_hstf_parent  => 'HIG'
       ,p_hstf_child   => 'HIG_DIRECTORIES'
       ,p_hstf_descr   => 'Directory Management'
       ,p_hstf_type    => 'F'
       ,p_hstf_order   =>  8
        );
--
   add (p_hstf_parent  => 'HIG_DIRECTORIES'
       ,p_hstf_child   => 'HIG1895'
       ,p_hstf_descr   => 'Directories'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  1
        );
--
   add (p_hstf_parent  => 'HIG_DIRECTORIES'
       ,p_hstf_child   => 'NMWEB0043'
       ,p_hstf_descr   => 'Upload file to Oracle Directory'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  2
        );
--
   add (p_hstf_parent  => 'HIG_DIRECTORIES'
       ,p_hstf_child   => 'NMWEB0044'
       ,p_hstf_descr   => 'Download from Oracle Directory'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  3
        );
--
   add (p_hstf_parent  => 'HIG_REFERENCE'
       ,p_hstf_child   => 'HIG3664'
       ,p_hstf_descr   => 'Financial Years'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  17
        );
--
  add (p_hstf_parent  => 'AST_REF'
       ,p_hstf_child   => 'NM0420'
       ,p_hstf_descr   => 'Derived Asset Setup'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  9
        );
--
   add (p_hstf_parent  => 'NSG_DATA'
       ,p_hstf_child   => 'NSG0060'
       ,p_hstf_descr   => 'Maintain Locations'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  2
        );
--
   add (p_hstf_parent  => 'NSG_DATA'
       ,p_hstf_child   => 'NSG0010'
       ,p_hstf_descr   => 'Maintain NSG Gazetteer'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  1
        );

--
   add (p_hstf_parent  => 'NSG_DATA'
       ,p_hstf_child   => 'NSG_DATA_ADMIN'
       ,p_hstf_descr   => 'Administration'
       ,p_hstf_type    => 'F'
       ,p_hstf_order   =>  3
        );
--
--   add (p_hstf_parent  => 'NSG_DATA_ADMIN'
--       ,p_hstf_child   => 'NSG0050'
--       ,p_hstf_descr   => 'Consolidate Street Nodes'
--       ,p_hstf_type    => 'M'
--       ,p_hstf_order   =>  1
--        );
--
   add (p_hstf_parent  => 'NSG_IMPORT_EXPORT'
       ,p_hstf_child   => 'NSG0040'
       ,p_hstf_descr   => 'Import'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  1
        );
--
   add (p_hstf_parent  => 'NET_REF'
       ,p_hstf_child   => 'NM0005'
       ,p_hstf_descr   => 'Network Cross Reference Rules'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  5
        );
--
   add (p_hstf_parent  => 'HIG_GRI'
       ,p_hstf_child   => 'GRI0260'
       ,p_hstf_descr   => 'GRI Saved Parameters'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  7
        );
--

   FOR i IN 1..l_hstf_child.COUNT loop

      INSERT INTO hig_standard_favourites
            (hstf_parent
            ,hstf_child
            ,hstf_descr
            ,hstf_type
            ,hstf_order
            )
      SELECT l_hstf_parent(i)
            ,l_hstf_child(i)
            ,l_hstf_descr(i)
            ,l_hstf_type(i)
            ,l_hstf_order(i)
      FROM dual
      WHERE  NOT EXISTS (SELECT 1
                         FROM  hig_standard_favourites
                         WHERE  hstf_parent = l_hstf_parent(i)
                         AND    hstf_child = l_hstf_child(i)
                        );

  END LOOP;
END;
/
--
-- re-jig the order of certain nodes in the hig_standard_favourites tree following
-- inserts of new menu options - Graeme
--
UPDATE hig_standard_favourites
SET    hstf_order = 7
WHERE  hstf_parent = 'HIG_SECURITY'
AND    hstf_child = 'HIG_SECURITY_REPORTS'
/
UPDATE hig_standard_favourites
SET    hstf_order = 18
WHERE  hstf_parent = 'HIG_REFERENCE'
AND    hstf_child = 'HIG_REFERENCE_MAIL'
/
UPDATE hig_standard_favourites
SET    hstf_order = 19
WHERE  hstf_parent = 'HIG_REFERENCE'
AND    hstf_child = 'HIG_REFERENCE_REPORTS'
/
UPDATE hig_standard_favourites
SET    hstf_order = 2
WHERE  hstf_parent = 'NSG_IMPORT_EXPORT'
AND    hstf_child = 'EXPORT'
/
--
-- Remove redundant menu options
--
DELETE FROM hig_standard_favourites
WHERE  hstf_parent = 'NSG_DATA'
AND    hstf_child  = 'NSG0030'
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
   l_tab_hol_user_option nm3type.tab_varchar30;
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
                 ,p_hol_user_option VARCHAR2 DEFAULT 'N'
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
      l_tab_hol_user_option(c_count) := p_hol_user_option;
      l_tab_hov_value(c_count)      := p_hov_value;
   END add;
BEGIN

--
-- Composite Inventory Option - Jon Mills
--
   add(p_hol_id         => 'MRGVIEWTRU'
      ,p_hol_product    => 'NET'
      ,p_hol_name       => 'Merge Views Include True'
      ,p_hol_remarks    => 'If this is set to "Y" then the TRUE distance along the OFFSET_NE_ID for the start and end of each merge chunk will be included on the merge views'
      ,p_hol_domain     => 'Y_OR_N'
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => 'N');
--
-- Composite Inventory Option - Jon Mills
--
   add(p_hol_id         => 'HIG_ST_CSS'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'URL for static CSS'
      ,p_hol_remarks    => 'If the organisation has a static style sheet (i.e. not accessed from within the oracle server) then set this option so that it is used (for example in mail messages)'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'Y'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => Null);


--
-- Mapserver option (AR)
--
   add(p_hol_id         => 'WEBMAPBUFR'
      ,p_hol_product    => 'WMP'
      ,p_hol_name       => 'MSV Buffer Colour'
      ,p_hol_remarks    => 'Colour Used to Render Web Map Buffer'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'Y'
      ,p_hov_value      => Null);


--
-- Look and Feel product options
--
   add(p_hol_id         => 'IMAGE1'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'Corporate Image 1'
      ,p_hol_remarks    => 'Corporate Image 1'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'Y'
      ,p_hol_user_option => 'Y'
      ,p_hov_value      => 'exor.jpg');


   add(p_hol_id         => 'IMAGE2'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'Corporate Image 2'
      ,p_hol_remarks    => 'Corporate Image 2'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'Y'
      ,p_hol_user_option => 'Y'
      ,p_hov_value      => 'exor.jpg');

   add(p_hol_id         => 'FAVURL'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'URL displayed in HIG1807'
      ,p_hol_remarks    => 'URL displayed in HIG1807'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'Y'
      ,p_hol_user_option => 'Y'
      ,p_hov_value      => 'http://www.exorcorp.com');


--
-- Spatial Server Product Option
--
   add(p_hol_id         => 'SDOFETBUFF'
      ,p_hol_product    => 'WMP'
      ,p_hol_name       => 'SDO Fetch Buffer Size'
      ,p_hol_remarks    => 'Buffer size for array fetches in nm3sdo'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => 200);
--
-- Spatial Server Product Option
--
   add(p_hol_id         => 'SDOCLIPTYP'
      ,p_hol_product    => 'WMP'
      ,p_hol_name       => 'Clipping Algorithm'
      ,p_hol_remarks    => 'Clipping Algorithm - set to SDO by default'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => 'SDO');
--


   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_list
            (hol_id
            ,hol_product
            ,hol_name
            ,hol_remarks
            ,hol_domain
            ,hol_datatype
            ,hol_mixed_case
            ,hol_user_option
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hol_product(i)
            ,l_tab_hol_name(i)
            ,l_tab_hol_remarks(i)
            ,l_tab_hol_domain(i)
            ,l_tab_hol_datatype(i)
            ,l_tab_hol_mixed_case(i)
            ,l_tab_hol_user_option(i)
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
DECLARE
--
-- HIG_USER_OPTION_LIST
--
   l_tab_huol_id         nm3type.tab_varchar30;
   l_tab_huol_product    nm3type.tab_varchar30;
   l_tab_huol_name       nm3type.tab_varchar30;
   l_tab_huol_remarks    nm3type.tab_varchar2000;
   l_tab_huol_domain     nm3type.tab_varchar30;
   l_tab_huol_datatype   nm3type.tab_varchar30;
   l_tab_huol_mixed_case nm3type.tab_varchar30;
--
   c_y_or_n CONSTANT    hig_domains.hdo_domain%TYPE := 'Y_OR_N';
--
   PROCEDURE add_huol (p_huol_id         VARCHAR2
                 ,p_huol_product    VARCHAR2
                 ,p_huol_name       VARCHAR2
                 ,p_huol_remarks    VARCHAR2
                 ,p_huol_domain     VARCHAR2 DEFAULT Null
                 ,p_huol_datatype   VARCHAR2 DEFAULT nm3type.c_varchar
                 ,p_huol_mixed_case VARCHAR2 DEFAULT 'N'
                 ) IS
      c_count PLS_INTEGER := l_tab_huol_id.COUNT+1;
   BEGIN
      l_tab_huol_id(c_count)         := p_huol_id;
      l_tab_huol_product(c_count)    := p_huol_product;
      l_tab_huol_name(c_count)       := p_huol_name;
      l_tab_huol_remarks(c_count)    := p_huol_remarks;
      l_tab_huol_domain(c_count)     := p_huol_domain;
      l_tab_huol_datatype(c_count)   := p_huol_datatype;
      l_tab_huol_mixed_case(c_count) := p_huol_mixed_case;
   END add_huol;
BEGIN

--
--
-- HIG user options
--
 add_huol(p_huol_id         => 'DATE_MASK'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'User Date Mask'
        ,p_huol_remarks    => 'User Date Mask'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'INTERPATH'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'Interfaces Output File Path'
        ,p_huol_remarks    => 'Interfaces Output File Path'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'PREFUNITS'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'User preferred units'
        ,p_huol_remarks    => 'User preferred units'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'REPCLIPATH'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'Reports Client Path'
        ,p_huol_remarks    => 'Reports Client Path'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'REPDEFCMND'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'Reports Default Command'
        ,p_huol_remarks    => 'Reports Default Command'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'REPPRNNORM'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'Normal Print Command'
        ,p_huol_remarks    => 'Normal Print Command'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'REPPRNWIDE'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'Wide Print Command'
        ,p_huol_remarks    => 'Wide Print Command'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'REPSQLPLUS'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'Reports SQL Plus command'
        ,p_huol_remarks    => 'Reports SQL Plus command'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'REPVEWTOOL'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'Reports Viewing Tool'
        ,p_huol_remarks    => 'Reports Viewing Tool'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'UTL_DIR'
        ,p_huol_product    => 'HIG'
        ,p_huol_name       => 'UTL_FILE Directory'
        ,p_huol_remarks    => 'UTL_FILE Directory'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
-- NET user options
--
 add_huol(p_huol_id         => 'WEBAPDRAD'
        ,p_huol_product    => 'NET'
        ,p_huol_name       => 'Use Radio Buttons to select'
        ,p_huol_remarks    => 'Use Radio Buttons to select'
        ,p_huol_domain     => 'Y_OR_N'
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'N');
--
 add_huol(p_huol_id         => 'WEBAPDDEP'
        ,p_huol_product    => 'NET'
        ,p_huol_name       => 'Calculate APD dependencies'
        ,p_huol_remarks    => 'Calculate APD dependencies'
        ,p_huol_domain     => 'Y_OR_N'
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'N');
--
--
-- AST user options
--
 add_huol(p_huol_id         => 'DEFAORPBI'
        ,p_huol_product    => 'AST'
        ,p_huol_name       => 'PBI query used in AOR'
        ,p_huol_remarks    => 'PBI query used in AOR'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--
 add_huol(p_huol_id         => 'DEFATTRSET'
        ,p_huol_product    => 'AST'
        ,p_huol_name       => 'Default Attribute Set'
        ,p_huol_remarks    => 'Default Attribute Set'
        ,p_huol_domain     => ''
        ,p_huol_datatype   => 'VARCHAR2'
        ,p_huol_mixed_case => 'Y');
--

   FORALL i IN 1..l_tab_huol_id.COUNT
      INSERT INTO hig_user_option_list
            (huol_id
            ,huol_product
            ,huol_name
            ,huol_remarks
            ,huol_domain
            ,huol_datatype
            ,huol_mixed_case
            )
      SELECT l_tab_huol_id(i)
            ,l_tab_huol_product(i)
            ,l_tab_huol_name(i)
            ,l_tab_huol_remarks(i)
            ,l_tab_huol_domain(i)
            ,l_tab_huol_datatype(i)
            ,l_tab_huol_mixed_case(i)
        FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_user_option_list
                         WHERE  huol_id = l_tab_huol_id(i)
                        );
--
END;
/

DECLARE
--
-- HIG_STATUS_CODES
--
   l_tab_hsc_domain_code    nm3type.tab_varchar30;
   l_tab_hsc_status_code    nm3type.tab_varchar10;
   l_tab_hsc_status_name    nm3type.tab_varchar30;
   l_tab_hsc_seq_no         nm3type.tab_number;
   l_tab_hsc_allow_feature1 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature2 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature3 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature4 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature5 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature6 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature7 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature8 nm3type.tab_varchar1;
   l_tab_hsc_allow_feature9 nm3type.tab_varchar1;
   l_tab_hsc_start_date     nm3type.tab_date;
   l_tab_hsc_end_date       nm3type.tab_date;
--
   c_y_or_n CONSTANT    hig_domains.hdo_domain%TYPE := 'Y_OR_N';
--
   PROCEDURE add ( l_tab_hsc_domain_code    VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_status_code    VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_status_name    VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_seq_no         NUMBER DEFAULT NULL
                 , l_tab_hsc_allow_feature1 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature2 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature3 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature4 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature5 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature6 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature7 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature8 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_allow_feature9 VARCHAR2 DEFAULT NULL
                 , l_tab_hsc_start_date     DATE DEFAULT NULL
                 , l_tab_hsc_end_date       DATE DEFAULT NULL
                 ) IS
      c_count PLS_INTEGER := l_tab_hsc_domain_code.COUNT+1;
   BEGIN
      l_tab_hsc_domain_code(c_count)    := p_hsc_domain_code;
      l_tab_hsc_status_code(c_count)    := p_hsc_status_code;
      l_tab_hsc_status_name(c_count)    := p_hsc_status_name;
      l_tab_hsc_seq_no(c_count)         := p_hsc_seq_no;
      l_tab_hsc_allow_feature1(c_count) := p_hsc_allow_feature1;
      l_tab_hsc_allow_feature2(c_count) := p_hsc_allow_feature2;
      l_tab_hsc_allow_feature3(c_count) := p_hsc_allow_feature3;
      l_tab_hsc_allow_feature4(c_count) := p_hsc_allow_feature4;
      l_tab_hsc_allow_feature5(c_count) := p_hsc_allow_feature5;
      l_tab_hsc_allow_feature6(c_count) := p_hsc_allow_feature6;
      l_tab_hsc_allow_feature7(c_count) := p_hsc_allow_feature7;
      l_tab_hsc_allow_feature8(c_count) := p_hsc_allow_feature8;
      l_tab_hsc_allow_feature9(c_count) := p_hsc_allow_feature9;
      l_tab_hsc_start_date(c_count)     := p_hsc_start_date;
      l_tab_hsc_end_date(c_count)       := p_hsc_end_date;
   END add;
BEGIN

--
--
   add(p_hsc_domain_code     => 'COMPLAINTS'
      ,p_hsc_status_code     => 'WA'
      ,p_hsc_status_name     => 'Work Actioned'
      ,p_hsc_seq_no          => 11
      ,p_hsc_allow_feature1  => 'N'
      ,p_hsc_allow_feature2  => 'N'
      ,p_hsc_allow_feature3  => 'N'
      ,p_hsc_allow_feature4  => 'N'
      ,p_hsc_allow_feature5  => 'Y'
      ,p_hsc_allow_feature6  => 'Y'
      ,p_hsc_allow_feature7  => 'N'
      ,p_hsc_allow_feature8  => 'N'
      ,p_hsc_allow_feature9  => 'N'
      ,p_hsc_start_date      => null
      ,p_hsc_end_date        => null
      );

   FORALL i IN 1..l_tab_hsc_domain_code.COUNT
      INSERT INTO hig_status_codes
            (hsc_domain_code
            ,hsc_status_code
            ,hsc_status_name
            ,hsc_seq_no
            ,hsc_allow_feature1
            ,hsc_allow_feature2
            ,hsc_allow_feature3
            ,hsc_allow_feature4
            ,hsc_allow_feature5
            ,hsc_allow_feature6
            ,hsc_allow_feature7
            ,hsc_allow_feature8
            ,hsc_allow_feature9
            ,hsc_start_date
            ,hsc_end_date
            )
      SELECT l_tab_hsc_domain_code(i)
            ,l_tab_hsc_status_code(i)
            ,l_tab_hsc_status_name(i)
            ,l_tab_hsc_seq_no(i)
            ,l_tab_hsc_allow_feature1(i)
            ,l_tab_hsc_allow_feature2(i)
            ,l_tab_hsc_allow_feature3(i)
            ,l_tab_hsc_allow_feature4(i)
            ,l_tab_hsc_allow_feature5(i)
            ,l_tab_hsc_allow_feature6(i)
            ,l_tab_hsc_allow_feature7(i)
            ,l_tab_hsc_allow_feature8(i)
            ,l_tab_hsc_allow_feature9(i)
            ,l_tab_hsc_start_date(i)
            ,l_tab_hsc_end_date(i)
        FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_status_codes
                         WHERE  hsc_domain_code = l_tab_hsc_domain_code(i)
                           AND  hsc_status_code = l_tab_hsc_status_code(i)
                        );
--
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
    add_hsa('NM_PROGRESS','PRG_PROGRESS_ID','PRG_ID_SEQ');
    add_hsa('NM_AUDIT_WHEN','NAW_ID','NAW_ID_SEQ');    
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
-------------------------------------------------------------------------------------------
-- INV_CATEGORIES
--
INSERT INTO nm_inv_categories
      (nic_category
      ,nic_descr
      )
SELECT 'D'
      ,'Derived (composite) Asset'
 FROM  dual
WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_inv_categories
                   WHERE  nic_category = 'D'
                  )
/
--
-------------------------------------------------------------------------------------------
-- INV_CATEGORY_MODULES
--
INSERT INTO nm_inv_category_modules
      (icm_nic_category
      ,icm_hmo_module
      ,icm_updatable
      )
SELECT 'D'
      ,a.icm_hmo_module
      ,'N'
 FROM  nm_inv_category_modules a
WHERE  a.icm_nic_category = 'I'
 AND   NOT EXISTS (SELECT 1
                    FROM  nm_inv_category_modules b
                   WHERE  b.icm_nic_category = 'D'
                    AND   b.icm_hmo_module   = a.icm_hmo_module
                  )
/
--
---------------------------------------------------------------------------------------------------
--                   **************** MISCELLANEOUS CHANGES BELOW HERE *******************

--
-- Module removed from NM3 (also removed at 3211)
--
DELETE FROM hig_modules
WHERE hmo_module = 'NM0002'
/
DELETE FROM hig_standard_favourites
WHERE hstf_child = 'NM0002'
/




--
-- NSG Data Manager Product Name Change
--
UPDATE hig_products
SET    hpr_product_name = 'Street Manager'
WHERE  hpr_product = 'NSG'
/
UPDATE hig_standard_favourites
SET    hstf_descr = 'Street Manager'
WHERE  hstf_parent = 'FAVOURITES'
AND    hstf_child = 'NSG'
/


--
-- Highways Product Name Change
--
UPDATE hig_products
SET    hpr_product_name = 'exor'
WHERE  hpr_product = 'HIG'
/
UPDATE hig_standard_favourites
SET    hstf_descr = 'exor'
WHERE  hstf_parent = 'FAVOURITES'
AND    hstf_child = 'HIG'
/


--
-- Report style metadata
--
UPDATE hig_report_styles
SET    hrs_footer_text = 'Exor Leading the way in Infrastructure Asset Management Solutions... '
WHERE  hrs_style_name = 'EXOR_DEFAULT'
/
UPDATE hig_report_styles
SET    hrs_footer_text = 'Exor Leading the way in Infrastructure Asset Management Solutions... '
WHERE  hrs_style_name = 'EXOR_CORPORATE'
/


--
-- Product/user options changes
--
UPDATE hig_option_list
SET hol_user_option = 'Y'
WHERE EXISTS (SELECT 'x'
              FROM hig_codes
              WHERE hco_domain = 'USER_OPTIONS'
              AND  hco_code = hol_id)
/
UPDATE hig_option_list
SET hol_user_option = 'N'
WHERE NOT EXISTS (SELECT 'x'
                  FROM hig_codes
                  WHERE hco_domain = 'USER_OPTIONS'
                  AND  hco_code = hol_id)
/
delete from hig_codes where hco_domain = 'USER_OPTIONS'
/
delete from hig_domains where hdo_domain = 'USER_OPTIONS'
/
update hig_modules
set hmo_title = 'Product and User Option List'
where hmo_module = 'HIG9135'
/
update hig_standard_favourites
set hstf_descr = 'Product and User Option List'
where hstf_child = 'HIG9135'
/
DELETE FROM hig_modules
WHERE hmo_module = 'HIG1838'
/
DELETE FROM hig_standard_favourites
WHERE hstf_child = 'HIG1838'
/

--
-- Module Removed from NSG
--
DELETE FROM hig_standard_favourites
WHERE hstf_child = 'NSG0021'
/
--
COMMIT;
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************



