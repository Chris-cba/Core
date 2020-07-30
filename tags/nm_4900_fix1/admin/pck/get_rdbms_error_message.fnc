CREATE OR REPLACE FUNCTION get_rdbms_error_message( pn_ora_err IN NUMBER )
RETURN VARCHAR2
IS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/get_rdbms_error_message.fnc-arc   1.0   Jul 30 2020 08:08:30   Vikas.Mhetre  $
    --       Module Name      : $Workfile:   get_rdbms_error_message.fnc  $
    --       Date into PVCS   : $Date:   Jul 30 2020 08:08:30  $
    --       Date fetched Out : $Modtime:   Jul 30 2020 07:58:44  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : Vikas Mhetre
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
  lv_error_message VARCHAR2( 256 ) := NULL;
  ln_i             PLS_INTEGER;
  --
BEGIN
  --
  ln_i := UTL_LMS.GET_MESSAGE( pn_ora_err, 'rdbms', 'ora', 'en', lv_error_message );
  --
  RETURN lv_error_message;
  --
END get_rdbms_error_message;
/