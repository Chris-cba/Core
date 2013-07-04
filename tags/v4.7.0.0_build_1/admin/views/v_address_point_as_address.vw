CREATE OR REPLACE FORCE VIEW V_ADDRESS_POINT_AS_ADDRESS
(HAD_ID, HAD_OSAPR, HAD_DEPARTMENT, HAD_PO_BOX, HAD_ORGANISATION, 
 HAD_BUILDING_NO, HAD_SUB_BUILDING_NAME_NO, HAD_BUILDING_NAME, HAD_DEPENDENT_THOROUGHFARE, HAD_THOROUGHFARE, 
 HAD_DOUBLE_DEP_LOCALITY_NAME, HAD_DEPENDENT_LOCALITY_NAME, HAD_POST_TOWN, HAD_COUNTY, HAD_POSTCODE, 
 HAD_XCO, HAD_YCO, HAD_NOTES, HAD_PROPERTY_TYPE)
AS 
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_address_point_as_address.vw	1.1 04/20/06
--       Module Name      : v_address_point_as_address.vw
--       Date into SCCS   : 06/04/20 10:42:28
--       Date fetched Out : 07/06/13 17:08:25
--       SCCS Version     : 1.1
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
SELECT NULL AS had_id,
	   hdp_osapr AS had_osapr, 
	   hdp_department AS had_department, 
	   hdp_po_box AS had_po_box, 
	   hdp_organisation AS had_organisation,   
	   hdp_building_no AS had_building_no,  
	   hdp_sub_building_name_no AS had_sub_building_name_no, 
	   hdp_building_name AS had_building_name, 
	   hdp_dependent_thoroughfare AS had_dependent_thoroughfare, 
	   hdp_thoroughfare AS had_thoroughfare,  
	   hdp_double_dep_locality_name AS had_double_dep_locality_name,  
	   hdp_dependent_locality_name AS had_dependent_locality_name,  
	   hdp_post_town AS had_post_town, 
	   hdp_county AS had_county,  
	   hdp_postcode AS had_postcode,  
	   hdp_xco AS had_xco,  
	   hdp_yco AS had_yco,
	   NULL AS had_notes,
	   NULL AS had_property_type
FROM   hig_address_point;
