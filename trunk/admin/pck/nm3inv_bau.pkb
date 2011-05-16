CREATE OR REPLACE package body nm3inv_bau as
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_bau.pkb-arc   2.3   May 16 2011 14:44:54   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3inv_bau.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:44:54  $
--       Date fetched Out : $Modtime:   Apr 01 2011 14:43:42  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.3
-------------------------------------------------------------------------
--   Author : Priidu Tanava
--
--   service api: BULK ASSET UPDATE
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
  g_package_name    CONSTANT  varchar2(30)   := 'nm3inv_bau';

  m_date_format constant varchar2(20) := 'DD-MON-YYYY';
  m_debug constant number(1) := 3;
  
  
  -- item id table for bulk attribute update
  --  and the timestamp when it was posted
  m_id_tbl    id_tbl;
  m_timestamp varchar2(40);
  
  -- static inv type
  m_inv_type  nm_inv_types_all.nit_inv_type%type;
  
  --
  -----------------------------------------------------------------------------
  --
  function get_version return varchar2
  is
  begin
     return g_sccsid;
  end;
  --
  -----------------------------------------------------------------------------
  --
  function get_body_version return varchar2
  is
  begin
     return g_body_sccsid;
  end;

  --
  -----------------------------------------------------------------------------
  --
  procedure sel_invattr_tbl(
     p_tbl in out invattr_tbl
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type)
  is
    i binary_integer;
    function is_attr_present(p_attrib_name in varchar2) return boolean
    is
    begin
      i := p_tbl.first;
      while  i is not null loop
        if p_tbl(i).ITA_ATTRIB_NAME = p_attrib_name then
          return true;
        end if;
        i := p_tbl.next(i);
      end loop;
      return false;
    end;
  begin
    -- load using the nm3asset procedure
    nm3asset.get_inv_flex_col_details (
      pi_iit_ne_id           => null
     ,pi_nit_inv_type        => p_inv_type
     ,pi_display_descr       => true
     ,pi_allow_null_ne_id    => true
     ,po_flex_col_dets       => p_tbl
    );
    
    -- IIT_DESCR, IIT_END_DATE and IIT_NOTE are fixed attributes
    -- the first is specified in the above procedure
    -- we need add the other two
    
    if not is_attr_present('IIT_END_DATE') then
      i := nvl(p_tbl.last, 0) + 1;
      p_tbl(i).ITA_ATTRIB_NAME           := 'IIT_END_DATE';
      p_tbl(i).ITA_SCRN_TEXT             := 'End Date';
      p_tbl(i).ITA_VIEW_COL_NAME         := p_tbl(i).ITA_ATTRIB_NAME;
      p_tbl(i).ITA_ID_DOMAIN             := NULL;
      p_tbl(i).ITA_MANDATORY_YN          := 'N';
      --p_tbl(i).ITA_MANDATORY_ASTERISK    := C_ASTERISK;
      p_tbl(i).IIT_VALUE                 := null;
      p_tbl(i).IIT_MEANING               := null;
      p_tbl(i).IIT_DESCRIPTION           := null;
      p_tbl(i).ITA_UPDATE_ALLOWED        := 'Y';
      p_tbl(i).ITA_FORMAT                := nm3type.C_DATE;
      p_tbl(i).ITA_FORMAT_MASK           := Sys_Context('NM3CORE','USER_DATE_MASK');
    end if;
    

  end;
  
  
  -- tbl update procedure for the forms attributes block
  --  this is where it happens
  --  the item ids must be passed in separately by post_item_id_table()
  procedure bulk_upd_invattr_tbl(
     p_tbl in out invattr_tbl
    ,p_timestamp in varchar2)
  is
    l_rec   nm_inv_items_all%rowtype;
    i       binary_integer;             -- m_id_tbl index
    k       binary_integer;             -- p_tbl    index
    -- attribute value copy, see generation code at package end
    procedure copy_tbl_value(
       p_attrib_name in varchar2
      ,p_value in varchar2
      ,p_format_mask in varchar2)
    is
    begin
      case p_attrib_name
      when 'IIT_NE_ID' then l_rec.IIT_NE_ID := to_number(p_value);
      when 'IIT_INV_TYPE' then l_rec.IIT_INV_TYPE := p_value;
      when 'IIT_PRIMARY_KEY' then l_rec.IIT_PRIMARY_KEY := p_value;
      when 'IIT_START_DATE' then l_rec.IIT_START_DATE := to_date(p_value,p_format_mask);
      when 'IIT_DATE_CREATED' then l_rec.IIT_DATE_CREATED := to_date(p_value,p_format_mask);
      when 'IIT_DATE_MODIFIED' then l_rec.IIT_DATE_MODIFIED := to_date(p_value,p_format_mask);
      when 'IIT_CREATED_BY' then l_rec.IIT_CREATED_BY := p_value;
      when 'IIT_MODIFIED_BY' then l_rec.IIT_MODIFIED_BY := p_value;
      when 'IIT_ADMIN_UNIT' then l_rec.IIT_ADMIN_UNIT := to_number(p_value);
      when 'IIT_DESCR' then l_rec.IIT_DESCR := p_value;
      when 'IIT_END_DATE' then l_rec.IIT_END_DATE := to_date(p_value,p_format_mask);
      when 'IIT_FOREIGN_KEY' then l_rec.IIT_FOREIGN_KEY := p_value;
      when 'IIT_LOCATED_BY' then l_rec.IIT_LOCATED_BY := to_number(p_value);
      when 'IIT_POSITION' then l_rec.IIT_POSITION := to_number(p_value);
      when 'IIT_X_COORD' then l_rec.IIT_X_COORD := to_number(p_value);
      when 'IIT_Y_COORD' then l_rec.IIT_Y_COORD := to_number(p_value);
      when 'IIT_NUM_ATTRIB16' then l_rec.IIT_NUM_ATTRIB16 := to_number(p_value);
      when 'IIT_NUM_ATTRIB17' then l_rec.IIT_NUM_ATTRIB17 := to_number(p_value);
      when 'IIT_NUM_ATTRIB18' then l_rec.IIT_NUM_ATTRIB18 := to_number(p_value);
      when 'IIT_NUM_ATTRIB19' then l_rec.IIT_NUM_ATTRIB19 := to_number(p_value);
      when 'IIT_NUM_ATTRIB20' then l_rec.IIT_NUM_ATTRIB20 := to_number(p_value);
      when 'IIT_NUM_ATTRIB21' then l_rec.IIT_NUM_ATTRIB21 := to_number(p_value);
      when 'IIT_NUM_ATTRIB22' then l_rec.IIT_NUM_ATTRIB22 := to_number(p_value);
      when 'IIT_NUM_ATTRIB23' then l_rec.IIT_NUM_ATTRIB23 := to_number(p_value);
      when 'IIT_NUM_ATTRIB24' then l_rec.IIT_NUM_ATTRIB24 := to_number(p_value);
      when 'IIT_NUM_ATTRIB25' then l_rec.IIT_NUM_ATTRIB25 := to_number(p_value);
      when 'IIT_CHR_ATTRIB26' then l_rec.IIT_CHR_ATTRIB26 := p_value;
      when 'IIT_CHR_ATTRIB27' then l_rec.IIT_CHR_ATTRIB27 := p_value;
      when 'IIT_CHR_ATTRIB28' then l_rec.IIT_CHR_ATTRIB28 := p_value;
      when 'IIT_CHR_ATTRIB29' then l_rec.IIT_CHR_ATTRIB29 := p_value;
      when 'IIT_CHR_ATTRIB30' then l_rec.IIT_CHR_ATTRIB30 := p_value;
      when 'IIT_CHR_ATTRIB31' then l_rec.IIT_CHR_ATTRIB31 := p_value;
      when 'IIT_CHR_ATTRIB32' then l_rec.IIT_CHR_ATTRIB32 := p_value;
      when 'IIT_CHR_ATTRIB33' then l_rec.IIT_CHR_ATTRIB33 := p_value;
      when 'IIT_CHR_ATTRIB34' then l_rec.IIT_CHR_ATTRIB34 := p_value;
      when 'IIT_CHR_ATTRIB35' then l_rec.IIT_CHR_ATTRIB35 := p_value;
      when 'IIT_CHR_ATTRIB36' then l_rec.IIT_CHR_ATTRIB36 := p_value;
      when 'IIT_CHR_ATTRIB37' then l_rec.IIT_CHR_ATTRIB37 := p_value;
      when 'IIT_CHR_ATTRIB38' then l_rec.IIT_CHR_ATTRIB38 := p_value;
      when 'IIT_CHR_ATTRIB39' then l_rec.IIT_CHR_ATTRIB39 := p_value;
      when 'IIT_CHR_ATTRIB40' then l_rec.IIT_CHR_ATTRIB40 := p_value;
      when 'IIT_CHR_ATTRIB41' then l_rec.IIT_CHR_ATTRIB41 := p_value;
      when 'IIT_CHR_ATTRIB42' then l_rec.IIT_CHR_ATTRIB42 := p_value;
      when 'IIT_CHR_ATTRIB43' then l_rec.IIT_CHR_ATTRIB43 := p_value;
      when 'IIT_CHR_ATTRIB44' then l_rec.IIT_CHR_ATTRIB44 := p_value;
      when 'IIT_CHR_ATTRIB45' then l_rec.IIT_CHR_ATTRIB45 := p_value;
      when 'IIT_CHR_ATTRIB46' then l_rec.IIT_CHR_ATTRIB46 := p_value;
      when 'IIT_CHR_ATTRIB47' then l_rec.IIT_CHR_ATTRIB47 := p_value;
      when 'IIT_CHR_ATTRIB48' then l_rec.IIT_CHR_ATTRIB48 := p_value;
      when 'IIT_CHR_ATTRIB49' then l_rec.IIT_CHR_ATTRIB49 := p_value;
      when 'IIT_CHR_ATTRIB50' then l_rec.IIT_CHR_ATTRIB50 := p_value;
      when 'IIT_CHR_ATTRIB51' then l_rec.IIT_CHR_ATTRIB51 := p_value;
      when 'IIT_CHR_ATTRIB52' then l_rec.IIT_CHR_ATTRIB52 := p_value;
      when 'IIT_CHR_ATTRIB53' then l_rec.IIT_CHR_ATTRIB53 := p_value;
      when 'IIT_CHR_ATTRIB54' then l_rec.IIT_CHR_ATTRIB54 := p_value;
      when 'IIT_CHR_ATTRIB55' then l_rec.IIT_CHR_ATTRIB55 := p_value;
      when 'IIT_CHR_ATTRIB56' then l_rec.IIT_CHR_ATTRIB56 := p_value;
      when 'IIT_CHR_ATTRIB57' then l_rec.IIT_CHR_ATTRIB57 := p_value;
      when 'IIT_CHR_ATTRIB58' then l_rec.IIT_CHR_ATTRIB58 := p_value;
      when 'IIT_CHR_ATTRIB59' then l_rec.IIT_CHR_ATTRIB59 := p_value;
      when 'IIT_CHR_ATTRIB60' then l_rec.IIT_CHR_ATTRIB60 := p_value;
      when 'IIT_CHR_ATTRIB61' then l_rec.IIT_CHR_ATTRIB61 := p_value;
      when 'IIT_CHR_ATTRIB62' then l_rec.IIT_CHR_ATTRIB62 := p_value;
      when 'IIT_CHR_ATTRIB63' then l_rec.IIT_CHR_ATTRIB63 := p_value;
      when 'IIT_CHR_ATTRIB64' then l_rec.IIT_CHR_ATTRIB64 := p_value;
      when 'IIT_CHR_ATTRIB65' then l_rec.IIT_CHR_ATTRIB65 := p_value;
      when 'IIT_CHR_ATTRIB66' then l_rec.IIT_CHR_ATTRIB66 := p_value;
      when 'IIT_CHR_ATTRIB67' then l_rec.IIT_CHR_ATTRIB67 := p_value;
      when 'IIT_CHR_ATTRIB68' then l_rec.IIT_CHR_ATTRIB68 := p_value;
      when 'IIT_CHR_ATTRIB69' then l_rec.IIT_CHR_ATTRIB69 := p_value;
      when 'IIT_CHR_ATTRIB70' then l_rec.IIT_CHR_ATTRIB70 := p_value;
      when 'IIT_CHR_ATTRIB71' then l_rec.IIT_CHR_ATTRIB71 := p_value;
      when 'IIT_CHR_ATTRIB72' then l_rec.IIT_CHR_ATTRIB72 := p_value;
      when 'IIT_CHR_ATTRIB73' then l_rec.IIT_CHR_ATTRIB73 := p_value;
      when 'IIT_CHR_ATTRIB74' then l_rec.IIT_CHR_ATTRIB74 := p_value;
      when 'IIT_CHR_ATTRIB75' then l_rec.IIT_CHR_ATTRIB75 := p_value;
      when 'IIT_NUM_ATTRIB76' then l_rec.IIT_NUM_ATTRIB76 := to_number(p_value);
      when 'IIT_NUM_ATTRIB77' then l_rec.IIT_NUM_ATTRIB77 := to_number(p_value);
      when 'IIT_NUM_ATTRIB78' then l_rec.IIT_NUM_ATTRIB78 := to_number(p_value);
      when 'IIT_NUM_ATTRIB79' then l_rec.IIT_NUM_ATTRIB79 := to_number(p_value);
      when 'IIT_NUM_ATTRIB80' then l_rec.IIT_NUM_ATTRIB80 := to_number(p_value);
      when 'IIT_NUM_ATTRIB81' then l_rec.IIT_NUM_ATTRIB81 := to_number(p_value);
      when 'IIT_NUM_ATTRIB82' then l_rec.IIT_NUM_ATTRIB82 := to_number(p_value);
      when 'IIT_NUM_ATTRIB83' then l_rec.IIT_NUM_ATTRIB83 := to_number(p_value);
      when 'IIT_NUM_ATTRIB84' then l_rec.IIT_NUM_ATTRIB84 := to_number(p_value);
      when 'IIT_NUM_ATTRIB85' then l_rec.IIT_NUM_ATTRIB85 := to_number(p_value);
      when 'IIT_DATE_ATTRIB86' then l_rec.IIT_DATE_ATTRIB86 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB87' then l_rec.IIT_DATE_ATTRIB87 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB88' then l_rec.IIT_DATE_ATTRIB88 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB89' then l_rec.IIT_DATE_ATTRIB89 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB90' then l_rec.IIT_DATE_ATTRIB90 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB91' then l_rec.IIT_DATE_ATTRIB91 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB92' then l_rec.IIT_DATE_ATTRIB92 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB93' then l_rec.IIT_DATE_ATTRIB93 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB94' then l_rec.IIT_DATE_ATTRIB94 := to_date(p_value,p_format_mask);
      when 'IIT_DATE_ATTRIB95' then l_rec.IIT_DATE_ATTRIB95 := to_date(p_value,p_format_mask);
      when 'IIT_ANGLE' then l_rec.IIT_ANGLE := to_number(p_value);
      when 'IIT_ANGLE_TXT' then l_rec.IIT_ANGLE_TXT := p_value;
      when 'IIT_CLASS' then l_rec.IIT_CLASS := p_value;
      when 'IIT_CLASS_TXT' then l_rec.IIT_CLASS_TXT := p_value;
      when 'IIT_COLOUR' then l_rec.IIT_COLOUR := p_value;
      when 'IIT_COLOUR_TXT' then l_rec.IIT_COLOUR_TXT := p_value;
      when 'IIT_COORD_FLAG' then l_rec.IIT_COORD_FLAG := p_value;
      when 'IIT_DESCRIPTION' then l_rec.IIT_DESCRIPTION := p_value;
      when 'IIT_DIAGRAM' then l_rec.IIT_DIAGRAM := p_value;
      when 'IIT_DISTANCE' then l_rec.IIT_DISTANCE := to_number(p_value);
      when 'IIT_END_CHAIN' then l_rec.IIT_END_CHAIN := to_number(p_value);
      when 'IIT_GAP' then l_rec.IIT_GAP := to_number(p_value);
      when 'IIT_HEIGHT' then l_rec.IIT_HEIGHT := to_number(p_value);
      when 'IIT_HEIGHT_2' then l_rec.IIT_HEIGHT_2 := to_number(p_value);
      when 'IIT_ID_CODE' then l_rec.IIT_ID_CODE := p_value;
      when 'IIT_INSTAL_DATE' then l_rec.IIT_INSTAL_DATE := to_date(p_value,p_format_mask);
      when 'IIT_INVENT_DATE' then l_rec.IIT_INVENT_DATE := to_date(p_value,p_format_mask);
      when 'IIT_INV_OWNERSHIP' then l_rec.IIT_INV_OWNERSHIP := p_value;
      when 'IIT_ITEMCODE' then l_rec.IIT_ITEMCODE := p_value;
      when 'IIT_LCO_LAMP_CONFIG_ID' then l_rec.IIT_LCO_LAMP_CONFIG_ID := to_number(p_value);
      when 'IIT_LENGTH' then l_rec.IIT_LENGTH := to_number(p_value);
      when 'IIT_MATERIAL' then l_rec.IIT_MATERIAL := p_value;
      when 'IIT_MATERIAL_TXT' then l_rec.IIT_MATERIAL_TXT := p_value;
      when 'IIT_METHOD' then l_rec.IIT_METHOD := p_value;
      when 'IIT_METHOD_TXT' then l_rec.IIT_METHOD_TXT := p_value;
      when 'IIT_NOTE' then l_rec.IIT_NOTE := p_value;
      when 'IIT_NO_OF_UNITS' then l_rec.IIT_NO_OF_UNITS := to_number(p_value);
      when 'IIT_OPTIONS' then l_rec.IIT_OPTIONS := p_value;
      when 'IIT_OPTIONS_TXT' then l_rec.IIT_OPTIONS_TXT := p_value;
      when 'IIT_OUN_ORG_ID_ELEC_BOARD' then l_rec.IIT_OUN_ORG_ID_ELEC_BOARD := to_number(p_value);
      when 'IIT_OWNER' then l_rec.IIT_OWNER := p_value;
      when 'IIT_OWNER_TXT' then l_rec.IIT_OWNER_TXT := p_value;
      when 'IIT_PEO_INVENT_BY_ID' then l_rec.IIT_PEO_INVENT_BY_ID := to_number(p_value);
      when 'IIT_PHOTO' then l_rec.IIT_PHOTO := p_value;
      when 'IIT_POWER' then l_rec.IIT_POWER := to_number(p_value);
      when 'IIT_PROV_FLAG' then l_rec.IIT_PROV_FLAG := p_value;
      when 'IIT_REV_BY' then l_rec.IIT_REV_BY := p_value;
      when 'IIT_REV_DATE' then l_rec.IIT_REV_DATE := to_date(p_value,p_format_mask);
      when 'IIT_TYPE' then l_rec.IIT_TYPE := p_value;
      when 'IIT_TYPE_TXT' then l_rec.IIT_TYPE_TXT := p_value;
      when 'IIT_WIDTH' then l_rec.IIT_WIDTH := to_number(p_value);
      when 'IIT_XTRA_CHAR_1' then l_rec.IIT_XTRA_CHAR_1 := p_value;
      when 'IIT_XTRA_DATE_1' then l_rec.IIT_XTRA_DATE_1 := to_date(p_value,p_format_mask);
      when 'IIT_XTRA_DOMAIN_1' then l_rec.IIT_XTRA_DOMAIN_1 := p_value;
      when 'IIT_XTRA_DOMAIN_TXT_1' then l_rec.IIT_XTRA_DOMAIN_TXT_1 := p_value;
      when 'IIT_XTRA_NUMBER_1' then l_rec.IIT_XTRA_NUMBER_1 := to_number(p_value);
      when 'IIT_X_SECT' then l_rec.IIT_X_SECT := p_value;
      when 'IIT_DET_XSP' then l_rec.IIT_DET_XSP := p_value;
      when 'IIT_OFFSET' then l_rec.IIT_OFFSET := to_number(p_value);
      when 'IIT_X' then l_rec.IIT_X := to_number(p_value);
      when 'IIT_Y' then l_rec.IIT_Y := to_number(p_value);
      when 'IIT_Z' then l_rec.IIT_Z := to_number(p_value);
      when 'IIT_NUM_ATTRIB96' then l_rec.IIT_NUM_ATTRIB96 := to_number(p_value);
      when 'IIT_NUM_ATTRIB97' then l_rec.IIT_NUM_ATTRIB97 := to_number(p_value);
      when 'IIT_NUM_ATTRIB98' then l_rec.IIT_NUM_ATTRIB98 := to_number(p_value);
      when 'IIT_NUM_ATTRIB99' then l_rec.IIT_NUM_ATTRIB99 := to_number(p_value);
      when 'IIT_NUM_ATTRIB100' then l_rec.IIT_NUM_ATTRIB100 := to_number(p_value);
      when 'IIT_NUM_ATTRIB101' then l_rec.IIT_NUM_ATTRIB101 := to_number(p_value);
      when 'IIT_NUM_ATTRIB102' then l_rec.IIT_NUM_ATTRIB102 := to_number(p_value);
      when 'IIT_NUM_ATTRIB103' then l_rec.IIT_NUM_ATTRIB103 := to_number(p_value);
      when 'IIT_NUM_ATTRIB104' then l_rec.IIT_NUM_ATTRIB104 := to_number(p_value);
      when 'IIT_NUM_ATTRIB105' then l_rec.IIT_NUM_ATTRIB105 := to_number(p_value);
      when 'IIT_NUM_ATTRIB106' then l_rec.IIT_NUM_ATTRIB106 := to_number(p_value);
      when 'IIT_NUM_ATTRIB107' then l_rec.IIT_NUM_ATTRIB107 := to_number(p_value);
      when 'IIT_NUM_ATTRIB108' then l_rec.IIT_NUM_ATTRIB108 := to_number(p_value);
      when 'IIT_NUM_ATTRIB109' then l_rec.IIT_NUM_ATTRIB109 := to_number(p_value);
      when 'IIT_NUM_ATTRIB110' then l_rec.IIT_NUM_ATTRIB110 := to_number(p_value);
      when 'IIT_NUM_ATTRIB111' then l_rec.IIT_NUM_ATTRIB111 := to_number(p_value);
      when 'IIT_NUM_ATTRIB112' then l_rec.IIT_NUM_ATTRIB112 := to_number(p_value);
      when 'IIT_NUM_ATTRIB113' then l_rec.IIT_NUM_ATTRIB113 := to_number(p_value);
      when 'IIT_NUM_ATTRIB114' then l_rec.IIT_NUM_ATTRIB114 := to_number(p_value);
      when 'IIT_NUM_ATTRIB115' then l_rec.IIT_NUM_ATTRIB115 := to_number(p_value);
      end case;
    end;

  begin
    -- m_timestamp has been set in post_item_id_table()
    -- to ensure that the two procedures are called in sync
    if p_timestamp = m_timestamp then
      m_timestamp := null;
    else
      raise_application_error(-20001
        ,g_package_name||'.bulk_upd_invattr_tbl(): invalid timestamp');
    end if;
    
    m_inv_type := null;
    
    -- the work starts here
    
    -- loop through invitem ids
    --    select the invitem into row variable
    --    loop through the modified attributes
    --      update the value into row variable
    --    post the row variable into database
    
    -- item ids loop
    i := m_id_tbl.first;
    while i is not null loop
      select * into l_rec
      from nm_inv_items_all i
      where i.IIT_NE_ID = m_id_tbl(i);
      
      -- check that the item is not a foreign table item
      if l_rec.IIT_INV_TYPE = m_inv_type then null;
      else
        m_inv_type := l_rec.IIT_INV_TYPE;
        if nm3get.get_nit(m_inv_type).NIT_TABLE_NAME is not null then
          raise_application_error(-20000
            ,g_package_name||'.bulk_upd_invattr_tbl():'
            ||' Foreign table items are not supported');
        end if;
      end if;
      
      -- attribute values loop
      k := p_tbl.first;
      while k is not null loop      
        copy_tbl_value(
           p_attrib_name  => p_tbl(k).ITA_ATTRIB_NAME
          ,p_value        => p_tbl(k).IIT_MEANING  --p_tbl(k).IIT_VALUE
          ,p_format_mask  => p_tbl(k).ITA_FORMAT_MASK
        );
        k := p_tbl.next(k);
      end loop;

      -- post the updated row
      update nm_inv_items_all i
        set row = l_rec
      where i.IIT_NE_ID = m_id_tbl(i);
      if sql%rowcount = 0 then
        raise no_data_found;
      end if;

      i := m_id_tbl.next(i); 
    end loop;
    
          
  end;
  
  
  
  
  -- this puts the passed in item id table into a static variable
  --  the timestamp is issued and checked later when the ids are used
  --  called from the _form during commit
  procedure post_item_id_table(
     p_tbl in id_tbl
    ,p_timestamp out varchar2)
  is
  begin
    m_timestamp := to_char(systimestamp);
    m_id_tbl := p_tbl;
    p_timestamp := m_timestamp;
  end;
  
  
  
  
  -- This returns the inv_type from gdo_session_id
  -- can cause no_data_found or too_many_rows
  -- based on Darren's code
  function get_inv_type_from_gis_session(
     p_gdo_session_id in gis_data_objects.gdo_session_id%type)
  return nm_inv_themes.nith_nit_id%type
  is
    l_retval nm_inv_themes.nith_nit_id%type;  -- NIT_INV_TYPE
    
  begin
    select distinct(it.nith_nit_id)
    into l_retval
    from
       gis_data_objects g
      ,nm_themes_all t
      ,nm_inv_themes it
    where g.gdo_theme_name = t.nth_theme_name
      and t.nth_theme_id   = it.nith_nth_theme_id
      and g.gdo_session_id = p_gdo_session_id;
      
    return l_retval;
    
	exception
		when no_data_found then
			raise_application_error(-20001, 'Unable to determine inventory type: no data found');
		when too_many_rows then
			raise_application_error(-20001, 'Unable to determine inventory type: too many rows');
  
  end;

  
  
  
  -- This is a copy of srv_stp_ssjd.lov()
  function code_name_meaning_lov(p_sql in varchar2) return nm_code_name_meaning_tbl --pipelined
  is
    cur sys_refcursor;
    rec nm_code_name_meaning_type := new nm_code_name_meaning_type(null, null, null);
    l_tbl nm_code_name_meaning_tbl := new nm_code_name_meaning_tbl();
    
  begin
    if p_sql is not null then
      open cur for p_sql;
      loop
        fetch cur into rec.CODE, rec.NAME, rec.MEANING;
        exit when cur%notfound;
        --pipe row(rec);
        l_tbl.extend;
        l_tbl(l_tbl.last) := rec;
      end loop;
    end if;
    return l_tbl;
  end;
  

  
/* code generation for copy_tbl_value()
begin 
  for r in (
    select utc.COLUMN_NAME, utc.DATA_TYPE from user_tab_cols utc
    where utc.TABLE_NAME = 'NM_INV_ITEMS_ALL'
    order by utc.COLUMN_ID
  )
  loop
    if r.DATA_TYPE = 'VARCHAR2' then
      dbms_output.put_line('when '''||r.COLUMN_NAME||''' then l_rec.'||r.COLUMN_NAME||' := p_value;');
    elsif r.DATA_TYPE = 'NUMBER' then
      dbms_output.put_line('when '''||r.COLUMN_NAME||''' then l_rec.'||r.COLUMN_NAME||' := to_number(p_value);');
    elsif r.DATA_TYPE = 'DATE' then
      dbms_output.put_line('when '''||r.COLUMN_NAME||''' then l_rec.'||r.COLUMN_NAME||' := to_date(p_value,p_format_mask);');
    end if;
  end loop;
end;
*/




end;
/
