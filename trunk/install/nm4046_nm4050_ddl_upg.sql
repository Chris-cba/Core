------------------------------------------------------------------
-- nm4046_nm4050_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4046_nm4050_ddl_upg.sql-arc   3.0   Aug 08 2008 10:02:36   malexander  $
--       Module Name      : $Workfile:   nm4046_nm4050_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Aug 08 2008 10:02:36  $
--       Date fetched Out : $Modtime:   Aug 08 2008 10:01:22  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
------------------------------------------------------------------


------------------------------------------------------------------

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Change to HIG_PU table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (JAMES WADSWORTH)
-- **** COMMENTS TO BE ADDED BY JWA ****
-- 
------------------------------------------------------------------
ALTER TABLE HIG_PU MODIFY(HPU_PID VARCHAR2(20 BYTE));

 

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Missing Indexes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (JAMES WADSWORTH)
-- Adds the DOC_FK_DMD_IND, DOC_FK_DTP_IND, DOC_FK_HAU_IND and DOC_FK_HUS1_IND indexes
-- 
------------------------------------------------------------------
Declare
  do_nothing exception;
  pragma exception_init(do_nothing,-955);
Begin
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_DMD_IND ON DOCS (DOC_DLC_DMD_ID)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_DTP_IND ON DOCS (DOC_DTP_CODE)');  
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_HAU_IND ON DOCS (DOC_ADMIN_UNIT)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_HUS1_IND ON DOCS (DOC_USER_ID)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
 End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT nm_nw_ad_link_all added columns
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 711748
-- 
-- CUSTOMER
-- Exor Corporation Ltd
-- 
-- PROBLEM
-- These changes are likely to force new forms to be generated due to signature issues.
-- Two new columns on the nm_nw_ad_link_all table should be added as well as changes to the view nm_nw_ad_link (date-tracked view).  They are:
-- 
-- '	NAD_MEMBER_ID		Number(9)
-- '	NAD_WHOLE_ROAD		Varchar2(1)
-- 
-- The whole-road flag should default to 1, ie whole-road ' this allows other data to be manipulated consistently.
-- 
-- A Trigger on the table should be built to populate the member id to be asset id if partial or the road group id if whole-road.
-- 
-- The nm3nsgasd and other packages should be modified accordingly. Creation and edit of the asd record should create the correct value of the whole-road flag.
-- 
-- An upgrade script should be built to populate the whole road from the relevant inventory attribute.
-- 
-- The generation of the members should use this normalized data on the nm_nw_ad_link_all table. The spatial generation of NSG shapes should also use this column. 
-- 
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (PRIIDU TANAVA)
-- This sript adds two columns into NM_NW_AD_LINK_ALL, needed in connection with log 711748. The view NM_NW_AD_LINK needs to be recreated too, this should happen during the standard upgraded process.
-- 
------------------------------------------------------------------
/*
Upgrade script to add de-normalised columns to the nm_nw_ad_link_all table

Author: Rob Coupe, Priidu Tanava
Date:   December 2007

*/


alter table nm_nw_ad_link_all
disable all triggers
/


alter table nm_nw_ad_link_all
add ( nad_whole_road varchar2(1) default '1',
      nad_member_id  number(9) )
/      



update nm_nw_ad_link_all
set nad_member_id = nad_ne_id
  , nad_whole_road = '1'
/

commit;
/

alter table nm_nw_ad_link_all modify (
   nad_whole_road not null
  ,nad_member_id not null
)
/

 

update nm_nw_ad_link_all
set nad_whole_road = '0',
    nad_member_id = nad_iit_ne_id
where exists ( select 1
               from nm_inv_items_all i
               where iit_ne_id = nad_iit_ne_id
               and decode ( iit_inv_type, 'TP21', iit_chr_attrib30, 
                                          'TP22', iit_chr_attrib28,
                                          'TP23', iit_chr_attrib34,
                                          'TP51', iit_chr_attrib30,
                                          'TP52', iit_chr_attrib28,
                                          'TP53', iit_chr_attrib34 ) = '0' )

/

commit;
/



create index nad_member_id_ind on nm_nw_ad_link_all ( nad_member_id )
/



alter table nm_nw_ad_link_all
enable all triggers
/

 

-- end of upgrade


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Increase size of HOV_VALUE
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (JAMES WADSWORTH)
-- Increase in size of the hov_value column on hig_option_values.
-- 
------------------------------------------------------------------
alter table hig_option_values modify hov_value varchar2(500)
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

