CREATE OR REPLACE FORCE VIEW imf_net_network_members (
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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_net_network_members.vw-arc   3.2   Jul 04 2013 11:20:30   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_network_members.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:03:48  $
--       Version          : $Revision:   3.2  $
-- Parent/Child network element relationships [date tracked]
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
         AND nm_start_date                                        <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
         AND NVL (nm_end_date, TO_DATE ('99991231', 'YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') -- only bring the element if it is 'live' on effective date
WITH READ ONLY
/

COMMENT ON TABLE IMF_NET_NETWORK_MEMBERS IS 'Parent/Child network element relationships [date tracked]';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.PARENT_ELEMENT_ID IS 'Parent Element Id';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.PARENT_ELEMENT_REFERENCE IS 'Parent Element Reference';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.PARENT_ELEMENT_DESCRIPTION IS 'Parent Element Description';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.PARENT_NETWORK_TYPE IS 'Parent Network Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.PARENT_GROUP_TYPE IS 'Parent Group Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.PARENT_ELEMENT_START_DATE IS 'Parent Element Start Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.PARENT_ELEMENT_END_DATE IS 'Parent Element End Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.CHILD_ELEMENT_ID IS 'Child Element Id';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.CHILD_ELEMENT_REFERENCE IS 'Child Element Reference';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.CHILD_ELEMENT_DESCRIPTION IS 'Child Element Description';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.CHILD_NETWORK_TYPE IS 'Child Network Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.CHILD_GROUP_TYPE IS 'Child Group Type';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.CHILD_ELEMENT_START_DATE IS 'Child Element Start Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.CHILD_ELEMENT_END_DATE IS 'Child Element End Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.MEMBERSHIP_START_DATE IS 'Membership Start Date';

COMMENT ON COLUMN IMF_NET_NETWORK_MEMBERS.MEMBERSHIP_END_DATE IS 'Membership End Date';

