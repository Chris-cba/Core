Create Or Replace Package Body nm3_doc_man
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3_doc_man.pkb-arc   3.4   Sep 05 2014 14:46:56   Linesh.Sorathia  $
--       Module Name      : $Workfile:   nm3_doc_man.pkb  $
--       Date into PVCS   : $Date:   Sep 05 2014 14:46:56  $
--       Date fetched Out : $Modtime:   Sep 03 2014 11:06:58  $
--       Version          : $Revision:   3.4  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.4  $';

  g_package_name CONSTANT varchar2(30) := 'nm3_doc_man';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_documents(pi_gateway_name In  Varchar2
                       ,pi_feature_id   In  Varchar2
                       ,po_ref_out      Out Sys_Refcursor)
Is
Begin
--
   Open po_ref_out For  
   Select eea_object_id
   From   eb_exor_associations 
   Where  eea_feature_table_name  = pi_gateway_name
   And    eea_feature_id          = pi_feature_id ;           
--
End get_documents;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_associations(pi_document_id  In  Number
                          ,po_ref_out      Out Sys_Refcursor)
Is
Begin
--
   Open po_ref_out For  
   Select eea_feature_table_name,eea_feature_id
   From   eb_exor_associations 
   Where  eea_object_id   = pi_document_id
   And    eea_object_type =  3 ;    
--
End get_associations;
--
-----------------------------------------------------------------------------
--
FUNCTION check_associations_exists(pi_document_id  In  Number)
Return Boolean
Is
   l_count   Number ; 
   Cursor c_asso_exists
   IS
   Select Count(0)
   From   eb_exor_associations 
   Where  eea_object_id   = pi_document_id
   And    eea_object_type =  3 ;    
Begin
--
   Open  c_asso_exists;
   Fetch c_asso_exists Into l_count;
   Close c_asso_exists;
   If l_count > 0
   Then 
       Return True;
   Else
       Return False;
   End If ;
--
End check_associations_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION check_associations_exists(pi_document_id  In  Number
                                  ,pi_gateway_name In  Varchar2
                                  ,pi_feature_id   In  Varchar2)
Return Boolean
Is
   l_count   Number ; 
   Cursor c_asso_exists
   IS
   Select Count(0)
   From   eb_exor_associations 
   Where  eea_object_id          = pi_document_id
   And    eea_feature_table_name = pi_gateway_name
   And    eea_feature_id         = pi_feature_id
   And    eea_object_type        =  3 ;    
Begin
--
   Open  c_asso_exists;
   Fetch c_asso_exists Into l_count;
   Close c_asso_exists;
   If l_count > 0
   Then 
       Return True;
   Else
       Return False;
   End If ;
--
End check_associations_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION check_associations_exists(pi_gateway_name In  Varchar2
                                  ,pi_feature_id   In  Varchar2)
Return Boolean
Is
   l_count   Number ; 
   Cursor c_asso_exists
   IS
   Select Count(0)
   From   eb_exor_associations 
   Where  eea_feature_table_name = pi_gateway_name
   And    eea_feature_id         = pi_feature_id
   And    eea_object_type        =  3 ;    
Begin
--
   Open  c_asso_exists;
   Fetch c_asso_exists Into l_count;
   Close c_asso_exists;
   If l_count > 0
   Then 
       Return True;
   Else
       Return False;
   End If ;
--
End check_associations_exists;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_associations(pi_document_id  In  Number)
Is
Begin
--
   Delete From eb_exor_associations
   Where  eea_object_id   = pi_document_id
   And    eea_object_type = 3 ;
--
End delete_associations;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_associations(pi_gateway_name In  Varchar2
                             ,pi_feature_id   In  Varchar2)
Is
Begin
--
   Delete From eb_exor_associations
   Where  eea_feature_table_name = pi_gateway_name
   And    eea_feature_id         = pi_feature_id ;
--
End delete_associations;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_associations(pi_document_id  In  Number
                             ,pi_gateway_name In  Varchar2
                             ,pi_feature_id   In  Varchar2)
Is
Begin
--
   Delete From eb_exor_associations
   Where  eea_object_id          = pi_document_id
   And    eea_feature_table_name = pi_gateway_name
   And    eea_feature_id         = pi_feature_id ;
--
End delete_associations;
--
-----------------------------------------------------------------------------
--
PROCEDURE synchronise_document_id(pi_old_document_id  In  Number
                                 ,pi_new_document_id  In  Number)
Is
Begin
--
   Update eb_exor_associations 
   Set    eea_object_id   = pi_new_document_id
   Where  eea_object_id   = pi_old_document_id
   And    eea_object_type = 3 ;
--
End synchronise_document_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_association(pi_object_type  In Number
                            ,pi_object_id    In Number
                            ,pi_gateway_name In Varchar2
                            ,pi_feature_id   In Varchar2)
Is
   l_eea_rec eb_exor_associations%RowType;
   l_cnt           Number ;
--
Begin
--
   Select Count(0) 
   Into   l_cnt
   From   eb_exor_associations
         ,dm_attributes_map 
   Where  eea_object_type = 3
   And    eea_object_id= pi_object_id
   And    eea_feature_table_name = dam_gateway_name ;

   --Do not allow to associate the document which has attribute synchronised from exor feature.
   If l_cnt >  0
   Then       
       Raise_Application_Error(-20101,'This document can be associated to only one feature.');
   End if;            

   l_eea_rec.eea_object_type        := pi_object_type;
   l_eea_rec.eea_object_id          := pi_object_id ;
   l_eea_rec.eea_feature_table_name := pi_gateway_name;
   l_eea_rec.eea_feature_id         := pi_feature_id;
   --
   Select eea_id_seq.Nextval Into l_eea_rec.eea_id
   From dual;
   --
   Insert into eb_exor_associations Values l_eea_rec;
--
End create_association;
--
-----------------------------------------------------------------------------
--
FUNCTION get_additional_asso_details(pi_gateway_name In Varchar2)
Return Varchar2
Is
--
   l_gateway_name        doc_gateways.dgt_table_name%Type;
   l_association_details Varchar2(1000); 
   Cursor c_getways 
   Is
   Select Gateway_Name 
   From   V_Doc_Gateway_Resolve 
   Where  Synonym_Name  = pi_gateway_name ;  
--
Begin
--
   NM3USER.SET_EFFECTIVE_DATE(sysdate);
   If pi_gateway_name Is Null
   Then 
       Raise_Application_Error(-20048,'Gateway name is null');
   End If;
      
   Open  c_getways ;
   Fetch c_getways Into l_gateway_name;
   Close c_getways;   

   Execute Immediate 'Select dgt_table_descr From doc_gateways Where dgt_table_name = :1' 
   Into l_association_details Using l_gateway_name ;
   
   Return l_association_details;
--
End get_additional_asso_details;
--
-----------------------------------------------------------------------------
PROCEDURE create_document_and_assocs(pi_template_id     In  Number
                                    ,pi_prefix          In  Varchar2
                                    ,pi_title           In  Varchar2
                                    ,pi_remarks         In  Varchar2
                                    ,pi_date_issued     In  Date
                                    ,pi_association_tab In  g_association_tab
                                    ,po_document_id     Out Number)
Is
--
   l_document_id     Number ;
   l_association_rec g_association_rec ;
--
Begin
--
   Execute Immediate ' Begin '||
                     ' ebexor_add_document(pi_template_id     => :1 '||
                     '                    ,ps_prefix          => :2 '||
                     '                    ,ps_title           => :3 '||
                     '                    ,ps_remarks         => :4 '||
                     '                    ,pdt_date_effective => :5 '||
                     '                    ,pi_called_by       => 1  '||
                     '                    ,pi_doc_id          => :6 ); '||
                     ' End ; ' Using pi_template_id,pi_prefix,pi_title,pi_remarks,pi_date_issued,Out l_document_id ;
   For i In 1..pi_association_tab.Count
   Loop
       l_association_rec := pi_association_tab(i);     

       create_association(pi_object_type  => 3
                         ,pi_object_id    => l_document_id 
                         ,pi_gateway_name => l_association_rec.featue_table_name
                         ,pi_feature_id   => l_association_rec.feature_id);
   End Loop; 
   po_document_id := l_document_id;
--
End create_document_and_assocs;
--
-----------------------------------------------------------------------------
Procedure check_docs(pi_gateway_name   In  Varchar2
                    ,pi_feature_key    In  Varchar2
                    ,po_icon_name      Out Varchar2) 
IS
--
   l_exists Varchar2(1);   
   Cursor check_docs_new (c_rec_id varchar2) 
   Is
   Select 'x' From dual
   Where Exists (Select 'x' 
                 From   eb_exor_associations  
                 Where  eea_feature_id         = c_rec_id
                 And    eea_feature_table_name In (Select Gateway_Name 
                                                   From   V_Doc_Gateway_Resolve 
                                                   Where  Synonym_Name  = pi_gateway_name)
                 And    eea_object_type        = 3 ) ;  

   Cursor check_docs (c_rec_id varchar2) 
   Is
   Select 'x' From dual
   Where Exists (Select 'x' 
                 From   doc_assocs
                 Where  das_rec_id         = c_rec_id
                 And    das_table_name In (Select Gateway_Name 
                                           From   V_Doc_Gateway_Resolve 
                                           Where  Synonym_Name  = pi_gateway_name)) ;

   
--
Begin
--
   If hig.get_sysopt('NEWDOCMAN') = 'Y'
   Then
       Open check_docs_new( pi_feature_key);
       Fetch check_docs_new Into l_exists;
       If check_docs_new%found 
       Then
           po_icon_name     := 'docs'; 
       Else
           po_icon_name     := 'nodocs' ; 
       End if;
       Close check_docs_new;   
  Else
       Open check_docs( pi_feature_key);
       Fetch check_docs Into l_exists;
       If check_docs%found 
       Then
           po_icon_name     := 'docs'; 
       Else
           po_icon_name     := 'nodocs' ; 
       End if;
       Close check_docs;   
   End If ;   
--
End  ;
--
Procedure get_associations(pi_object_type  In Number
                          ,pi_gateway_name In Varchar2
                          ,pi_feature_id   In Varchar2
                          ,po_ref_out      Out sys_refcursor)
Is
--
Begin
--
   Open po_ref_out For
   Select  *
   From    eb_exor_associations
   Where   eea_feature_id         = pi_feature_id
   And     eea_feature_table_name In (Select Gateway_Name 
                                      From   V_Doc_Gateway_Resolve 
                                      Where   Synonym_Name  = pi_gateway_name)
   And     eea_object_type        = pi_object_type ;  
--
End get_associations;
--
Procedure get_docs(pi_gateway_name In Varchar2
                  ,pi_feature_id   In Varchar2
                  ,po_ref_out      Out sys_refcursor)
Is
--
Begin
--
   Open po_ref_out For
   Select eea_object_id,eea_feature_table_name ,eea_feature_id, Null Image
   From   eb_exor_associations 
   Where eea_feature_table_name In (Select Gateway_Name 
                                  From   V_Doc_Gateway_Resolve 
                                  Where   Synonym_Name  = pi_gateway_name)
   And eea_feature_id =  pi_feature_id;  
   Null;
--
End get_docs;
--
Procedure update_associations(pi_gateway_name   In Varchar2
                             ,pi_old_feature_id In Varchar2
                             ,pi_new_feature_id In Varchar2 )
Is
--
Begin
--
   Update eb_exor_associations
   Set    eea_feature_id         = pi_new_feature_id
   Where  eea_feature_id         = pi_old_feature_id
   And    eea_feature_table_name = pi_gateway_name   ;
--
End update_associations;
--

Function get_url_for_gis_session_id(pi_gdo_session_id In  Number)
Return Varchar2
Is
--
   l_gateway_name  doc_gateways.dgt_table_name%Type;
   l_count         Number ;     
   l_feature_id Varchar2(100) ;
   Cursor c_getways 
   Is
   Select Gateway_Name 
   From   V_Doc_Gateway_Resolve 
   Where  Synonym_Name  = (Select ntdv_gateway_table 
                           FROM   nm_theme_details_v ,
                                  gis_data_objects  
                           WHERE  ntdv_nth_theme_name = gdo_theme_name 
                           And    gdo_session_id      = pi_gdo_session_id );      
--
Begin
--
   Select Count(0) 
   Into   l_count
   From   gis_data_objects 
   Where  gdo_session_id = pi_gdo_session_id ;
   If l_count > 1
   Then
        Raise_Application_Error(-20400,'More than one feature has been selected.');     
   End If;
   Open  c_getways ;
   Fetch c_getways Into l_gateway_name;
   Close c_getways;   
   
   If l_gateway_name Is Not Null
   Then  
       Select gdo_pk_id
       Into   l_feature_id
       From   gis_data_objects 
       Where  gdo_session_id  = pi_gdo_session_id ;
       Return hig.get_sysopt('eBAssoURL')||chr(294)||'tab='||l_gateway_name||chr(294)||'featureid='||l_feature_id;
   Else
       Raise_Application_Error(-20401,'Gateway had not been setup');     
   End If ;
--
End get_url_for_gis_session_id;
--
FUNCTION get_eB_url(pi_gateway_name In Varchar2
                   ,pi_feature_id   In Varchar2)
Return Varchar2
Is
--
Begin
--
   If pi_gateway_name Is Null
   Or pi_feature_id   Is Null
   Then
       Raise_Application_Error(-20101,'Either gateway name or feature ID is null');  
   End If ;
   Return hig.get_sysopt('eBAssoURL')||chr(294)||'tab='||pi_gateway_name||chr(294)||'featureid='||pi_feature_id ;
--
End get_eB_url;
--
PROCEDURE update_feature_id(pi_gateway_name    In  Varchar2
                           ,pi_old_feature_id  In  Varchar2
                           ,pi_new_feature_id  In  Varchar2)
Is
--
Begin
--
   Update eb_exor_associations 
   Set    eea_feature_id          = pi_new_feature_id 
   Where  eea_feature_table_name  = pi_gateway_name
   And    eea_feature_id          = pi_old_feature_id ;
--
End update_feature_id;
--
PROCEDURE create_document_and_assocs(pi_iit_ne_id       In  nm_inv_items.iit_ne_id%Type
                                    ,pi_inv_type        In  nm_inv_types.nit_inv_type%Type
                                    ,pi_photo           In  Varchar2)
Is
--
   l_table_name       VARCHAR2(30);
   l_doc_id           docs.doc_id%TYPE;
   l_iit_ne_id        nm_inv_items.iit_ne_id%TYPE := pi_iit_ne_id;
   l_doc_file         VARCHAR2(2000);
   l_rec_dlo          doc_locations%ROWTYPE;
   l_nit              nm_inv_types%ROWTYPE;
--
Begin
--
   If pi_photo Is Not Null
   Then
       l_nit := nm3get.get_nit(pi_inv_type);
       l_table_name := l_nit.nit_table_name;
       IF l_table_name IS NULL 
       THEN
           l_table_name := 'NM_INV_ITEMS';
       END IF;
       DECLARE
         l_rec_dgs doc_gate_syns%ROWTYPE;
       BEGIN
       --
          SELECT * INTO l_rec_dgs FROM doc_gate_syns
          WHERE dgs_table_syn = l_table_name;
          IF l_rec_dgs.dgs_dgt_table_name IS NOT NULL
          THEN
              l_table_name := l_rec_dgs.dgs_dgt_table_name ;
          END IF;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN NULL;
       END;
       If hig.get_sysopt('NEWDOCMAN') = 'Y'
       Then
           Declare
              --
              l_association_rec nm3_doc_man.g_association_rec;
              l_association_tab nm3_doc_man.g_association_tab := nm3_doc_man.g_association_tab(null);
              l_eB_doc_id       Number ;
           --
           Begin
           -- 
              l_association_rec.featue_table_name := l_table_name;
              l_association_rec.feature_id        := l_iit_ne_id ;
              l_association_tab(1)                := l_association_rec;
           
              nm3_doc_man.create_document_and_assocs(pi_template_id     => hig.get_sysopt('MCPPHOTTEM') 
                                                    ,pi_prefix          => pi_photo
                                                    --,pi_title           => 'Image of '||l_nit_type||' '||TO_CHAR(pi_nm_inv_id)||' from MCP Batch '||TO_CHAR(pi_batch_no)
                                                    --,pi_remarks         => 'Image of '||l_nit_type||' '||TO_CHAR(pi_nm_inv_id)||' from MCP Batch '||TO_CHAR(pi_batch_no)
                                                    ,pi_title           => 'Image of '||pi_inv_type||' '||TO_CHAR(pi_iit_ne_id)||' from Asset Surveyor '
                                                    ,pi_remarks         => 'Image of '||pi_inv_type||' '||TO_CHAR(pi_iit_ne_id)||' from Asset Surveyor '
                                                    ,pi_date_issued     => SYSDATE
                                                    ,pi_association_tab => l_association_tab    
                                                    ,po_document_id     => l_eB_doc_id );       
                 
           End ;
     Else
         SELECT * INTO l_rec_dlo
         FROM doc_locations
         WHERE dlc_name = hig.get_user_or_sys_opt('MCPDLC');
   
         Select doc_id_seq.NEXTVAL Into l_doc_id 
         From dual;
         --
         INSERT INTO DOCS
         ( doc_id,
         doc_title,
         doc_dtp_code,
         doc_date_issued,
         doc_file,
         doc_dlc_dmd_id,
         doc_dlc_id,
         doc_reference_code,
         doc_descr )
         VALUES (
         l_doc_id,
     --    'Image of '||l_nit_type||' '||TO_CHAR(pi_iit_ne_id)||' from MCP Batch '||TO_CHAR(pi_batch_no),
         'Image of '||pi_inv_type||' '||TO_CHAR(pi_iit_ne_id)||' from Asset Surveyor ',
         'PHOT',
         SYSDATE,
         pi_photo,
         l_rec_dlo.dlc_dmd_id,--3, --location for photos
         l_rec_dlo.dlc_id,--1, --media
         l_doc_file,
     --    'Image of '||l_nit_type||' '||TO_CHAR(pi_nm_inv_id)||' from MCP Batch '||TO_CHAR(pi_batch_no)
         'Image of '||pi_inv_type||' '||TO_CHAR(pi_iit_ne_id)||' from Asset Surveyor '
         );
          
         INSERT INTO DOC_ASSOCS
         ( das_table_name, das_rec_id, das_doc_id)
         VALUES
         ( l_table_name, l_iit_ne_id, l_doc_id);
      End If ;
   End If ;
--
EXCEPTION
--
   WHEN NO_DATA_FOUND THEN NULL;
End create_document_and_assocs ;
--
PROCEDURE get_templates(pi_gateway_name In  Varchar2
                       ,po_ref_out      Out Sys_Refcursor)
Is
--
Begin
--
   Open po_ref_out For  
   Select dgtm_template_id
   From   dm_gateway_template_map
   Where  dgtm_gateway_name = pi_gateway_name
   Order by dgtm_seq ;
--
End get_templates;
--
FUNCTION get_default_template(pi_gateway_name In  Varchar2)
Return Number 
Is
--
   l_template_id Number := -1;
--
Begin
--
   Select dgtm_template_id Into l_template_id 
   From (Select * 
         From   dm_gateway_template_map
         Where  dgtm_gateway_name = pi_gateway_name
         Order By dgtm_seq)
   Where rownum = 1 ;
   Return l_template_id;
--
Exception 
--
   When no_data_found
   Then
       return -1; 
End get_default_template;
--
FUNCTION get_hig_user_id(pi_person_id In Number)
Return Number
Is
--
   l_hig_user_id hig_users.hus_user_id%TYPE;
--
Begin
--
   Select eeum_hus_user_id
   Into   l_hig_user_id
   From   dm_eb_exor_user_mappings
   Where  eeum_person_id  = pi_person_id ;

   Return l_hig_user_id;
--
Exception 
   When No_Data_Found
   Then 
       Return Null;
End ;
--
FUNCTION get_eb_person_id(pi_hig_user_id In hig_users.hus_user_id%TYPE)
Return Number
Is
--
   l_person_id Number;
--
Begin
--
   Select eeum_person_id
   Into   l_person_id
   From   dm_eb_exor_user_mappings
   Where  eeum_hus_user_id  = pi_hig_user_id ;
 
   Return l_person_id;
--
Exception 
   When No_Data_Found
   Then 
       Return Null;
End ;
--
PROCEDURE copy_attributes (pi_doc_id       In Number
                          ,pi_gateway_name In Varchar2
                          ,pi_feature_id   In Varchar2)
Is
   l_date_value     Date;
   l_char_value     Varchar2(4000);
   l_number_value   Number;
Begin
   For dam In (Select * From dm_attributes_map , doc_gateways 
               Where  dam_gateway_name = pi_gateway_name
               And    dam_gateway_name = dgt_table_name  
               )
   Loop
       If dam.dam_data_type = 'DATE'
       Then
           Execute Immediate 'Select '||dam.dam_exor_column_name ||' From '||pi_gateway_name||
                             ' Where '|| dam.dgt_pk_col_name || '= :1 '
           Into    l_date_value
           Using   pi_feature_id ;       
       ElsIf dam.dam_data_type = 'VARCHAR2'
       Then
           Execute Immediate 'Select '||dam.dam_exor_column_name||' From '||pi_gateway_name||' Where '|| dam.dgt_pk_col_name || '= :1 '
           Into    l_char_value
           Using   pi_feature_id ;       
       Else
            Execute Immediate 'Select '||dam.dam_exor_column_name||' From '||pi_gateway_name||' Where '|| dam.dgt_pk_col_name || '= :1 '
           Into    l_number_value
           Using   pi_feature_id ;       
       End If;        
       If dam.dam_data_type = 'DATE'
       Then
           Execute Immediate 'Begin ebp_set_char_data(:1,:2,Null,Null,:3,Null,1); End ;  '
           Using  pi_doc_id,dam.dam_eb_char_id,l_date_value;
       Elsif dam.dam_data_type = 'VARCHAR2'
       Then
           Execute Immediate 'Begin ebp_set_char_data(:1,:2,:3,Null,Null,Null,1); End ;  '
           Using  pi_doc_id ,dam.dam_eb_char_id,l_char_value ;
       Else 
           Execute Immediate 'Begin ebp_set_char_data(:1,:2,Null,:3,Null,Null,1); End ;  '
           Using  pi_doc_id ,dam.dam_eb_char_id,l_number_value ;
       End If ;       
   End Loop;   
End copy_attributes;
--
End nm3_doc_man;
/