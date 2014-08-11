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


Insert into dm_attributes_map (Select 'DEFECTS', 'DEF_DATE_COMPL', 'DATE', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'DEFECTS'
                                                 And    dam_exor_column_name = 'DEF_DATE_COMPL'))
/


Insert into dm_attributes_map (Select 'DEFECTS', 'DEF_STATUS_CODE', 'VARCHAR2', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'DEFECTS'
                                                 And    dam_exor_column_name = 'DEF_STATUS_CODE'))
/
Insert into dm_attributes_map (Select 'DEFECTS', 'DEF_CREATED_DATE', 'DATE', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'DEFECTS'
                                                 And    dam_exor_column_name = 'DEF_CREATED_DATE'))
/
Insert into dm_attributes_map (Select 'DEFECTS', 'DEF_ARE_REPORT_ID', 'NUMBER', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'DEFECTS'
                                                 And    dam_exor_column_name = 'DEF_ARE_REPORT_ID'))
/
Insert into dm_attributes_map (Select 'WORK_ORDERS', 'WOR_DATE_CLOSED', 'DATE', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'WORK_ORDERS'
                                                 And    dam_exor_column_name = 'WOR_DATE_CLOSED'))
/
Insert into dm_attributes_map (Select 'WORK_ORDERS', 'WOR_DATE_RAISED', 'DATE', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'WORK_ORDERS'
                                                 And    dam_exor_column_name = 'WOR_DATE_RAISED'))
/
Insert into dm_attributes_map (Select 'DOCS2VIEW', 'DOC_COMPL_COMPLETE', 'DATE', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'DOCS2VIEW'
                                                 And    dam_exor_column_name = 'DOC_COMPL_COMPLETE'))
/
Insert into dm_attributes_map (Select 'DOCS2VIEW', 'DOC_DATE_ISSUED', 'DATE', 0, Null From dual 
                               Where Not Exists (Select 1 From dm_attributes_map 
                                                 Where  dam_gateway_name     = 'DOCS2VIEW'
                                                 And    dam_exor_column_name = 'DOC_DATE_ISSUED'))
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
   Execute Immediate ' GRANT EXECUTE ON NM3_DOC_MAN to public ' ;
   Execute Immediate ' Grant execute on WEB_USER_INFO to public ' ;
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
--

   hig2.upgrade(p_product        => 'HIG'
              ,p_upgrade_script => 'ha_doc_man_meta_data.sql'
              ,p_remarks        => '04.07.15.10'
              ,p_to_version     => Null); 
           
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/


