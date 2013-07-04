PROMPT Create the Package Body HIG3
CREATE OR REPLACE PACKAGE BODY hig3 AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig3.pkb	1.1 03/01/01
--       Module Name      : hig3.pkb
--       Date into SCCS   : 01/03/01 16:22:43
--       Date fetched Out : 07/06/13 14:10:28
--       SCCS Version     : 1.1
--
--
--   Author :
--
--   hig3 package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  VARCHAR2(80) := '"@(#)hig3.pkb	1.1 03/01/01"';
--  g_body_sccsid is the SCCS ID for the package body
--
--all global package variables here
--
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
 ------------------------------------------------------------------------------------
  PROCEDURE product_usage
  ( p_product in hig_products.hpr_product%type,
    p_message out varchar2)
  IS

  l_check number := 0;
  l_count number := 0;
  l_user hig_users.hus_username%type := null;
  l_process varchar2(30) := null;
  err_string varchar2(2000) := null;

  cursor c1 is
     select paddr, username
       from v$session
      where audsid = userenv('sessionid');

  cursor c2 is
     select count(*)
       from v$session
      where paddr = l_process
        and module = p_product;

  cursor c3 is
     select count(*)
       from v$session v1
       where not exists
             (select 1 from v$session v2 where v2.audsid = userenv('sessionid')
              and v1.paddr = v2.paddr)
         and v1.module = p_product;

  begin

   l_check := 0;
   l_count := 0;
   l_user := null;
   l_process := null;

   open c1;
   fetch c1 into l_process, l_user;
   close c1;

   open c2;
   fetch c2 into l_check;
   close c2;

   if l_check = 0 then

      open c3;
      fetch c3 into l_count;
      close c3;

      insert into hig_pu
         (hpu_pid,
          hpu_name,
          hpu_product,
          hpu_start,
          hpu_current)
      values
         (l_process,
          l_user,
          p_product,
          sysdate,
          l_count + 1);

      commit;

   end if;

  exception
   when others then

    /* trap the error string */

       err_string := sqlerrm;

       p_message := err_string;

  end product_usage;


END hig3;
/
