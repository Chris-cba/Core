CREATE OR REPLACE FORCE VIEW imf_net_network_all (
   network_element_id,
   network_element_reference,
   network_element_description,
   network_type,
   group_type,
   network_element_start_date,
   network_element_end_date,
   admin_unit_id,
   admin_unit_code,
   admin_unit_name,
   network_element_length,
   flx_network_element_owner,
   flx_network_element_name_1,
   flx_network_element_name_2,
   flx_network_element_prefix,
   flx_network_element_number,
   flx_network_element_sub_type,
   flx_network_element_group,
   flx_network_element_sub_class,
   flx_network_element_nsg_ref,
   flx_network_element_version_no
   )
AS
   SELECT                                                                   
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_net_network_all.vw-arc   3.1   Jul 04 2013 11:20:30   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_network_all.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:03:32  $
--       Version          : $Revision:   3.1  $
-- All network elements with an ID, Unique Reference and Description and generic flexible attributes
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   ne.ne_id network_element_id,
   CASE
      WHEN ne_nt_type = 'NSGN' THEN ne.ne_number
      ELSE ne.ne_unique
   END
      network_element_reference,
   ne.ne_descr network_element_description,
   ne.ne_nt_type network_type,
   ne.ne_gty_group_type group_type,
   ne.ne_start_date network_element_start_date,
   ne.ne_end_date network_element_end_date,
   ne.ne_admin_unit admin_unit_id,
   nau.nau_unit_code admin_unit_code,
   nau.nau_name admin_unit_name,
   ne.ne_length network_element_length,
   ne.ne_owner flx_network_element_owner,
   ne.ne_name_1 flx_network_element_name_1,
   ne.ne_name_2 flx_network_element_name_2,
   ne.ne_prefix flx_network_element_prefix,
   ne.ne_number flx_network_element_number,
   ne.ne_sub_type flx_network_element_sub_type,
   ne.ne_group flx_network_element_group,
   ne.ne_sub_class flx_network_element_sub_class,
   ne.ne_nsg_ref flx_network_element_nsg_ref,
   ne.ne_version_no flx_network_element_version_no
   FROM nm_elements_all ne, nm_admin_units_all nau
   WHERE ne.ne_admin_unit = nau.nau_admin_unit
WITH READ ONLY
/

COMMENT ON TABLE IMF_NET_NETWORK_ALL IS 'All network elements with an ID, Unique Reference and Description and generic flexible attributes';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_GROUP IS '[Flexible Attribute] Network Element Group';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_SUB_CLASS IS '[Flexible Attribute] Network Element Sub Class';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_NSG_REF IS '[Flexible Attribute] Network Element Nsg Ref';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_VERSION_NO IS '[Flexible Attribute] Network Element Version No';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.NETWORK_ELEMENT_ID IS 'Network Element Id';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.NETWORK_ELEMENT_REFERENCE IS 'Network Element Reference';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.NETWORK_ELEMENT_DESCRIPTION IS 'Network Element Description';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.NETWORK_TYPE IS 'Network Type';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.GROUP_TYPE IS 'Group Type';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.NETWORK_ELEMENT_START_DATE IS 'Network Element Start Date';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.NETWORK_ELEMENT_END_DATE IS 'Network Element End Date';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.ADMIN_UNIT_ID IS 'Admin Unit Id';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.ADMIN_UNIT_CODE IS 'Admin Unit Code';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.ADMIN_UNIT_NAME IS 'Admin Unit Name';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.NETWORK_ELEMENT_LENGTH IS 'Network Element Length';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_OWNER IS '[Flexible Attribute] Network Element Owner';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_NAME_1 IS '[Flexible Attribute] Network Element Name 1';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_NAME_2 IS '[Flexible Attribute] Network Element Name 2';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_PREFIX IS '[Flexible Attribute] Network Element Prefix';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_NUMBER IS '[Flexible Attribute] Network Element Number';

COMMENT ON COLUMN IMF_NET_NETWORK_ALL.FLX_NETWORK_ELEMENT_SUB_TYPE IS '[Flexible Attribute] Network Element Sub Type';

