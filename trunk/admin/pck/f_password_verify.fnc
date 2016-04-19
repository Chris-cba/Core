CREATE OR REPLACE FUNCTION f_password_verify
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/f_password_verify.fnc-arc   1.0   Apr 19 2016 09:35:00   Vikas.Mhetre  $
--       Module Name      : $Workfile:   f_password_verify.fnc  $
--       Date into PVCS   : $Date:   Apr 19 2016 09:35:00  $
--       Date fetched Out : $Modtime:   Apr 19 2016 09:33:54  $
--       Version          : $Revision:   1.0  $
--
-------------------------------------------------------------------------
--   Author : Vikas Mhetre.
--
-- Part of Exor Password Strength Validation framework, SYS owned
-- function to call exor_password_engine
--
------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--  
        (username      VARCHAR2,
         password      VARCHAR2,
         old_password  VARCHAR2) RETURN BOOLEAN IS
--
  lv_check BOOLEAN;
--
BEGIN
--  
  lv_check := SYS.exor_password_engine.f_verify(username, password, old_password);
  RETURN lv_check;
--
END f_password_verify;
/