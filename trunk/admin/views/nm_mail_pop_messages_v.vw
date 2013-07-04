CREATE OR REPLACE FORCE VIEW nm_mail_pop_messages_v AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
--
--
--   Author : Jonathan Mills
--
--   NM3 POP Mail view
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  NMPM_ID            ,
  NMPM_NMPS_ID       ,
  NMPM_DATE_CREATED  ,
  NMPM_DATE_MODIFIED ,
  NMPM_MODIFIED_BY   ,
  NMPM_CREATED_BY    ,
  NMPM_STATUS        ,
  NMPS_DESCRIPTION
 FROM   nm_mail_pop_messages, nm_mail_pop_servers
 WHERE nmpm_nmps_id = nmps_id
/
