--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_inv_types.vw-arc   2.2   Jul 04 2013 11:20:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_types.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:43:54  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
   l_view VARCHAR2(32767);
--
   CURSOR cs_enterprise_edn IS
   SELECT 'x'
    FROM  v$version
   WHERE  banner LIKE '%Enterprise Edition%'
    OR    banner LIKE '%Personal%';
--
   l_dummy cs_enterprise_edn%ROWTYPE;
--
   l_enterprise_edn BOOLEAN;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_view := l_view||p_text;
   END append;
--
   FUNCTION invsec_exists RETURN BOOLEAN IS
      l_retval BOOLEAN;
      l_dummy  number;
      CURSOR cs_invsec IS
      SELECT 1
       FROM  user_objects
      WHERE  object_name = 'INVSEC'
       AND   object_type = 'PACKAGE BODY';
   BEGIN
      OPEN  cs_invsec;
      FETCH cs_invsec INTO l_dummy;
      l_retval := cs_invsec%FOUND;
      CLOSE cs_invsec;
      RETURN l_retval;
   END invsec_exists;
BEGIN
--
   append ('CREATE OR replace force view nm_inv_types AS',FALSE);
   append ('SELECT');
   append ('--');
   append ('--   SCCS Identifiers :-');
   append ('--');
   append ('--       sccsid           : @(#)nm_inv_types.vw	1.7 03/24/05');
   append ('--       Module Name      : nm_inv_types.vw');
   append ('--       Date into SCCS   : 05/03/24 16:21:28');
   append ('--       Date fetched Out : 07/06/13 17:08:10');
   append ('--       SCCS Version     : 1.7');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('       *');
   append (' FROM  nm_inv_types_all');
   append ('WHERE  nit_start_date <= To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append (' AND   NVL(nit_end_date,TO_DATE('||CHR(39)||'99991231'||CHR(39)||','||CHR(39)||'YYYYMMDD'||CHR(39)||')) >  To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
--
   OPEN  cs_enterprise_edn;
   FETCH cs_enterprise_edn INTO l_dummy;
   l_enterprise_edn := cs_enterprise_edn%FOUND;
   CLOSE cs_enterprise_edn;
--
   EXECUTE IMMEDIATE l_view;
--
   IF NOT l_enterprise_edn
    AND invsec_exists
    THEN
      --
      -- If we are running on Standard Edn then put the restrictions which are normally
      --  sorted by the Policies into the views
      --
      append (' AND chk_inv_type_valid_for_role(nit_inv_type)!='||CHR(39)||'FALSE'||CHR(39));
      EXECUTE IMMEDIATE l_view;
   END IF;
--
END;
/
