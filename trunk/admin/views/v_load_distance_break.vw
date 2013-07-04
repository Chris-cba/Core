CREATE OR REPLACE FORCE VIEW v_load_distance_break AS
SELECT
--   SCCS Identifiers :-
--
--       sccsid           : @(#)v_load_distance_break.vw	1.1 12/10/02
--       Module Name      : v_load_distance_break.vw
--       Date into SCCS   : 02/12/10 13:58:19
--       Date fetched Out : 07/06/13 17:08:26
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Dummy view used to load distance breaks from the CSV loader
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
        ne_unique
       ,ne_nt_type
       ,ne_no_start
       ,ne_no_end
       ,ne_start_date
       ,ne_length
 FROM   nm_elements_all
WHERE   1 = 2
/
