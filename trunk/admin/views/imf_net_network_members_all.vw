CREATE OR REPLACE FORCE VIEW imf_net_network_members_all (
   parent_element_id,
   parent_element_reference,
   parent_element_description,
   parent_network_type,
   parent_group_type,
   parent_element_start_date,
   parent_element_end_date,
   child_element_id,
   child_element_reference,
   child_element_description,
   child_network_type,
   child_group_type,
   child_element_start_date,
   child_element_end_date,
   membership_start_date,
   membership_end_date
   )
AS
   SELECT
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_net_network_members_all.vw-arc   3.1   Jul 04 2013 11:20:30   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_network_members_all.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:04:10  $
--       Version          : $Revision:   3.1  $
-- Parent/Child network element relationships
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   p.network_element_id parent_element_id,
   p.network_element_reference parent_element_reference,
   p.network_element_description parent_element_description,
   p.network_type parent_network_type,
   p.group_type parent_group_type,
   p.network_element_start_date parent_element_start_date,
   p.network_element_end_date parent_element_end_date,
   c.network_element_id child_element_id,
   c.network_element_reference child_element_reference,
   c.network_element_description child_element_description,
   c.network_type child_network_type,
   c.group_type child_group_type,
   c.network_element_start_date child_element_start_date,
   c.network_element_end_date child_element_end_date,
   nm_start_date membership_start_date,
   nm_end_date membership_end_date
   FROM nm_members_all, imf_net_network_all p, imf_net_network_all c
   WHERE     nm_ne_id_in = p.network_element_id
         AND nm_ne_id_of = c.network_element_id
         AND nm_obj_type = p.group_type
WITH READ ONLY
/
         
COMMENT ON TABLE IMF_NET_NETWORK_MEMBERS_ALL IS 'Parent/Child network element relationships';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.PARENT_ELEMENT_ID IS 'Parent Element Id';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.PARENT_ELEMENT_REFERENCE IS 'Parent Element Reference';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.PARENT_ELEMENT_DESCRIPTION IS 'Parent Element Description';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.PARENT_NETWORK_TYPE IS 'Parent Network Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.PARENT_GROUP_TYPE IS 'Parent Group Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.PARENT_ELEMENT_START_DATE IS 'Parent Element Start Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.PARENT_ELEMENT_END_DATE IS 'Parent Element End Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.CHILD_ELEMENT_ID IS 'Child Element Id';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.CHILD_ELEMENT_REFERENCE IS 'Child Element Reference';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.CHILD_ELEMENT_DESCRIPTION IS 'Child Element Description';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.CHILD_NETWORK_TYPE IS 'Child Network Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.CHILD_GROUP_TYPE IS 'Child Group Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.CHILD_ELEMENT_START_DATE IS 'Child Element Start Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.CHILD_ELEMENT_END_DATE IS 'Child Element End Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.MEMBERSHIP_START_DATE IS 'Membership Start Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS_ALL.MEMBERSHIP_END_DATE IS 'Membership End Date';

