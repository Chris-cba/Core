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


Insert into hig_option_values (Select 'eBAssoURL','http://localhost/Documents/DocumentList.aspx?' From dual
                               Where Not Exists (Select 1 From hig_option_values 
                                                 Where  hov_id = 'eBAssoURL'))
/


Insert into hig_option_list (Select 'DEFPHOTTEM','HIG','eB Template Id for defects','eB template ID for creating documents for defects.',null,'NUMBER','N','N',2000 From dual 
Where Not Exists (Select 1 From hig_option_list
                  Where hol_id = 'DEFPHOTTEM' ))
/

Insert into hig_option_values (Select 'DEFPHOTTEM',1234 From dual
                               Where Not Exists (Select 1 From hig_option_values 
                                                 Where  hov_id = 'DEFPHOTTEM' ))
/


Insert into hig_option_list (Select 'COMMTEMPLA','HIG','eB Template Id for comments','eB template ID for creating commnets document.',null,'NUMBER','N','N',2000 From dual 
Where Not Exists (Select 1 From hig_option_list
                  Where hol_id = 'COMMTEMPLA' ))
/

Insert into hig_option_values (Select 'COMMTEMPLA',1234 From dual
                               Where Not Exists (Select 1 From hig_option_values 
                                                 Where  hov_id = 'COMMTEMPLA' ))
/


Insert into hig_option_list (Select 'MCPPHOTTEM','HIG','eB Template Id for MCP photos','eB template ID for creating documents for mapcapture photo.',null,'NUMBER','N','N',2000 From dual 
Where Not Exists (Select 1 From hig_option_list
                  Where hol_id = 'MCPPHOTTEM' ))
/

Insert into hig_option_values (Select 'MCPPHOTTEM',1234 From dual
                               Where Not Exists (Select 1 From hig_option_values 
                                                 Where  hov_id = 'MCPPHOTTEM' ))
/

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

Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-00955);
--
Begin
   Execute Immediate ' Create Public Synonym WEB_USER_INFO For WEB_USER_INFO ' ;
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

Begin
   Execute Immediate ' Grant execute ON WEB_USER_INFO TO public ' ;
End ;
/

Begin
--
   hig2.upgrade(p_product        => 'HIG'
              ,p_upgrade_script => 'ha_doc_man_meta_data.sql'
              ,p_remarks        => '04.07.15.18'
              ,p_to_version     => Null);            
--
End ;
/


