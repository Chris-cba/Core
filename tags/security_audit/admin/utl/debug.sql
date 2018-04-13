--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/debug.sql-arc   2.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   debug.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
