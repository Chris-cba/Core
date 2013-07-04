--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3210_nm40_metadata_upg.sql	1.102 02/07/07
--       Module Name      : nm3210_nm40_metadata_upg.sql
--       Date into SCCS   : 07/02/07 10:25:03
--       Date fetched Out : 07/06/13 13:58:07
--       SCCS Version     : 1.102
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

  --RAC - errors in nsg spatial stuff - these are both spatial and nsg so registered them as hig
  add_ner(434, 'NSG Node Theme is not present');
  add_ner(435, 'NSG ESU theme is not present');

  -- GJ - errors for enhanced security checking e.g. for use when defects are created in MAI3807 and by trigger on doc_assocs
  add_ner(436, 'User is not permitted to operate on the selected network element');
  add_ner(437, 'User is not permitted to operate on the selected asset');

  -- MH - Error For Locator As XY LOV.
  add_ner(438, 'Please Close Locator Before Using It As A Co-ordinate LOV.');
  -- MH Intervals
  add_ner(442,  'No Interval Exists For Given Interval Code. Please Use HIG1220 To Enter An Iterval For Interval Code');

  -- MH - Error For Create User.
  add_ner(443,  'User Creation Failed!');

  --CP 11/12/2006
  add_ner(500,  'This module is not available when the application is run on the web.');

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

  --
  -- DC : locator messages
  add_ner(426, 'Please enter both Eastings and Northings');
  add_ner(427, 'Please enter search criteria');
  add_ner(428, 'Eastings are out of bounds');
  add_ner(429, 'Northings are out of bounds');

  -- FJF: Log 702143
  add_ner(430, 'Cannot find linear parent for auto include','Network/Group type does not have a linear parent');

  -- FJF 10g reports server guff
  add_ner(431,  'No Reports Server Defined','The procedure to call reports through an Application Server has been called and has no reports server defined');

  -- MJA nm0410 Validate Asset API param name
  add_ner(432,  'Value already exists in the database - Query or re-enter');

  -- GJ - gaz query will reject inv types that are off network if querying in the context of network
  add_ner(433,  'Asset Type must be ''On Network''');

  -- MJA nm0410 Validate Asset API param name
  add_ner(436,  'Invalid character(s) detected in string');

  -- FJF rescale TM 17351
  add_ner(437,  'Route flagged as a divided highway and no carriageway indicator available', 'Suggest toggle group type reversable flag' );

  -- GJ new error message to support NM0590
  add_ner(438,  'Query must be restricted by at least Asset Type or Primary Key or Use Advanced Query on Floating Toolbar' );

  -- FJF rescale TM 11701
  add_ner(439,  'Rescale may not be called on a datum', 'Please contact exor support' );
  add_ner(440,  'You have selected a datum: assets on a route only supports using an entire datum', 'Use a route with the datum in and then select the offset you require' );

  -- MJA nm0590 TM 23336
  add_ner(441,  'No items have been selected from the map');

  -- MH nm7041 TM 36466
  add_ner(442,  'Auto Inclusion Group Type Is Non Linear, Please Select A Prefered LRM' );

  --KA MP referencing
  add_ner(443,  'References must be relative to a linear route');
  add_ner(444,  'Reference asset types must be point and allowed on the network for the asset location');


  -- GJ 21-DEC-2006
  -- 44300 - error message for additional check plugged into mai2110c.pkb
  add_ner(445,  'Asset item with this primary key/asset type/start date already exists' );

  --KA MP some more for referencing
  add_ner(446,  'Reference item has more than one location');
  add_ner(447,  'Asset is not located on the specified route');
  add_ner(448,  'Asset has more than one location');

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

-- added MJA
   l_domain := 'GAZ_QRY_FIXED_COLS_I';
   add_hco(l_domain,'IIT_NOTE','Note','Y',1110);
   add_hco(l_domain,'IIT_DESCR','Description','Y',1120);

   l_domain := 'CALL_NM9999';
   add_hdo(l_domain,'NET','Modules that return domain instead of id',30);
   add_hco(l_domain,'GRI0200','Reports','Y',1);

   l_domain := 'CALL_NM0570';
   add_hdo(l_domain,'NET','List of modules that call NM570',7);
   add_hco(l_domain,'DOC0150','Public Enquiries','Y',1);
   add_hco(l_domain,'NM0510','Asset Items','Y',2);
   add_hco(l_domain,'NM0560','Assets on a Route','Y',3);
   add_hco(l_domain,'NM0590','Asset Maintenance','Y',4);
-- MJA
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
--
   l_rec_hmo.hmo_module           := 'NM0590';
   l_rec_hmo.hmo_title            := 'Asset Maintenance';
   l_rec_hmo.hmo_filename         := 'nm0590';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'AST';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0150';
   l_rec_hmo.hmo_title            := 'Network Nodes Report';
   l_rec_hmo.hmo_filename         := 'nm0150';
   l_rec_hmo.hmo_module_type      := 'R25';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0151';
   l_rec_hmo.hmo_title            := 'Node Usage Report';
   l_rec_hmo.hmo_filename         := 'nm0151';
   l_rec_hmo.hmo_module_type      := 'R25';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0153';
   l_rec_hmo.hmo_title            := 'Group of Sections Membership Report';
   l_rec_hmo.hmo_filename         := 'nm0153';
   l_rec_hmo.hmo_module_type      := 'R25';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0154';
   l_rec_hmo.hmo_title            := 'Route Log Report';
   l_rec_hmo.hmo_filename         := 'nm0154';
   l_rec_hmo.hmo_module_type      := 'R25';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0155';
   l_rec_hmo.hmo_title            := 'Group Hierarchy Report';
   l_rec_hmo.hmo_filename         := 'nm0155';
   l_rec_hmo.hmo_module_type      := 'R25';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := 'NET';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_USER','NORMAL');
--
   l_rec_hmo.hmo_module           := 'GIS0020';
   l_rec_hmo.hmo_title            := 'GIS Layer Tool';
   l_rec_hmo.hmo_filename         := 'gis0020';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_USER','NORMAL');

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
-- HIG_STANDARD_FAVOURITES
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
   add (p_hstf_parent  => 'NSG_DATA_ADMIN'
       ,p_hstf_child   => 'NSG0015'
       ,p_hstf_descr   => 'Reset Street Coordinates'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  1
        );
--
   add (p_hstf_parent  => 'NSG_DATA_ADMIN'
       ,p_hstf_child   => 'NSG0025'
       ,p_hstf_descr   => 'Generate ASD Placements'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  2
        );
--
   add (p_hstf_parent  => 'NSG_IMPORT_EXPORT'
       ,p_hstf_child   => 'NSG0040'
       ,p_hstf_descr   => 'NSG File Manager'
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
   add (p_hstf_parent  => 'NET_INVENTORY'
       ,p_hstf_child   => 'NM0590'
       ,p_hstf_descr   => 'Asset Maintenance'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  4
        );
--
   add (p_hstf_parent  => 'MAI_FINANCIAL_REPORTS'
       ,p_hstf_child   => 'MAI3841'
       ,p_hstf_descr   => 'Payment Run Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  1
        );
--
   add (p_hstf_parent  => 'NET_NET_MANAGEMENT'
       ,p_hstf_child   => 'NET_NET_REPORTS'
       ,p_hstf_descr   => 'Reports'
       ,p_hstf_type    => 'F'
       ,p_hstf_order   =>  6
        );
--
   add (p_hstf_parent  => 'NET_NET_REPORTS'
       ,p_hstf_child   => 'NM0150'
       ,p_hstf_descr   => 'Network Nodes Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  1
        );
--
   add (p_hstf_parent  => 'NET_NET_REPORTS'
       ,p_hstf_child   => 'NM0151'
       ,p_hstf_descr   => 'Node Usage Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  2
        );
--
   add (p_hstf_parent  => 'NET_NET_REPORTS'
       ,p_hstf_child   => 'NM0153'
       ,p_hstf_descr   => 'Group of Sections Membership Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  3
        );
--
   add (p_hstf_parent  => 'NET_NET_REPORTS'
       ,p_hstf_child   => 'NM0154'
       ,p_hstf_descr   => 'Route Log Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  4
        );
--
   add (p_hstf_parent  => 'NET_NET_REPORTS'
       ,p_hstf_child   => 'NM0155'
       ,p_hstf_descr   => 'Group Hierarchy Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  5
        );
--
   add (p_hstf_parent  => 'UKP_PROCESS_DATA'
       ,p_hstf_child   => 'UKP0026'
       ,p_hstf_descr   => 'Road Condition Indicator'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  2
        );
--
   add (p_hstf_parent  => 'UKP_PROC_REPORTS'
       ,p_hstf_child   => 'UKP_BVPI_REPORTS'
       ,p_hstf_descr   => 'BVPI Reports'
       ,p_hstf_type    => 'F'
       ,p_hstf_order   =>  1
        );
--
   add (p_hstf_parent  => 'UKP_PROC_REPORTS'
       ,p_hstf_child   => 'UKP_BUDGET_REPORTS'
       ,p_hstf_descr   => 'Budget Reports'
       ,p_hstf_type    => 'F'
       ,p_hstf_order   =>  2
        );
--
   add (p_hstf_parent  => 'UKP_PROC_REPORTS'
       ,p_hstf_child   => 'UKP_UTILITIES_REPORTS'
       ,p_hstf_descr   => 'Utilities'
       ,p_hstf_type    => 'F'
       ,p_hstf_order   =>  3
        );
--
   add (p_hstf_parent  => 'UKP_BVPI_REPORTS'
       ,p_hstf_child   => 'UKP0040'
       ,p_hstf_descr   => 'BVPI223 Principal Roads Condition (Scanner RCI)'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  4
        );
--
   add (p_hstf_parent  => 'UKP_BVPI_REPORTS'
       ,p_hstf_child   => 'UKP0041'
       ,p_hstf_descr   => 'BVPI224a Non-Principal Road Condition(Scanner RCI)'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  5
        );
--
   add (p_hstf_parent  => 'UKP_UTILITIES_REPORTS'
       ,p_hstf_child   => 'UKP0025'
       ,p_hstf_descr   => 'Defect Lengths by Condition Index'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  1
        );
--
   add (p_hstf_parent  => 'UKP_UTILITIES_REPORTS'
       ,p_hstf_child   => 'UKP0029'
       ,p_hstf_descr   => 'Invalid Survey Data Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  3
        );
--
   add (p_hstf_parent  => 'UKP_UTILITIES_REPORTS'
       ,p_hstf_child   => 'UKP0028'
       ,p_hstf_descr   => 'Road Condition Indicator Report'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  4
        );
--
   add (p_hstf_parent  => 'UKP_UTILITIES_REPORTS'
       ,p_hstf_child   => 'UKP0024'
       ,p_hstf_descr   => 'Automatic Pass Section Details'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  5
        );
--
   add (p_hstf_parent  => 'UKP_MAINTAIN_DATA'
       ,p_hstf_child   => 'NET1119'
       ,p_hstf_descr   => 'Network Selection'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  5
        );
--
   add (p_hstf_parent  => 'HIG_GIS'
       ,p_hstf_child   => 'GIS0020'
       ,p_hstf_descr   => 'GIS Layer Tool'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  3
        );
--
   add (p_hstf_parent  => 'MAI_REF_MAINTENANCE'
       ,p_hstf_child   => 'MAI0132'
       ,p_hstf_descr   => 'Work Order Priorities'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  12
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
-- Reorder and rename UKPMS menu items - SW
--
update hig_standard_favourites
set    hstf_descr = 'HMDIF TTS/SCANNER and Griptester'
where  hstf_child = 'UKP036'
/
update hig_standard_favourites
set    hstf_descr = 'HMDIF Condition (CVI/DVI) and Rutting (CRUT/DRUT)'
where  hstf_child = 'UKP032'
/
update hig_standard_favourites
set    hstf_order = 3
where  hstf_child = 'UKP0006'
/
update hig_standard_favourites
set    hstf_order = 4
where  hstf_child = 'UKP0008'
/
update hig_standard_favourites
set    hstf_order = 5
where  hstf_child = 'UKP_PROC_REPORTS'
/
update hig_standard_favourites
set    hstf_order = 1
,      hstf_parent = 'UKP_BVPI_REPORTS'
,      hstf_descr = 'BVPI96 Principal Roads Condition (TTS)'
where  hstf_child = 'UKP0019'
/
update hig_standard_favourites
set    hstf_order = 2
,      hstf_parent = 'UKP_BVPI_REPORTS'
,      hstf_descr = 'BVPI96 Principal Roads Condition (CVI/DVI)'
where  hstf_child = 'UKP0016'
/
update hig_standard_favourites
set    hstf_order = 3
,      hstf_parent = 'UKP_BVPI_REPORTS'
,      hstf_descr = 'BVPI187 Footway Performance Indicator Report'
where  hstf_child = 'UKP0018'
/
update hig_standard_favourites
set    hstf_order = 6
,      hstf_parent = 'UKP_BVPI_REPORTS'
,      hstf_descr = 'BVPI224b/97b Non-Principal Road Condition(CVI/DVI)'
where  hstf_child = 'UKP0017'
/
update hig_standard_favourites
set    hstf_order = 1
,      hstf_parent = 'UKP_BUDGET_REPORTS'
where  hstf_child = 'UKP0012'
/
update hig_standard_favourites
set    hstf_order = 2
,      hstf_parent = 'UKP_BUDGET_REPORTS'
where  hstf_child = 'UKP0014'
/
update hig_standard_favourites
set    hstf_order = 3
,      hstf_parent = 'UKP_BUDGET_REPORTS'
where  hstf_child = 'UKP0013'
/
update hig_standard_favourites
set    hstf_order = 2
,      hstf_parent = 'UKP_UTILITIES_REPORTS'
where  hstf_child = 'UKP0015'
/
update hig_standard_favourites
set    hstf_order = 6
,      hstf_parent = 'UKP_UTILITIES_REPORTS'
where  hstf_child = 'UKP0095'
/
update hig_standard_favourites
set    hstf_order = 7
,      hstf_parent = 'UKP_UTILITIES_REPORTS'
where  hstf_child = 'UKP0011'
/
delete from  hig_standard_favourites
where hstf_parent = 'UKP_PROC_REPORTS'
and hstf_type = 'M'
/
--
-- Remove redundant menu options
--
DELETE FROM hig_standard_favourites
WHERE  hstf_parent = 'NSG_DATA'
AND    hstf_child  = 'NSG0030'
/

--
-- Correct spelling mistake
--
UPDATE hig_standard_favourites
SET    hstf_descr = 'Co-ordination'
WHERE  hstf_parent = 'SWR'
AND    hstf_child  = 'SWR_COORD'
/
--
-- CP 21/07/2006
-- Refresh all the SWM hig_standard_favourites
--
-- Delete all SWM data first
DELETE FROM HIG_STANDARD_FAVOURITES
WHERE  HSTF_PARENT LIKE 'SWR%'
/

--
-- Following code taken from nm3data2.sql
--
-- CP 31/10/2006 Remove swr1293; add swr1259
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_REF_ADMIN'
       ,'SWR1510'
       ,'Maintain Interface Mappings'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1510');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1512'
       ,'Maintain Works Rules'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1512');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1513'
       ,'Maintain Site Rules'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1513');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1514'
       ,'Maintain Sample Inspection Category Items'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1514');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR1517'
       ,'Maintain Defect Inspection Schedule'
       ,'M'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1517');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR1290'
       ,'Schedule Inspections'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1290');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1292'
       ,'Works Inspection Report'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1292');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1294'
       ,'Prospective Inspections Report'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1294');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1325'
       ,'Sample Inspections Invoice Report'
       ,'M'
       ,90 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1325');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1326'
       ,'Inspections Invoice'
       ,'M'
       ,100 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1326');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1328'
       ,'Chargeable Notices Invoice'
       ,'M'
       ,130 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1328');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_GAZ_ADMIN'
       ,'SWR1336'
       ,'Maintain Street Naming Authorities'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1336');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1209'
       ,'Expiring Reinstatement Guarantees'
       ,'M'
       ,100 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1209');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1212'
       ,'Interim Reinstatements > 6 Months Old'
       ,'M'
       ,90 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1212');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR1240'
       ,'Maintain Annual Inspection Profiles'
       ,'M'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1240');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR1250'
       ,'Maintain Inspection Details'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1250');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1255'
       ,'Annual Inspection Profiles'
       ,'M'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1255');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1256'
       ,'Sample Inspection Quotas Report'
       ,'M'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1256');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1257'
       ,'Inspection Performance'
       ,'M'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1257');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_REF_ADMIN'
       ,'SWR1060'
       ,'System Definitions'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1060');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_QUERY'
       ,'SWR1070'
       ,'Query Works/Sites'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
                    AND  HSTF_CHILD = 'SWR1070');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_COMMENTS_ADMIN'
       ,'SWR1111'
       ,'Maintain Works Comments'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COMMENTS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1111');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN'
       ,'SWR1120'
       ,'Notices Sent/Received'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_REF_ADMIN'
       ,'SWR1051'
       ,'Maintain User Definitions'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1051');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1156'
       ,'Works History'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1156');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN'
       ,'SWR1180'
       ,'Merge Unattributable Works'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1180');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_QUERY'
       ,'SWR1189'
       ,'Query Works History'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
                    AND  HSTF_CHILD = 'SWR1189');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN'
       ,'SWR1190'
       ,'Maintain Works / Reinstatement Details'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1190');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1195'
       ,'Notice Analysis Report'
       ,'M'
       ,120 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1195');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_COORD_REPORTS'
       ,'SWR1197'
       ,'Coordination Planning'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COORD_REPORTS'
                    AND  HSTF_CHILD = 'SWR1197');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_COORD_REPORTS'
       ,'SWR1198'
       ,'Conflicting Works'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COORD_REPORTS'
                    AND  HSTF_CHILD = 'SWR1198');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_GAZ_ADMIN'
       ,'SWR1530'
       ,'Streets of Interest'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1530');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_GAZ_REPORTS'
       ,'SWR1550'
       ,'SOI Gazetteer Data Report'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_REPORTS'
                    AND  HSTF_CHILD = 'SWR1550');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_GAZ_REPORTS'
       ,'SWR1551'
       ,'Authority Gazetteer Data Report'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_REPORTS'
                    AND  HSTF_CHILD = 'SWR1551');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN'
       ,'SWR1600'
       ,'Upload/Download Utility'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR1600');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN'
       ,'SWR1601'
       ,'Automatic Upload/Download Utility'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR1601');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1602'
       ,'Maintain Automatic Batch Processes'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1602');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1603'
       ,'Maintain Automatic Batch Rules'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1603');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1604'
       ,'Maintain Automatic Batch Operations'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1604');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN'
       ,'SWR1605'
       ,'Monitor Batch File Status'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR1605');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1519'
       ,'Maintain Notice Charges'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1519');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP'
       ,'SWR_INSP_ADMIN'
       ,'Admin'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP'
                    AND  HSTF_CHILD = 'SWR_INSP_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS'
       ,'SWR_WORKS_ADMIN'
       ,'Admin'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS'
                    AND  HSTF_CHILD = 'SWR_WORKS_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS'
       ,'SWR_WORKS_REPORTS'
       ,'Reports'
       ,'F'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS'
                    AND  HSTF_CHILD = 'SWR_WORKS_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP'
       ,'SWR_INSP_REPORTS'
       ,'Reports'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP'
                    AND  HSTF_CHILD = 'SWR_INSP_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_COORD'
       ,'SWR_COORD_REPORTS'
       ,'Reports'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COORD'
                    AND  HSTF_CHILD = 'SWR_COORD_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_REF'
       ,'Reference Data'
       ,'F'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_REF'
       ,'SWR_REF_ADMIN'
       ,'Admin'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF'
                    AND  HSTF_CHILD = 'SWR_REF_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN'
       ,'SWR_WORKS_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR_WORKS_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR_INSP_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR_INSP_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_GAZ_ADMIN'
       ,'SWR_GAZ_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR_GAZ_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH'
       ,'SWR_BATCH_ADMIN'
       ,'Admin'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH'
                    AND  HSTF_CHILD = 'SWR_BATCH_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN'
       ,'SWR_BATCH_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR_BATCH_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH'
       ,'SWR_BATCH_REPORTS'
       ,'Reports'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH'
                    AND  HSTF_CHILD = 'SWR_BATCH_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS_ADMIN'
       ,'SWR_ORGS_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR_ORGS_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_REF'
       ,'SWR_REF_REPORTS'
       ,'Reports'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF'
                    AND  HSTF_CHILD = 'SWR_REF_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1160'
       ,'Closed Works without a S74 Closed Notice'
       ,'M'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1160');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1161'
       ,'Works With S74 Charge'
       ,'M'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1161');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1210'
       ,'Check Inspection Units'
       ,'M'
       ,110 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1210');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1259'
       ,'Inspection Performance Hierarchy'
       ,'M'
       ,75 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1259');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_ORGS'
       ,'Organisations'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_ORGS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS'
       ,'SWR_ORG_REPORTS'
       ,'Reports'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS'
                    AND  HSTF_CHILD = 'SWR_ORG_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'FAVOURITES'
       ,'SWR'
       ,'Street Works Manager'
       ,'F'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'SWR');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS'
       ,'SWR_WORKS_QUERY'
       ,'Query'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS'
                    AND  HSTF_CHILD = 'SWR_WORKS_QUERY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_WORKS'
       ,'Works'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_WORKS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_COMMENTS'
       ,'Comments'
       ,'F'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_COMMENTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_INSP'
       ,'Inspections'
       ,'F'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_INSP');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_GAZ'
       ,'Gazetteer'
       ,'F'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_GAZ');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_COORD'
       ,'Co-ordination'
       ,'F'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_COORD');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR'
       ,'SWR_BATCH'
       ,'Batch Processing'
       ,'F'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_BATCH');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_REPORTS'
       ,'SWR1780'
       ,'Batch File Listing'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_REPORTS'
                    AND  HSTF_CHILD = 'SWR1780');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1710'
       ,'Maintain Inspection Item Status Codes'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1710');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1700'
       ,'Maintain Defect Notice Messages'
       ,'M'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1700');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1690'
       ,'Maintain Inspection Outcomes'
       ,'M'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1690');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1680'
       ,'Maintain Inspection Types'
       ,'M'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1680');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1670'
       ,'Maintain Sample Inspection Categories'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1670');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1660'
       ,'Maintain Inspection Categories'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1660');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1220'
       ,'Print Works Details'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1220');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1570'
       ,'Maintain Works/Sites Combinations'
       ,'M'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1570');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1560'
       ,'Maintain Allowable Site Updates'
       ,'M'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1560');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1159'
       ,'Works with a Section 74 Duration Challenge'
       ,'M'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1159');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1158'
       ,'Works Due a Section 74 Start'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1158');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1157'
       ,'Works Due to Complete'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1157');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_REPORTS'
       ,'SWR1610'
       ,'Batch Files Processed'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_REPORTS'
                    AND  HSTF_CHILD = 'SWR1610');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1650'
       ,'Section 74 Charges Invoice'
       ,'M'
       ,140 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1650');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1640'
       ,'Maintain Section 74 Charging Profile'
       ,'M'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1640');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN'
       ,'SWR1630'
       ,'Maintain Section 74 Charges'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1630');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1225'
       ,'Generic Works Report'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1225');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_COMMENTS_ADMIN'
       ,'SWR1112'
       ,'Comments Sent/Received'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COMMENTS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1112');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1620'
       ,'Maintain Batch Messages'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1620');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1305'
       ,'Inspection History'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1305');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_REPORTS'
       ,'SWR1230'
       ,'Generic Inspections Report'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1230');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR1770'
       ,'View Inspection Defects'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1770');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR1760'
       ,'View Inspections History'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1760');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN'
       ,'SWR1750'
       ,'Inspections Sent / Received'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1750');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_INSP_ADMIN_REF'
       ,'SWR1720'
       ,'Maintain Allowable Inspection Items'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1720');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN'
       ,'SWR1380'
       ,'Non Works Activity'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1380');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_QUERY'
       ,'SWR1390'
       ,'View Non Works Activity'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
                    AND  HSTF_CHILD = 'SWR1390');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN'
       ,'SWR1400'
       ,'Allocate Provisional Works'
       ,'M'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1400');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1401'
       ,'Maintain Work Types'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1401');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1403'
       ,'Maintain Notice Types'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1403');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS_ADMIN'
       ,'SWR1450'
       ,'SWA Organisations'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1450');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORG_REPORTS'
       ,'SWR1451'
       ,'Organisation Data Report'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORG_REPORTS'
                    AND  HSTF_CHILD = 'SWR1451');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS_ADMIN'
       ,'SWR1461'
       ,'Maintain District Hierarchy'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1461');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS_ADMIN'
       ,'SWR1471'
       ,'Contact List'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1471');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS_ADMIN'
       ,'SWR1480'
       ,'Coordination Groups'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1480');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS_ADMIN_REF'
       ,'SWR1490'
       ,'Standard Text'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1490');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_REF_ADMIN'
       ,'SWR1500'
       ,'Reference Data'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1500');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_REF_REPORTS'
       ,'SWR1501'
       ,'Reference Data Report'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_REPORTS'
                    AND  HSTF_CHILD = 'SWR1501');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_COMMENTS'
       ,'SWR_COMMENTS_ADMIN'
       ,'Admin'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COMMENTS'
                    AND  HSTF_CHILD = 'SWR_COMMENTS_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_ORGS'
       ,'SWR_ORGS_ADMIN'
       ,'Admin'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS'
                    AND  HSTF_CHILD = 'SWR_ORGS_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_GAZ'
       ,'SWR_GAZ_ADMIN'
       ,'Admin'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ'
                    AND  HSTF_CHILD = 'SWR_GAZ_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_GAZ'
       ,'SWR_GAZ_REPORTS'
       ,'Reports'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ'
                    AND  HSTF_CHILD = 'SWR_GAZ_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'SWR_WORKS_REPORTS'
       ,'SWR1193'
       ,'Works Overdue'
       ,'M'
       ,35 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1193');
--
-------------------------------------------------------------------------------------------------
--
------------------------------------------
-- Remove redundant SWM menu options - CP
------------------------------------------
DECLARE

   PROCEDURE drop_module(pi_hmo_module IN hig_modules.hmo_module%TYPE) IS

   BEGIN

         DELETE FROM hig_standard_favourites
         WHERE       hstf_child = pi_hmo_module;

         DELETE FROM hig_user_favourites
         WHERE       huf_child = pi_hmo_module;

         DELETE FROM hig_system_favourites
         WHERE       hsf_child = pi_hmo_module;

   END drop_module;

BEGIN
  -- Remove Maintain Street Gazetteer
  drop_module('SWR1330');
  -- Remove Maintain Street Coordinates
  drop_module('SWR1332');
  -- Remove Maintain Additional Street Data
  drop_module('SWR1337');
  -- Remove Maintain ASD Coordinates
  drop_module('SWR1350');
  -- Remove Street Reinstatement Designations
  drop_module('SWR1333');
  -- Remove Reinstatement Designation Coordinates
  drop_module('SWR1338');
  -- Remove Maintain Street Special Designations
  drop_module('SWR1335');
  -- Remove Special Designation Coordinates
  drop_module('SWR1339');

  -- Remove Maintain Reinstatement Categories
  drop_module('SWR1511');
  -- Remove Maintain Designation Types
  drop_module('SWR1334');

  -- Remove Works to be Re-Notified report
  drop_module('SWR1192');
  -- Remove Overdue 3/7 Days Works report
  drop_module('SWR1205');
  -- Remove Daily Works report
  drop_module('SWR1207');
  -- Remove Works Type Analysis report
  drop_module('SWR1202');

  -- Remove Maintain Error Messages
  drop_module('SWRERRM');
  -- Remove old Find Street Designations form
  drop_module('SWRP001');
  -- Remove Error Help
  drop_module('SWRP004');
  -- Remove Status Warnings
  drop_module('SWRP011');

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
-- Asset maint product option
add(p_hol_id         => 'DISAMBIGSC'
      ,p_hol_product    => 'NET'
      ,p_hol_name       => 'Display Ambig Sub Class'
      ,p_hol_remarks    => 'Should Ambig sub class be displayed'
      ,p_hol_domain     => null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => 'N');


--
-- Spatial Server option

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
--
-- 10g reports options (should be switched off) FJF
--
   add(p_hol_id         => 'REPURL'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'Reports Server URL'
      ,p_hol_remarks    => 'URL to get to the application server Reports Server (not 6i run_product)'
      ,p_hol_domain     => Null
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'Y'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => 'javascript:message("Product option REPURL not set, please contact your system admin");');
--
   add(p_hol_id         => 'NOT_6I_REP'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'Using non-6i Reports Server'
      ,p_hol_remarks    => 'Using non-6i Reports Server'
      ,p_hol_domain     => 'Y_OR_N'
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => 'N');

-- retrofit option introduced by RC as a patchette of 3210 and 3211
--
   add(p_hol_id         => 'UPDRDONLY'
      ,p_hol_product    => 'HIG'
      ,p_hol_name       => 'Allow update of subordinates'
      ,p_hol_remarks    => 'Update subordinates allowed if parent is readonly'
      ,p_hol_domain     => 'Y_OR_N'
      ,p_hol_datatype   => 'VARCHAR2'
      ,p_hol_mixed_case => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value      => 'Y');

--
-- 01-FEB-2007 new option for AR
--
   add(p_hol_id          => 'WEBMAPPRDS'
      ,p_hol_product     => 'WMP'
      ,p_hol_name        => 'Preferred Data Source'
      ,p_hol_remarks     => 'Preferred Data Source'
      ,p_hol_domain      => Null
      ,p_hol_datatype    => 'VARCHAR2'
      ,p_hol_mixed_case  => 'N'
      ,p_hol_user_option => 'Y'
      ,p_hov_value       => Null);

--
-- 07-FEB-2007 new option for GJ
--
   add(p_hol_id          => 'ALLOWDEBUG'
      ,p_hol_product     => 'HIG'
      ,p_hol_name        => 'Allow debug'
      ,p_hol_remarks     => 'Allow debug'
      ,p_hol_domain      => 'Y_OR_N'
      ,p_hol_datatype    => 'VARCHAR2'
      ,p_hol_mixed_case  => 'N'
      ,p_hol_user_option => 'N'
      ,p_hov_value       => 'N');


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

 add_huol(p_huol_id         => 'DEFITEMTYP'
         ,p_huol_product    => 'NET'
         ,p_huol_name       => 'Default Reference Item Type'
         ,p_huol_remarks    => 'Default reference item type for Assets on a Route.'
         ,p_huol_domain     => ''
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
   l_tab_hsc_status_code    nm3type.tab_varchar30;
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
   PROCEDURE add ( p_hsc_domain_code    VARCHAR2 DEFAULT NULL
                 , p_hsc_status_code    VARCHAR2 DEFAULT NULL
                 , p_hsc_status_name    VARCHAR2 DEFAULT NULL
                 , p_hsc_seq_no         NUMBER DEFAULT NULL
                 , p_hsc_allow_feature1 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature2 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature3 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature4 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature5 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature6 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature7 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature8 VARCHAR2 DEFAULT NULL
                 , p_hsc_allow_feature9 VARCHAR2 DEFAULT NULL
                 , p_hsc_start_date     DATE DEFAULT NULL
                 , p_hsc_end_date       DATE DEFAULT NULL
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

   add(p_hsc_domain_code     => 'COMPLAINTS'
      ,p_hsc_status_code     => 'NI'
      ,p_hsc_status_name     => 'Notice Issued'
      ,p_hsc_seq_no          => 12
      ,p_hsc_allow_feature1  => 'N'
      ,p_hsc_allow_feature2  => 'N'
      ,p_hsc_allow_feature3  => 'N'
      ,p_hsc_allow_feature4  => 'N'
      ,p_hsc_allow_feature5  => 'N'
      ,p_hsc_allow_feature6  => 'N'
      ,p_hsc_allow_feature7  => 'N'
      ,p_hsc_allow_feature8  => 'Y'
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
 l_rec_grm.grm_module       := 'NM0150';
 l_rec_grm.grm_module_type  := 'R25';
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
--
 l_rec_grm.grm_module       := 'NM0151';
 l_rec_grm.grm_module_type  := 'R25';
 l_rec_grm.grm_module_path  := '$PROD_HOME\bin';
 l_rec_grm.grm_file_type    := 'lis';
 l_rec_grm.grm_tag_flag     := 'N';
 l_rec_grm.grm_tag_table    := Null;
 l_rec_grm.grm_tag_column   := Null;
 l_rec_grm.grm_tag_where    := Null;
 l_rec_grm.grm_linesize     := 66;
 l_rec_grm.grm_pagesize     := 132;
 l_rec_grm.grm_pre_process  := Null;
 add_grm;
--
 l_rec_grm.grm_module       := 'NM0153';
 l_rec_grm.grm_module_type  := 'R25';
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
--
 l_rec_grm.grm_module       := 'NM0154';
 l_rec_grm.grm_module_type  := 'R25';
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
--
 l_rec_grm.grm_module       := 'NM0155';
 l_rec_grm.grm_module_type  := 'R25';
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
 l_rec_grp.gp_param            := 'ELEMENT_TYPE';
 l_rec_grp.gp_param_type       := 'CHAR';
 l_rec_grp.gp_table            := 'GRI_PARAM_LOOKUP';
 l_rec_grp.gp_column           := 'GPL_VALUE';
 l_rec_grp.gp_descr_column     := 'GPL_DESCR';
 l_rec_grp.gp_shown_column     := 'GPL_VALUE';
 l_rec_grp.gp_shown_type       := 'CHAR';
 l_rec_grp.gp_descr_type       := Null;
 l_rec_grp.gp_order            := Null;
 l_rec_grp.gp_case             := Null;
 l_rec_grp.gp_gaz_restriction  := Null;
 add_grp;
--
 l_rec_grp.gp_param            := 'NODE_TYPE';
 l_rec_grp.gp_param_type       := 'CHAR';
 l_rec_grp.gp_table            := 'NM_NODE_TYPES';
 l_rec_grp.gp_column           := 'NNT_TYPE';
 l_rec_grp.gp_descr_column     := 'NNT_NAME';
 l_rec_grp.gp_shown_column     := 'NNT_TYPE';
 l_rec_grp.gp_shown_type       := 'CHAR';
 l_rec_grp.gp_descr_type       := Null;
 l_rec_grp.gp_order            := Null;
 l_rec_grp.gp_case             := Null;
 l_rec_grp.gp_gaz_restriction  := Null;
 add_grp;
--
 l_rec_grp.gp_param            := 'REGION_OF_INTEREST';
 l_rec_grp.gp_param_type       := 'NUMBER';
 l_rec_grp.gp_table            := 'NM_ELEMENTS_ALL';
 l_rec_grp.gp_column           := 'NE_ID';
 l_rec_grp.gp_descr_column     := 'NE_DESCR';
 l_rec_grp.gp_shown_column     := 'NE_UNIQUE';
 l_rec_grp.gp_shown_type       := 'CHAR';
 l_rec_grp.gp_descr_type       := 'CHAR';
 l_rec_grp.gp_order            := Null;
 l_rec_grp.gp_case             := Null;
 l_rec_grp.gp_gaz_restriction  := Null;
 add_grp;
--
 l_rec_grp.gp_param            := 'ANSWER2';
 l_rec_grp.gp_param_type       := 'CHAR';
 l_rec_grp.gp_table            := 'GRI_PARAM_LOOKUP';
 l_rec_grp.gp_column           := 'GPL_VALUE';
 l_rec_grp.gp_descr_column     := 'GPL_DESCR';
 l_rec_grp.gp_shown_column     := 'GPL_VALUE';
 l_rec_grp.gp_shown_type       := 'CHAR';
 l_rec_grp.gp_descr_type       := 'CHAR';
 l_rec_grp.gp_order            := Null;
 l_rec_grp.gp_case             := Null;
 l_rec_grp.gp_gaz_restriction  := Null;
 add_grp;
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
 l_rec_gmp.gmp_module := 'NM0150';
 l_rec_gmp.gmp_param := 'NODE_TYPE';
 l_rec_gmp.gmp_seq := 1;
 l_rec_gmp.gmp_param_descr := 'Node Type';
 l_rec_gmp.gmp_mandatory := 'N';
 l_rec_gmp.gmp_no_allowed := 4;
 l_rec_gmp.gmp_where := NULL;
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := NULL;
 l_rec_gmp.gmp_default_column := NULL;
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := NULL;
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0150';
 l_rec_gmp.gmp_param := 'REGION_OF_INTEREST';
 l_rec_gmp.gmp_seq := 2;
 l_rec_gmp.gmp_param_descr := 'Region Of Interest';
 l_rec_gmp.gmp_mandatory := 'N';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'NE_TYPE IN (''G'',''P'',''S'')';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := NULL;
 l_rec_gmp.gmp_default_column := NULL;
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'Y';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please select Region Of Interest';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0150';
 l_rec_gmp.gmp_param := 'ELEMENT_TYPE';
 l_rec_gmp.gmp_seq := 3;
 l_rec_gmp.gmp_param_descr := 'Element Type';
 l_rec_gmp.gmp_mandatory := 'N';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'GPL_PARAM=''ELEMENT_TYPE''';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := 'GRI_PARAM_LOOKUP';
 l_rec_gmp.gmp_default_column := 'GPL_VALUE';
 l_rec_gmp.gmp_default_where := 'GPL_VALUE=''S'' AND GPL_PARAM=''ELEMENT_TYPE''';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Select node level to be displayed in report';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0150';
 l_rec_gmp.gmp_param := 'EFFECTIVE_DATE';
 l_rec_gmp.gmp_seq := 4;
 l_rec_gmp.gmp_param_descr := 'Effective Date';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := '';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := '';
 l_rec_gmp.gmp_default_table := 'DUAL';
 l_rec_gmp.gmp_default_column := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
 l_rec_gmp.gmp_default_where := '';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please enter Effective Date';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0150';
 l_rec_gmp.gmp_param := 'ANSWER';
 l_rec_gmp.gmp_seq := 5;
 l_rec_gmp.gmp_param_descr := 'View Orphan Nodes?';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'GPL_PARAM=''ANSWER'' AND ((:REGION_OF_INTEREST IS NOT NULL AND GPL_VALUE IN (''N'')) OR (:REGION_OF_INTEREST IS  NULL AND GPL_VALUE IN (''Y'',''N'')))';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := '';
 l_rec_gmp.gmp_default_table := 'GRI_PARAM_LOOKUP';
 l_rec_gmp.gmp_default_column := 'GPL_VALUE';
 l_rec_gmp.gmp_default_where := 'GPL_VALUE=''N'' AND GPL_PARAM=''ANSWER''';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'View Orphan Nodes?';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0151';
 l_rec_gmp.gmp_param := 'REGION_OF_INTEREST';
 l_rec_gmp.gmp_seq := 1;
 l_rec_gmp.gmp_param_descr := 'Region Of Interest';
 l_rec_gmp.gmp_mandatory := 'N';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'NE_TYPE IN (''G'',''P'',''S'')';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := NULL;
 l_rec_gmp.gmp_default_column := NULL;
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'Y';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please select Region of Interest';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0151';
 l_rec_gmp.gmp_param := 'ELEMENT_TYPE';
 l_rec_gmp.gmp_seq := 2;
 l_rec_gmp.gmp_param_descr := 'Element Type';
 l_rec_gmp.gmp_mandatory := 'N';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'GPL_PARAM=''ELEMENT_TYPE''';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := '';
 l_rec_gmp.gmp_default_table := 'GRI_PARAM_LOOKUP';
 l_rec_gmp.gmp_default_column := 'GPL_VALUE';
 l_rec_gmp.gmp_default_where := 'GPL_VALUE=''S'' AND GPL_PARAM=''ELEMENT_TYPE''';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please enter a Group Type';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0151';
 l_rec_gmp.gmp_param := 'EFFECTIVE_DATE';
 l_rec_gmp.gmp_seq := 3;
 l_rec_gmp.gmp_param_descr := 'Effective Date';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := NULL;
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := 'DUAL';
 l_rec_gmp.gmp_default_column := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please enter Effective Date';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0151';
 l_rec_gmp.gmp_param := 'ANSWER';
 l_rec_gmp.gmp_seq := 4;
 l_rec_gmp.gmp_param_descr := 'Include Leg No (Y/N)';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'GPL_PARAM=''ANSWER''';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := 'GRI_PARAM_LOOKUP';
 l_rec_gmp.gmp_default_column := 'GPL_VALUE';
 l_rec_gmp.gmp_default_where := 'GPL_VALUE=''N'' AND GPL_PARAM=''ANSWER''';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Include Leg No (Y/N)';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0153';
 l_rec_gmp.gmp_param := 'REGION_OF_INTEREST';
 l_rec_gmp.gmp_seq := 1;
 l_rec_gmp.gmp_param_descr := 'Region Of Interest';
 l_rec_gmp.gmp_mandatory := 'N';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'NE_TYPE IN (''G'',''P'')';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := NULL;
 l_rec_gmp.gmp_default_column := NULL;
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'Y';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please select Region of Interest';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0153';
 l_rec_gmp.gmp_param := 'EFFECTIVE_DATE';
 l_rec_gmp.gmp_seq := 2;
 l_rec_gmp.gmp_param_descr := 'Effective Date';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := NULL;
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := 'DUAL';
 l_rec_gmp.gmp_default_column := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please enter Effective Date';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0153';
 l_rec_gmp.gmp_param := 'ANSWER';
 l_rec_gmp.gmp_seq := 3;
 l_rec_gmp.gmp_param_descr := 'Include Historic?';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'GPL_PARAM=''ANSWER''';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := '';
 l_rec_gmp.gmp_default_table := 'GRI_PARAM_LOOKUP';
 l_rec_gmp.gmp_default_column := 'GPL_VALUE';
 l_rec_gmp.gmp_default_where := 'GPL_VALUE=''N'' AND GPL_PARAM=''ANSWER''';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Include Historic?';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0154';
 l_rec_gmp.gmp_param := 'REGION_OF_INTEREST';
 l_rec_gmp.gmp_seq := 1;
 l_rec_gmp.gmp_param_descr := 'Region Of Interest';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'NE_TYPE IN (''G'',''P'')';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := NULL;
 l_rec_gmp.gmp_default_column := NULL;
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'Y';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please select Region of Interest';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0154';
 l_rec_gmp.gmp_param := 'EFFECTIVE_DATE';
 l_rec_gmp.gmp_seq := 2;
 l_rec_gmp.gmp_param_descr := 'Effective Date';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := NULL;
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := 'DUAL';
 l_rec_gmp.gmp_default_column := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please enter Effective Date';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0155';
 l_rec_gmp.gmp_param := 'REGION_OF_INTEREST';
 l_rec_gmp.gmp_seq := 1;
 l_rec_gmp.gmp_param_descr := 'Region of Interest';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'NE_TYPE IN (''G'',''P'')';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := NULL;
 l_rec_gmp.gmp_default_column := NULL;
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'Y';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please select Region of Interest';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0155';
 l_rec_gmp.gmp_param := 'EFFECTIVE_DATE';
 l_rec_gmp.gmp_seq := 2;
 l_rec_gmp.gmp_param_descr := 'Effective Date';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := NULL;
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := 'DUAL';
 l_rec_gmp.gmp_default_column := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
 l_rec_gmp.gmp_default_where := NULL;
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'N';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Please enter Effective Date';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0155';
 l_rec_gmp.gmp_param := 'ANSWER';
 l_rec_gmp.gmp_seq := 3;
 l_rec_gmp.gmp_param_descr := 'Include Datum Elements';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'GPL_PARAM=''ANSWER''';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := NULL;
 l_rec_gmp.gmp_default_table := 'GRI_PARAM_LOOKUP';
 l_rec_gmp.gmp_default_column := 'GPL_VALUE';
 l_rec_gmp.gmp_default_where := 'GPL_VALUE=''N'' AND GPL_PARAM=''ANSWER''';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Include Datum Elements';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
--
 l_rec_gmp.gmp_module := 'NM0155';
 l_rec_gmp.gmp_param := 'ANSWER2';
 l_rec_gmp.gmp_seq := 4;
 l_rec_gmp.gmp_param_descr := 'Include Historic';
 l_rec_gmp.gmp_mandatory := 'Y';
 l_rec_gmp.gmp_no_allowed := 1;
 l_rec_gmp.gmp_where := 'GPL_PARAM=''ANSWER2''';
 l_rec_gmp.gmp_tag_restriction := 'N';
 l_rec_gmp.gmp_tag_where := '';
 l_rec_gmp.gmp_default_table := 'GRI_PARAM_LOOKUP';
 l_rec_gmp.gmp_default_column := 'GPL_VALUE';
 l_rec_gmp.gmp_default_where := 'GPL_VALUE=''N'' AND GPL_PARAM=''ANSWER2''';
 l_rec_gmp.gmp_visible := 'Y';
 l_rec_gmp.gmp_gazetteer := 'N';
 l_rec_gmp.gmp_lov := 'Y';
 l_rec_gmp.gmp_wildcard := 'N';
 l_rec_gmp.gmp_hint_text := 'Include Historic';
 l_rec_gmp.gmp_allow_partial := 'N';
 add_gmp;
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
-- *********************
-- *  GRI_PARAM_LOOKUP *
-- *********************
-- Insert into gri_param_lookup
--    (GPL_PARAM, GPL_VALUE, GPL_DESCR)
--  Values
--    ('ELEMENT_TYPE', 'Datum', 'Datum');

Insert into gri_param_lookup
   (GPL_PARAM, GPL_VALUE, GPL_DESCR)
select 'ELEMENT_TYPE', 'DATUM', 'Datum'
from dual
 where not exists (select 'already there'
                     from gri_param_lookup
                    where gpl_param = 'ELEMENT_TYPE'
                      and gpl_value = 'DATUM');
--
-- Insert into gri_param_lookup
--    (GPL_PARAM, GPL_VALUE, GPL_DESCR)
--  Values
--    ('ELEMENT_TYPE', 'Group', 'Group');

Insert into gri_param_lookup
   (GPL_PARAM, GPL_VALUE, GPL_DESCR)
select 'ELEMENT_TYPE', 'GROUP', 'Group'
from dual
 where not exists (select 'already there'
                     from gri_param_lookup
                    where gpl_param = 'ELEMENT_TYPE'
                      and gpl_value = 'GROUP');
--
-- Insert into gri_param_lookup
--    (GPL_PARAM, GPL_VALUE, GPL_DESCR)
--  Values
--    ('ELEMENT_TYPE', 'Distance_break', 'Distance Break');

Insert into gri_param_lookup
   (GPL_PARAM, GPL_VALUE, GPL_DESCR)
select 'ELEMENT_TYPE', 'DISTANCE_BREAK', 'Distance Break'
from dual
 where not exists (select 'already there'
	                    from gri_param_lookup
	                   where gpl_param = 'ELEMENT_TYPE'
				                  and gpl_value = 'DISTANCE_BREAK');

Insert into gri_param_lookup
   (GPL_PARAM, GPL_VALUE, GPL_DESCR)
select 'ANSWER2', 'Y', 'Yes'
from dual
 where not exists (select 'already there'
                     from gri_param_lookup
                    where gpl_param = 'ANSWER2'
                      and gpl_value = 'Y');

Insert into gri_param_lookup
   (GPL_PARAM, GPL_VALUE, GPL_DESCR)
select 'ANSWER2', 'N', 'No'
from dual
 where not exists (select 'already there'
                     from gri_param_lookup
                    where gpl_param = 'ANSWER2'
				                  and gpl_value = 'N');

--
-------------------------------------------------------------------------------------------------
--
-- **************************
-- *  GRI_PARAM_DEPENDENCIES*
-- **************************
Insert into gri_param_dependencies
   (GPD_MODULE, GPD_DEP_PARAM, GPD_INDEP_PARAM)
select 'NM0150', 'ELEMENT_TYPE', 'REGION_OF_INTEREST'
from dual
 where not exists (select 'already there'
                     from gri_param_dependencies
                    where gpd_module = 'NM0150'
				                  and gpd_dep_param = 'ELEMENT_TYPE'
				                  and gpd_indep_param = 'REGION_OF_INTEREST');


--
Insert into gri_param_dependencies
   (GPD_MODULE, GPD_DEP_PARAM, GPD_INDEP_PARAM)
select 'NM0150', 'ANSWER', 'REGION_OF_INTEREST'
from dual
 where not exists (select 'already there'
                     from gri_param_dependencies
                    where gpd_module = 'NM0150'
			                   and gpd_dep_param = 'ANSWER'
			                   and gpd_indep_param = 'REGION_OF_INTEREST');
--
Insert into gri_param_dependencies
   (GPD_MODULE, GPD_DEP_PARAM, GPD_INDEP_PARAM)
select 'NM0151', 'ELEMENT_TYPE', 'REGION_OF_INTEREST'
from dual
 where not exists (select 'already there'
                     from gri_param_dependencies
                    where gpd_module = 'NM0151'
			                   and gpd_dep_param = 'ELEMENT_TYPE'
			                   and gpd_indep_param = 'REGION_OF_INTEREST');
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
-- NSG Data Manager Product Name Change
--
UPDATE hig_products
SET    hpr_product_name = 'Street Gazetteer Manager'
WHERE  hpr_product = 'NSG'
/
UPDATE hig_standard_favourites
SET    hstf_descr = 'Street Gazetteer Manager'
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
-- Structural Projects Product Name Change
--
UPDATE hig_products
SET    hpr_product_name = 'Schemes'
WHERE  hpr_product = 'STP'
/
UPDATE hig_standard_favourites
SET    hstf_descr = 'Schemes'
WHERE  hstf_parent = 'FAVOURITES'
AND    hstf_child = 'STP'
/
--
-- New Product - Schemes Enterprise Edition
--
INSERT INTO hig_products
            (hpr_product
            ,hpr_product_name
            ,hpr_version
            )
SELECT 'SCH'
     , 'schemes enterprise edition'
	 , '4.0'
FROM DUAL
WHERE NOT EXISTS (SELECT 'X'
                  FROM hig_products
                  WHERE hpr_product = 'SCH')
/
update hig_standard_favourites
set hstf_child = 'STP4400'
where hstf_parent = 'STP_ROAD'
and hstf_child = 'STP3030'
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
DELETE FROM hig_module_keywords
WHERE hmk_hmo_module = 'HIG1838'
/
DELETE FROM hig_module_roles
WHERE hmr_module = 'HIG1838'
/
DELETE FROM hig_modules
WHERE hmo_module = 'HIG1838'
/
DELETE FROM hig_standard_favourites
WHERE hstf_child = 'HIG1838'
/
DELETE FROM hig_user_favourites
WHERE huf_child = 'HIG1838'
/
DELETE FROM hig_system_favourites
WHERE hsf_child = 'HIG1838'
/
DELETE FROM hig_user_options
WHERE huo_id in ('USEACTION','USEDAMAGE')
/
--
-- Module Removed from NSG
--
DELETE FROM hig_standard_favourites
WHERE hstf_child = 'NSG0021'
/

-- Remove the defunc AUTOZOOM product/user option
delete hig_user_option_list
where huol_id = 'AUTOZOOM';

delete hig_user_options
where huo_id = 'AUTOZOOM';

delete hig_option_values
where hov_id = 'AUTOZOOM';

delete hig_option_list
where hol_id = 'AUTOZOOM';

--
-- MAI reports changes
--
update hig_standard_favourites
set hstf_order = 2
where hstf_parent = 'MAI_FINANCIAL_REPORTS'
and hstf_child = 'MAI3942';

update hig_standard_favourites
set hstf_order = 3
where hstf_parent = 'MAI_FINANCIAL_REPORTS'
and hstf_child = 'MAI3944';

update hig_standard_favourites
set hstf_order = 4
where hstf_parent = 'MAI_FINANCIAL_REPORTS'
and hstf_child = 'MAI3690';

update hig_standard_favourites
set hstf_order = 5
where hstf_parent = 'MAI_FINANCIAL_REPORTS'
and hstf_child = 'MAI3692';


--
-- PMS changes
--
DELETE FROM hig_standard_favourites
WHERE  hstf_parent LIKE 'PMS%'
OR     hstf_child like 'PMS%'
/
UPDATE hig_products
SET    hpr_product_name = 'structural projects v2 - REDUNDANT'
       ,hpr_key = Null
WHERE  hpr_product = 'PMS'
/


--
-- Ensure inv_type_attribs.ita_disp_width does not contravene logic introduced in new trigger
--
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_ALL_DT_TRG DISABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_ALL_WHO DISABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_AS_TRG DISABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_BS_TRG DISABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_B_IU_TRG DISABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_EXCL_TRG DISABLE;


update nm_inv_type_attribs_all
set ita_disp_width = 1
where ita_displayed = 'Y'
and ita_disp_width is null;

ALTER TRIGGER NM_INV_TYPE_ATTRIBS_ALL_DT_TRG ENABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_ALL_WHO ENABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_AS_TRG ENABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_BS_TRG ENABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_B_IU_TRG ENABLE;
ALTER TRIGGER NM_INV_TYPE_ATTRIBS_EXCL_TRG ENABLE;



----------------------------------------------------------------------------------------------
-- Start of Data to support NM0590 - new Asset Maintenance module
--
--
-- DOC_GATE_SYNS
--
INSERT INTO DOC_GATE_SYNS ( DGS_DGT_TABLE_NAME, DGS_TABLE_SYN )
SELECT
       'NM_INV_ITEMS_ALL'
     , 'NM_ASSET_RESULTS'
FROM dual
WHERE NOT EXISTS (SELECT 'already exists'
                  FROM   DOC_GATE_SYNS
				  WHERE  DGS_DGT_TABLE_NAME = 'NM_INV_ITEMS_ALL'
				  AND    DGS_TABLE_SYN = 'NM_ASSET_RESULTS');

--
-- NM_INV_CATEGORY_MODULES
--
INSERT INTO nm_inv_category_modules
            (icm_nic_category, icm_hmo_module, icm_updatable)
   SELECT 'C', 'NM0590', 'Y'
     FROM DUAL
    WHERE NOT EXISTS (
                    SELECT 'already exists'
                      FROM nm_inv_category_modules
                     WHERE icm_nic_category = 'C'
                       AND icm_hmo_module = 'NM0590');


INSERT INTO nm_inv_category_modules
            (icm_nic_category, icm_hmo_module, icm_updatable)
   SELECT 'G', 'NM0590', 'N'
     FROM DUAL
    WHERE NOT EXISTS (
                    SELECT 'already exists'
                      FROM nm_inv_category_modules
                     WHERE icm_nic_category = 'G'
                       AND icm_hmo_module = 'NM0590');

INSERT INTO nm_inv_category_modules
            (icm_nic_category, icm_hmo_module, icm_updatable)
   SELECT 'X', 'NM0590', 'N'
     FROM DUAL
    WHERE NOT EXISTS (
                    SELECT 'already exists'
                      FROM nm_inv_category_modules
                     WHERE icm_nic_category = 'X'
                       AND icm_hmo_module = 'NM0590');

INSERT INTO nm_inv_category_modules
            (icm_nic_category, icm_hmo_module, icm_updatable)
   SELECT 'I', 'NM0590', 'Y'
     FROM DUAL
    WHERE NOT EXISTS (
                    SELECT 'already exists'
                      FROM nm_inv_category_modules
                     WHERE icm_nic_category = 'I'
                       AND icm_hmo_module = 'NM0590');


INSERT INTO nm_inv_category_modules
            (icm_nic_category, icm_hmo_module, icm_updatable)
   SELECT 'F', 'NM0590', 'N'
     FROM DUAL
    WHERE NOT EXISTS (
                    SELECT 'already exists'
                      FROM nm_inv_category_modules
                     WHERE icm_nic_category = 'F'
                       AND icm_hmo_module = 'NM0590');


INSERT INTO nm_inv_category_modules
            (icm_nic_category, icm_hmo_module, icm_updatable)
   SELECT 'D', 'NM0590', 'N'
     FROM DUAL
    WHERE NOT EXISTS (
                    SELECT 'already exists'
                      FROM nm_inv_category_modules
                     WHERE icm_nic_category = 'D'
                       AND icm_hmo_module = 'NM0590');

-- End of Data to support NM0590 - new Asset Maintenance module
----------------------------------------------------------------------------------------------



--
-------------------------------------------------------------------------------------------
-- HIG_STANDARD_FAVOURITES - for Schemes Manager
--
merge into hig_standard_favourites d using (
select 'FAVOURITES' HSTF_PARENT, 'STP' HSTF_CHILD, 'Scheme Manager' HSTF_DESCR, 'F' HSTF_TYPE, 11 HSTF_ORDER
from dual union all
select 'STP'        HSTF_PARENT, 'STP_ROAD' HSTF_CHILD, 'Schemes' HSTF_DESCR, 'F' HSTF_TYPE, 10 HSTF_ORDER
from dual union all
select 'STP_ROAD'   HSTF_PARENT, 'STP4400' HSTF_CHILD, 'Maintain Schemes' HSTF_DESCR, 'M' HSTF_TYPE, 10 HSTF_ORDER
from dual union all
select 'STP_ROAD'   HSTF_PARENT, 'STP4401' HSTF_CHILD, 'Scheme Priorities' HSTF_DESCR, 'M' HSTF_TYPE, 20 HSTF_ORDER
from dual union all
select 'STP'        HSTF_PARENT, 'STP_RCON' HSTF_CHILD, 'Road Construction' HSTF_DESCR, 'F' HSTF_TYPE, 20 HSTF_ORDER
from dual union all
select 'STP_RCON'   HSTF_PARENT, 'STP1000' HSTF_CHILD, 'Road Construction Data' HSTF_DESCR, 'M' HSTF_TYPE, 10 HSTF_ORDER
from dual union all
select 'STP'        HSTF_PARENT, 'STP_REFERENCE' HSTF_CHILD, 'Reference Data' HSTF_DESCR, 'F' HSTF_TYPE, 30 HSTF_ORDER
from dual) s
on (s.HSTF_PARENT = d.HSTF_PARENT and s.HSTF_CHILD = d.HSTF_CHILD)
when matched then
  update set
     d.HSTF_DESCR = s.HSTF_DESCR
   , d.HSTF_TYPE = s.HSTF_TYPE
   , d.HSTF_ORDER = s.HSTF_ORDER
when not matched then
  insert (HSTF_PARENT, HSTF_CHILD, HSTF_DESCR, HSTF_TYPE, HSTF_ORDER)
  values (s.HSTF_PARENT, s.HSTF_CHILD, s.HSTF_DESCR, s.HSTF_TYPE, s.HSTF_ORDER)
/

-- this item has been inserted under different parent
delete from HIG_STANDARD_FAVOURITES
where hstf_parent = 'STP_ROAD' and hstf_child = 'STP1000'
/
--
-- End of HIG_STANDARD_FAVOURITES - for Schemes Manager
----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------
-- Start of create a theme function for all non-foreign table themes to call
-- the Bulk Assets Update module
--
-- PT

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
-- End of create a theme function for all non-foreign table themes to call
-- the Bulk Assets Update module
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- AE 12/12/2006
-- full set of NM_LAYER_TREE metadata
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'ENQ'
       ,'Enquiry Manager'
       ,'F'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ENQ');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'AST'
       ,'Asset Manager'
       ,'F'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AST');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'CUS'
       ,'Custom Layers'
       ,'F'
       ,120 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CUS');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'MAI'
       ,'Maintenance Manager'
       ,'F'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'MAI');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ACC'
       ,'AC1'
       ,'Accidents Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AC1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'NET'
       ,'Network Manager'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NET');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'TOP'
       ,'ROOT'
       ,'SDO Layers'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ROOT');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ENQ'
       ,'EN1'
       ,'Enquiry Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'EN1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'AST'
       ,'AS1'
       ,'Asset Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'AS1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'CUS'
       ,'CU1'
       ,'Custom'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CU1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'MAI'
       ,'MA1'
       ,'Defects Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'MA1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'STR'
       ,'Structures Manager'
       ,'F'
       ,70 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'STR');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'NET'
       ,'NE1'
       ,'Datum Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'NET'
       ,'NE2'
       ,'Route Layer'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE2');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'NET'
       ,'NE3'
       ,'Node Layer'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NE3');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'STR'
       ,'ST1'
       ,'Structure Items'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ST1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'CLM'
       ,'Street Lighting Manager'
       ,'F'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CLM');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'CLM'
       ,'CL1'
       ,'Street Lights Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'CL1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'SWR'
       ,'Streetworks Manager'
       ,'F'
       ,80 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SWR');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'SWR'
       ,'SW1'
       ,'Sites Layer'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'SW1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'NSG'
       ,'Street Gazetteer Manager'
       ,'F'
       ,90 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NSG');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'NSG'
       ,'NS1'
       ,'NSG Layers'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'NS1');
--
INSERT INTO NM_LAYER_TREE
       (NLTR_PARENT
       ,NLTR_CHILD
       ,NLTR_DESCR
       ,NLTR_TYPE
       ,NLTR_ORDER
       )
SELECT
        'ROOT'
       ,'ACC'
       ,'Accidents Manager'
       ,'F'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_LAYER_TREE
                   WHERE NLTR_CHILD = 'ACC');

COMMIT;
-- AE 12/12/2006
-- full set of NM_LAYER_TREE metadata
-----------------------------------------------------------------------------------

--
-----------------------------------------------------------------------------------
--
-- MA
--********** NM_SPECIAL_CHARS **********--
--
-- Inserts ascii value of invalid characters for a field
-- nm3flx.string_contains_special_chars procedure loops around
-- nm_special_chars table and uses instr chr(special_char value)
-- to root out any invalid characters
-- chr(i) valid values currently are 48-57 (A-Z), 65-90 (a-z),
-- 97-122 (0-9) and 95 (_)
--
DECLARE
   i   NUMBER;
BEGIN
   FOR i IN 32 .. 172
   LOOP
      IF     (i < 48 OR i > 57)
         AND (i < 65 OR i > 90)
         AND (i < 97 OR i > 122)
         AND i <> 95
      THEN
         BEGIN
            INSERT INTO nm_special_chars
                        (nsch_ascii_character
                        )
                 VALUES (i
                        );
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
            THEN
               NULL;
            WHEN OTHERS
            THEN
               raise_application_error (-20001, SQLERRM);
         END;
      END IF;
   END LOOP;
END;
/
--
-- MA
--********** NM_SPECIAL_CHARS **********--
-- FINISHED


------------------------------------------------------------------------
-- ensure that metres unit has an accuracy of AT LEAST 3 decimal places
-- requirement came about following discussion with CS regarding coordinate format masks for nsg
--
update nm_units
set un_format_mask = '999999999990.000'
where un_unit_id = 1
and   un_format_mask IN ('999999999990.00','999999999990.0','999999999990')
/
--
--
------------------------------------------------------------------------


------------------------------------------------------------------------
-- Start of Network Selection Changes  (GJ)
-- ensure network type column is added for 'NM2G' and 'NM2L' network types
-- and then populated
--
--
-- Add a flexible column to 'NM2G' network definition (if it exists) to allow network selection flag to be specified
--
INSERT INTO nm_type_columns
            (ntc_nt_type
            ,ntc_column_name
            ,ntc_column_type
            ,ntc_seq_no
            ,ntc_displayed
            ,ntc_str_length
            ,ntc_mandatory
            ,ntc_domain
            ,ntc_query
            ,ntc_inherit
            ,ntc_string_start
            ,ntc_string_end
            ,ntc_seq_name
            ,ntc_format
            ,ntc_prompt
            ,ntc_default
            ,ntc_default_type
            ,ntc_separator
            ,ntc_unique_seq
            ,ntc_unique_format
            ,ntc_updatable
            )
SELECT       'NM2G'
            , 'NE_VERSION_NO'
            , 'VARCHAR2'
            , 2
            , 'N'
            , 1
            , 'N'
            , 'Y_OR_N'
            , NULL
            , 'N'
            , NULL
            , NULL
            , NULL
            , NULL
            , 'Net Sel Crt'
            , '''N'''
            , NULL
            , NULL
            , NULL
            , NULL
            , 'Y'
FROM dual
WHERE NOT EXISTS (select 'x'
                  from nm_type_columns
                  where ntc_nt_type = 'NM2G'
                  and   ntc_column_name = 'NE_VERSION_NO')
AND EXISTS (SELECT 'x'
            FROM nm_types
            WHERE nt_type = 'NM2G')
/
--
-- Add a flexible column to 'NM2L' network definition (if it exists) to allow network selection flag to be specified
--
INSERT INTO nm_type_columns
            (ntc_nt_type
            ,ntc_column_name
            ,ntc_column_type
            ,ntc_seq_no
            ,ntc_displayed
            ,ntc_str_length
            ,ntc_mandatory
            ,ntc_domain
            ,ntc_query
            ,ntc_inherit
            ,ntc_string_start
            ,ntc_string_end
            ,ntc_seq_name
            ,ntc_format
            ,ntc_prompt
            ,ntc_default
            ,ntc_default_type
            ,ntc_separator
            ,ntc_unique_seq
            ,ntc_unique_format
            ,ntc_updatable
            )
SELECT       'NM2L'
            , 'NE_VERSION_NO'
            , 'VARCHAR2'
            , 2
            , 'N'
            , 1
            , 'N'
            , 'Y_OR_N'
            , NULL
            , 'N'
            , NULL
            , NULL
            , NULL
            , NULL
            , 'Net Sel Crt'
            , '''N'''
            , NULL
            , NULL
            , NULL
            , NULL
            , 'Y'
FROM dual
WHERE NOT EXISTS (select 'x'
                  from nm_type_columns
                  where ntc_nt_type = 'NM2L'
                  and   ntc_column_name = 'NE_VERSION_NO')
AND EXISTS (SELECT 'x'
            FROM nm_types
            WHERE nt_type = 'NM2L')
/
--
-- update existing elements of type 'L' or 'D' to carry the value that would (in some cases) have previously
-- been stored as a flexible attribute on the 'NETW' associated asset
--
DELETE FROM nm_inv_type_attribs
WHERE  ita_inv_type = 'NETW'
AND    ita_attrib_name = 'IIT_CHR_ATTRIB52'
AND    ita_view_attri = 'RSE_NET_SEL_CRT' -- just in case customer has their own asset type of NETW which models something completely different
/
ALTER TABLE nm_elements_all DISABLE ALL TRIGGERS
/
UPDATE nm_elements_all
SET ne_version_no = 'N'
WHERE ne_nt_type IN ('NM2L','NM2G')
AND ne_version_no is null -- do not update records that already have a value set
/
ALTER TABLE nm_elements_all ENABLE ALL TRIGGERS
/
--
-- End of Network Selection Changes  (GJ)
------------------------------------------------------------------------




------------------------------------------------------------------------
-- missing hig_error
--
INSERT INTO hig_errors (HER_APPL
                      , HER_NO
                      , HER_TYPE
                      , HER_DESCR)
SELECT 'HWAYS'
      ,191
      ,'I'
      ,'No data found'
FROM dual
WHERE NOT EXISTS(select 'x'
                 from hig_errors
                 where her_appl = 'HWAYS'
                 and her_no = 191)
/

--
-- missing hig_error
------------------------------------------------------------------------


------------------------------------------------------------------------
-- CP 06/10/2006
-- update Node Type data
--
update nm_node_types
set    nnt_no_name_format = '000000000'
where  nnt_type = 'ROAD'
/

update nm_node_types
set    nnt_no_name_format = '000000000'
where  nnt_type = ( select nt_node_type
                    from   nm_types
                    where  nt_type = 'NSGN' )
/

update nm_node_types
set    nnt_no_name_format = '000000000'
where  nnt_type = ( select nt_node_type
                    from   nm_types
                    where  nt_type = 'ESU')
/

--
-- update Node Type data
--

------------------------------------------------------------------------
-- CP 06/11/2006
-- Test Id 40898 - Rename DOC0206 as MAI8000
--
-- Remove doc0206 gri data (mai8000 created in mai scripts)
DELETE FROM gri_param_dependencies
WHERE  gpd_module = 'DOC0206'
/

DELETE FROM gri_module_params
WHERE  gmp_module = 'DOC0206'
/

DELETE FROM gri_modules
WHERE  grm_module = 'DOC0206'
/


-- Reset hig_standard_favourites
DELETE FROM hig_standard_favourites
WHERE  hstf_child = 'DOC0206'
/

INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT
        'MAI'
       ,'MAI8000'
       ,'Batch Works Order Printing'
       ,'M'
       ,21 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI8000')
/

-- Rename DOC0206 to MAI8000
------------------------------------------------------------------------



------------------------------------------------------------------------
-- GJ
-- Meta-Data to support NM0575
--
--
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       )
SELECT
        'NM0575'
       ,'Delete Global Assets'
       ,'nm0575'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'AST'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NM0575')
/
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT
        'NM0575'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NM0575'
                    AND  HMR_ROLE = 'NET_ADMIN')
/
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT
        'C'
       ,'NM0575'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'C'
                    AND  ICM_HMO_MODULE = 'NM0575')
/
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT
        'D'
       ,'NM0575'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'D'
                    AND  ICM_HMO_MODULE = 'NM0575')
/
--
INSERT INTO NM_INV_CATEGORY_MODULES
       (ICM_NIC_CATEGORY
       ,ICM_HMO_MODULE
       ,ICM_UPDATABLE
       )
SELECT
        'I'
       ,'NM0575'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_CATEGORY_MODULES
                   WHERE ICM_NIC_CATEGORY = 'I'
                    AND  ICM_HMO_MODULE = 'NM0575')
/
--
-- as part of this work, sort out the sub-menu of standard favourites
-- i.e. the ordering of menu options needs attention
delete from hig_standard_favourites
where hstf_parent = 'NET_INVENTORY'
/
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM0510', 'Asset Items', 'M', 10
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM0570', 'Find Assets', 'M', 20
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM0560', 'Assets On A Route', 'M', 30
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM0572', 'EXOR Locator', 'M', 40
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM0590', 'Asset Maintenance', 'M', 50
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM0530', 'Global Asset Update', 'M', 60
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM0575', 'Delete Global Assets', 'M', 70
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child,
             hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NM1861',
             'Inventory Admin Unit Security Maintenance', 'M', 80
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NET_INVENTORY_REPORTS', 'Reports', 'F', 90
            );
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child,
             hstf_descr, hstf_type, hstf_order
            )
     VALUES ('NET_INVENTORY', 'NET_INVENTORY_MAPCAP',
             'MapCapture Asset Loader', 'F', 100
            );
COMMIT ;

-- SSC
-- Meta-Data to support new modules MAI3811 and MAI3815
--------------------------------------------------------------------------
--
-- as part of this work, sort out the sub-menu of standard favourites
-- i.e. the ordering of menu options needs attention
delete from hig_standard_favourites
where hstf_parent in ('MAI_INSP','MAI_WORKS')
/
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3808', 'Inspections', 'M', 10);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3899', 'Inspections by Group', 'M', 20);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3806', 'Defects', 'M', 30);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3810', 'View Defects', 'M', 40);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3815', 'View Defect History', 'M', 50);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI3816', 'Responses to Notices', 'M', 60);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2730', 'Match Duplicate Defects', 'M', 70);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2760', 'Unmatch Duplicate Defects', 'M', 80);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2470', 'Delete Inspections', 'M', 90);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI2775', 'Batch Setting of Repair Dates', 'M', 100);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_INSP', 'MAI_INSP_REPORTS', 'Reports', 'F', 110);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3800', 'Works Orders (Defects)', 'M', 10);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3800A', 'Works Orders (Cyclic)', 'M', 20);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3802', 'Maintain Work Orders - Contractor Interface', 'M', 30);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3811', 'View Work Order Line History', 'M', 40);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3805', 'Gang/Crew Allocation', 'M', 50);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3848', 'Work Orders Authorisation', 'M', 60);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3804', 'View Cyclic Maintenance Work', 'M', 70);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3860', 'Cyclic Maintenance Schedules', 'M', 80);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3862', 'Cyclic Maintenance Schedules by Road Section', 'M', 90);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3825', 'Maintenance Report', 'M', 100);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3610', 'Cancel Work Orders', 'M', 110);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI3820', 'Quality Inspection Results', 'M', 120);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI1280', 'External Activities', 'M', 130);
INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
     VALUES ('MAI_WORKS', 'MAI_WORKS_REPORTS', 'Reports', 'F', 140);
COMMIT ;

-- SS
-- Meta-Data to support new modules MAI3811 and MAI3815
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--KA: new load destination for nm3rsc.resize_route
declare
  l_new_nld_id nm_load_destinations.nld_id%type;

begin
  l_new_nld_id := nm3seq.next_nld_id_seq;

  INSERT INTO NM_LOAD_DESTINATIONS ( NLD_ID, NLD_TABLE_NAME, NLD_TABLE_SHORT_NAME, NLD_INSERT_PROC, NLD_VALIDATION_PROC )
  VALUES (l_new_nld_id, 'V_LOAD_RESIZE_ROUTE', 'V_RSZ', 'NM3NET_LOAD.RESIZE_ROUTE', 'NM3NET_LOAD.VALIDATE_RESIZE_ROUTE');
END;
/
--------------------------------------------------------------------------



----------------------------------------------------------------
-- 705080
-- nm0530 is not  geared up to be used from locator.
-- therefore remove any theme function references to the module
----------------------------------------------------------------
delete from nm_theme_functions_all
where ntf_hmo_module = 'NM0530'
/

--------------------------------------------------------------------------
--KA : load destination and file for mp referencing
declare
  l_new_nld_id nm_load_destinations.nld_id%type;

begin
  l_new_nld_id := nm3seq.next_nld_id_seq;

  INSERT INTO NM_LOAD_DESTINATIONS ( NLD_ID, NLD_TABLE_NAME, NLD_TABLE_SHORT_NAME, NLD_INSERT_PROC,
  NLD_VALIDATION_PROC ) VALUES (
  l_new_nld_id, 'V_LOAD_LOCATE_INV_BY_REF', 'LIBR', 'nm3mp_ref.locate_asset', NULL);
END;
/

--------------------------------------------------------------------------


--
-- CH NADL csv loader enablement
--
declare
l_chk pls_integer;
l_nld_id number;
begin

  SELECT count(*)
  INTO l_chk
  FROM nm_load_destinations
  WHERE NLD_TABLE_NAME = 'NM_NW_AD_LINK_ALL'
  AND  NLD_TABLE_SHORT_NAME = 'NWAD';

  IF l_chk = 0 THEN

    select nld_id_seq.nextval
    into l_nld_id
    from dual;

    INSERT INTO NM_LOAD_DESTINATIONS
    ( NLD_ID
    , NLD_TABLE_NAME
    , NLD_TABLE_SHORT_NAME
    , NLD_INSERT_PROC
    , NLD_VALIDATION_PROC )
    VALUES
    ( l_nld_id
    , 'NM_NW_AD_LINK_ALL'
    , 'NWAD'
    , ' NM3NWAD.INS_NADL'
    , NULL);



    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
    (  NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE )
    VALUES
    ( l_nld_id
    , 'NAD_END_DATE'
    , 'ne.ne_end_date');

    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE )
    VALUES
    (l_nld_id
    , 'NAD_GTY_TYPE'
    , 'ne.ne_gty_group_type');

    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE )
    VALUES
    (l_nld_id
    , 'NAD_IIT_NE_ID'
    , 'iit.iit_ne_id');

    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE )
    VALUES
    (l_nld_id
    , 'NAD_INV_TYPE'
    , 'iit.iit_inv_type');

    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE )
    VALUES
    (l_nld_id
    , 'NAD_NE_ID'
    , 'ne.ne_id');

    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE )
     VALUES
    (l_nld_id
    , 'NAD_NT_TYPE'
    , 'ne.ne_nt_type');

    INSERT INTO NM_LOAD_DESTINATION_DEFAULTS
    ( NLDD_NLD_ID
    , NLDD_COLUMN_NAME
    , NLDD_VALUE )
    VALUES
    (l_nld_id
  , 'NAD_START_DATE'
  , 'ne.ne_start_Date');

   commit;

 END IF;

end;
/


COMMIT;
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************



