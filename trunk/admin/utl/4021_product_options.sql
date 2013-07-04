--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/4021_product_options.sql-arc   3.1   Jul 04 2013 10:29:56   James.Wadsworth  $
--       Module Name      : $Workfile:   4021_product_options.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:18:42  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--


delete from hig_option_values
where hov_id = 'SDOUSEQT';
 
delete from hig_option_values
where hov_id = 'SDOQTTILES';
 
delete from hig_option_list
where hol_id = 'SDOUSEQT';

delete from hig_option_list
where hol_id = 'SDOQTTILES';
 

insert into hig_option_list
(hol_id, hol_product, hol_name, hol_remarks, hol_domain)
values
('SDOUSEQT', 'NET', 'QUAD TREES', 'USE QUADTREES BY DEFAULT IF SET TO Y', NULL );

insert into hig_option_list
(hol_id, hol_product, hol_name, hol_remarks, hol_domain)
values
('SDOQTTILES', 'NET', 'QT TILE', 'QUADTREE TILE SIZE', NULL );


insert into hig_option_values
(hov_id, hov_value )
values 
('SDOUSEQT', 'Y' ); 

insert into hig_option_values
(hov_id, hov_value )
values 
('SDOQTTILES', '6' ); 

commit;




