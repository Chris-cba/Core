
Declare
--
   l_exception exception;
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate ' Create table eb_exor_associations                 '||
                     ' (                                                 '||
                     ' eea_id                     Number                 '||  
                     ',eea_object_type            Number        Not Null '||  
                     ',eea_object_id              Number        Not Null '|| 
                     ',eea_feature_table_name     Varchar2(50)  Not Null '||
                     ',eea_feature_id             Varchar2(100) Not null  ) ';
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
   Execute Immediate ' Alter table eb_exor_associations  Add Constraint eea_pk primary key (eea_id) ';
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
   pragma      exception_init(l_exception,-02275);
--
Begin
--
   Execute Immediate ' Alter table eb_exor_associations add ( constraint eea_fk_dgt foreign key (eea_feature_table_name) references doc_gateways (dgt_table_name) '||
                     ' On delete cascade) ';
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
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate ' Create Index eea_ind1 on eb_exor_associations (eea_feature_table_name,eea_feature_id)  ';
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
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate ' Create Index eea_ind2 on eb_exor_associations (eea_object_type,eea_object_id)  ';
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
   Execute Immediate ' Alter table eb_exor_associations  Add Constraint eea_uk Unique (eea_object_id,eea_object_type,eea_feature_table_name,eea_feature_id)';
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
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate ' Create sequence eea_id_seq Increment by 1 Start with 1 NoCache ' ;
           
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
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate ' Create table dm_gateway_template_map              '||
                     ' (                                                 '||
                     ' dgtm_gateway_name Varchar(30)   Not Null              '||  
                     ',dgtm_template_id  Number        Not Null '||  
                     ',dgtm_seq          Number        Not Null   ) ';
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
   Execute Immediate ' Alter table dm_gateway_template_map  Add Constraint dm_pk primary key (dgtm_gateway_name,dgtm_template_id) ';
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
   Execute Immediate ' Alter table dm_gateway_template_map  Add Constraint dm_uk Unique (dgtm_gateway_name,dgtm_seq)';
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
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate           ' Create Table dm_attributes_map (           '||
                               ' dam_gateway_name     Varchar2(50) Not Null '||
                               ',dam_exor_column_name Varchar2(50) Not Null '||
                               ',dam_data_type        Varchar2(50) Not Null '||
                               ',dam_eb_char_id       Number       Not Null '||
                               ',dam_inv_type         Varchar2(10) )        ';
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
   Execute Immediate ' Alter table dm_attributes_map  Add Constraint dam_uk Unique (dam_gateway_name,dam_exor_column_name) ';
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
   pragma      exception_init(l_exception,-00955);
--
Begin
--
   Execute Immediate           ' Create Table dm_eb_exor_user_mappings(  '||
                               ' eeum_hus_user_id  Number Not Null       '||
                               ',eeum_person_id    Number Not null)      ';
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
   Execute Immediate ' Alter table dm_eb_exor_user_mappings Add Constraint eeum_uk Unique (eeum_hus_user_id,eeum_person_id) ';
--
Exception
  When l_exception Then
  null;
  When Others Then
  Raise ;
End ;
/
