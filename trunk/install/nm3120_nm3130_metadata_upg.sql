-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3120_nm3130_metadata_upg.sql	1.1 08/12/04
--       Module Name      : nm3120_nm3130_metadata_upg.sql
--       Date into SCCS   : 04/08/12 15:51:08
--       Date fetched Out : 07/06/13 13:57:51
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

SET FEEDBACK OFF
--
DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
     Null;
END;
/
----------------------------------------------------------------------------
--Call a proc in nm_debug to instantiate it before calling metadata scripts.
--
--If this is not done any inserts into hig_option_values may fail due to
-- mutating trigger when nm_debug checks DEBUGAUTON.
----------------------------------------------------------------------------
BEGIN
  nm_debug.debug_off;
END;
/

--
-------------------------------------------------------------------------------------------------
--
DECLARE
   --
   -- NM_ERRORS
   --
   l_tab_ner_id    nm3type.tab_number;
   l_tab_ner_descr nm3type.tab_varchar2000;
   l_tab_appl      nm3type.tab_varchar30;
   --
   l_tab_dodgy_ner_id    nm3type.tab_number;
   l_tab_dodgy_ner_appl  nm3type.tab_varchar30;
   l_tab_dodgy_descr_old nm3type.tab_varchar2000;
   l_tab_dodgy_descr_new nm3type.tab_varchar2000;
   --
   l_current_type  nm_errors.ner_appl%TYPE;
   --
   PROCEDURE add_ner (p_ner_id    number
                     ,p_ner_descr varchar2
                     ,p_app       varchar2 DEFAULT l_current_type
                     ) IS
      c_count CONSTANT pls_integer := l_tab_ner_id.COUNT+1;
   BEGIN
      l_tab_ner_id(c_count)    := p_ner_id;
      l_tab_ner_descr(c_count) := p_ner_descr;
      l_tab_appl(c_count)      := p_app;
   END add_ner;
   --
   PROCEDURE add_dodgy (p_ner_id        number
                       ,p_ner_descr_old varchar2
                       ,p_ner_descr_new varchar2
                       ,p_app           varchar2 DEFAULT l_current_type
                       ) IS
      c_count CONSTANT pls_integer := l_tab_dodgy_ner_id.COUNT+1;
   BEGIN
      l_tab_dodgy_ner_id(c_count)    := p_ner_id;
      l_tab_dodgy_descr_old(c_count) := p_ner_descr_old;
      l_tab_dodgy_descr_new(c_count) := NVL(p_ner_descr_new,p_ner_descr_old);
      l_tab_dodgy_ner_appl(c_count)  := p_app;
   END add_dodgy;
   --
BEGIN
   --
   -- HIG errors
   --
   l_current_type := nm3type.c_hig;
   --
   add_ner(232, 'Points are not on same network element');
   add_ner(233, 'No theme data available to determine gtype');
   add_ner(234, 'No suitable PK column for SDE registration' );
   add_ner(235, 'Theme must be consistent for the same session');
   add_ner(236, 'Unknown geometry');
   add_ner(237, 'Dimension not available' );
   add_ner(238, 'Invalid dimension - must be between 2 and 4');
   add_ner(239, 'No data to base diminfo calculation');
   add_ner(240, 'The SRID does not match - please reset the current SRID or use the correct value' );
   add_ner(241, 'No Index on the table and column');
   add_ner(242, 'Already registered in SDO Metadata');
   add_ner(243, 'Needs a Feature table');
   add_ner(244, 'Needs a Feature table spatial column');
   add_ner(245, 'Needs a base theme to dyn-seg from');
   add_ner(246, 'Not enough info on the theme');
   add_ner(247, 'Tolerance cannot be found from point data' );
   add_ner(248, 'Dimension information is incomopatible with operation');
   add_ner(249, 'FT and theme do not match');
   add_ner(250, 'Inventory type is not a foreign table');
   add_ner(251, 'SRID generator failure');
   add_ner(252, 'Table is not registered or SDE schema cannot see it');
   add_ner(253, 'No sde layer for theme');
   add_ner(254, 'Layer not found in SDE metadata');
   add_ner(255, 'Failure in SDE date conversion');
   add_ner(256, 'Failure in date conversion to SDE');
   add_ner(257, 'Object does not exist');   
   
   FORALL i IN 1..l_tab_ner_id.COUNT
      INSERT INTO nm_errors
            (ner_appl
            ,ner_id
            ,ner_descr
            )
      SELECT l_tab_appl(i)
            ,l_tab_ner_id(i)
            ,l_tab_ner_descr(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  nm_errors
                         WHERE  ner_id   = l_tab_ner_id(i)
                          AND   ner_appl = l_tab_appl(i)
                        )
       AND   l_tab_ner_descr(i) IS NOT NULL;
   --
   FORALL i IN 1..l_tab_dodgy_ner_id.COUNT
      UPDATE nm_errors
       SET   ner_descr = l_tab_dodgy_descr_new (i)
      WHERE  ner_id    = l_tab_dodgy_ner_id(i)
       AND   ner_appl  = l_tab_dodgy_ner_appl(i)
       AND   ner_descr = l_tab_dodgy_descr_old(i);
   --
END;
/
--
-------------------------------------------------------------------------------------------------
--

Insert into HIG_OPTION_LIST
   (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
 Values
   ('SDOSURKEY', 'HIG', 'SDO Surrogate Key', 'Register SDO layers with a surrogate primary key', 'Y_OR_N', 'VARCHAR2', 'N');

Insert into HIG_OPTION_VALUES
   (HOV_ID, HOV_VALUE)
 Values
   ('SDOSURKEY', 'Y');

COMMIT;
--
--
--
SET FEEDBACK ON


