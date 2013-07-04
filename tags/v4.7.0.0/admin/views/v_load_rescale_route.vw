CREATE OR REPLACE FORCE VIEW v_load_rescale_route AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_load_rescale_route.vw	1.1 12/10/02
--       Module Name      : v_load_rescale_route.vw
--       Date into SCCS   : 02/12/10 13:57:49
--       Date fetched Out : 07/06/13 17:08:30
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Dummy view used to rescale routes from the CSV loader
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
        ne_unique
       ,ne_nt_type
       ,ne_start_date effective_date
       ,ne_length     start_offset
       ,ne_id         st_element_id
       ,ne_nt_type    use_history
       ,ne_id         ne_id_start
 FROM   nm_elements_all
WHERE   1 = 2
/
