CREATE OR REPLACE FORCE VIEW hig_directories_v AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_directories_v.vw	1.1 08/31/05
--       Module Name      : hig_directories_v.vw
--       Date into SCCS   : 05/08/31 15:45:56
--       Date fetched Out : 07/06/13 17:08:01
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
-- List all hig_directories that actually exist as oracle directories
-- along with the read/write permission of the current user
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hdir.hdir_name
      ,hdir.hdir_path
      ,hdir.hdir_url
      ,hdir.hdir_comments
      ,hdir.hdir_protected
      ,hig_directories_api.directory_read_permission(hdir_name) hdir_read
      ,hig_directories_api.directory_write_permission(hdir_name) hdir_write
from hig_directories hdir
where hig_directories_api.directory_exists(hdir_name,hdir_path) = 'Y'
/

