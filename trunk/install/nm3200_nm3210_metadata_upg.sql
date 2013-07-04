--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3200_nm3210_metadata_upg.sql	1.56 08/10/05
--       Module Name      : nm3200_nm3210_metadata_upg.sql
--       Date into SCCS   : 05/08/10 16:47:51
--       Date fetched Out : 07/06/13 13:57:58
--       SCCS Version     : 1.56
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
-------------------------------------------------------------------------------------------------
--
--
--- Populate NER_CAUSE with details from associated hig_errors
--
DECLARE

 l_cause nm_errors.ner_cause%TYPE;


BEGIN

FOR i IN (select * from nm_errors where ner_cause IS NULL ) loop

       FOR h IN (select * from hig_errors where her_appl = i.ner_appl and her_no = i.ner_her_no) loop

        l_cause := Null;

        IF h.her_action_1 IS NOT NULL THEN
          l_cause := l_cause||h.her_action_1||chr(10);
        END IF;

        IF h.her_action_2 IS NOT NULL THEN
          l_cause := l_cause|| h.her_action_2||chr(10);
        END IF;

        IF h.her_action_3 IS NOT NULL THEN
          l_cause := l_cause|| h.her_action_3||chr(10);
        END IF;

        IF h.her_action_4 IS NOT NULL THEN
          l_cause := l_cause|| h.her_action_4||chr(10);
        END IF;

        IF h.her_action_5 IS NOT NULL THEN
          l_cause := l_cause|| h.her_action_5||chr(10);
        END IF;

        IF h.her_action_6 IS NOT NULL THEN
          l_cause := l_cause|| h.her_action_6||chr(10);
        END IF;

        IF h.her_action_7 IS NOT NULL THEN
          l_cause := l_cause|| h.her_action_7||chr(10);
        END IF;

       END LOOP;

       UPDATE nm_errors set ner_cause = l_cause where ner_id = i.ner_id and ner_appl = i.ner_appl;
       l_cause := Null;
   END LOOP;

   COMMIT;

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
-- PS misc change
   add_ner(260, 'Runtime Library missing from working directory/path','A required file is missing from your working directory/path');


   --
   -- NET errors
   --
   l_current_type := 'NET';
   --
-- PS misc change
   add_ner(380, 'Invalid membership - ',Null);

-- GJ changes for 270-Infrastructure Changes Required to Support NSG Maintenance
   add_ner(381, 'Parent Sub-Type must also be a sub-type within this Admin Type','A parent sub-type has been defined that is not a sub-type within the same admin type.  Check sub-type rules.');
   add_ner(382, 'Cyclic relationship not permitted between Sub-Type and Parent Sub-Type','The following invalid scenario has occurred....'||chr(10)||'Sub-Type X    Parent Y'||chr(10)||'Sub-Type Y   Parent X');
   add_ner(383, 'Admin Type for Group Type/Network Type does not match','The admin type for the specified group type must match the admin type for sub-type.');
   add_ner(384, 'Admin Unit Sub-Type is invalid.  Check sub-type of both this admin unit and the parent admin unit','The sub-type specified for the admin unit does not exist in the sub-type rules.');
   add_ner(385, 'Elements of the given group type already exist','A group type to police cannot be specified in the sub-type rules if elements of that group type already exist.');
   add_ner(386, 'Element Group Type conflicts with Admin Unit Sub-Type rules','Admin unit has been applied to an element which has a confling group type in the admin sub-type rules.');
   add_ner(387, 'Cannot perform action - Admin Type is locked','Admin type has an admin type grouping of ''LOCKED'' which prevents insert/update/delete operations on admin units of this type.');
--
   add_ner(388, 'Invalid query defined for attribute','Flexible attribute query does not parse.  Check the query syntax.');
   add_ner(389, 'Invalid value defined for attribute','A specified value is invalid for an attribute.  If applicable, use a list of values to select a valid value. ');
   add_ner(390, 'Query must return 3 columns','Flexible attribute select statement must contain three columns.'||chr(10)||'(1)ID - not shown in list of values but returned back to calling module'||chr(10)||'(2)MEANING - shown in the list of values'||chr(10)||'(3)CODE - shown in the list of values');
   add_ner(391, 'Query must contain a maximum of 1 bind variable','More than the permitted 1 bind variable has been specified.');
   add_ner(392, 'Bind variable must also be a network type column for this network type','The bind variable specified in the flexible attribute query is not a network type column for this given network type.');
   add_ner(393, 'Bind variable must also be a attribute for this inventory type','The bind variable specified in the flexible attribute query is not a attribute for this given inventory type.');
   add_ner(394, 'Wilcard characters cannot be used to restrict the list of allowable values for an attribute','''%'' has been specified against an attribute that is used to restrict the allowable values for the current attribute.');
   add_ner(395, 'Bind variable attribute must be of a lower sequence than the current flexible attribute','The bind variable specified in the flexible attribute query appears after the current attribute, so cannot be used to restrict by.  Possibly re-sequence the flexible attributes.');
   add_ner(396, 'Specify either a domain or a query - not both','A domain and a query have both been specified.');
--
   add_ner(397, 'Duplicate file name','The filename specified is already loaded.');
   add_ner(398, 'Cannot map attributes','There has been a problem mapping the attributes for display. Check the inventory metadata');
   add_ner(399, 'Out of Memory','There is not sufficient memory available to display the results. Consider restricting the search');
--
-- Errors for Composite Inventory - JM
--
   add_ner(400, '<reserved for composite inventory>',Null);
   add_ner(401, '<reserved for composite inventory>',Null);
   add_ner(402, '<reserved for composite inventory>',Null);
   add_ner(403, '<reserved for composite inventory>',Null);
   add_ner(404, '<reserved for composite inventory>',Null);
   add_ner(405, '<reserved for composite inventory>',Null);
   add_ner(406, '<reserved for composite inventory>',Null);
   add_ner(407, '<reserved for composite inventory>',Null);
   add_ner(408, '<reserved for composite inventory>',Null);
   add_ner(409, '<reserved for composite inventory>',Null);
--
   add_ner(410, 'Press Button once download has completed');
--
--
-- More Errors for Composite Inventory - JM
--
   add_ner(411, '<reserved for composite inventory>',Null);
   add_ner(412, '<reserved for composite inventory>',Null);
   add_ner(413, '<reserved for composite inventory>',Null);
   add_ner(414, '<reserved for composite inventory>',Null);
   add_ner(415, '<reserved for composite inventory>',Null);
   add_ner(416, '<reserved for composite inventory>',Null);
   add_ner(417, '<reserved for composite inventory>',Null);
   add_ner(418, '<reserved for composite inventory>',Null);
   add_ner(419, '<reserved for composite inventory>',Null);
   add_ner(420, '<reserved for composite inventory>',Null);
--
   -- PS added for nm3homo_gis package
   add_ner(421, 'No path through distinct datums',Null);
--
   l_current_type := 'HIG';
-- AE new error messages for spatial changes
   add_ner(259, 'Invalid Geometry Type', NULL);

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
   l_rec_hmo.hmo_module           := 'HIG1910';
   l_rec_hmo.hmo_title            := 'POP3 Mail Server Definition';
   l_rec_hmo.hmo_filename         := 'hig1910';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
   l_rec_hmo.hmo_module           := 'HIG1911';
   l_rec_hmo.hmo_title            := 'POP3 Mail Message View';
   l_rec_hmo.hmo_filename         := 'hig1911';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
   l_rec_hmo.hmo_module           := 'HIG1912';
   l_rec_hmo.hmo_title            := 'POP3 Mail Processing Rules';
   l_rec_hmo.hmo_filename         := 'hig1912';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'HIG';
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr ('HIG_ADMIN','NORMAL');
--
   l_rec_hmo.hmo_module           := 'NM0572';
   l_rec_hmo.hmo_title            := 'Locator';
   l_rec_hmo.hmo_filename         := 'nm0572';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := 'AST';
   l_rec_hmo.hmo_menu             := 'FORM';
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
     INSERT INTO hig_standard_favourites
           (hstf_parent
           ,hstf_child
           ,hstf_descr
           ,hstf_type
           ,hstf_order
           )
     SELECT hstf_parent
           ,l_rec_hmo.hmo_module
           ,l_rec_hmo.hmo_title
           ,'M'
           ,i+4
      FROM  hig_standard_favourites a
     WHERE  hstf_child = 'HIG1900'
      AND   NOT EXISTS (SELECT 1
                         FROM  hig_standard_favourites b
                        WHERE  a.hstf_parent = b.hstf_parent
                         AND   b.hstf_child  = l_rec_hmo.hmo_module
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
   l_domain := 'POP3_HEADER_FIELDS';
   add_hdo (l_domain, 'HIG', 'Header Fields For POP3 Mail', 20);
   add_hco(l_domain,'RETURN-PATH','RETURN-PATH','Y',1);
   add_hco(l_domain,'DATE','DATE','Y',2);
   add_hco(l_domain,'FROM','FROM','Y',3);
   add_hco(l_domain,'SUBJECT','SUBJECT','Y',4);
   add_hco(l_domain,'TO','TO','Y',5);
   add_hco(l_domain,'MESSAGE-ID','MESSAGE-ID','Y',6);
   add_hco(l_domain,'ORIGINAL-RECIPIENT','ORIGINAL-RECIPIENT','Y',7);
--
   l_domain := 'ADMIN TYPE GROUPINGS';
   add_hdo (l_domain, 'NET', 'Admin Type Groupings', 10);
   add_hco(l_domain,'1','Highway Authority','Y',1);
   add_hco(l_domain,'2','Utility','Y',2);
   add_hco(l_domain,'3','Private Street Manager','Y',3);
   add_hco(l_domain,'4','Transport Authority','Y',4);
   add_hco(l_domain,'5','Bridge Authority','Y',5);
   add_hco(l_domain,'6','Sewer Authority','Y',6);
   add_hco(l_domain,'7','Street Naming Authority','Y',7);
   add_hco(l_domain,'8','Other Interested','Y',8);
   add_hco(l_domain,'LOCKED','Locked','Y');
--
   l_domain := 'SAV_FORMAT';
   add_hdo('SAV_FORMAT', 'NET', 'Export Formats', 3);
   add_hco(l_domain,'CSV','Comma Separated Values','Y',1);
   add_hco(l_domain,'XML','XML','Y',2);
--
   l_domain := 'LAUNCHPAD_MODE';
   add_hdo(l_domain, 'HIG', 'Starting Mode for launchpad', 10);
   add_hco(l_domain,'LAUNCHPAD'  ,'Launchpad','Y',1);
   add_hco(l_domain,'USER'  ,'User','Y',2);
   add_hco(l_domain,'SYSTEM'  ,'System','Y',3);
--
   add_hco('USER_OPTIONS','AUTOZOOM'  ,'Synchronisation of Map with form contents','Y');
   add_hco('USER_OPTIONS','SAV_FORMAT','Default format for export of data','Y');
   add_hco('USER_OPTIONS','DEFASSTYPE','Default asset type to search for','Y');
   add_hco('USER_OPTIONS','DEFSCHTYPD','Default scheme type for DoT','Y');
   add_hco('USER_OPTIONS','DEFSCHTYPL','Default scheme type for Local','Y');
   add_hco('USER_OPTIONS','DEFSCHTYPU','Defaulted Scheme Type On Works Order Updateable(Y/N)','Y');
   add_hco('USER_OPTIONS','FAVMODE','Determines the default starting tab for the user','Y');   
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

   add('AUTOZOOM', 'NET', 'Map Synchronization', 'Control of synchronisation of map with form contents. If set to Y then the mnap will be synchronized with the form.', 'Y_OR_N', 'VARCHAR2', 'N' );
   add('SAV_FORMAT', 'NET', 'Export Format', 'Default export format', 'SAV_FORMAT', 'VARCHAR2', 'N' );
   add('DEFASSTYPE', 'NET', 'Default Asset Search', 'Default asset type to search for', NULL, 'VARCHAR2', 'N' );

   add('ENQVALDATE', 'ENQ', 'Date Validation', 'Y = Enabled, N = Disabled', 'Y_OR_N', 'VARCHAR2', 'N', 'Y' );
   
   add('SDOSURKEY', 'HIG', 'SDO Surrogate Key', 'Register SDO layers with a surrogate primary key', 'Y_OR_N', 'VARCHAR2', 'N' );

   add('FAVMODE', 'HIG', 'Favourite Mode', 'Determines the default starting tab for the user', 'LAUNCHPAD_MODE', 'VARCHAR2', 'N' );


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
-------------------------------------------------------------------------------------------
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
    add_hsa('NM_AU_SUB_TYPES','NSTY_ID','NSTY_ID_SEQ');
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
--
--
-- JM - pop3 email change
--
UPDATE nm_load_destinations
 SET   nld_insert_proc     = 'nm3job_load.load_njc'
      ,nld_validation_proc = 'nm3job_load.validate_njc'
WHERE  nld_table_name      = 'NM_JOB_CONTROL'
/
--
------------------------------------------------------------------------------------------------------------
--CN 07/04/05 Replace the word 'Inventory' with 'Assets' in module titles.
-------------------------------------------------------------------------------------------------------------
--
update hig_modules set hmo_title = 'Asset Domains' where hmo_module = 'NM0301';
update hig_modules set hmo_title = 'Asset XSPs' where hmo_module = 'NM0306';
update hig_modules set hmo_title = 'Asset Metamodel' where hmo_module = 'NM0410';
update hig_modules set hmo_title = 'Asset Exclusive View Creation' where hmo_module = 'NM0411';
update hig_modules set hmo_title = 'Asset Attribute Sets' where hmo_module = 'NM0415';
update hig_modules set hmo_title = 'Asset Items' where hmo_module = 'NM0510';
update hig_modules set hmo_title = 'Asset Location History' where hmo_module = 'NM0520';
update hig_modules set hmo_title = 'Asset Admin Unit Security Maintenance' where hmo_module = 'NM1861';
update hig_modules set hmo_title = 'Global Asset Update' where hmo_module = 'NM0530';
--
---------------------------------------------------------------------------------------------------------------
--CN 07/04/05 Replace the word 'Inventory' with 'Assets' in Error messages.
----------------------------------------------------------------------------------------------------------------
--
update nm_errors
set ner_descr = REPLACE(ner_descr,'inventory','asset')
where ner_descr like '%inventory%'
and   ner_appl IN ('NET','HIG')
/
update nm_errors
set ner_descr = REPLACE(ner_descr,'Inventory','Asset')
where ner_descr like '%Inventory%'
and   ner_appl IN ('NET','HIG')
/
--
----------------------------------------------------------------------------------------------------------------
--CN 07/04/05 Column hstf_descr in hig_standard_favourites needs to be the same as hmo_title in hig_modules
--	      as the module titles have been changed (The word 'Inventory' has been replaced with 'Assets').
-----------------------------------------------------------------------------------------------------------------
--
 UPDATE HIG_STANDARD_FAVOURITES
  SET HSTF_DESCR = (SELECT hmo_title FROM HIG_MODULES
                     WHERE  hmo_module = hstf_child)
  WHERE hstf_type = 'M'
  AND hstf_child LIKE 'NM%'
/
--
----------------------------------------------------------------------------------------------------------------
--CN 07/04/05 Remove any Asset favourites that are under network manager
----------------------------------------------------------------------------------------------------------------
--
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0301';
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0305';
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0306';
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0410';
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0550';
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0551';
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0411';
delete from hig_standard_favourites where hstf_parent='NET_REF_INVENTORY' and hstf_child = 'NM0415';
delete from hig_standard_favourites where hstf_parent='NET' and hstf_child = 'NET_QUERIES';
delete from hig_standard_favourites where hstf_parent='NET' and hstf_child = 'NET_INVENTORY';
--
----------------------------------------------------------------------------------------------------------------
-- CN 07/04/05 Add asset modules into Asset Manager
-----------------------------------------------------------------------------------------------------------------
--
INSERT INTO hig_products
             (hpr_product
            , hpr_product_name
            , hpr_version
            , hpr_key
            )
SELECT        'AST'
            , 'asset manager'
            , '3.2.1.0'
            , 65
FROM         dual
WHERE NOT EXISTS (select 'x'
                  from   hig_products
                  where  hpr_product = 'AST')
/

----------------------------------------------------------------------------------------------------------------
-- PS 30/06/05 Add NEW product Web Mapping for locator
-----------------------------------------------------------------------------------------------------------------
--
INSERT INTO hig_products
             (hpr_product
            , hpr_product_name
            , hpr_version
            , hpr_key
            )
SELECT        'WMP'
            , 'Web Mapping'
            , '3.2.1.0'
            , null
FROM         dual
WHERE NOT EXISTS (select 'x'
                  from   hig_products
                  where  hpr_product = 'WMP')
/

insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('FAVOURITES','AST','Asset Manager','F',3);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST','AST_REF','Asset Reference Data','F',3);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST','NET_QUERIES','Asset Queries','F',2);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST','NET_INVENTORY','Asset Management','F',1);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0415','Asset Attribute Sets','M',4);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0411','Asset Exclusive View Creation','M',3);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0551','Cross Item Validation Setup','M',8);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0550','Cross Attribute Validation Setup','M',7);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0410','Asset Metamodel','M',2);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0306','Asset XSPs','M',6);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0305','XSP and Reversal Rules','M',5);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('AST_REF','NM0301','Asset Domains','M',1);
--
---------------------------------------------------------------------------------------------------------------------
-- CN 07/04/05 update product names so they have initial capitals
----------------------------------------------------------------------------------------------------------------------
--
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'DOC';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'NSG';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'ACC';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'MAI';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'NET';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'PMS';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'ENQ';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'CLM';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'SWR';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'STP';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'STR';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'TM';
update hig_standard_favourites set hstf_descr = INITCAP(hstf_descr) where hstf_parent = 'FAVOURITES' and hstf_child = 'HIG';
--
---------------------------------------------------------------------------------------------------------------------
--CN 07/04/05 Delete 'Jobs from Netword Manager
---------------------------------------------------------------------------------------------------------------------
--
delete from hig_standard_favourites where hstf_parent='NET_REF_JOB' and hstf_child = 'NM3010';
delete from hig_standard_favourites where hstf_parent='NET_REF_JOB' and hstf_child = 'NM3020';
delete from hig_standard_favourites where hstf_parent='NET_REF' and hstf_child = 'NET_REF_JOB';
--
----------------------------------------------------------------------------------------------------------------------
--CN 07/04/05 Add 'Jobs' to the Highways folder
----------------------------------------------------------------------------------------------------------------------
--
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('HIG','HIG_JOBS','Jobs','F',5);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('HIG_JOBS','NM3010','Job Operations','M',2);
insert into hig_standard_favourites (hstf_parent, hstf_child, hstf_descr,hstf_type,hstf_order) values ('HIG_JOBS','NM3020','Job Types','M',1);
--
--------------------------------------------------------------------------------------------------------------------
--CN 13/04/05  Changed one of the codes to show AST not INV.
---------------------------------------------------------------------------------------------------------------------
--
update hig_codes
set hco_meaning = 'Ast Type and Location Based Cross Item Validation'
where hco_meaning = 'Inv Type and Location Based Cross Item Validation'
and hco_domain = 'X_ATTR_VAL_TYPES'
and hco_code = '1';
--
--------------------------------------------------------------------------------------------------------------------
--CN 13/04/05 Move modules from Network folder to Reference Data folder
--------------------------------------------------------------------------------------------------------------------
UPDATE HIG_STANDARD_FAVOURITES SET HSTF_PARENT = 'NET_REF'   WHERE HSTF_PARENT = 'NET_REF_NETWORK';
--
----------------------------------------------------------------------------------------------------------------------
-- CN 13/04/05 Remove folders Inventory and Network from Referance Data
-----------------------------------------------------------------------------------------------------------------------
--
DELETE FROM HIG_STANDARD_FAVOURITES WHERE hstf_parent='NET_REF' and hstf_child = 'NET_REF_NETWORK';
DELETE FROM HIG_STANDARD_FAVOURITES WHERE hstf_parent='NET_REF' and hstf_child = 'NET_REF_INVENTORY';
--
----------------------------------------------------------------------------------------------------------------------
-- CN 13/04/05 Change module title
-----------------------------------------------------------------------------------------------------------------------
--
UPDATE HIG_STANDARD_FAVOURITES SET HSTF_DESCR = 'Maintain AD Types' WHERE HSTF_CHILD = 'NM0700';
--
----------------------------------------------------------------------------------------------------------------------

--
----------------------------------------------------------------------------------------------------------------------
--
-- Move any modules that are now under the AST menu from the 'NET' application to 'AST' application
UPDATE hig_modules hmo
SET    hmo_application = 'AST'
WHERE  EXISTS (select 1 from hig_standard_favourites
               where hmo.hmo_module = hstf_child
               and (hstf_parent like 'AST%' or HSTF_PARENT LIKE 'NET_INVEN%' or HSTF_PARENT LIKE 'NET_QUER%')
 	       )
/ 	       



--------------------------------------------------------------------------------------
--HIG_STANDARD_FAVOURITES.
--------------------------------------------------------------------------------------
INSERT
  INTO HIG_STANDARD_FAVOURITES
      (HSTF_PARENT
      ,HSTF_CHILD
      ,HSTF_DESCR
      ,HSTF_TYPE
      ,HSTF_ORDER)
select 'MAI_GMIS_LOADERS'
      ,'MAI2530'
      ,'Create Route and Defect Files for GMIS Inspections'
      ,'M'
      ,10
FROM  dual
WHERE NOT EXISTS (SELECT 'x'
                  FROM  HIG_STANDARD_FAVOURITES
                  WHERE  HSTF_PARENT = 'MAI_GMIS_LOADERS'
                  AND    HSTF_CHILD = 'MAI2530')
/

UPDATE hig_standard_favourites
   SET hstf_order = 14
 WHERE hstf_parent = 'MAI_REF_MAINTENANCE'
   AND hstf_child  = 'MAI_REF_MAINTENANCE_REPORTS'
/

INSERT
  INTO HIG_STANDARD_FAVOURITES
      (HSTF_PARENT
      ,HSTF_CHILD
      ,HSTF_DESCR
      ,HSTF_TYPE
      ,HSTF_ORDER)
SELECT 'MAI_REF_MAINTENANCE'
      ,'MAI3632'
      ,'Asset Activities'
      ,'M'
      ,10
FROM  dual
WHERE NOT EXISTS (SELECT 'x'
                  FROM  HIG_STANDARD_FAVOURITES
                  WHERE  HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                  AND    HSTF_CHILD = 'MAI3632')
/

INSERT
  INTO HIG_STANDARD_FAVOURITES
      (HSTF_PARENT
      ,HSTF_CHILD
      ,HSTF_DESCR
      ,HSTF_TYPE
      ,HSTF_ORDER)
SELECT 'MAI_REF_MAINTENANCE'
      ,'MAI3630'
      ,'Budget Allocations'
      ,'M'
      ,11
FROM  dual
WHERE NOT EXISTS (SELECT 'x'
                  FROM  HIG_STANDARD_FAVOURITES
                  WHERE  HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                  AND    HSTF_CHILD = 'MAI3630')
/



--
----------------------------------------------------------------------------------------------------------------------
-- 701392
-----------------------------------------------------------------------------------------------------------------------
update gri_params
set gp_shown_column = 'HCT_ID'
where gp_param = 'ENQUIRER';

--
-------------------------------------------------------------------------------------------------
-- Mapserver Product Options
-- Ensure that they are all present and that they are now part of the WMP product
-------------------------------------------------------------------------------------------------
--
update hig_option_list
set hol_product = 'WMP'
where hol_id IN ('JDBCHOST'
                ,'JDBCPORT'
                ,'JDBCSID'
                ,'LINESTYLE'
                ,'OVRVWSTYLE'
                ,'POINTSTYLE'
                ,'SDODEFNTH'
                ,'SDOPEMNTH'
                ,'SDOPTZOOM'
                ,'WEBMAPDBUG'
                ,'WEBMAPDSRC'
                ,'WEBMAPMSV'
                ,'WEBMAPNAME'
                ,'WEBMAPSERV'
                ,'WEBMAPTITL')
/  
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'JDBCHOST'
       ,'WMP'
       ,'JDBC Host'
       ,'JDBC Server Host Name'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'JDBCHOST');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'JDBCPORT'
       ,'WMP'
       ,'JDBC Port'
       ,'JDBC Port for Host Connection'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'JDBCPORT');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'JDBCSID'
       ,'WMP'
       ,'JDBC SID'
       ,'Oracle SID for JDBC Connection'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'JDBCSID');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'LINESTYLE'
       ,'WMP'
       ,'Map Highlight Line Style'
       ,'Line style for Map Highlight'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'LINESTYLE');
--
INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'USER_OPTIONS'
       ,'OVRVWSTYLE'
       ,'Web Map Overview Rectangle Line Style'
       ,'Y'
       ,99
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'OVRVWSTYLE');
--                    
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'POINTSTYLE'
       ,'WMP'
       ,'Map Highlight Point Style'
       ,'Point style for Map Highlight'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'POINTSTYLE');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDODEFNTH'
       ,'WMP'
       ,'SDO DEFECT Theme ID'
       ,'Theme ID of the DEFECT SDO layer'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDODEFNTH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDOPEMNTH'
       ,'WMP'
       ,'SDO PEM Theme ID'
       ,'Theme ID of the PEM SDO Layer'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOPEMNTH');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'SDOPTZOOM'
       ,'WMP'
       ,'Point Zoom Scale'
       ,'Zoom Scale when selecting Point Items'
       ,''
       ,'NUMBER'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'SDOPTZOOM');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPDBUG'
       ,'WMP'
       ,'Map Debug'
       ,'Debug Level for Web Mapping. 0 is off - 1 is on'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPDBUG');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPDSRC'
       ,'WMP'
       ,'Data Source'
       ,'Name of the JDBC Data Source connecting map server to RDBMS'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPDSRC');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPMSV'
       ,'WMP'
       ,'OMV Servlet URL'
       ,'URL to specify the Oracle Mapviewer Servlet'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPMSV');
--                   
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPNAME'
       ,'WMP'
       ,'Base Map'
       ,'Name of the Base Map as defined in Oracle metadata'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPNAME');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPSERV'
       ,'WMP'
       ,'Web Map Server'
       ,'The URL for the web map server'
       ,''
       ,'VARCHAR2'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPSERV');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       )
SELECT 
        'WEBMAPTITL'
       ,'WMP'
       ,'Map Banner'
       ,'Title Text for Web Mapping'
       ,''
       ,'VARCHAR2'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPTITL');
--
-- user options
--
INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPMSV', 'URL to specify the Oracle Mapviewer Servlet', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPMSV')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPNAME', 'Base Map Name', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPNAME')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPDSRC', 'Data Source Name', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPDSRC')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPDBUG', 'Web Mapping Debug Level', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPDBUG')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPTITL', 'Web Map Banner', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPTITL')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'OVRVWSTYLE', 'Web Map Overview Rectangle Line Style', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'OVRVWSTYLE')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'LINESTYLE', 'Web Map Highlight Line Style', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'LINESTYLE')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'POINTSTYLE', 'Web Map Highlight Point Style', 'Y', 99, null, null
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'POINTSTYLE')
/

INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'USER_OPTIONS'
       ,'JDBCHOST'
       ,'JDBC Server Host Name'
       ,'Y'
       ,99
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'JDBCHOST');
--
INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'USER_OPTIONS'
       ,'JDBCPORT'
       ,'JDBC Port for Host Connection'
       ,'Y'
       ,99
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'JDBCPORT');
--
INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'USER_OPTIONS'
       ,'JDBCSID'
       ,'Oracle SID for JDBC Connection'
       ,'Y'
       ,99
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'JDBCSID');
--




--
---------------------------------------------------------------------------------------------------
--
/* Upgrade NM_THEMES_ALL
    > Create a backup table called NM_THEMES_ALL_3200
    > Update all themes that use a sequence for their surrogate key (nth_sequence_name - SSV Layers only)
    > Update all themes that use history (SSV Layer only)
    > Update all themes so that the base table theme is set for view based layers (SSV Layers only)
*/
--
DECLARE
--
 TYPE tab_nth
   IS TABLE OF NM_THEMES_ALL%ROWTYPE INDEX BY BINARY_INTEGER;

  l_tab_nit_nth     tab_nth;
  l_tab_nlt_nth     tab_nth;
  l_tab_nat_nth     tab_nth;

  b_surrogate_key   VARCHAR2(1) := Nm3sdo.use_surrogate_key;

  l_table_not_exist EXCEPTION;
  PRAGMA            EXCEPTION_INIT (l_table_not_exist, -942);
--
  FUNCTION is_ssv_layer (pi_theme_id IN NUMBER) RETURN BOOLEAN
  IS
    l_flag PLS_INTEGER;
  --
  BEGIN
  --
    SELECT *
      INTO l_flag
      FROM ( SELECT 1
               FROM NM_INV_THEMES
              WHERE NITH_NTH_THEME_ID = pi_theme_id
              UNION
             SELECT 1
               FROM NM_NW_THEMES
              WHERE NNTH_NTH_THEME_ID = pi_theme_id
                AND EXISTS
                    (SELECT 1
                      FROM nm_linear_types
                     WHERE nlt_id = nnth_nlt_id
                       AND nlt_G_I_D = 'G')
              UNION
             SELECT 1
               FROM NM_AREA_THEMES
              WHERE NATH_NTH_THEME_ID = pi_theme_id );
  --
    IF l_flag IS NOT NULL
    THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
      THEN RETURN FALSE;
    WHEN OTHERS
      THEN RAISE;
  END is_ssv_layer;
--
BEGIN
--
  BEGIN
    EXECUTE IMMEDIATE
      'DROP TABLE NM_THEMES_ALL_3200';
  EXCEPTION
    WHEN l_table_not_exist
      THEN NULL;
    WHEN OTHERS
      THEN RAISE;
  END;
  --
  BEGIN
    EXECUTE IMMEDIATE
      'CREATE TABLE NM_THEMES_ALL_3200 AS'||
      ' (SELECT * FROM NM_THEMES_ALL)';
  EXCEPTION
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR (-20001,'Error backing up NM_THEMES_ALL table ');
  END;
  --
  FOR i IN
    (SELECT * FROM NM_THEMES_ALL
      WHERE nth_theme_type = 'SDO')
  LOOP
  --
    -- Make sure layer is generated by SSV before changing it.
    IF is_ssv_layer (i.nth_theme_id)
    THEN
    --
      -- Set history columns
      IF i.nth_use_history = 'N'
      AND i.nth_start_date_column IS NULL
      AND i.nth_end_date_column IS NULL
      THEN
        UPDATE NM_THEMES_ALL
           SET nth_use_history = 'Y'
             , nth_start_date_column = 'START_DATE'
             , nth_end_date_column   = 'END_DATE'
         WHERE nth_theme_id = i.nth_theme_id;
      END IF;
    --
      IF b_surrogate_key = 'Y'
      THEN
    --
        -- Set sequence name attribute on layer if using sequence
        IF i.nth_sequence_name IS NULL
        THEN
          UPDATE NM_THEMES_ALL
             SET nth_sequence_name = 'NTH_'||TO_CHAR(i.nth_theme_id)||'_SEQ'
           WHERE nth_theme_id = i.nth_theme_id;
        END IF;
    --
      END IF;
  --
    END IF;
  --
  END LOOP;
--
  -- collect together all the base table SSV asset themes
  BEGIN
   SELECT NM_THEMES_ALL.*
     BULK COLLECT INTO l_tab_nit_nth
     FROM NM_INV_THEMES
         ,NM_THEMES_ALL
    WHERE nth_theme_id = nith_nth_theme_id
      AND nth_feature_table LIKE 'NM_NIT_%';
  EXCEPTION
    WHEN NO_DATA_FOUND
      THEN NULL;
    WHEN OTHERS
      THEN RAISE;
  END;
--
  -- collect together all the base table SSV linear themes
  BEGIN
   SELECT NM_THEMES_ALL.*
     BULK COLLECT INTO l_tab_nlt_nth
     FROM NM_NW_THEMES
         ,NM_THEMES_ALL
    WHERE nth_theme_id = nnth_nth_theme_id
      AND nth_feature_table LIKE 'NM_NLT_%';
  EXCEPTION
    WHEN NO_DATA_FOUND
      THEN NULL;
    WHEN OTHERS
      THEN RAISE;
  END;
--
  -- collect together all the base table SSV area themes
  BEGIN
   SELECT NM_THEMES_ALL.*
     BULK COLLECT INTO l_tab_nat_nth
     FROM NM_AREA_THEMES
         ,NM_THEMES_ALL
    WHERE nth_theme_id = nath_nth_theme_id
      AND nth_feature_table LIKE 'NM_NAT_%';
  EXCEPTION
    WHEN NO_DATA_FOUND
      THEN NULL;
    WHEN OTHERS
      THEN RAISE;
  END;
--
  -- Retrospectively update the base table themes for the SSV generated layers
  -- we can rely on naming conventions for this.
  -- Other layers will need to be set manually.
  FOR i IN 1..l_tab_nit_nth.COUNT
  LOOP
    UPDATE NM_THEMES_ALL
       SET NTH_BASE_TABLE_THEME = l_tab_nit_nth(i).nth_theme_id
     WHERE nth_feature_table LIKE 'V_'||l_tab_nit_nth(i).nth_feature_table||'%';
  END LOOP;
  FOR i IN 1..l_tab_nlt_nth.COUNT
  LOOP
    UPDATE NM_THEMES_ALL
       SET NTH_BASE_TABLE_THEME = l_tab_nlt_nth(i).nth_theme_id
     WHERE nth_feature_table LIKE 'V_'||l_tab_nlt_nth(i).nth_feature_table||'%';
  END LOOP;
  FOR i IN 1..l_tab_nat_nth.COUNT
  LOOP
    UPDATE NM_THEMES_ALL
       SET NTH_BASE_TABLE_THEME = l_tab_nat_nth(i).nth_theme_id
     WHERE nth_feature_table LIKE 'V_'||l_tab_nat_nth(i).nth_feature_table||'%';
  END LOOP;
--
END;
/
--
---------------------------------------------------------------------------------------------------
DECLARE
--
/* Upgrade Linear Route Layers
    > End-date shapes where their parent elements have been enddated.
    > Delete shapes where their end-date post-dates the element end-date
*/
 TYPE tab_nth IS 
 TABLE OF nm_themes_all%ROWTYPE INDEX BY BINARY_INTEGER;
--
  l_tab_nth          tab_nth;
  l_tab_ne_id_1      nm3type.tab_number;
  l_tab_ne_edate_1   nm3type.tab_date;
  l_tab_ne_id_2      nm3type.tab_number;
BEGIN
--
  SELECT *
    BULK COLLECT INTO l_tab_nth
    FROM nm_themes_all
   WHERE EXISTS
    (SELECT 1 
       FROM nm_nw_themes
      WHERE NNTH_NTH_THEME_ID = nth_theme_id
        AND EXISTS
         (SELECT 1 
            FROM nm_linear_types
           WHERE nlt_g_i_d = 'G'
             AND nlt_id = nnth_nlt_id))
    AND nth_base_table_theme IS NULL;
  --
  FOR i IN 1..l_tab_nth.COUNT
  LOOP
    EXECUTE IMMEDIATE
    'SELECT a.ne_id, b.ne_end_date '||CHR(10)||
    '  FROM '||l_tab_nth(i).nth_feature_table||' a,'||CHR(10)||
    '        nm_elements b '||CHR(10)||
    ' WHERE a.NE_ID = b.NE_ID '||CHR(10)||
    '   AND end_date IS NULL '||CHR(10)||
    '   AND b.ne_end_date IS NOT NULL'
    BULK COLLECT INTO l_tab_ne_id_1, l_tab_ne_edate_1;
    --
    FOR i IN 1..l_tab_ne_id_1.COUNT
    LOOP
      EXECUTE IMMEDIATE
        'UPDATE '||l_tab_nth(i).nth_feature_table||CHR(10)||
        '   SET end_date = '||l_tab_ne_edate_1(i)||CHR(10)||
        ' WHERE ne_id = '||l_tab_ne_id_1(i);
    END LOOP;
    --
    EXECUTE IMMEDIATE
    'SELECT a.ne_id '||CHR(10)||
    '  FROM '||l_tab_nth(i).nth_feature_table||' a'||CHR(10)||
    ' WHERE EXISTS '||CHR(10)||
    '  (SELECT 1 '||CHR(10)||
    '     FROM nm_elements_all c '||CHR(10)||
    '    WHERE a.ne_id = c.ne_id '||CHR(10)||
    '      AND a.end_date IS NOT NULL '||CHR(10)||
    '      AND a.end_date > c.ne_end_date)'
    BULK COLLECT INTO l_tab_ne_id_2;
    --
    FOR i IN 1..l_tab_ne_id_2.COUNT
    LOOP
      EXECUTE IMMEDIATE
        'DELETE '||l_tab_nth(i).nth_feature_table||CHR(10)||
         'WHERE ne_id = '||l_tab_ne_id_2(i);
    END LOOP;
  --
  END LOOP;
  --
 EXCEPTION
   WHEN OTHERS
     THEN NULL;
END;
/
--
------------------------------------------------------------------------
-- This attempts to set the option value SDOPEMNTH - selects the first theme if finds with DOC_ID as the PK (i.e. the PEM Theme).
-- If it fails to find one (i.e. no data found from implicit select) then it can fail silently. The user will have to create their PEM theme first.
DECLARE
   l_pem_nth_id  nm_themes_all.nth_theme_id%TYPE;
BEGIN
--  Get PEM theme id
   SELECT nth_theme_id
        INTO l_pem_nth_id
      FROM nm_themes_all
    WHERE nth_pk_column = 'DOC_ID'
        AND rownum = 1;
-- Set PEM theme product option for Mapviewer
    INSERT INTO HIG_OPTION_VALUES
      (hov_id, hov_value)
    VALUES
      ('SDOPEMNTH',l_pem_nth_id);
--
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/

-- This attempts to set the option value - selects the first theme it finds with DEF_DEFECT_ID as the PK (i.e. a DEFECT Theme).
-- If it fails to find one (i.e. no data found from implicit select) then it can fail silently. The user will have to create their DEFECT theme first.
DECLARE
   l_def_nth_id  nm_themes_all.nth_theme_id%TYPE;
BEGIN
--  Get DEFECTS theme id
   SELECT nth_theme_id
        INTO l_def_nth_id
      FROM nm_themes_all
    WHERE nth_pk_column = 'DEF_DEFECT_ID'
        AND rownum = 1;
-- Set DEFECTS theme product option for Mapviewer
    INSERT INTO HIG_OPTION_VALUES
      (hov_id, hov_value)
    VALUES
      ('SDODEFNTH',l_def_nth_id);
--
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/


--
---------------------------------------------------------------------------------------------------
-- START OF NM_TYPE_COLUMNS metadata changes to existing known models
--
BEGIN
    EXECUTE IMMEDIATE
      'DROP TABLE NM_TYPE_COLUMNS_OLD';
EXCEPTION
    WHEN others
      THEN NULL;
END;
/
BEGIN
    EXECUTE IMMEDIATE
      'CREATE TABLE NM_TYPE_COLUMNS_OLD AS SELECT * FROM NM_TYPE_COLUMNS';
EXCEPTION
    WHEN others
      THEN NULL;
END;
/

UPDATE nm_type_columns
SET    ntc_query = 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''L'''
WHERE  ntc_nt_type = 'L'
AND    ntc_column_name = 'NE_SUB_CLASS'
AND    ntc_query IS NOT NULL
/
UPDATE nm_type_columns
SET    ntc_query = 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''LLNK'''
WHERE  ntc_nt_type = 'LLNK'
AND    ntc_column_name = 'NE_SUB_CLASS'
AND    ntc_query IS NOT NULL
/
UPDATE nm_type_columns
SET    ntc_query = 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''D'''
WHERE  ntc_nt_type = 'D'
AND    ntc_column_name = 'NE_SUB_CLASS'
AND    ntc_query IS NOT NULL
/
UPDATE nm_type_columns
SET    ntc_query = 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''DLNK'''
WHERE  ntc_nt_type = 'DLNK'
AND    ntc_column_name = 'NE_SUB_CLASS'
AND    ntc_query IS NOT NULL
/


-- END OF NM_TYPE_COLUMNS metadata changes to existing known models
--
---------------------------------------------------------------------------------------------------
--
--
-- Remove DOC product options that are duplicated as ENQ product options
--
delete from hig_option_list
where hol_id in ('WOOLFCLASS'
,'WOOLFDAYS1'
,'WOOLFDAYS2'
,'WOOLFDAYS3'
,'DEFCAT'
,'DEFCLASS'
,'DEFCMPDATE'
,'DEFSOURCE'
,'ENQATTOP'
,'ENQDATES'
,'AUTOACTION'
,'CLAIMANT'
,'CLAIMCAT'
,'CLAIMROLE'
,'USEACTIONS'
,'USEDAMAGE'
,'ENQSTODEF'
,'INTERNORG')
and hol_product = 'DOC'
/
--
---------------------------------------------------------------------------------------------------
--
-- Assign missing default module roles to Jobs modules
--
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE
                             , HMR_ROLE
                             , HMR_MODE ) 
SELECT
  'NM3010'
, 'HIG_ADMIN'
, 'NORMAL'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                  FROM   hig_module_roles
                  WHERE  hmr_module = 'NM3010'
                  AND    hmr_role = 'HIG_ADMIN')
/
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE
                             , HMR_ROLE
                             , HMR_MODE ) 
SELECT
  'NM3010'
, 'HIG_USER'
, 'READONLY'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                  FROM   hig_module_roles
                  WHERE  hmr_module = 'NM3010'
                  AND    hmr_role = 'HIG_USER')
/
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE
                             , HMR_ROLE
                             , HMR_MODE ) 
SELECT
  'NM3020'
, 'HIG_ADMIN'
, 'NORMAL'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                  FROM   hig_module_roles
                  WHERE  hmr_module = 'NM3020'
                  AND    hmr_role = 'HIG_ADMIN')
/
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE
                             , HMR_ROLE
                             , HMR_MODE ) 
SELECT
  'NM3020'
, 'HIG_USER'
, 'READONLY'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                  FROM   hig_module_roles
                  WHERE  hmr_module = 'NM3020'
                  AND    hmr_role = 'HIG_USER')
/
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE
                             , HMR_ROLE
                             , HMR_MODE ) 
SELECT
  'NM3030'
, 'HIG_ADMIN'
, 'NORMAL'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                  FROM   hig_module_roles
                  WHERE  hmr_module = 'NM3030'
                  AND    hmr_role = 'HIG_ADMIN')
/
INSERT INTO HIG_MODULE_ROLES ( HMR_MODULE
                             , HMR_ROLE
                             , HMR_MODE ) 
SELECT
  'NM3030'
, 'HIG_USER'
, 'READONLY'
FROM DUAL
WHERE NOT EXISTS (SELECT 1
                  FROM   hig_module_roles
                  WHERE  hmr_module = 'NM3030'
                  AND    hmr_role = 'HIG_USER')
/



---------------------------------------------------
--Adding locator to hig standard favoutrites
--
---------------------------------------------------
INSERT
  INTO HIG_STANDARD_FAVOURITES
      (HSTF_PARENT
      ,HSTF_CHILD
      ,HSTF_DESCR
      ,HSTF_TYPE
      ,HSTF_ORDER)
SELECT 'NET_INVENTORY'
      ,'NM0572'
      ,'EXOR Locator'
      ,'M'
      ,3
FROM  dual
WHERE NOT EXISTS (SELECT 'x'
                  FROM  HIG_STANDARD_FAVOURITES
                  WHERE  HSTF_PARENT = 'NET_INVENTORY'
                  AND    HSTF_CHILD = 'NM0572')
/


---------------------------------------------------
--Adding missing MAI module hig standard favoutrites
---------------------------------------------------
INSERT
  INTO HIG_STANDARD_FAVOURITES
      (HSTF_PARENT
      ,HSTF_CHILD
      ,HSTF_DESCR
      ,HSTF_TYPE
      ,HSTF_ORDER)
SELECT 'MAI_INSP_REPORTS'
      ,'MAI5025'
      ,'Detailed Inspection Work Done'
      ,'M'
      ,9
FROM  dual
WHERE NOT EXISTS (SELECT 'x'
                  FROM  HIG_STANDARD_FAVOURITES
                  WHERE  HSTF_PARENT = 'MAI_INSP_REPORTS'
                  AND    HSTF_CHILD = 'MAI5025')
/

---------------------------------------------------------------------------------------------------
-- Metadata change for Defect and PEM creation
---------------------------------------------------------------------------------------------------
DECLARE

   CURSOR cur1 IS
   SELECT * FROM doc_assocs
   WHERE das_table_name IN ( 'INV_ITEMS_ALL'
                            ,'INV_ITEMS'
                            ,'INV_ON_ROADS'
                            ,'NM_INV_ITEMS'
                            ,'NM_INV_ITEMS_ALL');
                            
                            
   CURSOR cur2 IS 
   SELECT * FROM doc_gate_syns
   WHERE dgs_table_syn IN ('INV_ITEMS_ALL'
                          ,'INV_ITEMS'
                          ,'INV_ON_ROADS'
                          ,'NM_INV_ITEMS'
                          ,'NM_INV_ITEMS_ALL');
   

   l_tab_dgs_dgt_table_name  nm3type.tab_varchar2000;
   l_tab_dgs_table_syn       nm3type.tab_varchar2000;                            
   

   PROCEDURE add_row (p_dgs_dgt_table_name VARCHAR2
                     ,p_dgs_table_syn      VARCHAR2
                     ) IS

      c_count CONSTANT pls_integer := l_tab_dgs_dgt_table_name.COUNT+1;

   BEGIN

      l_tab_dgs_dgt_table_name(c_count)    := p_dgs_dgt_table_name;
      l_tab_dgs_table_syn  (c_count)       := p_dgs_dgt_table_name;

   END add_row;  
   
   
BEGIN


   -- NEED  doc_gateways to have nm_inv_items_all as the gateway 
  
   INSERT INTO doc_gateways 
   (
    DGT_TABLE_NAME         
   ,DGT_TABLE_DESCR         
   ,DGT_PK_COL_NAME         
   ,DGT_LOV_DESCR_LIST      
   ,DGT_LOV_FROM_LIST       
   )
    SELECT
    'NM_INV_ITEMS_ALL'
   ,'Asset items all'
   ,'IIT_NE_ID'
   ,'IIT_INV_TYPE||'||''''||'-'||''''||'||DECODE(IIT_X_SECT,Null,Null,IIT_X_SECT||'||''''||'-'||''''||')||IIT_PRIMARY_KEY'
   ,'NM_INV_ITEMS'
    FROM dual
    WHERE NOT EXISTS (SELECT 1 FROM doc_gateways 
                      WHERE dgt_table_name = 'NM_INV_ITEMS_ALL');  
                    
                    
  -- need to update doc_gate_syns so that they point to the correct gateway 
  -- First need to update any effected doc_assocs records  
  
  FOR rec1 IN cur1 LOOP
  
  
     UPDATE doc_assocs
     SET das_table_name = 'NM_INV_ITEMS_ALL'
     WHERE das_table_name = rec1.das_table_name
     AND   das_rec_id     = rec1.das_rec_id
     AND   das_doc_id     = rec1.das_doc_id; 
      
  
  END LOOP;
  
  
  -- Now need to update the doc_gate_syns table so that they point to the correct gateway
  
  FOR rec2 IN cur2 LOOP                             -- update any existing ones 
  
     UPDATE doc_gate_syns
     SET dgs_dgt_table_name = 'NM_INV_ITEMS_ALL'
     WHERE dgs_table_syn = rec2.dgs_table_syn;  
  
  END LOOP;

  
   add_row( 'NM_INV_ITEMS_ALL', 'INV_ITEMS_ALL' );    
   add_row( 'NM_INV_ITEMS_ALL', 'INV_ITEMS' );
   add_row( 'NM_INV_ITEMS_ALL', 'INV_ON_ROADS');
   add_row( 'NM_INV_ITEMS_ALL', 'NM_INV_ITEMS');

   FORALL i IN 1..l_tab_dgs_dgt_table_name.COUNT          -- create any that do not exist 
      INSERT INTO doc_gate_syns
      (
       dgs_dgt_table_name
      ,dgs_table_syn   
      )
      SELECT l_tab_dgs_dgt_table_name(i)
            ,l_tab_dgs_table_syn(i)
      FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  doc_gate_syns
                          WHERE  dgs_dgt_table_name   = l_tab_dgs_dgt_table_name(i)
                          AND    dgs_table_syn        = l_tab_dgs_table_syn(i)
                        );
     
END;                         
/
--
---------------------------------------------------------------------------------------------------
--
/* AD Tidyup */

ALTER TRIGGER nm_nw_ad_link_all_dt_trg DISABLE;

CREATE TABLE nm_nw_ad_link_all_bck
AS SELECT * FROM nm_nw_ad_link_all;


DECLARE
--
  CURSOR nadl
  IS
    SELECT *
      FROM NM_NW_AD_LINK_ALL
     WHERE nad_end_date IS NULL;
  l_start_date DATE;
--
BEGIN
  FOR i IN nadl
  LOOP
    BEGIN
      l_start_date := LEAST(Nm3get.get_ne_all(i.nad_ne_id).ne_start_date
                           ,Nm3get.get_iit_all(i.nad_iit_ne_id).iit_start_date);
      UPDATE NM_NW_AD_LINK_ALL
         SET nad_start_date = l_start_date
       WHERE nad_ne_id = i.nad_ne_id
         AND nad_iit_ne_id = i.nad_iit_ne_id
         AND nad_start_date = i.nad_start_date;
    EXCEPTION
      WHEN OTHERS THEN NULL;
    END;
  END LOOP;
END;
/

ALTER TRIGGER nm_nw_ad_link_all_dt_trg ENABLE;
--
---------------------------------------------------------------------------------------------------
--
/* Create Subordinate User SDO Metadata views for Mapviewer */
BEGIN
  FOR i IN 
    (SELECT hus_username
       FROM hig_users
      WHERE HUS_IS_HIG_OWNER_FLAG = 'N'
        AND EXISTS
        (SELECT 1 
           FROM all_users
          WHERE username = hus_username))
  LOOP
    nm3ddl.Create_Sub_Sdo_Views(i.hus_username);
  END LOOP;
EXCEPTION
  WHEN OTHERS
  THEN NULL;
END;
/
--
---------------------------------------------------------------------------------------------------
--
COMMIT;
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************

