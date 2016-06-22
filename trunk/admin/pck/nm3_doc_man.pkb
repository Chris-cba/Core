Create Or Replace Package Body nm3_doc_man
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3_doc_man.pkb-arc   3.7   Jun 22 2016 11:39:56   linesh.sorathia  $
--       Module Name      : $Workfile:   nm3_doc_man.pkb  $
--       Date into PVCS   : $Date:   Jun 22 2016 11:39:56  $
--       Date fetched Out : $Modtime:   Apr 27 2016 10:20:04  $
--       Version          : $Revision:   3.7  $
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
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.7  $';

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
Procedure check_docs(pi_gateway_name   In  Varchar2
                    ,pi_feature_key    In  Varchar2
                    ,po_icon_name      Out Varchar2) 
IS
--
   l_exists Varchar2(1);       
   l_cnt    INT ;
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
       po_icon_name     := 'nodocs' ;
       For i IN  (Select Gateway_Name 
                  From   V_Doc_Gateway_Resolve 
                  Where  Synonym_Name  = pi_gateway_name )
       Loop
           Execute Immediate ' Begin                                                    '||
                             ' :1 := docman_get_document_count ( ps_feature_id   => :2,  '||
                             '                            ps_gateway_name => :3   '||
                             '                         );'||
                             ' END ; ' Using Out l_cnt, pi_feature_key , i.Gateway_Name    ;
           If l_cnt > 0 
           Then 
               po_icon_name  := 'docs'; 
               Exit;
           End If ;        
       End Loop;
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
       Return hig.get_sysopt('eBAssoURL')||'tab/'||l_gateway_name||'/feature/'||l_feature_id||'?loadTab=DocumentsRelationshipTemplateId';
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
   Return hig.get_sysopt('eBAssoURL')||'Tab/'||pi_gateway_name||'/Feature/'||pi_feature_id||'?loadTab=DocumentsRelationshipTemplateId' ;
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
  EXECUTE IMMEDIATE 'BEGIN update_feature (:1,:2,:3,1) ; END ;' USING pi_gateway_name,pi_old_feature_id,pi_new_feature_id ;
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
   l_iit_rec          nm_inv_items%ROWTYPE;  
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
              l_eB_template_id  Number ;
              l_eB_doc_id       Number ;
              l_association_rec nm3_doc_man.g_association_rec;
              l_association_tab nm3_doc_man.g_association_tab := nm3_doc_man.g_association_tab(null);
              l_title           Varchar2(1000) ;
              l_scope_id        Number;
              Cursor c_scope_id (pi_admin_unit_id NUMBER)
              Is
              Select dasm_scope_id
              From   dm_admin_unit_scope_map
              Where  dasm_admin_unit_id = pi_admin_unit_id ; 
           --
           Begin
           -- 
             l_iit_rec := nm3get.get_iit(pi_iit_ne_id);
             l_title := 'Image of '||pi_inv_type||' '||TO_CHAR(pi_iit_ne_id)||' from Asset Surveyor ' ;
             --Get the eB scope id mapped to admin unit.
             Open  c_scope_id(l_iit_rec.iit_admin_unit);
             Fetch c_scope_id Into l_scope_id;
             Close c_scope_id;   
             l_scope_id := NVL(l_scope_id,1)  ;          

             l_eB_template_id  := hig.get_sysopt('MCPPHOTTEM');
             l_association_rec.featue_table_name := l_table_name ;
             l_association_rec.feature_id        := l_iit_ne_id ;
             l_association_tab(1)                := l_association_rec;
           
             create_document_and_assocs
             (pi_template_id      => l_eB_template_id
             ,pi_scope_id        => l_scope_id
             ,pi_prefix          => pi_photo
             ,pi_title           => l_title
             ,pi_remarks         => l_title
             ,pi_date_issued     => SYSDATE
             ,pi_association_tab => l_association_tab 
             ,pi_called_by       =>  1 
             ,po_document_id     => l_eB_doc_id) ;
                 
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
-----------------------------------------------------------------------------
PROCEDURE create_document_and_assocs(pi_template_id     In  Number
                                    ,pi_scope_id        In  Number
                                    ,pi_prefix          In  Varchar2
                                    ,pi_title           In  Varchar2
                                    ,pi_remarks         In  Varchar2
                                    ,pi_date_issued     In  Date
                                    ,pi_association_tab In  g_association_tab
                                    ,pi_called_by       In  Number
                                    ,po_document_id     Out Number)
Is
--
   l_eB_doc_id     Number ;
   l_association_rec nm3_doc_man.g_association_rec;  
   l_associations    Varchar2(1000); 
--
Begin
--
   l_associations := '<associations>' ;
   For i IN 1..pi_association_tab.Count
   Loop
       l_association_rec := pi_association_tab(i) ;
       l_associations := l_associations||'<association><gateway_name>'||l_association_rec.featue_table_name||'</gateway_name><feature_id>'||l_association_rec.feature_id||'</feature_id></association>';  
   End Loop; 
   l_associations := l_associations||'</associations>';

           EXECUTE IMMEDIATE ' BEGIN '||
                             ' docman_add_document(pi_template_id     => :1 '||
                             '                    ,pi_scope_id        => :2 '||
                             '                    ,ps_prefix          => :3 '||
                             '                    ,ps_title           => :4 '||
                             '                    ,ps_remarks         => :5 '||
                             '                    ,pdt_date_effective => :6 '||
                             '                    ,ps_associations    => :7 '||
                             '                    ,pi_called_by       =>  1 '||
                             '                    ,pi_doc_id          => :8) ;'||
                             ' END ; '
           USING pi_template_id,NVL(pi_scope_id,1), pi_prefix ,pi_title, pi_remarks, pi_date_issued, l_associations, OUT l_eB_doc_id;
   po_document_id := l_eB_doc_id;
--
End create_document_and_assocs;
--
End nm3_doc_man;
/