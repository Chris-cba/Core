CREATE OR REPLACE FORCE VIEW v_load_resize_route AS 
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_load_resize_route.vw	1.3 01/11/07
--       Module Name      : v_load_resize_route.vw
--       Date into SCCS   : 07/01/11 16:40:12
--       Date fetched Out : 07/06/13 17:08:31
--       SCCS Version     : 1.3
--
--   Author : Kevin Angus
--
--   Dummy view used to resize routes from the CSV loader.
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------
        ne_unique
       ,ne_nt_type
       ,ne_length     new_length
       ,ne_id         ne_id_start
 FROM   nm_elements_all
WHERE   1 = 2
/
