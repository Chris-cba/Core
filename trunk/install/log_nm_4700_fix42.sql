----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix42.sql-arc   1.1   Jun 22 2016 14:36:30   linesh.sorathia  $   
--       Module Name      : $Workfile:   log_nm_4700_fix42.sql  $ 
--       Date into PVCS   : $Date:   Jun 22 2016 14:36:30  $
--       Date fetched Out : $Modtime:   Jun 22 2016 14:26:46  $
--       Version     	  : $Revision:   1.1  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate ' CREATE TABLE dm_admin_unit_scope_map              '||
                     ' (                                                 '||
                     ' dasm_admin_unit_id NUMBER NOT NULL                '||  
                     ',dasm_scope_id      NUMBER NOT NULL                '||  
                     ',dasm_scope_name    NVARCHAR2(255) NOT NULL        )';
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/

Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-02260);
--
Begin
--
   Execute Immediate ' ALTER TABLE dm_admin_unit_scope_map ADD (Constraint dasm_pk PRIMARY KEY (dasm_admin_unit_id)) ';
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/

Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-02261);
--
Begin
--
   Execute Immediate ' ALTER TABLE dm_admin_unit_scope_map ADD (Constraint dasm_uk UNIQUE (dasm_scope_id)) ';
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/


Insert into hig_option_list (Select 'NEWDOCMAN','HIG','New Document Manager','If this is "Y" the documents are stored in eB else documents are stored in exor.','Y_OR_N','VARCHAR2','N','N',1 From dual 
Where Not Exists (Select 1 From hig_option_list
                  Where hol_id = 'NEWDOCMAN' ))
/

Insert into hig_option_values (Select 'NEWDOCMAN','N' From dual
                               Where Not Exists (Select 1 From hig_option_values 
                                                 Where  hov_id = 'NEWDOCMAN' ))
/

-- eB document assocation api url
Insert into hig_option_list (Select 'eBAssoURL','HIG','eB document assocation api url','eB document assocation api url',null,'VARCHAR2','Y','N',2000 From dual 
Where Not Exists (Select 1 From hig_option_list
                  Where hol_id = 'eBAssoURL' ))
/


Insert into hig_option_values (Select 'eBAssoURL','<AssetWise CONNECT Document Manager URL>' From dual
                               Where Not Exists (Select 1 From hig_option_values 
                                                 Where  hov_id = 'eBAssoURL'))
/

SET TERM ON 
PROMPT Compiling nm3_doc_man.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3_doc_man.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Compiling nm3_doc_man.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3_doc_man.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Compiling hig_nav.pkw
SET TERM OFF
--
SET FEEDBACK ON
start hig_nav.pkw
SET FEEDBACK OFF

Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-00955);
--
Begin
   Execute Immediate ' Create Public Synonym nm3_doc_man For nm3_doc_man ' ;
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/

Begin
   Execute Immediate ' GRANT EXECUTE ON NM3_DOC_MAN   TO public ' ;
End ;
/


BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix42.sql'
				,p_remarks        => 'NET 4700 FIX 42 (Build 1)'
				,p_to_version     => NULL
				);
	--
	COMMIT;
	--
EXCEPTION 
	WHEN OTHERS THEN
	--
		NULL;
	--
END;
/