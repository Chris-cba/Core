------------------------------------------------------------------
-- nm4500_nm4700_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4500_nm4700_ddl_upg.sql-arc   1.0   Aug 19 2013 17:36:48   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4500_nm4700_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Aug 19 2013 17:36:48  $
--       Date fetched Out : $Modtime:   Aug 19 2013 17:23:20  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------
SET TERM ON
PROMPT DDL Upgrade from 4.5 
SET TERM OFF

------------------------------------------------------------------
SET TERM ON
PROMPT New Sequence for read Only Forms.
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New Sequence to be used with passing parameters between ready only forms.
-- 
------------------------------------------------------------------
Declare
  Already_Exists Exception;
  Pragma Exception_Init (Already_Exists,-955); 
Begin
  Execute Immediate 'Create Sequence Hig_Router_Params_Seq Start With 1 Increment By 1  NOMAXVALUE NOMINVALUE NOCYCLE NOCACHE';
Exception 
  When Already_Exists Then
    Null;
End;
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Table for ready Only Forms.
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New Table to be used with passing parameters between ready only forms.
-- 
------------------------------------------------------------------
Drop Table Hig_Router_Params
/

Create Table Hig_Router_Params
(
Hrp_Router_Id             Number        Not Null,
Hrp_Param_Name            Varchar2(30)  Not Null,
Hrp_Param_Created         Date          Default Sysdate,
Hrp_Param_Value_Varchar   Varchar2(100),
Hrp_Param_Value_Date      Date,
Hrp_Param_Value_Number    Number,
Constraint Hig_Router_Params_pk Primary Key (Hrp_Router_Id,Hrp_Param_Name),
Constraint Hig_Router_Params_Mutual_Ex  Check ( 
                                                (   Hrp_Param_Value_Varchar   Is  Null  
                                                And Hrp_Param_Value_Number    Is  Null
                                                And Hrp_Param_Value_Date      Is  Not Null
                                                )
                                                Or
                                                (   Hrp_Param_Value_Varchar   Is  Null  
                                                And Hrp_Param_Value_Date      Is  Null
                                                And Hrp_Param_Value_Number    Is  Not Null
                                                )
                                                Or
                                                (   Hrp_Param_Value_Number    Is  Null  
                                                And Hrp_Param_Value_Date      Is  Null
                                                And Hrp_Param_Value_Varchar   Is  Not Null
                                                )
                                              )
)
Organization Index
/

Comment on Table Hig_Router_Params Is 'Used to hold the parameters of a routed forms call.'
/

Comment on Column Hig_Router_Params.Hrp_Router_Id Is 'The router id that identifies a forms session parameters.'
/

Comment on Column Hig_Router_Params.Hrp_Param_Created Is 'The Date the parameter was created.'
/

Comment on Column Hig_Router_Params.Hrp_Param_Name Is 'The Name of the parameter.'
/

Comment on Column Hig_Router_Params.Hrp_Param_Value_Varchar Is 'The Value of the parameter, if the parameter is a varchar2. mutually exclusive with Param_Value_Date and Param_Value_Number.'
/

Comment on Column Hig_Router_Params.Hrp_Param_Value_Date Is 'The Value of the parameter, if the parameter is a date. mutually exclusive with Param_Value_Varchar and Param_Value_Number.'
/

Comment on Column Hig_Router_Params.Hrp_Param_Value_Number Is 'The Value of the parameter, if the parameter is a number. mutually exclusive with Param_Value_Varchar and Param_Value_Date.'
/

Create Index Hig_Router_Params_Created_Idx On Hig_Router_Params(Hrp_Param_Created)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Tidy up of the extent data and constraints
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 111809
-- 
-- TASK DETAILS
-- The problem is possibly caused by SM creating faulty extents from route layers. The extent is a three tier hiearchy and APIs exist to remove any one of the three tiers of data. SM only plugs into two of the three APIs allowing the removal of the extent or the extent member datums. To minimise the problem, the extent hierarchy is now cascaded after the API so at least the top level can be cleaned out.
-- 
-- Prior to this fix, the foreign keys from extent members and extent member datums were disabled but on many cases inadvertently enabled on customer sites. The script executes a clean up - removing all orphan member and member datums before re-creating the foreign key with the cascade delete option.
-- 
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- This is intended to help the removal of faulty extents that have been created using SM with route layers. It does nto fix the immediate problem but provides a partial solution to help the user clean up faulty extents.
-- 
-- Ticket number 8001269723.
-- 
-- */
-- 
-- 
-- 
------------------------------------------------------------------
/* script to tidy-up extents */

alter table nm_saved_extent_member_datums
drop constraint nsd_nsm_fk;

alter table NM_SAVED_EXTENT_MEMBERS drop constraint nsu_nse_fk;

begin
  delete from nm_saved_extent_member_datums
  where not exists ( select 1 from nm_saved_extent_members  where nsm_id = nsd_nsm_id and nsm_nse_id = nsd_nse_id );
exception
  when no_data_found then null;
end;
/

begin
  delete from nm_saved_extent_member_datums
  where not exists ( select 1 from nm_saved_extents where nse_id = nsd_nse_id );
exception
  when no_data_found then null;
end;
/

begin
  delete from nm_saved_extent_members
  where not exists ( select 1 from nm_saved_extents where nse_id = nsm_nse_id );
exception
  when no_data_found then null;
end;
/

ALTER TABLE NM_SAVED_EXTENT_MEMBERS ADD 
CONSTRAINT nsu_nse_fk
FOREIGN KEY (NSM_NSE_ID)
REFERENCES NM_SAVED_EXTENTS (NSE_ID)
ON DELETE CASCADE
ENABLE
VALIDATE;

ALTER TABLE NM_SAVED_EXTENT_MEMBER_DATUMS ADD 
CONSTRAINT nsd_nsm_fk
FOREIGN KEY (NSD_NSE_ID, NSD_NSM_ID)
REFERENCES NM_SAVED_EXTENT_MEMBERS (NSM_NSE_ID, NSM_ID)
ON DELETE CASCADE
ENABLE
VALIDATE;

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Index Housekeeping
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Script to tidy up indexes and contraints on Mv_Highlight
-- 
------------------------------------------------------------------
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm4500_nm4700_ddl_upg.sql-arc   1.0   Aug 19 2013 17:36:48   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4500_nm4700_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Aug 19 2013 17:36:48  $
--       Date fetched Out : $Modtime:   Aug 19 2013 17:23:20  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--

PROMPT Drop the Primary Key constraint

Declare
  Ex_Not_Exists Exception;
  Pragma Exception_Init (Ex_Not_Exists,-02443);
Begin
  Execute Immediate 
    'Alter Table Mv_Highlight Drop Constraint Mv_Highlight_Pk';
Exception
  When Ex_Not_Exists Then Null;
End;
/

PROMPT Drop the Primary Key Index

Declare
  Index_Not_Exists Exception;
  Pragma Exception_Init (Index_Not_Exists,-01418);
Begin
  Execute Immediate 'Drop Index Mv_Highlight_PK';
Exception
  When  Index_Not_Exists Then
    Null;   
End;
/

PROMPT Create a non-unique index to replace it


Declare
  Index_Not_Exists Exception;
  Pragma Exception_Init (Index_Not_Exists,-01418);
Begin
  Execute Immediate 'Drop Index Mv_Ind1';
Exception
  When  Index_Not_Exists Then
    Null;   
End;
/

Declare
  Index_Not_Exists Exception;
  Pragma Exception_Init (Index_Not_Exists,-01418);
Begin
  Execute Immediate 'Drop Index Mv_Highlight_Ind';
Exception
  When  Index_Not_Exists Then
    Null;   
End;
/

Create Index Mv_Highlight_Ind On Mv_Highlight
(
Mv_Id,
Mv_Feat_Type
)
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hig_User, Execute Any Type
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Added to consolidate changes made in 4500 regarding the grant of execute any type.
-- 
------------------------------------------------------------------
Grant Execute Any Type  To Hig_User
/

Begin
  For x In  (
            Select  drp.Grantee
            From    Dba_Role_Privs    drp
            Where   drp.Granted_Role    =   'HIG_USER'
            And     Not Exists      (
                                    Select    Null     
                                    From      Dba_Sys_Privs   dsp
                                    Where     dsp.Privilege    Like   'EXECUTE ANY TYPE'
                                    And       dsp.Grantee      =     drp.Grantee
                                    )
            )
  Loop
    Execute Immediate 'Grant Execute Any Type to ' || x.Grantee;    
  End Loop;
End;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Nm_Admin_Extents
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Added new Table Nm_Admin_Extents
-- 
------------------------------------------------------------------
Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -00955);
Begin
Execute Immediate 
   'Create Table Nm_Admin_Extents '
   ||'  ( '
   ||' Nae_Admin_Unit    Number(9), '        
   ||' Nae_Extent        Sdo_Geometry, '
   ||'Constraint Nae_Pk Primary Key (Nae_Admin_Unit), '
   ||'Constraint Nae_Nau_Fk Foreign Key (Nae_Admin_Unit) References Nm_Admin_Units_All(Nau_Admin_Unit) On Delete Cascade '
   ||') '
   ||'Organization Index ';
Exception 
  When Ex_Exists Then Null;
End;  
/

Comment On Table Nm_Admin_Extents Is 'Used to hold the default extent per admin unit, for use with mapviewer.'
/

Comment On Column  Nm_Admin_Extents.Nae_Admin_Unit Is 'The admin unit for the extent.'
/

Comment On Column  Nm_Admin_Extents.Nae_Extent Is 'The default Extent for an admin unit.'
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Doc Gateways DDL enchancement
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Added extra constraints on to Doc gateway tables and tidied up some data.
-- 
------------------------------------------------------------------
Alter Table Doc_Gate_Syns  Disable Constraint Dgs_Fk_Dgt
/

Update  Doc_Gate_Syns
Set     Dgs_Dgt_Table_Name  =   Upper(Dgs_Dgt_Table_Name),
        Dgs_Table_Syn       =   Upper(Dgs_Table_Syn) 
/

Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -02264);
Begin
Execute Immediate 
  'Alter Table Doc_Gate_Syns '
  ||'Add Constraint Dgs_Table_Name_Upper Check (Dgs_Dgt_Table_Name = Upper(Dgs_Dgt_Table_Name)) ';
Exception 
  When Ex_Exists Then Null;
End;    
/

Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -02264);
Begin
Execute Immediate 
  'Alter Table Doc_Gate_Syns '
  ||'Add Constraint Dgs_Table_Syn_Upper Check (Dgs_Table_Syn = Upper(Dgs_Table_Syn)) ';
Exception 
  When Ex_Exists Then Null;
End;    
/

Declare
  Ex_Not_Exists Exception;
  Pragma Exception_Init (Ex_Not_Exists,-01418);
Begin
  Execute Immediate 'Drop Index Dgs_Ind1';
Exception
  When Ex_Not_Exists then Null;
End;
/

Declare
  Ex_Not_Exists Exception;
  Pragma Exception_Init (Ex_Not_Exists,-01418);
Begin
  Execute Immediate 'Drop Index Dgs_Fk_Dgt_Ind';
Exception
  When Ex_Not_Exists then Null;
End;
/

Prompt Doc Gate Syns - remove possible duplicates

Declare
  Cursor Dupl_DGS is
    Select Dgs_Table_Syn, irowid, count(*) from
    ( Select Dgs_Table_Syn, first_value(rowid) over (partition by Dgs_Table_Syn) Irowid
      from Doc_Gate_Syns )
  group by Dgs_Table_Syn, Irowid
  having count(*) > 1;
begin
  for irec in Dupl_DGS loop
    Delete from Doc_Gate_Syns
    where Dgs_Table_Syn = irec.Dgs_Table_Syn
    and rowid != irec.Irowid;
  end loop;
end;
/

Prompt Doc Gateways DDL enchancement - unique index and more constraints

Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -00955);
Begin
Execute Immediate 
   'Create Unique Index Dgs_UK1 On Doc_Gate_Syns(Dgs_Table_Syn)';
Exception 
  When Ex_Exists Then Null;
End;  
/

--Gateway Templates 
Alter Table Doc_Template_Gateways Disable Constraint Dtg_Fk_Dgt
/

Update  Doc_Template_Gateways
Set     Dtg_Table_Name  =  Upper(Dtg_Table_Name)
/

Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -02264);
Begin
Execute Immediate 
  'Alter Table Doc_Template_Gateways '
  ||'Add Constraint  Dtg_Table_Name_Upper Check (Dtg_Table_Name = Upper(Dtg_Table_Name)) ';
Exception 
  When Ex_Exists Then Null;
End;    
/

Prompt Doc Assocs

--Doc Assocs
Alter Table Doc_Assocs Disable Constraint Das_Fk_Dgt
/

Alter Trigger Doc_Assocs_B_Iu_Trg Disable
/

Update  Doc_Assocs
Set     Das_Table_Name = Upper(Das_Table_Name)
/

Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -02264);
Begin
Execute Immediate 
  'Alter Table Doc_Assocs '
  ||'Add Constraint Das_Table_Name_Upper Check (Das_Table_Name = Upper(Das_Table_Name)) ';
Exception 
  When Ex_Exists Then Null;
End;    
/
 
Update  Doc_Assocs
Set     Das_Table_Name = 'NM_INV_ITEMS'
Where   Das_Table_Name = 'NM_INV_ITEMS_ALL'
/

Alter Trigger Doc_Assocs_B_Iu_Trg Enable
/

--Gateways
Update Doc_Gateways
Set Dgt_Table_Name = Upper(Dgt_Table_Name)
/

Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -02264);
Begin
Execute Immediate 
  'Alter Table Doc_Gateways '
  ||'Add Constraint Dgt_Table_Name_Upper Check (Dgt_Table_Name = Upper(Dgt_Table_Name)) ';
Exception 
  When Ex_Exists Then Null;
End;    
/

Alter Table Doc_Gate_Syns  Enable Constraint Dgs_Fk_Dgt
/

Alter Table Doc_Template_Gateways Enable Constraint Dtg_Fk_Dgt
/

Alter Table Doc_Assocs Enable Constraint Das_Fk_Dgt
/

Begin
  For x In  (
            Select  dgs.Dgs_Dgt_Table_Name,
                    dgs.Dgs_Table_Syn
            From    Doc_Gate_Syns  dgs
            Where   dgs.Dgs_Dgt_Table_Name   =  'NM_INV_ITEMS_ALL'
            )
  Loop    
    Begin
      Update  Doc_Gate_Syns  dgs
      Set     dgs.Dgs_Dgt_Table_Name  =   'NM_INV_ITEMS'
      Where   dgs.Dgs_Dgt_Table_Name  =   x.Dgs_Dgt_Table_Name
      And     dgs.Dgs_Table_Syn       =   x.Dgs_Table_Syn;
    Exception
      When Dup_Val_On_Index Then        
        Delete
        From    Doc_Gate_Syns dgs
        Where   dgs.Dgs_Dgt_Table_Name    =   x.Dgs_Dgt_Table_Name
        And     dgs.Dgs_Table_Syn         =   x.Dgs_Table_Syn;
    End;
  End Loop;
End;
/

Delete 
From    Doc_Gate_Syns   dgs  
Where   dgs.Dgs_Dgt_Table_Name = dgs.Dgs_Table_Syn;
/

Declare
Ex_Exists Exception;
Pragma Exception_Init (Ex_Exists, -02264);
Begin
Execute Immediate 
  'Alter Table Doc_Gate_Syns '
  ||'Add Constraint Dgs_Table_Name_Syn_Diff Check (Dgs_Dgt_Table_Name <> Dgs_Table_Syn) ';
Exception 
  When Ex_Exists Then Null;
End;    
/

Delete From Doc_Template_Gateways Where Dtg_Table_Name =  'NM_INV_ITEMS_ALL'
/

Delete From Doc_Gateways Where Dgt_Table_Name = 'NM_INV_ITEMS_ALL'
/

Commit
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator Asset Labels
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- Added new table to support Navigato changes in its support for more generic specification of asset labels
-- 
------------------------------------------------------------------
CREATE TABLE hig_navigator_asset_labels (
hnal_inv_type      Varchar2(4)   NOT NULL,
hnal_hier_label_1  VARCHAR2(500) NOT NULL,
hnal_hier_label_2  VARCHAR2(500),
hnal_hier_label_3  VARCHAR2(500),
hnal_hier_label_4  VARCHAR2(500),
hnal_hier_label_5  VARCHAR2(500),
hnal_hier_label_6  VARCHAR2(500),
hnal_hier_label_7  VARCHAR2(500),
hnal_hier_label_8  VARCHAR2(500),
hnal_hier_label_9  VARCHAR2(500),
hnal_hier_label_10 VARCHAR2(500)
)
/


COMMENT ON TABLE hig_navigator_asset_labels IS 'This table allows configuring flexible attributes as Navigator labels for inventory assets.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_inv_type IS 'The asset type for which the navigator label can be configured.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_1 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_2 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_3 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_4 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_5 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_6 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_7 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_8 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_9 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/
COMMENT ON COLUMN hig_navigator_asset_labels.hnal_HIER_LABEL_10 IS 'Column name whose value will be displayed in the Navigator hierarchy. This column can be database column from the inventory table 
or database function.'
/

    
ALTER TABLE hig_navigator_asset_labels  ADD (CONSTRAINT hnal_pk PRIMARY KEY (hnal_inv_type))
/
 
ALTER TABLE hig_navigator_asset_labels   ADD (CONSTRAINT hnal_nit_fk FOREIGN KEY (hnal_inv_type) REFERENCES nm_inv_types_all (nit_inv_type) ON DELETE CASCADE)
/

------------------------------------------------------------------

SET TERM ON
PROMPT DDL Upgrade from 4.6 
SET TERM OFF

------------------------------------------------------------------
SET TERM ON
PROMPT DDL Upgrade to DOC_REDIR_PRIOR
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- Imported from NM_4600_fix2.sql
-- 
------------------------------------------------------------------
DECLARE
  --
  already_exists EXCEPTION;
  PRAGMA exception_init( already_exists,-01430); 
  --
  lv_top_admin_unit hig_admin_units.hau_admin_unit%TYPE;
  --
  PROCEDURE get_top_admin_unit
    IS
  BEGIN
    SELECT hau_admin_unit
      INTO lv_top_admin_unit
      FROM hig_admin_units
     WHERE hau_level = 1
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Cannot find the top admin unit.');
    WHEN others
     THEN RAISE;
  END;
BEGIN
  /*
  ||Add the Admin Unit Column.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior ADD(drp_admin_unit NUMBER(9))');
  /*
  ||Populate existing rows with the top Admin Unit;
  */
  get_top_admin_unit;
  --
  EXECUTE IMMEDIATE('UPDATE doc_redir_prior SET drp_admin_unit = :lv_top_admin_unit') USING lv_top_admin_unit;
  /*
  ||Make the column NOT NULL.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior MODIFY(drp_admin_unit NOT NULL)');
  /*
  ||Create FK for Admin Unit.
  */
  EXECUTE IMMEDIATE('CREATE INDEX drp_fk_nau_ind ON doc_redir_prior (drp_admin_unit)');
  EXECUTE IMMEDIATE('ALTER TABLE doc_redir_prior ADD (CONSTRAINT drp_fk_nau FOREIGN KEY (drp_admin_unit) REFERENCES nm_admin_units_all (nau_admin_unit))');
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT DDL Upgrade to DOC_STD_ACTIONS
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- Imported from NM_4600_fix2.sql
-- 
------------------------------------------------------------------
DECLARE
  --
  already_exists EXCEPTION;
  PRAGMA exception_init( already_exists,-01430); 
  --
  lv_top_admin_unit hig_admin_units.hau_admin_unit%TYPE;
  --
  PROCEDURE get_top_admin_unit
    IS
  BEGIN
    SELECT hau_admin_unit
      INTO lv_top_admin_unit
      FROM hig_admin_units
     WHERE hau_level = 1
         ;
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Cannot find the top admin unit.');
    WHEN others
     THEN RAISE;
  END;
BEGIN
  /*
  ||Add the Admin Unit Column.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_std_actions ADD(dsa_admin_unit NUMBER(9))');
  /*
  ||Populate existing rows with the top Admin Unit;
  */
  get_top_admin_unit;
  --
  EXECUTE IMMEDIATE('UPDATE doc_std_actions SET dsa_admin_unit = :lv_top_admin_unit') USING lv_top_admin_unit;
  /*
  ||Make the column NOT NULL.
  */
  EXECUTE IMMEDIATE('ALTER TABLE doc_std_actions MODIFY(dsa_admin_unit NOT NULL)');
  /*
  ||Rebuild the Unique Index.
  */
  EXECUTE IMMEDIATE('DROP INDEX dsa_ind1');
  EXECUTE IMMEDIATE('CREATE UNIQUE INDEX dsa_ind1 ON doc_std_actions (dsa_admin_unit, dsa_dtp_code, dsa_dcl_code, dsa_doc_status, dsa_doc_type, dsa_code)');
  /*
  ||Create FK for Admin Unit.
  */
  EXECUTE IMMEDIATE('CREATE INDEX dsa_fk_nau_ind ON doc_std_actions (dsa_admin_unit)');
  EXECUTE IMMEDIATE('ALTER TABLE doc_std_actions ADD (CONSTRAINT dsa_fk_nau FOREIGN KEY (dsa_admin_unit) REFERENCES nm_admin_units_all (nau_admin_unit))');
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT SDE Sub-layer exemptions
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- From nm3_4600_fix3 (supporting MCI changes)
-- 
------------------------------------------------------------------
declare
obj_exists exception;
pragma exception_init( obj_exists, -955);
begin
execute immediate ' CREATE TABLE NM_SDE_SUB_LAYER_EXEMPT '||
'( '||
'  NSSL_OBJECT_NAME  VARCHAR2(128),'||
'  NSSL_OBJECT_TYPE  VARCHAR2(19), '||
'  CONSTRAINT NSSL_PK'||
'  PRIMARY KEY'||
'  (NSSL_OBJECT_NAME, NSSL_OBJECT_TYPE)'||
'  ENABLE VALIDATE'||
')'||
'ORGANIZATION INDEX';
exception
  when obj_exists then
    NULL;
end;
/


begin
nm3ddl.create_synonym_for_object('NM_SDE_SUB_LAYER_EXEMPT');
end;
/

declare
obj_exists exception;
pragma exception_init( obj_exists, -2264);
begin
execute immediate 'ALTER TABLE NM_SDE_SUB_LAYER_EXEMPT ADD ( '||
'  CONSTRAINT NSSL_OBJ_NAME_UPP_CHK '||
'  CHECK (Nssl_Object_Name = Upper(Nssl_Object_Name)) '||
'  ENABLE VALIDATE, '||
'  CONSTRAINT NSSL_OBJ_TYPE_UPP_CHK '||
'  CHECK (Nssl_Object_Type = Upper(Nssl_Object_Type)) '||
'  ENABLE VALIDATE) ';
exception
  when obj_exists then
    NULL;
end;
/


------------------------------------------------------------------
SET TERM ON
PROMPT Bentley Select License table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- Table used for Bentley Select Licensing
-- 
------------------------------------------------------------------

declare
obj_exists exception;
pragma exception_init( obj_exists, -955);
begin
execute immediate ' CREATE TABLE BENTLEY_SELECT '||
'( '||
'   BS_PRODUCT_ID         INTEGER                      NOT NULL,'||
'   BS_PRODUCT_NAME  VARCHAR2(80)          NOT NULL, '||
'   BS_HPR_PRODUCT     VARCHAR2(6)            NOT NULL, '||
'  CONSTRAINT  BS_PK'||
'  PRIMARY KEY'||
'   (BS_HPR_PRODUCT, BS_PRODUCT_ID)'||
'  ENABLE VALIDATE'||
')'||
'ORGANIZATION INDEX';
exception
  when obj_exists then
    NULL;
end;
/


begin
nm3ddl.create_synonym_for_object('BENTLEY_SELECT');
end;
/


------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

