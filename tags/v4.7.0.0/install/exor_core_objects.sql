--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/exor_core_objects.sql-arc   3.6   Jul 04 2013 13:45:14   James.Wadsworth  $
--       Module Name      : $Workfile:   exor_core_objects.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:59:34  $
--       PVCS Version     : $Revision:   3.6  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
prompt Creating Exor_Core Objects

@@nm3security.pkh

@@nm3security.pkw

@@nm3ctx.pkh

@@nm3ctx.pkw

@@nm3utils.pkh

@@nm3utils.pkw

prompt Creating Application Contexts
   
Create Or Replace Context Nm3Sql Using Exor_Core.Nm3Ctx
/

Create Or Replace Context Nm3_Security_Ctx Using Exor_Core.NM3Security
/

Create Or Replace Context Nm3Core Using Exor_Core.NM3ctx
/

prompt Creating Public Synonyms on Exor_Core Objects   

Create Or Replace Public Synonym Nm3Ctx For Exor_Core.Nm3Ctx
/

Create Or Replace Public Synonym NM3Security For Exor_Core.NM3Security
/

Create Or Replace Public Synonym Nm3Utils For Exor_Core.Nm3Utils
/

prompt Granting Privileges on Exor_Core Objects

Grant Execute On Exor_Core.Nm3Ctx To Public
/

Grant Execute on Exor_Core.NM3Security to Public
/

Grant Execute on Exor_Core.Nm3Utils to Public
/

