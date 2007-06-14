--
-- nm_element_history views for unsplit and unmerge
--
CREATE OR REPLACE FORCE VIEW  v_nm_element_hist_unsplit
( old_ne_id,old_ne_unique,old_ne_descr )
AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
DISTINCT old_ne_id,old_ne_unique,old_ne_descr
 FROM v_nm_element_history
 WHERE neh_operation = 'S'
/

CREATE OR REPLACE FORCE VIEW  v_nm_element_hist_unmerge
( new_ne_id,new_ne_unique,new_ne_descr )
AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
DISTINCT new_ne_id,new_ne_unique,new_ne_descr
 FROM v_nm_element_history
 WHERE neh_operation = 'M'
/


 