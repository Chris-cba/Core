CREATE OR REPLACE FORCE VIEW hig_directories_write_v AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_directories_write_v.vw	1.1 08/31/05
--       Module Name      : hig_directories_write_v.vw
--       Date into SCCS   : 05/08/31 15:47:41
--       Date fetched Out : 07/06/13 17:08:01
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
-- List all hig_directories that actually exist as oracle directories
-- where the current user has write permission (granted via a role)
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
from hig_directories_v hdir
where hdir_write = 'Y'
/

