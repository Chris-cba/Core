-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_nm_user_au_modes.vw	1.2 07/12/02
--       Module Name      : v_nm_user_au_modes.vw
--       Date into SCCS   : 02/07/12 12:04:10
--       Date fetched Out : 07/06/13 17:08:38
--       SCCS Version     : 1.2
--
--
--   Author : Kevin Angus
--
--   v_nm_user_au_modes view - shows all admin units for the current user
--                             and the access mode.
--
-----------------------------------------------------------------------------
--      Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW v_nm_user_au_modes AS
SELECT
  nag.nag_child_admin_unit                                        admin_unit,
  nm3ausec.get_au_mode(nua.nua_user_id, nag.nag_child_admin_unit) au_mode
FROM
  nm_user_aus     nua,
  nm_admin_groups nag
WHERE
  nua.nua_user_id = To_Number(Sys_Context('NM3CORE','USER_ID'))
AND
  nua.nua_admin_unit = nag.nag_parent_admin_unit;
