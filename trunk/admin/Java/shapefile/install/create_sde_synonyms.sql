SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- SYNONYMS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Public Synonyms
SET TERM OFF
--
SET FEEDBACK ON
--
CREATE OR REPLACE PUBLIC SYNONYM sde_varchar_array FOR sde_varchar_array;
--
CREATE OR REPLACE PUBLIC SYNONYM sde_varchar_2d_array FOR sde_varchar_2d_array;
--
CREATE OR REPLACE PUBLIC SYNONYM sde_where FOR sde_where;
--
CREATE OR REPLACE PUBLIC SYNONYM sde_tables FOR sde_tables;
--
CREATE OR REPLACE PUBLIC SYNONYM sde_registry FOR sde_registry;
--
CREATE OR REPLACE PUBLIC SYNONYM sw_unique_seq_1 FOR sw_unique_seq_1;
--
CREATE OR REPLACE PUBLIC SYNONYM st_unique_seq_1 FOR st_unique_seq_1;
--
CREATE OR REPLACE PUBLIC SYNONYM sde_util FOR sde_util;
--
SET FEEDBACK OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
