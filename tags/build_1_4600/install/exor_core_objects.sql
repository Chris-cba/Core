--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/exor_core_objects.sql-arc   3.5   Oct 03 2011 09:38:48   Steve.Cooper  $
--       Module Name      : $Workfile:   exor_core_objects.sql  $
--       Date into PVCS   : $Date:   Oct 03 2011 09:38:48  $
--       Date fetched Out : $Modtime:   Oct 03 2011 09:27:38  $
--       PVCS Version     : $Revision:   3.5  $
--
--------------------------------------------------------------------------------
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

