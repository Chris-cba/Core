--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/debug.sql-arc   2.1   Jul 04 2013 10:29:56   James.Wadsworth  $
--       Module Name      : $Workfile:   debug.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:21:22  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DROP table nm_dbug;
--
create table nm_dbug
   (nd_id         number                                                  not null
   ,nd_timestamp  date         DEFAULT sysdate                            not null
   ,nd_terminal   varchar2(30) DEFAULT sys_context('USERENV','TERMINAL')  not null
   ,nd_session_id NUMBER       DEFAULT sys_context('USERENV','SESSIONID') not null
   ,nd_level      NUMBER(1)                                               NOT NULL
   ,nd_text       varchar2(4000)
   ,CONSTRAINT nd_pk PRIMARY KEY (nd_id)
   );
--
DROP sequence nd_id_seq;
--
create sequence nd_id_seq;
--
