CREATE OR REPLACE TRIGGER NM_INV_ITEMS_ALL_AUD_BR_IU BEFORE
  INSERT OR UPDATE ON NM_INV_ITEMS_ALL FOR EACH row 
  FOLLOWS NM_INV_ITEMS_ALL_B_DT_TRG, 
          NM_INV_ITEMS_ALL_WHO DECLARE
    --
    --   SCCS Identifiers :-
    --
    --       pvcsid                     : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_inv_items_all_aud_br_iu.trg-arc   3.6   Mar 03 2015 09:27:32   Stephen.Sewell  $
    --       Module Name                : $Workfile:   nm_inv_items_all_aud_br_iu.trg  $
    --       Date into PVCS             : $Date:   Mar 03 2015 09:27:32  $
    --       Date fetched Out           : $Modtime:   Mar 03 2015 09:31:46  $
    --       PVCS Version               : $Revision:   3.6  $
    --
    --   table_name_AUD trigger
    --   Write old row into Audit Journal table for any update to this table
    --   Note That must be executed after trigger NM_INV_ITEMS_ALL_B_DT_TRG so
    --   update of IIT_START_DATE is allowed.
    --
    --   Trigger allows for 'M'odification and 'C'orrection rows which may 
    --   overlap in date as follows
    --
    --        01-OCT-14             31-OCT-14             30-NOV-14
    --    'M'   I---------------------II----------------------------...
    --    'C'            I----II------I                     I-------...
    --                                ^
    --                      Correction consolidated
    --                      into Modification at this date  
    --
    --    21-JAN-2015 S.J.Sewell. Included INSERT section to ensure IIT_AUDIT_TYPE is set to 'M'
    --                            and not left as NULL (default value on column doesn't apply if NULL
    --                            explicitly inserted).
    --    17-FEB-2015 S.J.Sewell. Suppress insertion of Journal row when update is requested but no
    --                            fields have been changed as happens when Global Asset Update is called.
    -----------------------------------------------------------------------------
    --    Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    l_old_iit_end_date   DATE;
    
  BEGIN

    IF inserting THEN
      --
      -- Ensure IIT_AUDIT_TYPE is NOT NULL.
      --
      :NEW.IIT_AUDIT_TYPE := nvl(:NEW.IIT_AUDIT_TYPE,'M');

    ELSIF updating THEN
      --
      -- Compare current value for IIT_AUDIT_TYPE against value held in
      -- Audit package and update if it differs.
      --
      if :NEW.IIT_AUDIT_TYPE <> nm3inv_item_aud.nii_audit_type
      THEN
        :NEW.IIT_AUDIT_TYPE := nm3inv_item_aud.nii_audit_type;
      end if;
      
      --
      -- Check if we are 'M'odifying or 'C'orrecting this row and
      -- the previous row and manage dates accordingly.
      --

      IF nvl(:NEW.IIT_AUDIT_TYPE,'M') = 'C' AND
         nvl(:OLD.IIT_AUDIT_TYPE,'M') = 'M'
      THEN
        --
        -- Don't set an end date as the 'M' row is still valid under
        -- most conditions.
        --
        :NEW.IIT_START_DATE  := trunc(SYSDATE);
        l_old_iit_end_date   := NULL;
      ELSE
        --
        -- Record requires start and end dates. Use date passed in
        -- if different to previous start date
        -- or trunc(SYSDATE).
        --
        if nvl(:NEW.IIT_START_DATE,SYSDATE) <> nvl(:OLD.IIT_START_DATE,SYSDATE)
        THEN
          l_old_iit_end_date   := nvl(:NEW.IIT_START_DATE, trunc(SYSDATE));
        ELSE
          l_old_iit_end_date   := trunc(SYSDATE);
        END IF;
        :NEW.IIT_START_DATE  := l_old_iit_end_date;
      END IF;

      IF nvl(:OLD.IIT_NE_ID,-1)<> nvl(:NEW.IIT_NE_ID,-1) OR
         nvl(:OLD.IIT_INV_TYPE,'??') <> nvl( :NEW.IIT_INV_TYPE,'??') OR
         nvl(:OLD.IIT_PRIMARY_KEY,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_PRIMARY_KEY,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         --nvl(:OLD.IIT_START_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_START_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_CREATED,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_CREATED,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         --nvl(:OLD.IIT_DATE_MODIFIED,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_MODIFIED,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_CREATED_BY,'??') <> nvl( :NEW.IIT_CREATED_BY,'??') OR
         nvl(:OLD.IIT_MODIFIED_BY,'??') <> nvl( :NEW.IIT_MODIFIED_BY,'??') OR
         nvl(:OLD.IIT_ADMIN_UNIT,-1) <> nvl( :NEW.IIT_ADMIN_UNIT,-1) OR
         nvl(:OLD.IIT_DESCR,'??') <> nvl( :NEW.IIT_DESCR,'??') OR
         --nvl(:OLD.IIT_END_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_END_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_FOREIGN_KEY,'??') <> nvl( :NEW.IIT_FOREIGN_KEY,'??') OR
         nvl(:OLD.IIT_LOCATED_BY,-1) <> nvl( :NEW.IIT_LOCATED_BY,-1) OR
         nvl(:OLD.IIT_POSITION,-1) <> nvl( :NEW.IIT_POSITION,-1) OR
         nvl(:OLD.IIT_X_COORD,-1) <> nvl( :NEW.IIT_X_COORD,-1) OR
         nvl(:OLD.IIT_Y_COORD,-1) <> nvl( :NEW.IIT_Y_COORD,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB16,-1) <> nvl( :NEW.IIT_NUM_ATTRIB16,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB17,-1) <> nvl( :NEW.IIT_NUM_ATTRIB17,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB18,-1) <> nvl( :NEW.IIT_NUM_ATTRIB18,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB19,-1) <> nvl( :NEW.IIT_NUM_ATTRIB19,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB20,-1) <> nvl( :NEW.IIT_NUM_ATTRIB20,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB21,-1) <> nvl( :NEW.IIT_NUM_ATTRIB21,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB22,-1) <> nvl( :NEW.IIT_NUM_ATTRIB22,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB23,-1) <> nvl( :NEW.IIT_NUM_ATTRIB23,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB24,-1) <> nvl( :NEW.IIT_NUM_ATTRIB24,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB25,-1) <> nvl( :NEW.IIT_NUM_ATTRIB25,-1) OR
         nvl(:OLD.IIT_CHR_ATTRIB26,'??') <> nvl( :NEW.IIT_CHR_ATTRIB26,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB27,'??') <> nvl( :NEW.IIT_CHR_ATTRIB27,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB28,'??') <> nvl( :NEW.IIT_CHR_ATTRIB28,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB29,'??') <> nvl( :NEW.IIT_CHR_ATTRIB29,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB30,'??') <> nvl( :NEW.IIT_CHR_ATTRIB30,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB31,'??') <> nvl( :NEW.IIT_CHR_ATTRIB31,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB32,'??') <> nvl( :NEW.IIT_CHR_ATTRIB32,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB33,'??') <> nvl( :NEW.IIT_CHR_ATTRIB33,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB34,'??') <> nvl( :NEW.IIT_CHR_ATTRIB34,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB35,'??') <> nvl( :NEW.IIT_CHR_ATTRIB35,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB36,'??') <> nvl( :NEW.IIT_CHR_ATTRIB36,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB37,'??') <> nvl( :NEW.IIT_CHR_ATTRIB37,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB38,'??') <> nvl( :NEW.IIT_CHR_ATTRIB38,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB39,'??') <> nvl( :NEW.IIT_CHR_ATTRIB39,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB40,'??') <> nvl( :NEW.IIT_CHR_ATTRIB40,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB41,'??') <> nvl( :NEW.IIT_CHR_ATTRIB41,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB42,'??') <> nvl( :NEW.IIT_CHR_ATTRIB42,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB43,'??') <> nvl( :NEW.IIT_CHR_ATTRIB43,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB44,'??') <> nvl( :NEW.IIT_CHR_ATTRIB44,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB45,'??') <> nvl( :NEW.IIT_CHR_ATTRIB45,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB46,'??') <> nvl( :NEW.IIT_CHR_ATTRIB46,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB47,'??') <> nvl( :NEW.IIT_CHR_ATTRIB47,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB48,'??') <> nvl( :NEW.IIT_CHR_ATTRIB48,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB49,'??') <> nvl( :NEW.IIT_CHR_ATTRIB49,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB50,'??') <> nvl( :NEW.IIT_CHR_ATTRIB50,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB51,'??') <> nvl( :NEW.IIT_CHR_ATTRIB51,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB52,'??') <> nvl( :NEW.IIT_CHR_ATTRIB52,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB53,'??') <> nvl( :NEW.IIT_CHR_ATTRIB53,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB54,'??') <> nvl( :NEW.IIT_CHR_ATTRIB54,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB55,'??') <> nvl( :NEW.IIT_CHR_ATTRIB55,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB56,'??') <> nvl( :NEW.IIT_CHR_ATTRIB56,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB57,'??') <> nvl( :NEW.IIT_CHR_ATTRIB57,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB58,'??') <> nvl( :NEW.IIT_CHR_ATTRIB58,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB59,'??') <> nvl( :NEW.IIT_CHR_ATTRIB59,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB60,'??') <> nvl( :NEW.IIT_CHR_ATTRIB60,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB61,'??') <> nvl( :NEW.IIT_CHR_ATTRIB61,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB62,'??') <> nvl( :NEW.IIT_CHR_ATTRIB62,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB63,'??') <> nvl( :NEW.IIT_CHR_ATTRIB63,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB64,'??') <> nvl( :NEW.IIT_CHR_ATTRIB64,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB65,'??') <> nvl( :NEW.IIT_CHR_ATTRIB65,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB66,'??') <> nvl( :NEW.IIT_CHR_ATTRIB66,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB67,'??') <> nvl( :NEW.IIT_CHR_ATTRIB67,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB68,'??') <> nvl( :NEW.IIT_CHR_ATTRIB68,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB69,'??') <> nvl( :NEW.IIT_CHR_ATTRIB69,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB70,'??') <> nvl( :NEW.IIT_CHR_ATTRIB70,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB71,'??') <> nvl( :NEW.IIT_CHR_ATTRIB71,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB72,'??') <> nvl( :NEW.IIT_CHR_ATTRIB72,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB73,'??') <> nvl( :NEW.IIT_CHR_ATTRIB73,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB74,'??') <> nvl( :NEW.IIT_CHR_ATTRIB74,'??') OR
         nvl(:OLD.IIT_CHR_ATTRIB75,'??') <> nvl( :NEW.IIT_CHR_ATTRIB75,'??') OR
         nvl(:OLD.IIT_NUM_ATTRIB76,-1) <> nvl( :NEW.IIT_NUM_ATTRIB76,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB77,-1) <> nvl( :NEW.IIT_NUM_ATTRIB77,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB78,-1) <> nvl( :NEW.IIT_NUM_ATTRIB78,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB79,-1) <> nvl( :NEW.IIT_NUM_ATTRIB79,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB80,-1) <> nvl( :NEW.IIT_NUM_ATTRIB80,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB81,-1) <> nvl( :NEW.IIT_NUM_ATTRIB81,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB82,-1) <> nvl( :NEW.IIT_NUM_ATTRIB82,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB83,-1) <> nvl( :NEW.IIT_NUM_ATTRIB83,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB84,-1) <> nvl( :NEW.IIT_NUM_ATTRIB84,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB85,-1) <> nvl( :NEW.IIT_NUM_ATTRIB85,-1) OR
         nvl(:OLD.IIT_DATE_ATTRIB86,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB86,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB87,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB87,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB88,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB88,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB89,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB89,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB90,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB90,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB91,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB91,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB92,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB92,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB93,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB93,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB94,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB94,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_DATE_ATTRIB95,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_DATE_ATTRIB95,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_ANGLE,-1) <> nvl( :NEW.IIT_ANGLE,-1) OR
         nvl(:OLD.IIT_ANGLE_TXT,'??') <> nvl( :NEW.IIT_ANGLE_TXT,'??') OR
         nvl(:OLD.IIT_CLASS,'??') <> nvl( :NEW.IIT_CLASS,'??') OR
         nvl(:OLD.IIT_CLASS_TXT,'??') <> nvl( :NEW.IIT_CLASS_TXT,'??') OR
         nvl(:OLD.IIT_COLOUR,'??') <> nvl( :NEW.IIT_COLOUR,'??') OR
         nvl(:OLD.IIT_COLOUR_TXT,'??') <> nvl( :NEW.IIT_COLOUR_TXT,'??') OR
         nvl(:OLD.IIT_COORD_FLAG,'??') <> nvl( :NEW.IIT_COORD_FLAG,'??') OR
         nvl(:OLD.IIT_DESCRIPTION,'??') <> nvl( :NEW.IIT_DESCRIPTION,'??') OR
         nvl(:OLD.IIT_DIAGRAM,'??') <> nvl( :NEW.IIT_DIAGRAM,'??') OR
         nvl(:OLD.IIT_DISTANCE,-1) <> nvl( :NEW.IIT_DISTANCE,-1) OR
         nvl(:OLD.IIT_END_CHAIN,-1) <> nvl( :NEW.IIT_END_CHAIN,-1) OR
         nvl(:OLD.IIT_GAP,-1) <> nvl( :NEW.IIT_GAP,-1) OR
         nvl(:OLD.IIT_HEIGHT,-1) <> nvl( :NEW.IIT_HEIGHT,-1) OR
         nvl(:OLD.IIT_HEIGHT_2,-1) <> nvl( :NEW.IIT_HEIGHT_2,-1) OR
         nvl(:OLD.IIT_ID_CODE,'??') <> nvl( :NEW.IIT_ID_CODE,'??') OR
         nvl(:OLD.IIT_INSTAL_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_INSTAL_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_INVENT_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_INVENT_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_INV_OWNERSHIP,'??') <> nvl( :NEW.IIT_INV_OWNERSHIP,'??') OR
         nvl(:OLD.IIT_ITEMCODE,'??') <> nvl( :NEW.IIT_ITEMCODE,'??') OR
         nvl(:OLD.IIT_LCO_LAMP_CONFIG_ID,-1) <> nvl( :NEW.IIT_LCO_LAMP_CONFIG_ID,-1) OR
         nvl(:OLD.IIT_LENGTH,-1) <> nvl( :NEW.IIT_LENGTH,-1) OR
         nvl(:OLD.IIT_MATERIAL,'??') <> nvl( :NEW.IIT_MATERIAL,'??') OR
         nvl(:OLD.IIT_MATERIAL_TXT,'??') <> nvl( :NEW.IIT_MATERIAL_TXT,'??') OR
         nvl(:OLD.IIT_METHOD,'??') <> nvl( :NEW.IIT_METHOD,'??') OR
         nvl(:OLD.IIT_METHOD_TXT,'??') <> nvl( :NEW.IIT_METHOD_TXT,'??') OR
         nvl(:OLD.IIT_NOTE,'??') <> nvl( :NEW.IIT_NOTE,'??') OR
         nvl(:OLD.IIT_NO_OF_UNITS,-1) <> nvl( :NEW.IIT_NO_OF_UNITS,-1) OR
         nvl(:OLD.IIT_OPTIONS,'??') <> nvl( :NEW.IIT_OPTIONS,'??') OR
         nvl(:OLD.IIT_OPTIONS_TXT,'??') <> nvl( :NEW.IIT_OPTIONS_TXT,'??') OR
         nvl(:OLD.IIT_OUN_ORG_ID_ELEC_BOARD,-1) <> nvl( :NEW.IIT_OUN_ORG_ID_ELEC_BOARD,-1) OR
         nvl(:OLD.IIT_OWNER,'??') <> nvl( :NEW.IIT_OWNER,'??') OR
         nvl(:OLD.IIT_OWNER_TXT,'??') <> nvl( :NEW.IIT_OWNER_TXT,'??') OR
         nvl(:OLD.IIT_PEO_INVENT_BY_ID,-1) <> nvl( :NEW.IIT_PEO_INVENT_BY_ID,-1) OR
         nvl(:OLD.IIT_PHOTO,'??') <> nvl( :NEW.IIT_PHOTO,'??') OR
         nvl(:OLD.IIT_POWER,-1) <> nvl( :NEW.IIT_POWER,-1) OR
         nvl(:OLD.IIT_PROV_FLAG,'??') <> nvl( :NEW.IIT_PROV_FLAG,'??') OR
         nvl(:OLD.IIT_REV_BY,'??') <> nvl( :NEW.IIT_REV_BY,'??') OR
         nvl(:OLD.IIT_REV_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_REV_DATE,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_TYPE,'??') <> nvl( :NEW.IIT_TYPE,'??') OR
         nvl(:OLD.IIT_TYPE_TXT,'??') <> nvl( :NEW.IIT_TYPE_TXT,'??') OR
         nvl(:OLD.IIT_WIDTH,-1) <> nvl( :NEW.IIT_WIDTH,-1) OR
         nvl(:OLD.IIT_XTRA_CHAR_1,'??') <> nvl( :NEW.IIT_XTRA_CHAR_1,'??') OR
         nvl(:OLD.IIT_XTRA_DATE_1,to_date('01-JAN-1900','DD-MON-YYYY')) <> nvl( :NEW.IIT_XTRA_DATE_1,to_date('01-JAN-1900','DD-MON-YYYY')) OR
         nvl(:OLD.IIT_XTRA_DOMAIN_1,'??') <> nvl( :NEW.IIT_XTRA_DOMAIN_1,'??') OR
         nvl(:OLD.IIT_XTRA_DOMAIN_TXT_1,'??') <> nvl( :NEW.IIT_XTRA_DOMAIN_TXT_1,'??') OR
         nvl(:OLD.IIT_XTRA_NUMBER_1,-1) <> nvl( :NEW.IIT_XTRA_NUMBER_1,-1) OR
         nvl(:OLD.IIT_X_SECT,'??') <> nvl( :NEW.IIT_X_SECT,'??') OR
         nvl(:OLD.IIT_DET_XSP,'??') <> nvl( :NEW.IIT_DET_XSP,'??') OR
         nvl(:OLD.IIT_OFFSET,-1) <> nvl( :NEW.IIT_OFFSET,-1) OR
         nvl(:OLD.IIT_X,-1) <> nvl( :NEW.IIT_X,-1) OR
         nvl(:OLD.IIT_Y,-1) <> nvl( :NEW.IIT_Y,-1) OR
         nvl(:OLD.IIT_Z,-1) <> nvl( :NEW.IIT_Z,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB96,-1) <> nvl( :NEW.IIT_NUM_ATTRIB96,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB97,-1) <> nvl( :NEW.IIT_NUM_ATTRIB97,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB98,-1) <> nvl( :NEW.IIT_NUM_ATTRIB98,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB99,-1) <> nvl( :NEW.IIT_NUM_ATTRIB99,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB100,-1) <> nvl( :NEW.IIT_NUM_ATTRIB100,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB101,-1) <> nvl( :NEW.IIT_NUM_ATTRIB101,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB102,-1) <> nvl( :NEW.IIT_NUM_ATTRIB102,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB103,-1) <> nvl( :NEW.IIT_NUM_ATTRIB103,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB104,-1) <> nvl( :NEW.IIT_NUM_ATTRIB104,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB105,-1) <> nvl( :NEW.IIT_NUM_ATTRIB105,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB106,-1) <> nvl( :NEW.IIT_NUM_ATTRIB106,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB107,-1) <> nvl( :NEW.IIT_NUM_ATTRIB107,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB108,-1) <> nvl( :NEW.IIT_NUM_ATTRIB108,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB109,-1) <> nvl( :NEW.IIT_NUM_ATTRIB109,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB110,-1) <> nvl( :NEW.IIT_NUM_ATTRIB110,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB111,-1) <> nvl( :NEW.IIT_NUM_ATTRIB111,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB112,-1) <> nvl( :NEW.IIT_NUM_ATTRIB112,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB113,-1) <> nvl( :NEW.IIT_NUM_ATTRIB113,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB114,-1) <> nvl( :NEW.IIT_NUM_ATTRIB114,-1) OR
         nvl(:OLD.IIT_NUM_ATTRIB115,-1) <> nvl( :NEW.IIT_NUM_ATTRIB115,-1)
      THEN
        --
        -- Record has changed so should be updated.
        -- Note that as IIT_DATE_MODIFIED is changed by
        -- trigger this is excluded from this test (it would always
        -- return TRUE).
        --       
        INSERT
        INTO nm_inv_items_all_j
          (
          IIT_NE_ID,
          IIT_INV_TYPE,
          IIT_PRIMARY_KEY,
          IIT_START_DATE,
          IIT_DATE_CREATED,
          IIT_DATE_MODIFIED,
          IIT_CREATED_BY,
          IIT_MODIFIED_BY,
          IIT_ADMIN_UNIT,
          IIT_DESCR,
          IIT_END_DATE,
          IIT_FOREIGN_KEY,
          IIT_LOCATED_BY,
          IIT_POSITION,
          IIT_X_COORD,
          IIT_Y_COORD,
          IIT_NUM_ATTRIB16,
          IIT_NUM_ATTRIB17,
          IIT_NUM_ATTRIB18,
          IIT_NUM_ATTRIB19,
          IIT_NUM_ATTRIB20,
          IIT_NUM_ATTRIB21,
          IIT_NUM_ATTRIB22,
          IIT_NUM_ATTRIB23,
          IIT_NUM_ATTRIB24,
          IIT_NUM_ATTRIB25,
          IIT_CHR_ATTRIB26,
          IIT_CHR_ATTRIB27,
          IIT_CHR_ATTRIB28,
          IIT_CHR_ATTRIB29,
          IIT_CHR_ATTRIB30,
          IIT_CHR_ATTRIB31,
          IIT_CHR_ATTRIB32,
          IIT_CHR_ATTRIB33,
          IIT_CHR_ATTRIB34,
          IIT_CHR_ATTRIB35,
          IIT_CHR_ATTRIB36,
          IIT_CHR_ATTRIB37,
          IIT_CHR_ATTRIB38,
          IIT_CHR_ATTRIB39,
          IIT_CHR_ATTRIB40,
          IIT_CHR_ATTRIB41,
          IIT_CHR_ATTRIB42,
          IIT_CHR_ATTRIB43,
          IIT_CHR_ATTRIB44,
          IIT_CHR_ATTRIB45,
          IIT_CHR_ATTRIB46,
          IIT_CHR_ATTRIB47,
          IIT_CHR_ATTRIB48,
          IIT_CHR_ATTRIB49,
          IIT_CHR_ATTRIB50,
          IIT_CHR_ATTRIB51,
          IIT_CHR_ATTRIB52,
          IIT_CHR_ATTRIB53,
          IIT_CHR_ATTRIB54,
          IIT_CHR_ATTRIB55,
          IIT_CHR_ATTRIB56,
          IIT_CHR_ATTRIB57,
          IIT_CHR_ATTRIB58,
          IIT_CHR_ATTRIB59,
          IIT_CHR_ATTRIB60,
          IIT_CHR_ATTRIB61,
          IIT_CHR_ATTRIB62,
          IIT_CHR_ATTRIB63,
          IIT_CHR_ATTRIB64,
          IIT_CHR_ATTRIB65,
          IIT_CHR_ATTRIB66,
          IIT_CHR_ATTRIB67,
          IIT_CHR_ATTRIB68,
          IIT_CHR_ATTRIB69,
          IIT_CHR_ATTRIB70,
          IIT_CHR_ATTRIB71,
          IIT_CHR_ATTRIB72,
          IIT_CHR_ATTRIB73,
          IIT_CHR_ATTRIB74,
          IIT_CHR_ATTRIB75,
          IIT_NUM_ATTRIB76,
          IIT_NUM_ATTRIB77,
          IIT_NUM_ATTRIB78,
          IIT_NUM_ATTRIB79,
          IIT_NUM_ATTRIB80,
          IIT_NUM_ATTRIB81,
          IIT_NUM_ATTRIB82,
          IIT_NUM_ATTRIB83,
          IIT_NUM_ATTRIB84,
          IIT_NUM_ATTRIB85,
          IIT_DATE_ATTRIB86,
          IIT_DATE_ATTRIB87,
          IIT_DATE_ATTRIB88,
          IIT_DATE_ATTRIB89,
          IIT_DATE_ATTRIB90,
          IIT_DATE_ATTRIB91,
          IIT_DATE_ATTRIB92,
          IIT_DATE_ATTRIB93,
          IIT_DATE_ATTRIB94,
          IIT_DATE_ATTRIB95,
          IIT_ANGLE,
          IIT_ANGLE_TXT,
          IIT_CLASS,
          IIT_CLASS_TXT,
          IIT_COLOUR,
          IIT_COLOUR_TXT,
          IIT_COORD_FLAG,
          IIT_DESCRIPTION,
          IIT_DIAGRAM,
          IIT_DISTANCE,
          IIT_END_CHAIN,
          IIT_GAP,
          IIT_HEIGHT,
          IIT_HEIGHT_2,
          IIT_ID_CODE,
          IIT_INSTAL_DATE,
          IIT_INVENT_DATE,
          IIT_INV_OWNERSHIP,
          IIT_ITEMCODE,
          IIT_LCO_LAMP_CONFIG_ID,
          IIT_LENGTH,
          IIT_MATERIAL,
          IIT_MATERIAL_TXT,
          IIT_METHOD,
          IIT_METHOD_TXT,
          IIT_NOTE,
          IIT_NO_OF_UNITS,
          IIT_OPTIONS,
          IIT_OPTIONS_TXT,
          IIT_OUN_ORG_ID_ELEC_BOARD,
          IIT_OWNER,
          IIT_OWNER_TXT,
          IIT_PEO_INVENT_BY_ID,
          IIT_PHOTO,
          IIT_POWER,
          IIT_PROV_FLAG,
          IIT_REV_BY,
          IIT_REV_DATE,
          IIT_TYPE,
          IIT_TYPE_TXT,
          IIT_WIDTH,
          IIT_XTRA_CHAR_1,
          IIT_XTRA_DATE_1,
          IIT_XTRA_DOMAIN_1,
          IIT_XTRA_DOMAIN_TXT_1,
          IIT_XTRA_NUMBER_1,
          IIT_X_SECT,
          IIT_DET_XSP,
          IIT_OFFSET,
          IIT_X,
          IIT_Y,
          IIT_Z,
          IIT_NUM_ATTRIB96,
          IIT_NUM_ATTRIB97,
          IIT_NUM_ATTRIB98,
          IIT_NUM_ATTRIB99,
          IIT_NUM_ATTRIB100,
          IIT_NUM_ATTRIB101,
          IIT_NUM_ATTRIB102,
          IIT_NUM_ATTRIB103,
          IIT_NUM_ATTRIB104,
          IIT_NUM_ATTRIB105,
          IIT_NUM_ATTRIB106,
          IIT_NUM_ATTRIB107,
          IIT_NUM_ATTRIB108,
          IIT_NUM_ATTRIB109,
          IIT_NUM_ATTRIB110,
          IIT_NUM_ATTRIB111,
          IIT_NUM_ATTRIB112,
          IIT_NUM_ATTRIB113,
          IIT_NUM_ATTRIB114,
          IIT_NUM_ATTRIB115,
          IIT_AUDIT_TYPE,
          PARENT_NE_ID,
          CREATED_BY,
          DATE_CREATED
          )
          VALUES
          (
          :OLD.IIT_NE_ID,
          :OLD.IIT_INV_TYPE,
          :OLD.IIT_PRIMARY_KEY,
          :OLD.IIT_START_DATE,
          :OLD.IIT_DATE_CREATED,
          :OLD.IIT_DATE_MODIFIED,
          :OLD.IIT_CREATED_BY,
          :OLD.IIT_MODIFIED_BY,
          :OLD.IIT_ADMIN_UNIT,
          :OLD.IIT_DESCR,
          l_old_iit_end_date,
          :OLD.IIT_FOREIGN_KEY,
          :OLD.IIT_LOCATED_BY,
          :OLD.IIT_POSITION,
          :OLD.IIT_X_COORD,
          :OLD.IIT_Y_COORD,
          :OLD.IIT_NUM_ATTRIB16,
          :OLD.IIT_NUM_ATTRIB17,
          :OLD.IIT_NUM_ATTRIB18,
          :OLD.IIT_NUM_ATTRIB19,
          :OLD.IIT_NUM_ATTRIB20,
          :OLD.IIT_NUM_ATTRIB21,
          :OLD.IIT_NUM_ATTRIB22,
          :OLD.IIT_NUM_ATTRIB23,
          :OLD.IIT_NUM_ATTRIB24,
          :OLD.IIT_NUM_ATTRIB25,
          :OLD.IIT_CHR_ATTRIB26,
          :OLD.IIT_CHR_ATTRIB27,
          :OLD.IIT_CHR_ATTRIB28,
          :OLD.IIT_CHR_ATTRIB29,
          :OLD.IIT_CHR_ATTRIB30,
          :OLD.IIT_CHR_ATTRIB31,
          :OLD.IIT_CHR_ATTRIB32,
          :OLD.IIT_CHR_ATTRIB33,
          :OLD.IIT_CHR_ATTRIB34,
          :OLD.IIT_CHR_ATTRIB35,
          :OLD.IIT_CHR_ATTRIB36,
          :OLD.IIT_CHR_ATTRIB37,
          :OLD.IIT_CHR_ATTRIB38,
          :OLD.IIT_CHR_ATTRIB39,
          :OLD.IIT_CHR_ATTRIB40,
          :OLD.IIT_CHR_ATTRIB41,
          :OLD.IIT_CHR_ATTRIB42,
          :OLD.IIT_CHR_ATTRIB43,
          :OLD.IIT_CHR_ATTRIB44,
          :OLD.IIT_CHR_ATTRIB45,
          :OLD.IIT_CHR_ATTRIB46,
          :OLD.IIT_CHR_ATTRIB47,
          :OLD.IIT_CHR_ATTRIB48,
          :OLD.IIT_CHR_ATTRIB49,
          :OLD.IIT_CHR_ATTRIB50,
          :OLD.IIT_CHR_ATTRIB51,
          :OLD.IIT_CHR_ATTRIB52,
          :OLD.IIT_CHR_ATTRIB53,
          :OLD.IIT_CHR_ATTRIB54,
          :OLD.IIT_CHR_ATTRIB55,
          :OLD.IIT_CHR_ATTRIB56,
          :OLD.IIT_CHR_ATTRIB57,
          :OLD.IIT_CHR_ATTRIB58,
          :OLD.IIT_CHR_ATTRIB59,
          :OLD.IIT_CHR_ATTRIB60,
          :OLD.IIT_CHR_ATTRIB61,
          :OLD.IIT_CHR_ATTRIB62,
          :OLD.IIT_CHR_ATTRIB63,
          :OLD.IIT_CHR_ATTRIB64,
          :OLD.IIT_CHR_ATTRIB65,
          :OLD.IIT_CHR_ATTRIB66,
          :OLD.IIT_CHR_ATTRIB67,
          :OLD.IIT_CHR_ATTRIB68,
          :OLD.IIT_CHR_ATTRIB69,
          :OLD.IIT_CHR_ATTRIB70,
          :OLD.IIT_CHR_ATTRIB71,
          :OLD.IIT_CHR_ATTRIB72,
          :OLD.IIT_CHR_ATTRIB73,
          :OLD.IIT_CHR_ATTRIB74,
          :OLD.IIT_CHR_ATTRIB75,
          :OLD.IIT_NUM_ATTRIB76,
          :OLD.IIT_NUM_ATTRIB77,
          :OLD.IIT_NUM_ATTRIB78,
          :OLD.IIT_NUM_ATTRIB79,
          :OLD.IIT_NUM_ATTRIB80,
          :OLD.IIT_NUM_ATTRIB81,
          :OLD.IIT_NUM_ATTRIB82,
          :OLD.IIT_NUM_ATTRIB83,
          :OLD.IIT_NUM_ATTRIB84,
          :OLD.IIT_NUM_ATTRIB85,
          :OLD.IIT_DATE_ATTRIB86,
          :OLD.IIT_DATE_ATTRIB87,
          :OLD.IIT_DATE_ATTRIB88,
          :OLD.IIT_DATE_ATTRIB89,
          :OLD.IIT_DATE_ATTRIB90,
          :OLD.IIT_DATE_ATTRIB91,
          :OLD.IIT_DATE_ATTRIB92,
          :OLD.IIT_DATE_ATTRIB93,
          :OLD.IIT_DATE_ATTRIB94,
          :OLD.IIT_DATE_ATTRIB95,
          :OLD.IIT_ANGLE,
          :OLD.IIT_ANGLE_TXT,
          :OLD.IIT_CLASS,
          :OLD.IIT_CLASS_TXT,
          :OLD.IIT_COLOUR,
          :OLD.IIT_COLOUR_TXT,
          :OLD.IIT_COORD_FLAG,
          :OLD.IIT_DESCRIPTION,
          :OLD.IIT_DIAGRAM,
          :OLD.IIT_DISTANCE,
          :OLD.IIT_END_CHAIN,
          :OLD.IIT_GAP,
          :OLD.IIT_HEIGHT,
          :OLD.IIT_HEIGHT_2,
          :OLD.IIT_ID_CODE,
          :OLD.IIT_INSTAL_DATE,
          :OLD.IIT_INVENT_DATE,
          :OLD.IIT_INV_OWNERSHIP,
          :OLD.IIT_ITEMCODE,
          :OLD.IIT_LCO_LAMP_CONFIG_ID,
          :OLD.IIT_LENGTH,
          :OLD.IIT_MATERIAL,
          :OLD.IIT_MATERIAL_TXT,
          :OLD.IIT_METHOD,
          :OLD.IIT_METHOD_TXT,
          :OLD.IIT_NOTE,
          :OLD.IIT_NO_OF_UNITS,
          :OLD.IIT_OPTIONS,
          :OLD.IIT_OPTIONS_TXT,
          :OLD.IIT_OUN_ORG_ID_ELEC_BOARD,
          :OLD.IIT_OWNER,
          :OLD.IIT_OWNER_TXT,
          :OLD.IIT_PEO_INVENT_BY_ID,
          :OLD.IIT_PHOTO,
          :OLD.IIT_POWER,
          :OLD.IIT_PROV_FLAG,
          :OLD.IIT_REV_BY,
          :OLD.IIT_REV_DATE,
          :OLD.IIT_TYPE,
          :OLD.IIT_TYPE_TXT,
          :OLD.IIT_WIDTH,
          :OLD.IIT_XTRA_CHAR_1,
          :OLD.IIT_XTRA_DATE_1,
          :OLD.IIT_XTRA_DOMAIN_1,
          :OLD.IIT_XTRA_DOMAIN_TXT_1,
          :OLD.IIT_XTRA_NUMBER_1,
          :OLD.IIT_X_SECT,
          :OLD.IIT_DET_XSP,
          :OLD.IIT_OFFSET,
          :OLD.IIT_X,
          :OLD.IIT_Y,
          :OLD.IIT_Z,
          :OLD.IIT_NUM_ATTRIB96,
          :OLD.IIT_NUM_ATTRIB97,
          :OLD.IIT_NUM_ATTRIB98,
          :OLD.IIT_NUM_ATTRIB99,
          :OLD.IIT_NUM_ATTRIB100,
          :OLD.IIT_NUM_ATTRIB101,
          :OLD.IIT_NUM_ATTRIB102,
          :OLD.IIT_NUM_ATTRIB103,
          :OLD.IIT_NUM_ATTRIB104,
          :OLD.IIT_NUM_ATTRIB105,
          :OLD.IIT_NUM_ATTRIB106,
          :OLD.IIT_NUM_ATTRIB107,
          :OLD.IIT_NUM_ATTRIB108,
          :OLD.IIT_NUM_ATTRIB109,
          :OLD.IIT_NUM_ATTRIB110,
          :OLD.IIT_NUM_ATTRIB111,
          :OLD.IIT_NUM_ATTRIB112,
          :OLD.IIT_NUM_ATTRIB113,
          :OLD.IIT_NUM_ATTRIB114,
          :OLD.IIT_NUM_ATTRIB115,
          :OLD.IIT_AUDIT_TYPE,
          :OLD.IIT_NE_ID,
          USER,
          SYSDATE
          );
      END IF;
    END IF;
    --
  END nm_inv_items_all_aud;
  /
  ALTER TRIGGER NM_INV_ITEMS_ALL_AUD_BR_IU ENABLE;

