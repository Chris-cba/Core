--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/indexes.sql-arc   2.1   Jul 04 2013 13:45:34   James.Wadsworth  $
--       Module Name      : $Workfile:   indexes.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:34  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:15:46  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM SCCS ID Keyword, do no remove
define sccsid = '%W% %G%';

CREATE INDEX NAU_NAT_FK_IND ON NM_ADMIN_UNITS
(
NAU_ADMIN_TYPE
);
CREATE INDEX NE_NT_FK_IND ON NM_ELEMENTS
(
NE_NT_TYPE
);
CREATE INDEX IAD_ID_FK_IND ON NM_INV_ATTRI_LOOKUP
(
IAD_DOMAIN
);
CREATE INDEX IIT_NAU_FK_IND ON NM_INV_ITEMS
(
IIT_ADMIN_UNIT
);
CREATE INDEX IIT_NE_FK_IND ON NM_INV_ITEMS
(
IIT_NE_ID
);
CREATE INDEX IIT_LOCATED_FK_IND ON NM_INV_ITEMS
(
IIT_LOCATED_BY
);
CREATE INDEX IIT_NIT_FK_IND ON NM_INV_ITEMS
(
IIT_INV_TYPE
);
CREATE INDEX NIN_NT_FK_IND ON NM_INV_NW
(
NIN_NW_TYPE
);
CREATE INDEX NIN_NIT_FK_IND ON NM_INV_NW
(
NIN_NIT_INV_CODE
);
CREATE INDEX NIT_NAT_FK_IND ON NM_INV_TYPES
(
NIT_ADMIN_TYPE
);
CREATE INDEX ITA_ID_FK_IND ON NM_INV_TYPE_ATTRIBS
(
ITA_ID_DOMAIN
);
CREATE INDEX ITA_NMU_FK_IND ON NM_INV_TYPE_ATTRIBS
(
ITA_UNITS
);
CREATE INDEX ITA_NIT_FK_IND ON NM_INV_TYPE_ATTRIBS
(
ITA_INV_TYPE
);
CREATE INDEX ITG_NIT_FK_IND ON NM_INV_TYPE_GROUPINGS
(
ITG_INV_TYPE
);
CREATE INDEX ITR_NIT_FK_IND ON NM_INV_TYPE_ROLES
(
ITR_INV_CODE
);
CREATE INDEX NLS_NL_FK_IND ON NM_LAYER_SETS
(
NLS_LAYER_ID
);
CREATE INDEX NN_NNT_FK_IND ON NM_NODES
(
NO_NODE_TYPE
);
CREATE INDEX NN_NP_FK_IND ON NM_NODES
(
NO_NP_ID
);
CREATE INDEX NNU_NN_FK_IND ON NM_NODE_USAGES
(
NNU_NO_NODE_ID
);
CREATE INDEX NNU_NE_FK_IND ON NM_NODE_USAGES
(
NNU_NE_ID
);
CREATE INDEX NNG_NT_FK_IND ON NM_NT_GROUPINGS
(
NNG_NT_TYPE
);
CREATE INDEX NNG_NGT_FK_IND ON NM_NT_GROUPINGS
(
NNG_GROUP_TYPE
);
CREATE INDEX NS_NL_FK_IND ON NM_SHAPES_1
(
NS_LAYER_ID
);
CREATE INDEX NS_NE_FK_IND ON NM_SHAPES_1
(
NS_NE_ID
);
CREATE INDEX NTP_NLT_FK_IND ON NM_TABLE_PARTITIONS
(
NTP_LOC_TYPE
);
CREATE INDEX NTP_NPT_FK_IND ON NM_TABLE_PARTITIONS
(
NTP_PARTITION
);
CREATE INDEX NT_NNT_FK_IND ON NM_TYPES
(
NT_NODE_TYPE
);
CREATE INDEX NT_NAT_FK_IND ON NM_TYPES
(
NT_ADMIN_TYPE
);
CREATE INDEX NTC_NT_FK_IND ON NM_TYPE_COLUMNS
(
NTC_NT_TYPE
);
CREATE INDEX NTL_NL_FK_IND ON NM_TYPE_LAYERS
(
NTL_LAYER_ID
);
CREATE INDEX NSC_NT_FK_IND ON NM_TYPE_SUBCLASS
(
NSC_NW_TYPE
);
CREATE INDEX NWX_NSC_FK_IND ON NM_XSP
(
NWX_NW_TYPE,
NWX_NSC_SUB_CLASS
);
CREATE INDEX XSR_NWX_FK_IND ON XSP_RESTRAINTS
(
XSR_NW_TYPE,
XSR_X_SECT_VALUE,
XSR_SCL_CLASS
);
