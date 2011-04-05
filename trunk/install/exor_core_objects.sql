prompt Creating Exor_Core Objects

@@nm3ctx.pkh

@@nm3ctx.pkw

prompt Creating Application Context
   
Create Or Replace Context Nm3Sql Using Exor_Core.Nm3Ctx
/

prompt Creating Public Synonyms on Exor_Core Objects   

Create Or Replace Public Synonym Nm3Ctx For Exor_Core.Nm3Ctx
/

prompt Granting Privileges on Exor_Core Objects

Grant Execute On Exor_Core.Nm3Ctx To Public
/

