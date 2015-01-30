CREATE OR REPLACE TRIGGER NM_INV_ITEMS_ALL_AUD_BR_IU BEFORE
  INSERT OR UPDATE ON NM_INV_ITEMS_ALL FOR EACH row 
  FOLLOWS NM_INV_ITEMS_ALL_B_DT_TRG DECLARE
    --
    --   SCCS Identifiers :-
    --
    --       pvcsid                     : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_inv_items_all_aud_br_iu.trg-arc   3.1   Jan 30 2015 15:44:44   Stephen.Sewell  $
    --       Module Name                : $Workfile:   nm_inv_items_all_aud_br_iu.trg  $
    --       Date into PVCS             : $Date:   Jan 30 2015 15:44:44  $
    --       Date fetched Out           : $Modtime:   Jan 28 2015 16:26:28  $
    --       PVCS Version               : $Revision:   3.1  $
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
    --    21-JAN-2015 - Included INSERT section to ensure IIT_AUDIT_TYPE is set to 'M'
    --                  and not left as NULL (default value on column doesn't apply if NULL
    --                  explicitly inserted).
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
    --
  END nm_inv_items_all_aud;
  /
  ALTER TRIGGER NM_INV_ITEMS_ALL_AUD_BR_IU ENABLE;

