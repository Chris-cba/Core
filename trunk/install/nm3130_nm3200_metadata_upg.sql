--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3130_nm3200_metadata_upg.sql	1.18 04/05/05
--       Module Name      : nm3130_nm3200_metadata_upg.sql
--       Date into SCCS   : 05/04/05 10:06:41
--       Date fetched Out : 07/06/13 13:57:56
--       SCCS Version     : 1.18
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
    add_hsa('NM_AREA_LOCK','NAL_ID','NAL_SEQ');
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
-- HIG_DOMAINS
--
 
   l_tab_hdo_domain         nm3type.tab_varchar30;
   l_tab_hdo_product        nm3type.tab_varchar30;
   l_tab_hdo_title          nm3type.tab_varchar80;
   l_tab_hdo_code_length    nm3type.tab_number;
   
 
   PROCEDURE add (p_hdo_domain       VARCHAR2
                 ,p_hdo_product      VARCHAR2
                 ,p_hdo_title        VARCHAR2
                 ,p_hdo_code_length  NUMBER
                 ) IS
     
      c_count PLS_INTEGER := l_tab_hdo_domain.COUNT+1;
   
   BEGIN
      l_tab_hdo_domain(c_count)        := p_hdo_domain;
      l_tab_hdo_product(c_count)       := p_hdo_product;
      l_tab_hdo_title(c_count)         := p_hdo_title;
      l_tab_hdo_code_length(c_count)   := p_hdo_code_length;
      
   END add;
   
BEGIN
--

   add (p_hdo_domain        => 'GAZMODE'
       ,p_hdo_product       => 'NET'
       ,p_hdo_title         => 'Default Gazetteer Mode'
       ,p_hdo_code_length   => 8
       );
--
   add (p_hdo_domain        => 'THEME_TYPE'
       ,p_hdo_product       => 'NET'
       ,p_hdo_title         => 'GIS Theme Type'
       ,p_hdo_code_length   => 4
       );
--
   add (p_hdo_domain        => 'GEOMETRY_TYPE'
       ,p_hdo_product       => 'NET'
       ,p_hdo_title         => 'GIS Geometry Type'
       ,p_hdo_code_length   => 4
       );
--
   add (p_hdo_domain        => 'PBI_SR_COND'
       ,p_hdo_product       => 'NET'
       ,p_hdo_title         => 'SQL Single Row Conditions'
       ,p_hdo_code_length   => 20
       );
--
   FORALL i IN 1..l_tab_hdo_domain.COUNT
      INSERT INTO hig_domains
            (hdo_domain
            ,hdo_product
            ,hdo_title
            ,hdo_code_length
            )
      SELECT l_tab_hdo_domain(i)
            ,l_tab_hdo_product(i)
            ,l_tab_hdo_title(i)
            ,l_tab_hdo_code_length(i)
      FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_domains
                         WHERE  hdo_domain = l_tab_hdo_domain(i)
                        );
--

END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- HIG_CODES
--
   
   l_tab_hco_domain        nm3type.tab_varchar30;
   l_tab_hco_code          nm3type.tab_varchar30;
   l_tab_hco_meaning       nm3type.tab_varchar80;
   l_tab_hco_system        nm3type.tab_VARCHAR1;
   l_tab_hco_seq           nm3type.tab_NUMBER;
   l_tab_hco_start_date    nm3type.tab_date;
   l_tab_hco_end_date      nm3type.tab_date;
   
   PROCEDURE add (p_hco_domain       VARCHAR2
                 ,p_hco_code         VARCHAR2
                 ,p_hco_meaning      VARCHAR2
                 ,p_hco_system       VARCHAR2
                 ,p_hco_seq          NUMBER
                 ,p_hco_start_date   date
                 ,p_hco_end_date     date
                 ) IS
     
      c_count PLS_INTEGER := l_tab_hco_domain.COUNT+1;
   
   BEGIN
          
      l_tab_hco_domain(c_count)         :=  p_hco_domain;
      l_tab_hco_code(c_count)           :=  p_hco_code;
      l_tab_hco_meaning(c_count)        :=  p_hco_meaning;
      l_tab_hco_system(c_count)         :=  p_hco_system;
      l_tab_hco_seq(c_count)            :=  p_hco_seq;
      l_tab_hco_start_date(c_count)     :=  p_hco_start_date;
      l_tab_hco_end_date(c_count)       :=  p_hco_end_date;
      
   END add;
   
BEGIN
--
--
   add (p_hco_domain      => 'GAZMODE'
       ,p_hco_code        => 'STANDARD'
       ,p_hco_meaning     => 'Start Gazetteer in Standard mode'
       ,p_hco_system      => 'N'
       ,p_hco_seq         => 1
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--  
   add (p_hco_domain      => 'GAZMODE'
       ,p_hco_code        => 'ADVANCED'
       ,p_hco_meaning     => 'Start Gazetteer in Advanced mode'
       ,p_hco_system      => 'N'
       ,p_hco_seq         => 2
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--  
   add (p_hco_domain      => 'USER_OPTIONS'
       ,p_hco_code        => 'GAZ_RGT'
       ,p_hco_meaning     => 'Default Gazetteer Group'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 1
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--  
   add (p_hco_domain      => 'USER_OPTIONS'
       ,p_hco_code        => 'GAZMODE'
       ,p_hco_meaning     => 'Default Gazetteer Starting Mode'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 1
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );       
--
   add (p_hco_domain      => 'THEME_TYPE'
       ,p_hco_code        => 'SDO'
       ,p_hco_meaning     => 'Oracle Spatial'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 1
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'THEME_TYPE'
       ,p_hco_code        => 'SDE'
       ,p_hco_meaning     => 'Esri Spatial Database Engine'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 2
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'THEME_TYPE'
       ,p_hco_code        => 'LOCL'
       ,p_hco_meaning     => 'Local'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 3
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '2001'
       ,p_hco_meaning     => '2D Point'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 1
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '2002'
       ,p_hco_meaning     => '2D Line'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 2
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '2003'
       ,p_hco_meaning     => '2D Polygon'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 3
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '2004'
       ,p_hco_meaning     => '2D Collection'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 4
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '2005'
       ,p_hco_meaning     => '2D Multi-point'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 5
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '2006'
       ,p_hco_meaning     => '2D Multi-line'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 6
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '2007'
       ,p_hco_meaning     => '2D Multi-polygon'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 7
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '3001'
       ,p_hco_meaning     => '3D Point'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 8
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '3002'
       ,p_hco_meaning     => '3D Line'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 9
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '3003'
       ,p_hco_meaning     => '3D Polygon'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 10
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '3004'
       ,p_hco_meaning     => '3D Collection'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 11
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '3005'
       ,p_hco_meaning     => '3D Multi-point'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 12
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '3006'
       ,p_hco_meaning     => '3D Multi-line'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 13
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'GEOMETRY_TYPE'
       ,p_hco_code        => '3007'
       ,p_hco_meaning     => '3D Multi-polygon'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 14
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'PBI_SR_COND'
       ,p_hco_code        => '='
       ,p_hco_meaning     => 'Equals'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 1
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'PBI_SR_COND'
       ,p_hco_code        => '<>'
       ,p_hco_meaning     => 'Not equal to'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 2
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'PBI_SR_COND'
       ,p_hco_code        => '<'
       ,p_hco_meaning     => 'Less than'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 3
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'PBI_SR_COND'
       ,p_hco_code        => '<='
       ,p_hco_meaning     => 'Less than or equal to'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 4
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'PBI_SR_COND'
       ,p_hco_code        => '>'
       ,p_hco_meaning     => 'Greater than'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 5
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'PBI_SR_COND'
       ,p_hco_code        => '>='
       ,p_hco_meaning     => 'Greater than or equal to'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 6
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   add (p_hco_domain      => 'PBI_SR_COND'
       ,p_hco_code        => 'LIKE'
       ,p_hco_meaning     => 'Like'
       ,p_hco_system      => 'Y'
       ,p_hco_seq         => 7
       ,p_hco_start_date  => NULL
       ,p_hco_end_date    => NULL
       );
--
   FORALL i IN 1..l_tab_hco_domain.COUNT
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
      FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_codes
                         WHERE  hco_domain = l_tab_hco_domain(i)
                         AND    hco_code = l_tab_hco_code(i)
                        );

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

   PROCEDURE add (p_hol_id         VARCHAR2
                 ,p_hol_product    VARCHAR2
                 ,p_hol_name       VARCHAR2
                 ,p_hol_remarks    VARCHAR2
                 ,p_hol_domain     VARCHAR2 DEFAULT Null
                 ,p_hol_datatype   VARCHAR2 DEFAULT 'VARCHAR2'
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
   add (p_hol_id         => 'HTML_BASE'
       ,p_hol_product    => 'HIG'
       ,p_hol_name       => 'WebHelp HTML Base'
       ,p_hol_remarks    => 'Base URL for HTML help'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => 'VARCHAR2'
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => 'http://www.<host_not_set>.com/webhelp'
       );

   add (p_hol_id         => 'HTMLHLPST'
       ,p_hol_product    => 'HIG'
       ,p_hol_name       => 'WebHelp HTML Entry Point'
       ,p_hol_remarks    => 'Entry Point for HTML help'
       ,p_hol_domain     => Null
       ,p_hol_datatype   => 'VARCHAR2'
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => '/hig/webhelp/hig.htm'
       );

   add (p_hol_id         => 'GAZMODE'
       ,p_hol_product    => 'NET'
       ,p_hol_name       => 'Gazetteer Mode'
       ,p_hol_remarks    => 'This value is used to define which mode the gazetteer should open in, Standard or Advanced'
       ,p_hol_domain     => 'GAZMODE'
       ,p_hol_datatype   => 'VARCHAR2'
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'STANDARD'
       );
            
   add (p_hol_id         => 'GAZ_RGT'
       ,p_hol_product    => 'NET'
       ,p_hol_name       => 'Default Gazetteer Group Type'
       ,p_hol_remarks    => 'This option is to set the prefered group type for the gazetteer'
       ,p_hol_domain     => null
       ,p_hol_datatype   => 'VARCHAR2'
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'OFFN'
       );
   
   add (p_hol_id         => 'SDMREGULYR'
       ,p_hol_product    => 'HIG'
       ,p_hol_name       => 'Register user layers for SDM'
       ,p_hol_remarks    => 'When set to Y the system will maintain a set of SDO/SDE metadata for all users'
       ,p_hol_domain     => 'Y_OR_N'
       ,p_hol_datatype   => 'VARCHAR2'
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'N'
       );

   add (p_hol_id         => 'SMTPAUDTIT'
       ,p_hol_product    => 'HIG'
       ,p_hol_name       => 'Audit info in mail titles'
       ,p_hol_remarks    => 'If set to "Y" information about the sender will be included in the mail message title for any mails sent by the system'
       ,p_hol_domain     => 'Y_OR_N'
       ,p_hol_datatype   => 'VARCHAR2'
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'Y'
       );
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
END;
/
---------------------------------------------------------------------------------------------------
-- Update of Usage Remark for Product Option EXTRTEDATE  -- PS
---------------------------------------------------------------------------------------------------
DECLARE

   
BEGIN
  
   UPDATE hig_option_list
   SET hol_remarks = 'Default Start Date when extending a route.  1 - Leave as Null, 2 - Inherit from previous Element, 3 - Effective Date, 4 - Previous Element membership'
   WHERE hol_id = 'EXTRTEDATE';
   
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
   -- NET errors
   --
   l_current_type := 'NET';
   --
   add_ner(224, 'Subclass is invalid');
   add_ner(357, 'Operation can only be performed on datum elements and groups of sections.');
   add_ner(358, 'Split position is invalid.');
   add_ner(359, 'Group cannot be split at this node.');
   add_ner(360, 'Position coincides with node(s).');
   add_ner(361, 'Element cannot be split.');
   add_ner(362, 'You have chosen to re-use an existing node but no node has been specified.');
   add_ner(363, 'Elements cannot be merged.');
   add_ner(364, 'Elements are connected at more than one node.');
   add_ner(365, 'Merge would result in reversal of route direction which is not permitted.');
   add_ner(366, 'Group Start/End node(s) do not match Start/End node(s) of datum.');
   add_ner(367, 'Group Offset does not coincide with Non-Ambiguous Offset.');
   add_ner(368, 'A Primary does not exist for this Network Type. A Primary must be created first');
   add_ner(369, 'A Primary already exists for this Network Type');
   add_ner(370, 'This combination of Network Type and Asset Type already exists');
   add_ner(371, 'A Primary does not exist for this Network Type/Group Type combination. A primary must be created first');
   add_ner(372, 'A Primary already exists for this Network Type/Group Type combination');
   add_ner(373, 'This combination of Network Type, Asset Type and Group Type already exists');
   add_ner(374, 'Cannot have multiple inventory item links for a Primary AD Type');
   add_ner(375, 'An Inventory item should only be associated with a single network element in the context of Associated Data');
   add_ner(376, 'This AD Type is flagged as Single Row - only one item allowed');
   add_ner(377, 'No Primary AD Type defined for Network Type');
   add_ner(378, 'Element has memberships with a future start date');   
   add_ner(379, 'Inventory Type invalid for AD Type');
   
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
-- Add AD Types module
--
Insert into HIG_MODULES
   (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
 Values
   ('NM0700', 'Maintain Additional Data', 'nm0700', 'FMX', 'N', 'N', 'NET', 'FORM')
/

Insert into HIG_MODULE_ROLES
   (HMR_MODULE, HMR_ROLE, HMR_MODE)
 Values
   ('NM0700', 'NET_USER', 'NORMAL')
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
   add (p_hstf_parent  => 'MAI_WORKS_REPORTS'
       ,p_hstf_child   => 'MAI3918'
       ,p_hstf_descr   => 'Works Orders (Enhanced Format)'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  3
        );
   
   add (p_hstf_parent  => 'NET_REF_NETWORK'
       ,p_hstf_child   => 'NM0700'
       ,p_hstf_descr   => 'AD Types'
       ,p_hstf_type    => 'M'
       ,p_hstf_order   =>  4
        );

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

  -------------------------------
  -- REMOVE REDUNDANT HIG_MODULES
  -------------------------------
   
   PROCEDURE drop_module(pi_hmo_module IN hig_modules.hmo_module%TYPE) IS
   
   BEGIN
    
         DELETE FROM hig_module_keywords
         WHERE       hmk_hmo_module = pi_hmo_module;

         DELETE FROM gri_param_dependencies
         WHERE       gpd_module = pi_hmo_module;

         DELETE FROM gri_module_params
         WHERE       gmp_module = pi_hmo_module;         

         DELETE FROM gri_modules
         WHERE       grm_module = pi_hmo_module;
            
         DELETE FROM hig_module_roles
         WHERE       hmr_module = pi_hmo_module;

         DELETE FROM hig_modules
         WHERE       hmo_module = pi_hmo_module;

         DELETE FROM hig_standard_favourites
         WHERE       hstf_child = pi_hmo_module;

         DELETE FROM hig_user_favourites 
         WHERE       huf_child = pi_hmo_module;

         DELETE FROM hig_system_favourites 
         WHERE       hsf_child = pi_hmo_module;
   
   END drop_module;

BEGIN
  drop_module('NM0003');
  drop_module('NET2000');  
END;
/
--
-------------------------------------------------------------------------------------------------
--  
-- DC
-- Fix bug in 3110 where the ESU_ID_SEQ was associated with ne_unique
--
DELETE FROM hig_sequence_associations
WHERE hsa_column_name   = 'NE_UNIQUE'
AND   hsa_sequence_name = 'ESU_ID_SEQ'
/  
--
-------------------------------------------------------------------------------------------------
--
-- CN
-- Changes resulting from renaming of NM0570
--
UPDATE hig_modules
SET    hmo_title = 'Find Assets'
WHERE  hmo_module = 'NM0570'
/
UPDATE hig_standard_favourites
SET hstf_descr = 'Find Assets'
WHERE hstf_child = 'NM0570'
/
--
-------------------------------------------------------------------------------------------------
--  
-- JM
-- 699174
INSERT INTO nm_load_destinations
      (nld_id
      ,nld_table_name
      ,nld_table_short_name
      ,nld_insert_proc
      ,nld_validation_proc
      )
SELECT nld_id_seq.NEXTVAL
      ,'V_LOAD_POINT_INV_MEM_ON_ELE'
      ,'LIPE'
      ,'nm3inv_load.load_point_on_ele'
      ,'nm3inv_load.validate_point_on_ele'
 FROM  dual
WHERE  NOT EXISTS (SELECT 1
                    FROM  nm_load_destinations
                   WHERE  nld_table_name = 'V_LOAD_POINT_INV_MEM_ON_ELE'
                  )
/
INSERT INTO nm_load_destination_defaults
      (nldd_nld_id
      ,nldd_column_name
      ,nldd_value
      )
SELECT a.nld_id
      ,b.nldd_column_name
      ,b.nldd_value
 FROM  nm_load_destinations a
      ,nm_load_destinations c
      ,nm_load_destination_defaults b
WHERE  a.nld_table_name = 'V_LOAD_POINT_INV_MEM_ON_ELE'
 AND   c.nld_table_name = 'V_LOAD_INV_MEM_ON_ELEMENT'
 AND   c.nld_id         = b.nldd_nld_id
 AND   NOT EXISTS (SELECT 1
                    FROM  nm_load_destination_defaults d
                   WHERE  d.nldd_nld_id      = a.nld_id
                    AND   d.nldd_column_name = b.nldd_column_name
                  )
/
---------------------------------------------------------------------------------------------------
-- Start of AD Data Migration
---------------------------------------------------------------------------------------------------
DECLARE
   CURSOR next_nad_id
   IS
      SELECT nad_id_seq.NEXTVAL
        FROM dual;

   CURSOR c_ad_types
   IS
      SELECT ngit_ngt_group_type, ngit_nit_inv_type
        FROM nm_group_inv_types;

   CURSOR c1
   IS
      SELECT ngil.ngil_ne_ne_id ne_id, nel.ne_gty_group_type a,
             ngil.ngil_iit_ne_id iit_ne_id, iit.iit_inv_type b
        FROM nm_group_inv_link_all ngil, nm_elements nel, nm_inv_items iit
       WHERE ngil.ngil_ne_ne_id = nel.ne_id
         AND ngil.ngil_iit_ne_id = iit.iit_ne_id;

   CURSOR c2 (cp_inv_type IN VARCHAR2, cp_gty_type IN VARCHAR2)
   IS
      SELECT nad_id
        FROM nm_nw_ad_types
       WHERE nad_inv_type = cp_inv_type AND nad_gty_type = cp_gty_type;

   l_nad_id   PLS_INTEGER;
BEGIN
   -- AD Types
   FOR z IN c_ad_types
   LOOP
      OPEN next_nad_id;
      FETCH next_nad_id INTO l_nad_id;
      CLOSE next_nad_id;

      INSERT INTO nm_nw_ad_types
                  (nad_id, nad_inv_type,
                   nad_nt_type,
                   nad_gty_type,
                   nad_descr,
                   nad_start_date, nad_end_date, nad_primary_ad,
                   nad_display_order, nad_single_row, nad_mandatory
                  )
           VALUES (l_nad_id, z.ngit_nit_inv_type,
                   nm3net.get_gty_nt (z.ngit_ngt_group_type),
                   z.ngit_ngt_group_type,
                      UPPER (z.ngit_ngt_group_type)
                   || ' - '
                   || UPPER (z.ngit_nit_inv_type)
                   || ' AD Type',
                   nm3user.get_effective_date, NULL, 'Y',
                   1, 'Y', 'N'
                  );
   END LOOP;

   -- Links
   FOR i IN c1
   LOOP
      OPEN c2 (i.b, i.a);

      FETCH c2
       INTO l_nad_id;

      CLOSE c2;

      INSERT INTO nm_nw_ad_link
                  (nad_id, nad_iit_ne_id, nad_ne_id, nad_start_date
                  )
           VALUES (l_nad_id, i.iit_ne_id, i.ne_id, nm3user.get_effective_date
                  );
   END LOOP;
END;
/
---------------------------------------------------------------------------------------------------
-- AD Data Migration for post-migration folks
---------------------------------------------------------------------------------------------------
DECLARE
  TYPE l_cur IS REF CURSOR;
  
  no_mig_table EXCEPTION;
  PRAGMA EXCEPTION_INIT(no_mig_table, -00942);
  
  l_sql varchar2(2000) := 'SELECT nad_id_seq.NEXTVAL nad_id '||chr(10)|| 
                          '      ,nt_type '||chr(10)||
                          '      ,nt_descr '||chr(10)||
                          'FROM   nm_types '||chr(10)||
                          '      ,mig_dtp_local '||chr(10)||
                          'WHERE  nt_datum = ''Y'' '||chr(10)||
                          'AND    nt_type = rse_sys_flag';
  
  get_datum_types l_cur;
  l_nad        nm_nw_ad_types%ROWTYPE;
  l_start_date DATE := nm3get.get_hus(pi_hus_username => hig.get_application_owner).hus_start_date;
BEGIN
  
  OPEN get_datum_types FOR l_sql;
  LOOP
    FETCH get_datum_types INTO l_nad.nad_id
                              ,l_nad.nad_nt_type
                              ,l_nad.nad_descr;
                              
    EXIT WHEN get_datum_types%NOTFOUND;
    
    l_nad.nad_inv_type      := 'NETW';
    l_nad.nad_gty_type      := NULL;
    l_nad.nad_start_date    := l_start_date;
    l_nad.nad_end_date      := NULL;
    l_nad.nad_primary_ad    := 'Y';
    l_nad.nad_display_order := 1;
    l_nad.nad_single_row    := 'Y';
    l_nad.nad_mandatory     := 'Y';
    
    nm3ins.ins_nad(p_rec_nad => l_nad);
    
    -- now insert the types values
    
    nm3nwad.create_links_from_membs (pi_nad_id => l_nad.nad_id);
    
  END LOOP;
  
EXCEPTION
  WHEN no_mig_table THEN
    -- if tables dont exist just exit
    NULL;
END;
/

Insert into NM_INV_CATEGORY_MODULES
   (ICM_NIC_CATEGORY, ICM_HMO_MODULE, ICM_UPDATABLE)
 SELECT  'G', 'NM0105', 'Y'
 FROM dual
 WHERE NOT EXISTS (SELECT 1
                   FROM nm_inv_category_modules
                   WHERE ICM_NIC_CATEGORY = 'G'
                   AND   ICM_HMO_MODULE   = 'NM0105'
                   );
                   
Insert into NM_INV_CATEGORY_MODULES
   (ICM_NIC_CATEGORY, ICM_HMO_MODULE, ICM_UPDATABLE)
 SELECT 'G', 'NM0110', 'Y'
 FROM dual
 WHERE NOT EXISTS (SELECT 1
                   FROM nm_inv_category_modules
                   WHERE ICM_NIC_CATEGORY = 'G'
                   AND   ICM_HMO_MODULE   = 'NM0110'
                   );
 
Insert into NM_INV_CATEGORY_MODULES
   (ICM_NIC_CATEGORY, ICM_HMO_MODULE, ICM_UPDATABLE)
 SELECT 'G', 'NM0115', 'Y'
 FROM dual
 WHERE NOT EXISTS (SELECT 1
                   FROM nm_inv_category_modules
                   WHERE ICM_NIC_CATEGORY = 'G'
                   AND   ICM_HMO_MODULE   = 'NM0115'
                   );
---------------------------------------------------------------------------------------------------
-- End of AD Data Migration
---------------------------------------------------------------------------------------------------
---

-- JM 23-DEC_2004
-- I have written  a package called NM3JOB_LOAD (as the job
-- component is generic NM3 rather than STP) which will create a view and
-- package for each NM_OPERATION which will allow CSV loading (with full validation)
-- into the relevant tables......this metadata upgrade will need to be run as part of the 3.2 upgrade....
-- which will make the CSV loaded job operation data use the new procedures which have full validation.
--
UPDATE nm_load_destinations
 SET   nld_insert_proc     = 'nm3job_load.load_njc'
      ,nld_validation_proc = 'nm3job_load.validate_njc'
WHERE  nld_table_name      = 'NM_JOB_CONTROL'
/

--
-- new mapserver options from AR                       
--
INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WMSSERVER', 'URL to specify the WMS Data Source', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WMSSERVER')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WMSLAYERS', 'Layers to be retrieved from WMS Data Source', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WMSLAYERS')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WMSLYRNAME', 'Display name for WMS Layer in Layer Control Tool', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WMSLYRNAME')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WMSSVCNAME', 'Service Name to use for WMS Connector.', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WMSSVCNAME')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WMSIMGFMT', 'Image format for WMS Connector', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WMSIMGFMT')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WMSSERVER', 'HIG', 'WMS Server URL', 'URL to specify the WMS Data Source', '', 'VARCHAR2', 'Y' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSSERVER')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WMSLAYERS', 'HIG', 'WMS Layers', 'Layers to be retrieved from WMS Data Source', '', 'VARCHAR2', 'Y' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSLAYERS')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WMSLYRNAME', 'HIG', 'WMS Layer Name', 'Display name for WMS Layer in Layer Control Tool', '', 'VARCHAR2', 'Y' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSLYRNAME')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WMSSVCNAME', 'HIG', 'WMS Service Name', 'Service Name to use for WMS Connector.', '', 'VARCHAR2', 'Y' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSSVCNAME')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WMSIMGFMT', 'HIG', 'WMS Image Format', 'Image format for WMS Connector', '', 'VARCHAR2', 'Y' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WMSIMGFMT')
/                        


COMMIT;  


--
-- Ensure that any hig_user_options are also in the domain of USER_OPTIONS
--
INSERT INTO hig_codes
      (hco_domain
      ,hco_code
      ,hco_meaning
      ,hco_system
      )
SELECT hco_domain
      ,hco_code
      ,hco_meaning
      ,hco_system
 FROM (SELECT DISTINCT
              'USER_OPTIONS' hco_domain
             ,huo_id         hco_code
             ,huo_id         hco_meaning
             ,'N'            hco_system
        FROM  hig_user_options
      ) a
WHERE NOT EXISTS (SELECT 1
                   FROM  hig_codes b
                  WHERE  a.hco_domain = a.hco_domain
                   AND   a.hco_code   = b.hco_code
                 )
/

COMMIT;  


--
-- GJ 07-FEB-2005
-- Rename Traffic Manager Product
--
UPDATE hig_products
SET    hpr_product_name = 'Traffic Interface Manager'
WHERE  hpr_product = 'TM'
/
UPDATE hig_standard_favourites
SET    hstf_descr = 'traffic interface manager'
WHERE  hstf_parent = 'FAVOURITES'
AND    hstf_child = 'TM'
/
COMMIT;

--
-- Allow HTML_BASE product option to be mixed case
--
UPDATE hig_option_list
SET    hol_mixed_case = 'Y'
WHERE  hol_id = 'HTML_BASE'
AND    hol_mixed_case = 'N'
/
COMMIT;

-- 
-- AE : Change G Category to AD
--
UPDATE NM_INV_CATEGORIES
   SET NIC_DESCR = 'Additional Data Inventory'
   WHERE NIC_CATEGORY = 'G'
/
COMMIT
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************


 
