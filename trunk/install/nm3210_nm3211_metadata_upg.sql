--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3210_nm3211_metadata_upg.sql	1.12 03/10/06
--       Module Name      : nm3210_nm3211_metadata_upg.sql
--       Date into SCCS   : 06/03/10 15:41:04
--       Date fetched Out : 07/06/13 13:58:01
--       SCCS Version     : 1.12
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


 
  -- HIG errors
  --
  l_current_type := 'HIG';
  --
 
  --
  -- Spatial Server error messages (belong to HIG)
  --
  add_ner(266,  'No base themes for this route type');
  add_ner(267,  'No themes for linear type');
  add_ner(268,  'Cannot derive Gtype from base theme');
  add_ner(269,  'Duplicate Theme or Theme Name Found');
  add_ner(270,  'Theme is already registered');
  add_ner(271,  'Error associating Geometry Type with Theme');
  add_ner(272,  'No themes for linear type ');
  add_ner(273,  'Error creating spatial sequence');
  add_ner(274,  'Theme is not a datum layer');
  add_ner(275,  'Table already exists - please specify another');
  add_ner(276,  'No subordinate users to process!');
  add_ner(277,  'Creation of view(s) not neccessary - no layers use SRIDS');
  add_ner(278,  'Error dropping private synonym');
  add_ner(279,  'No USGM data to process!');
  add_ner(280,  'Inconsistent base srids');
  add_ner(281,  'There are no known themes, populate the input array arguments');
  add_ner(282,  'Fatal error in dynamic segmentation on');
  add_ner(283,  'You may not project a geometry in a local cordinate system');
  add_ner(284,  'Mid point must apply to a line');
  add_ner(285,  'Invalid dimension for mid-point function');
  add_ner(286,  'No snaps at this position');
  add_ner(287,  'Unknown geometry type - must be a point, line or polygon');
  add_ner(288,  'Not a point geometry');
  add_ner(289,  'Use sdo_point');
  add_ner(290,  'Not a single part');
  add_ner(291,  'Theme is not a linear referencing layer - cannot return projections');
  add_ner(292,  'Cannot find position to project from');
  add_ner(293,  'No NT datums for ne_id');
  add_ner(294,  'No NT type for nlt id');
  add_ner(295,  'No geometry column on the table');
  add_ner(296,  'More than one geometry column, need to choose one');
  add_ner( 297, 'Dyn seg error - mismatch in length of datum and shape');
  add_ner( 298, 'Dyn seg error - measures are out of bounds of datum lengths');  


   --
   -- NET errors
   --
   l_current_type := 'NET';
   --


   ------------------------------------------------------
   -- Remove the reserved errors for derived assets
   --
   delete from nm_errors
   where ner_appl = 'NET'
   and   ner_id IN (400,401,402,403,404,405,406,407,408,409,411,412,413,414,415,416,417,418,419,420);


   ------------------------------
   -- Start Derived Assets Errors
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
   -- End Derived Assets Errors
   ------------------------------
   
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

--
-- Derived Assets
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
-- PT: Bulk Asset Update
--
   l_rec_hmo.hmo_module           := 'NM0535';
   l_rec_hmo.hmo_title            := 'Bulk Asset Update';
   l_rec_hmo.hmo_filename         := 'nm0535';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'Y';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'AST';
   l_rec_hmo.hmo_menu             := null; --'FORM';
   add_hmo;
   add_hmr ('NET_USER','NORMAL');
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


-- for NM0535
-- create a theme function for all non-foreign table themes to call the Bulk Assets Update module
merge into nm_theme_functions_all d using (
  select gt_theme_id NTH_THEME_ID
        ,'NM0535' HMO_MODULE
        ,'GIS_SESSION_ID' PARAMETER
        ,'UPDATE ' || nit_inv_type MENU_OPTION
        ,'Y'  SEEN_IN_GIS
  from   gis_themes
        ,nm_inv_types
        ,nm_inv_themes
  where  gt_theme_id = nith_nth_theme_id
  and    nith_nit_id = nit_inv_type
  and    nit_table_name is null
  ) s
  on (s.NTH_THEME_ID = d.NTF_NTH_THEME_ID
  and s.HMO_MODULE = d.NTF_HMO_MODULE
  and s.PARAMETER = d.NTF_PARAMETER)
when matched then
  update set
     d.NTF_SEEN_IN_GIS = d.NTF_SEEN_IN_GIS
    -- d.NTF_MENU_OPTION = s.MENU_OPTION
    --,d.NTF_SEEN_IN_GIS = s.SEEN_IN_GIS
when not matched then
  insert (NTF_NTH_THEME_ID, NTF_HMO_MODULE, NTF_PARAMETER, NTF_MENU_OPTION, NTF_SEEN_IN_GIS) 
  values (s.NTH_THEME_ID, s.HMO_MODULE, s.PARAMETER, s.MENU_OPTION, s.SEEN_IN_GIS)
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
-- Derived Assets
--
  add (p_hstf_parent  => 'AST_REF'
       ,p_hstf_child   => 'NM0420'
       ,p_hstf_descr   => 'Derived Asset Setup'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  9
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
-- Derived Assets
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
-- Derived Assets
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
--
-- Spatial Server Product Option
--
   add(p_hol_id         => 'SDODEFTOL'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'SDO Default Tolerance'
      ,p_hol_remarks    => 'SDO Default Tolerance'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'NUMBER'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => '0.005');
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
   FORALL i IN 1..l_tab_hol_id.COUNT
     INSERT INTO hig_codes
            (hco_domain
            ,hco_code
            ,hco_meaning
            ,hco_system
            )
      SELECT 'USER_OPTIONS'
            ,l_tab_hol_id(i)
			,l_tab_hol_name(i)
			,'Y'
      FROM dual
     WHERE l_tab_hol_user_option(i) = 'Y'
      AND  NOT EXISTS (SELECT 1
                       FROM  hig_codes
                       WHERE hco_domain = 'USER_OPTIONS'
                       AND   hco_code =   l_tab_hol_id(i)
                       );                        
                       
 
END;
/
--
---------------------------------------------------------------------------------------------------
--                   **************** MISCELLANEOUS CHANGES BELOW HERE *******************


--
-- Derived Assets Misc Change
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
-- Derived Assets Misc Change
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
COMMIT;
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************

