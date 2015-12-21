CREATE OR REPLACE function get_passw_exp_date (p_user_name varchar2) return date is
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/GET_PASSW_EXP_DATE.fnc-arc   1.0   Dec 21 2015 17:17:34   Sarah.Williams  $
--       Module Name      : $Workfile:   get_passw_exp_date.fnc  $
--       Date into PVCS   : $Date:   Dec 21 2015 17:17:34  $
--       Date fetched Out : $Modtime:   Dec 21 2015 17:16:40  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Natalija Tretjakova
--
--   Database password expiry date
--
-----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
v_exp_date date;
begin
 SELECT expiry_date into v_exp_date
        FROM dba_users 
        WHERE username = p_user_name;
  return (v_exp_date);
exception  
when no_data_found then return (null);

end;
/
