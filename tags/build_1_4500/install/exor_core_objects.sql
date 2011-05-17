--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/exor_core_objects.sql-arc   3.4   May 17 2011 13:56:56   Steve.Cooper  $
--       Module Name      : $Workfile:   exor_core_objects.sql  $
--       Date into PVCS   : $Date:   May 17 2011 13:56:56  $
--       Date fetched Out : $Modtime:   May 17 2011 13:53:06  $
--       PVCS Version     : $Revision:   3.4  $
--
--------------------------------------------------------------------------------
--
prompt Creating Exor_Core Objects

@@nm3security.pkh

@@nm3security.pkw

@@nm3ctx.pkh

@@nm3ctx.pkw

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

prompt Granting Privileges on Exor_Core Objects

Grant Execute On Exor_Core.Nm3Ctx To Public
/

Grant Execute on Exor_Core.NM3Security to Public
/

 

