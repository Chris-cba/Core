CREATE OR REPLACE VIEW V_NM_MSV_THEME_DEF
(VNMT_THEME_NAME, VNMT_BASE_TABLE, VNMT_GEOMETRY_COLUMN, VNMT_RULE_COLUMN, VNMT_RULE_STYLE, 
 VNMT_RULE_FEATURES, VNMT_RULE_LABEL_COLUMN, VNMT_RULE_LABEL_STYLE, VNMT_RULE_LABEL)
AS 
SELECT 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_msv_theme_def.vw	1.4 06/27/06
--       Module Name      : v_nm_msv_theme_def.vw
--       Date into SCCS   : 06/06/27 10:04:18
--       Date fetched Out : 07/06/13 17:08:36
--       SCCS Version     : 1.4
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
         name 
       , base_table 
       , geometry_column 
       , xmltype.getstringval(EXTRACT(VALUE(d),'/rule/@column'))          AS rule_column 
       , xmltype.getstringval(EXTRACT(VALUE(d),'/rule/features/@style'))  AS rule_style 
       , dbms_xmlgen.convert(xmltype.getstringval(EXTRACT(VALUE(d),'/rule/features/text()')),1)  AS rule_features 
       , xmltype.getstringval(EXTRACT(VALUE(d),'/rule/label/@column'))    AS rule_label_column 
       , xmltype.getstringval(EXTRACT(VALUE(d),'/rule/label/@style'))     AS rule_label_style 
       , xmltype.getstringval(EXTRACT(VALUE(d),'/rule/label/text()'))     AS rule_label 
 FROM user_sdo_themes m, 
      TABLE(xmlsequence(EXTRACT(XMLTYPE(m.styling_rules),'/styling_rules/rule'))) d
/
