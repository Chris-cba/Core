DECLARE
 ex_no_bother EXCEPTION;
 pragma exception_init(ex_no_bother,-955);
BEGIN
 EXECUTE IMMEDIATE ('DROP VIEW nm_mail_pop_servers_v');
EXCEPTION
  WHEN ex_no_bother THEN 
   Null;
END; 
/

CREATE FORCE VIEW nm_mail_pop_servers_v AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_mail_pop_servers_v.vw	1.1 03/07/05
--       Module Name      : nm_mail_pop_servers_v.vw
--       Date into SCCS   : 05/03/07 23:49:14
--       Date fetched Out : 07/06/13 17:08:12
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   NM3 POP Mail view
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
        *
 FROM   nm_mail_pop_servers
/

