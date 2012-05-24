--Gateway Synonyms
Alter Table Doc_Gate_Syns  Disable Constraint Dgs_Fk_Dgt
/

Update  Doc_Gate_Syns
Set     Dgs_Dgt_Table_Name  =   Upper(Dgs_Dgt_Table_Name),
        Dgs_Table_Syn       =   Upper(Dgs_Table_Syn) 
/

Alter Table Doc_Gate_Syns
Add Constraint Dgs_Table_Name_Upper Check (Dgs_Dgt_Table_Name = Upper(Dgs_Dgt_Table_Name))
/

Alter Table Doc_Gate_Syns
Add Constraint Dgs_Table_Syn_Upper Check (Dgs_Table_Syn = Upper(Dgs_Table_Syn))
/

Drop Index Dgs_Ind1
/

Drop Index Dgs_Fk_Dgt_Ind
/

Create Unique Index Dgs_UK1 On Doc_Gate_Syns(Dgs_Table_Syn)    
/

--Gateway Templates 
Alter Table Doc_Template_Gateways Disable Constraint Dtg_Fk_Dgt
/

Update  Doc_Template_Gateways
Set     Dtg_Table_Name  =  Upper(Dtg_Table_Name)
/

Alter Table Doc_Template_Gateways
Add Constraint Dtg_Table_Name_Upper Check (Dtg_Table_Name = Upper(Dtg_Table_Name))
/

--Doc Assocs
Alter Table Doc_Assocs Disable Constraint Das_Fk_Dgt
/

Alter Trigger Doc_Assocs_B_Iu_Trg Disable
/

Update  Doc_Assocs
Set     Das_Table_Name = Upper(Das_Table_Name)
/

Alter Table Doc_Assocs
Add Constraint Das_Table_Name_Upper Check (Das_Table_Name = Upper(Das_Table_Name))
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

Alter Table Doc_Gateways
Add Constraint Dgt_Table_Name_Upper Check (Dgt_Table_Name = Upper(Dgt_Table_Name))
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

Alter Table Doc_Gate_Syns
Add Constraint Dgs_Table_Name_Syn_Diff Check (Dgs_Dgt_Table_Name <> Dgs_Table_Syn)
/

Delete From Doc_Template_Gateways Where Dtg_Table_Name =  'NM_INV_ITEMS_ALL'
/

Delete From Doc_Gateways Where Dgt_Table_Name = 'NM_INV_ITEMS_ALL'
/

Commit
/

