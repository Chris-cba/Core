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
