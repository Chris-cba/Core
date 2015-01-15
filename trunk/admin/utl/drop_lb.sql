--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/utl/drop_lb.sql-arc   1.2   Jan 15 2015 22:11:42   Rob.Coupe  $
--       Module Name      : $Workfile:   drop_lb.sql  $
--       Date into PVCS   : $Date:   Jan 15 2015 22:11:42  $
--       Date fetched Out : $Modtime:   Jan 15 2015 22:11:14  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : Rob Coupe
--
--   Location Bridge drop script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--


ALTER TABLE LB_TYPES
   DROP PRIMARY KEY CASCADE
/

DROP TABLE LB_TYPES CASCADE CONSTRAINTS
/


DROP TABLE lb_inv_security CASCADE CONSTRAINTS
/


ALTER TABLE NM_ASSET_LOCATIONS_ALL
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_ASSET_LOCATIONS_ALL CASCADE CONSTRAINTS
/

DROP SEQUENCE nal_id_seq
/

DROP SEQUENCE NM_loc_id_seq
/

ALTER TABLE NM_JUXTAPOSITION_TYPES
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_JUXTAPOSITION_TYPES CASCADE CONSTRAINTS
/

ALTER TABLE NM_JUXTAPOSITIONS
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_JUXTAPOSITIONS CASCADE CONSTRAINTS
/


ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_ASSET_TYPE_JUXTAPOSITIONS CASCADE CONSTRAINTS
/

DROP SEQUENCE NLG_ID_SEQ
/

ALTER TABLE NM_LOCATION_GEOMETRY
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_LOCATION_GEOMETRY CASCADE CONSTRAINTS
/

ALTER TABLE NM_LOCATIONS_ALL
   DROP PRIMARY KEY CASCADE
/

DROP TABLE NM_LOCATIONS_ALL CASCADE CONSTRAINTS
/


drop view v_lb_nlt_geometry
/

drop procedure create_nlt_geometry_view
/

drop view v_nm_nlt_data
/

--drop view V_XSP_LIST
--/

drop view v_lb_xsp_list
/

drop view V_NM_NLT_MEASURES
/

drop view V_LB_NLT_REFNTS
/

drop view V_LB_NETWORKTYPES
/

drop view V_LB_INV_NLT_DATA
/

drop view NM_ASSET_LOCATIONS
/

drop view NM_LOCATIONS
/

drop view V_NM_NLT_UNIT_CONVERSIONS
/

drop view v_nm_nlt_refnts
/
