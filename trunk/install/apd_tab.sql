--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/apd_tab.sql-arc   2.1   Jul 04 2013 13:44:58   James.Wadsworth  $
--       Module Name      : $Workfile:   apd_tab.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:44:58  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:55:56  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
define sccsid = '@(#)apd_tab.sql	1.1 09/05/01'
--
DROP TABLE apd_tab;
--
CREATE GLOBAL TEMPORARY TABLE apd_tab
   (id             NUMBER                               NOT NULL
   ,timestamp      DATE           DEFAULT SYSDATE       NOT NULL
   ,item_type      VARCHAR2(2000) DEFAULT 'UNSPECIFIED' NOT NULL
   ,text           VARCHAR2(4000)
   );
CREATE INDEX apd_tab_ix ON apd_tab (item_type);
--
COMMENT ON TABLE apd_tab IS 'Table used to store rows which will be spooled in order to produce APD';
--
DROP TABLE apd_dependencies;
--
CREATE GLOBAL TEMPORARY TABLE apd_dependencies
   (OWNER             VARCHAR2(30)       NOT NULL
   ,NAME              VARCHAR2(30)       NOT NULL
   ,TYPE              VARCHAR2(12)
   ,REFERENCED_OWNER  VARCHAR2(30)
   ,REFERENCED_NAME   VARCHAR2(64)
   ,REFERENCED_TYPE   VARCHAR2(12)
   );
CREATE INDEX apd_dependencies_ix ON apd_dependencies (OWNER,NAME);
--
COMMENT ON TABLE apd_dependencies IS 'Temporary table used to store a snapshot of all_dependencies for APD';
--
