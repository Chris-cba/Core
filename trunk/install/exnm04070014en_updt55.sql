/* Formatted on 11/07/2018 22:06:11 (QP5 v5.326) */
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/exnm04070014en_updt55.sql-arc   1.0   Jul 30 2018 15:20:34   Rob.Coupe  $
--       Module Name      : $Workfile:   exnm04070014en_updt55.sql  $
--       Date into PVCS   : $Date:   Jul 30 2018 15:20:34  $
--       Date fetched Out : $Modtime:   Jul 30 2018 13:40:22  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Grab date/time to append to log file name
--
UNDEFINE log_extension
COL log_extension NEW_VALUE log_extension NOPRINT
SET TERM OFF

SELECT TO_CHAR (SYSDATE, 'DDMONYYYY_HH24MISS') || '.LOG'     log_extension
  FROM DUAL
/

SET TERM ON
--
--------------------------------------------------------------------------------
--
-- Spool to Logfile
--
DEFINE logfile1 = 'nm_4700_fix55_&log_extension'
SPOOL &logfile1
--
--------------------------------------------------------------------------------
--

SELECT 'Fix Date ' || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;

--

SELECT    'Install Running on '
       || LOWER (USER || '@' || instance_name || '.' || host_name)
       || ' - DB ver : '
       || version
  FROM v$instance;

--

SELECT 'Current version of ' || hpr_product || ' ' || hpr_version
  FROM hig_products
 WHERE hpr_product IN ('HIG', 'NET');

--
--------------------------------------------------------------------------------
-- 	Check(s)
--------------------------------------------------------------------------------
--
WHENEVER SQLERROR EXIT
--

DECLARE
    --
    l_dummy_c1          VARCHAR2 (1);
    incorrect_version   EXCEPTION;
    PRAGMA EXCEPTION_INIT (incorrect_version, -20000);
--
BEGIN
    --
    --  Check that the user isn't sys or system
    --
    IF USER IN ('SYS', 'SYSTEM')
    THEN
        RAISE_APPLICATION_ERROR (
            -20000,
            'You cannot install this product as ' || USER);
    END IF;

    --
    --  Check that HIG has been installed @ v4.7.0.x
    --  begin
    HIG2.PRODUCT_EXISTS_AT_VERSION (p_product => 'HIG', p_VERSION => '4.7.0.0');
EXCEPTION
    WHEN incorrect_version
    THEN
        BEGIN
            HIG2.PRODUCT_EXISTS_AT_VERSION (p_product   => 'HIG',
                                            p_VERSION   => '4.8.0.0');
        EXCEPTION
            WHEN incorrect_version
            THEN
                raise_application_error (
                    -20000,
                    'Exor must be installed at version 4.7 or 4.8');
        END;
--

END;
/

DECLARE
    n   VARCHAR2 (10);
BEGIN
    SELECT hpr_version
      INTO n
      FROM Hig_Products
     WHERE     Hpr_Product = 'LB'
           AND hpr_version IN ('4.2',
                               '4,3',
                               '4.4',
                               '4.5',
                               '4.7.0.0',
                               '4.7.0.1',
                               '4.7.0.2',
                               '4.7.0.3',
                               '4.7.0.4',
                               '4.7.0.5',
                               '4.7.0.6',
                               '4.7.0.7',
							   '4.7.0.8');

    UPDATE Hig_Products
       SET hpr_version = '4.7.0.8'
     WHERE Hpr_product = 'LB';
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        DECLARE
            lb_get_version   VARCHAR2 (20);
        BEGIN
            DECLARE
                lb_get_status   VARCHAR2 (30);
            BEGIN
                SELECT status
                  INTO lb_get_status
                  FROM user_objects
                 WHERE     object_name = 'LB_GET'
                       AND object_type = 'PACKAGE_BODY';

                --
                IF lb_get_status = 'INVALID'
                THEN
                    EXECUTE IMMEDIATE 'Alter package lb_get compile body';
                END IF;
            --
            EXCEPTION
                WHEN OTHERS
                THEN
                    raise_application_error (-20003,
                                             'Problems in the status of LB');
            END;

            --
            SELECT lb_get.get_version INTO lb_get_version FROM DUAL;

            --    if lb_get_version = '1.6' then
            --  LB is installed, add the product code
            BEGIN
                INSERT INTO hig_products (hpr_product,
                                          hpr_product_name,
                                          hpr_version,
                                          hpr_key,
                                          hpr_sequence)
                     VALUES ('LB',
                             'Location Bridge',
                             '4.7.0.8',
                             '76',
                             99);
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                    UPDATE hig_products
                       SET hpr_version = '4.7.0.8'
                     WHERE hpr_product = 'LB';
            END;
        --    else
        --      raise_application_error( -20001, 'LB packages are at an incorrect state for this upgrade');
        --    end if;
        --
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                raise_application_error (
                    -20002,
                    'LB has not been installed, please install prior to upgrade');
            WHEN OTHERS
            THEN
                raise_application_error (
                    -20004,
                       'There seems a problem with the LB code, please re-compile prior to running this upgrade '
                    || SQLERRM);
        END;
END;
/


PROMPT Checking the status (if any) of fix 56

-- Note that we expect the remarks to either be there or have a numeric after the build string.

Select '***   Build 2 of Exor core fix 56 (exnm04070002en_updt56 or later) must be installed for consistency of network edits   ***'
from dual where not exists ( select 1 from hig_upgrades
where hup_product = 'NET' and remarks like 'NET 4700 FIX 56 Build%'
and to_number(substr( remarks, instr(remarks, 'Build ')+6, 10)) > 1);

WHENEVER SQLERROR CONTINUE
--
PROMPT Function to remove any transient types that prevent refresh

create or replace procedure drop_transient_types (p_type in varchar2 ) is
  cursor c1 is select name from user_dependencies
  where referenced_name = p_type
  and type = 'TYPE'
  and name like 'SYSTP%==';
begin
  for irec in c1 loop
    execute immediate 'drop type "'||irec.name||'"';
  end loop;
end;
/

prompt Transaction_ID sequence

declare
  already_exists exception;
  pragma exception_init (already_exists, -955 );
begin
  execute immediate 'create sequence LB_TRANSACTION_ID_SEQ start with 1';
exception
  when already_exists then NULL;
end;
/

begin
NM3DDL.CREATE_SYNONYM_FOR_OBJECT('LB_TRANSACTION_ID_SEQ');
end;
/

--
PROMPT improved key structure on unit translation table

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -2261);
    dupl_found       EXCEPTION;
    PRAGMA EXCEPTION_INIT (dupl_found, -2299);
BEGIN
    EXECUTE IMMEDIATE 'alter table lb_units add constraint lb_units_uk2 UNIQUE ( exor_unit_id) ';
EXCEPTION
    WHEN already_exists
    THEN
        NULL;
    WHEN dupl_found
    THEN
        raise_application_error (
            -20001,
            ' The LB_UNITS table has dulicate copies of an Exor unit ID. Please remove the duplicates prior to execution ');
END;
/

PROMPT adjustment to asset-geometry index

ALTER TABLE nm_asset_geometry_all
    DROP CONSTRAINT nag_uk;

DROP INDEX NAG_ASSET_IDX;

CREATE UNIQUE INDEX NAG_ASSET_IDX
    ON NM_ASSET_GEOMETRY_ALL (NAG_ASSET_ID,
                              NAG_OBJ_TYPE,
                              NAG_START_DATE,
                              NAG_LOCATION_TYPE,
                              NAG_END_DATE);


ALTER TABLE nm_asset_geometry_all
    ADD CONSTRAINT NAG_UK UNIQUE (NAG_ASSET_ID,
                                  NAG_OBJ_TYPE,
                                  NAG_START_DATE,
                                  NAG_LOCATION_TYPE,
                                  NAG_END_DATE)
            USING INDEX NAG_ASSET_IDX;
            
     
PROMPT Table for network edit transactions

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -955);
BEGIN
    EXECUTE IMMEDIATE   'CREATE TABLE LB_ELEMENT_HISTORY '
                     || ' ( '
                     || '   TRANSACTION_ID        INTEGER                 NOT NULL, '
                     || '  NEH_ID                INTEGER, '
                     || '   PRIOR_TRANSACTION_ID  INTEGER '
                     || ' ) ';
EXCEPTION
    WHEN already_exists
    THEN
        NULL;
END;
/

PROMPT constraints ....

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -2275);
BEGIN
    EXECUTE IMMEDIATE   'ALTER TABLE LB_ELEMENT_HISTORY ADD  '
                     || '  CONSTRAINT lb_trans_neh_fk '
                     || ' FOREIGN KEY (NEH_ID) '
                     || ' REFERENCES NM_ELEMENT_HISTORY (NEH_ID) ON DELETE CASCADE'
                     || ' ENABLE '
                     || ' VALIDATE ';
EXCEPTION
    WHEN already_exists
    THEN
        EXECUTE IMMEDIATE 'ALTER TABLE LB_ELEMENT_HISTORY drop constraint LB_TRANS_NEH_FK';
--  
    EXECUTE IMMEDIATE   'ALTER TABLE LB_ELEMENT_HISTORY ADD  '
                     || '  CONSTRAINT lb_trans_neh_fk '
                     || ' FOREIGN KEY (NEH_ID) '
                     || ' REFERENCES NM_ELEMENT_HISTORY (NEH_ID) ON DELETE CASCADE'
                     || ' ENABLE '
                     || ' VALIDATE ';      
END;
/

PROMPT indexes - lb_trans_idx1

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -955);
BEGIN
    EXECUTE IMMEDIATE   'CREATE INDEX lb_trans_idx1 ON LB_ELEMENT_HISTORY '
                     || ' (TRANSACTION_ID, NEH_ID)';
EXCEPTION
    WHEN already_exists
    THEN
        NULL;
END;
/

PROMPT indexes - lb_trans_idx2

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -955);
BEGIN
    EXECUTE IMMEDIATE   'CREATE INDEX lb_trans_idx2 ON LB_ELEMENT_HISTORY '
                     || ' (NEH_ID) ';
EXCEPTION
    WHEN already_exists
    THEN
        NULL;
END;
/

PROMPT indexes - lb_trans_idx3

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -955);
BEGIN
    EXECUTE IMMEDIATE   'CREATE INDEX lb_trans_idx3 ON LB_ELEMENT_HISTORY '
                     || ' (PRIOR_TRANSACTION_ID, TRANSACTION_ID) ';
EXCEPTION
    WHEN already_exists
    THEN
        NULL;
END;
/


PROMPT Types...
PROMPT lb_edit_transaction...


DECLARE
    l_dummy          INTEGER;
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -2303);
BEGIN
    SELECT 1
      INTO l_dummy
      FROM user_types
     WHERE type_name = 'LB_EDIT_TRANSACTION';
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        EXECUTE IMMEDIATE   'CREATE OR REPLACE TYPE lb_edit_transaction as object '
                         || ' ( t_edit_id integer, '
                         || '   t_old_ne integer,  '
                         || '   t_new_ne integer,  '
                         || '   t_op varchar2(1),  '
                         || '   t_date date,  '
                         || '   t_old_len number, '
                         || '   t_new_len number, '
                         || '   t_p1 integer, '
                         || '   t_p2 integer, '
                         || '   t_id integer, '
                         || '   prior_t_id integer ) ';
    --
    WHEN already_exists
    THEN
        NULL;
END;
/

PROMPT lb_edit_transaction_tab...

CREATE OR REPLACE TYPE lb_edit_transaction_tab
    AS TABLE OF lb_edit_transaction
/

PROMPT lb_snap...

declare
not_exists exception;
pragma exception_init(not_exists, -4043);
begin
   begin
      execute immediate 'drop type lb_snap_tab';
   exception
      when not_exists then NULL;
   end;
--   
   begin
      execute immediate 'drop type lb_snap';
   exception
      when not_exists then NULL;
   end;
end;
/


start .\admin\typ\lb_snap.tyh;
   
PROMPT lb_snap_tab...

begin
   execute immediate 'CREATE OR REPLACE TYPE lb_snap_tab AS TABLE OF lb_snap';
end;
/

PROMPT Exor core change to the INT_ARRAY type

DROP TYPE INT_ARRAY FORCE;

START .\admin\typ\int_array.tyh;

START .\admin\typ\int_array.tyb;

begin
  execute immediate 'alter package nm3sdm compile';
end;
/

PROMPT Juxtaposition integrity

DECLARE
    max_value        INTEGER := 1;

    CURSOR c1 IS
        SELECT con.table_name, con.constraint_name, col.column_name
          FROM user_constraints con, user_cons_columns col
         WHERE     con.table_name IN
                       ('NM_ASSET_TYPE_JUXTAPOSITIONS',
                        'NM_JUXTAPOSITIONS',
                        'NM_JUXTAPOSITION_TYPES')
               AND con.constraint_type = 'P'
               AND col.constraint_name = con.constraint_name;

    --
    ALREADY_EXISTS   EXCEPTION;
    PRAGMA EXCEPTION_INIT (ALREADY_EXISTS, -955);
BEGIN
    FOR irec IN c1
    LOOP
        BEGIN
            EXECUTE IMMEDIATE   'select max('
                             || irec.column_name
                             || ') from '
                             || irec.table_name
                INTO max_value;

            max_value := NVL (max_value, 1);
            --
            nm_debug.debug (
                   'select max('
                || irec.column_name
                || ') from '
                || irec.table_name);
            nm_debug.debug ('max value = ' || max_value);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                max_value := 1;
        END;

        --
        BEGIN
            IF NM3DDL.DOES_OBJECT_EXIST (irec.column_name || '_SEQ')
            THEN
                EXECUTE IMMEDIATE   'drop sequence '
                                 || irec.column_name
                                 || '_SEQ ';
            END IF;

            --
            EXECUTE IMMEDIATE   'create sequence '
                             || irec.column_name
                             || '_SEQ start with '
                             || TO_CHAR (max_value);
        END;
    --
    END LOOP;
END;
/

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -2261);
BEGIN
    EXECUTE IMMEDIATE   ' ALTER TABLE NM_JUXTAPOSITIONS ADD '
                     || ' CONSTRAINT njx_uk '
                     || ' UNIQUE (NJX_NJXT_ID, NJX_CODE) '
                     || ' ENABLE '
                     || ' VALIDATE';
EXCEPTION
    WHEN already_exists
    THEN
        NULL;
END;
/

DECLARE
    already_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (already_exists, -2275);
BEGIN
    EXECUTE IMMEDIATE   'ALTER TABLE NM_ASSET_TYPE_JUXTAPOSITIONS '
                     || ' ADD CONSTRAINT NAJX_NJXT_FK '
                     || ' FOREIGN KEY (NAJX_NJXT_ID) '
                     || ' REFERENCES NM_JUXTAPOSITION_TYPES (NJXT_ID) '
                     || ' ENABLE '
                     || ' VALIDATE';
EXCEPTION
    WHEN already_exists
    THEN
        NULL;
END;
/


------------------------------------------------object-name changes -------------------------------------

PROMPT Change of name of objects

DECLARE
    not_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (not_exists, -4043);

    CURSOR c1 IS
          SELECT type_name, typecode
            FROM dba_types
           WHERE     owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                 AND type_name IN ('LINEAR_ELEMENT_TYPES',
                                   'LINEAR_ELEMENT_TYPE',
                                   'LINEAR_LOCATION',
                                   'LINEAR_LOCATIONS')
        ORDER BY typecode;
BEGIN
    FOR irec IN c1
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'drop type ' || irec.type_name || ' FORCE';
        EXCEPTION
            WHEN not_exists
            THEN
                NULL;
        END;
    END LOOP;
END;
/

DECLARE
    not_exists   EXCEPTION;
    PRAGMA EXCEPTION_INIT (not_exists, -4043);
    CURSOR c1 IS
          SELECT synonym_name
            FROM all_synonyms
           WHERE     table_owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                 AND synonym_name in ('LINEAR_ELEMENT_TYPES',
                                   'LINEAR_ELEMENT_TYPE',
                                   'LINEAR_LOCATION',
                                   'LINEAR_LOCATIONS');
BEGIN
    FOR irec IN c1
    LOOP
        BEGIN
            nm3ddl.drop_synonym_for_object(irec.synonym_name);
        EXCEPTION
            WHEN not_exists
            THEN
                NULL;
        END;
    END LOOP;
END;
/

DECLARE
    l_dummy   INTEGER;
BEGIN
    DECLARE
        not_exists   EXCEPTION;
        PRAGMA EXCEPTION_INIT (not_exists, -4043);
    BEGIN
        EXECUTE IMMEDIATE 'DROP TYPE LB_LINEAR_LOCATIONS';
    EXCEPTION
        WHEN not_exists
        THEN
            NULL;
    END;

    --
    EXECUTE IMMEDIATE   'CREATE OR REPLACE '
                     || CHR (13)
                     || CHR (10)
                     || ' TYPE LB_LINEAR_LOCATION AS OBJECT( '
                     || CHR (13)
                     || CHR (10)
                     || '    AssetId             NUMBER(38),    -- ID of the linearly located asset '
                     || CHR (13)
                     || CHR (10)
                     || '    AssetType           NUMBER(38),    -- Type of the asset '
                     || CHR (13)
                     || CHR (10)
                     || '    LocationId          NUMBER(38),    -- ID of the linear location '
                     || CHR (13)
                     || CHR (10)
                     || '    LocationDescription VARCHAR2(240), -- Linear location description '
                     || CHR (13)
                     || CHR (10)
                     || '    NetworkTypeId       INTEGER,       -- Network element type '
                     || CHR (13)
                     || CHR (10)
                     || '    NetworkElementId    INTEGER,       -- Network element ID '
                     || CHR (13)
                     || CHR (10)
                     || '    StartM              NUMBER,        -- Absolute position of start of linear range '
                     || CHR (13)
                     || CHR (10)
                     || '    EndM                NUMBER,        -- Optional absolute position of end of linear range '
                     || CHR (13)
                     || CHR (10)
                     || '    Unit                INTEGER,       -- Exor ID of Units of start and end position '
                     || CHR (13)
                     || CHR (10)
                     || '    NetworkElementName  VARCHAR2(30),  -- Network element unique name '
                     || CHR (13)
                     || CHR (10)
                     || '    NetworkElementDescr VARCHAR2(240), -- Optional network element description '
                     || CHR (13)
                     || CHR (10)
                     || '    JXP                 VARCHAR2(80), -- Juxtaposition of owning linear location '
                     || CHR (13)
                     || CHR (10)
                     || '    StartDate           DATE,          -- Start date of the asset location '
                     || CHR (13)
                     || CHR (10)
                     || '    EndDate             DATE           -- End date of the asset location '
                     || CHR (13)
                     || CHR (10)
                     || ')';
END;
/


DECLARE
    l_dummy   INTEGER;
BEGIN
    DECLARE
        not_exists   EXCEPTION;
        PRAGMA EXCEPTION_INIT (not_exists, -4043);
    BEGIN
        EXECUTE IMMEDIATE 'drop type LB_LINEAR_ELEMENT_TYPES';
    EXCEPTION
        WHEN not_exists
        THEN
            NULL;
    END;

    --
    EXECUTE IMMEDIATE   'CREATE OR REPLACE '
                     || CHR (13)
                     || CHR (10)
                     || 'TYPE LB_LINEAR_ELEMENT_TYPE  AS OBJECT( '
                     || CHR (13)
                     || CHR (10)
                     || '   linearlyLocatableType  NUMBER,        -- ID of a linearly locatable type '
                     || CHR (13)
                     || CHR (10)
                     || '   linearElementTypeId    NUMBER,        -- ID of the linear element type '
                     || CHR (13)
                     || CHR (10)
                     || '   linearElementTypeName  VARCHAR2(30),  -- Unique name of the linear element type '
                     || CHR (13)
                     || CHR (10)
                     || '   linearElementTypeDescr VARCHAR2(80),  -- Optional description of the linear element type '
                     || CHR (13)
                     || CHR (10)
                     || '   lengthUnit             VARCHAR2(20) -- Default length unit '
                     || CHR (13)
                     || CHR (10)
                     || ')';
END;
/


CREATE OR REPLACE TYPE LB_LINEAR_ELEMENT_TYPES
    AS TABLE OF lb_linear_element_type;
/


CREATE OR REPLACE TYPE LB_LINEAR_LOCATIONS AS TABLE OF lb_linear_location;
/

UPDATE lb_objects
   SET object_name = 'LB_' || object_name
 WHERE object_name IN ('LINEAR_ELEMENT_TYPES',
                       'LINEAR_ELEMENT_TYPE',
                       'LINEAR_LOCATION',
                       'LINEAR_LOCATIONS')
/

UPDATE lb_objects
   SET object_name = 'LB_' || SUBSTR (object_name, 3)
 WHERE object_name IN ('L_LINEAR_ELEMENT_TYPES',
                       'L_LINEAR_ELEMENT_TYPE',
                       'L_LINEAR_LOCATION',
                       'L_LINEAR_LOCATIONS')
/

PROMPT Object to retrieve and aggregate locations with XSP

DECLARE
    l_dummy   INTEGER;
BEGIN
    DECLARE
        not_exists   EXCEPTION;
        PRAGMA EXCEPTION_INIT (not_exists, -4043);
    BEGIN
        EXECUTE IMMEDIATE 'drop type LB_XRPT_TAB';
        drop_transient_types('LB_XRPT_TAB');
        drop_transient_types('LB_XRPT');
    EXCEPTION
        WHEN not_exists
        THEN
            NULL;
    END;

    --
    EXECUTE IMMEDIATE   'CREATE OR REPLACE '
                     || CHR (13)
                     || CHR (10)
                     || 'TYPE LB_XRPT as object ( '
                     || CHR (13)
                     || CHR (10)
                     || '   refnt integer, '
                     || CHR (13)
                     || CHR (10)
                     || '   refnt_type integer, '
                     || CHR (13)
                     || CHR (10)
                     || '   obj_type varchar2(4), '
                     || CHR (13)
                     || CHR (10)
                     || '   obj_id integer, '
                     || CHR (13)
                     || CHR (10)
                     || '   seg_id integer, '
                     || CHR (13)
                     || CHR (10)
                     || '   seq_id integer, '
                     || CHR (13)
                     || CHR (10)
                     || '   dir_flag integer, '
                     || CHR (13)
                     || CHR (10)
                     || '   start_m number, '
                     || CHR (13)
                     || CHR (10)
                     || '   end_m number, '
                     || CHR (13)
                     || CHR (10)
                     || '   m_unit integer, '
                     || CHR (13)
                     || CHR (10)
                     || '   xsp varchar2(4), '
                     || CHR (13)
                     || CHR (10)
                     || '   offset number, '
                     || CHR (13)
                     || CHR (10)
                     || '   start_date date, '
                     || CHR (13)
                     || CHR (10)
                     || '   end_date date  '
                     || CHR (13)
                     || CHR (10)
                     || ')';
END;
/

CREATE OR REPLACE TYPE lb_xrpt_tab AS TABLE OF lb_xrpt;
/

PROMPT function changes after rename...

START .\admin\eB_Interface\GetAssetLinearLocationsTab.fnc

START .\admin\eB_Interface\GetLinearElementTypes.prc

START .\admin\eB_Interface\GetNetworkLinearLocationsTab.fnc

START .\admin\eB_Interface\GetAssetLinearLocations.fnc

START .\admin\eB_Interface\GetNetworkLinearLocations.fnc

------------------------------------------------end of impact of object-name changes -------------------------------------

PROMPT Triggers...

START .\admin\trg\najx_id_seq_trg.trg;

START .\admin\trg\nal_asset_locations_all_who.trg;

START .\admin\trg\nal_jxp_validtion.trg;

START .\admin\trg\njxt_id_seq_trg.trg;

START .\admin\trg\njx_id_seq_trg.trg;

START .\admin\trg\nm_asset_geometry_all_trg.trg;

START .\admin\trg\nm_location_geometry_trg.trg;

START .\admin\trg\nm_loc_id_seq_usage_who.trg;

PROMPT Views...

START .\admin\eB_Interface\v_network_types.sql

START .\admin\eB_Interface\v_network_elements.sql

START .\admin\views\nm_locations_full.vw

START .\admin\views\views.sql

START .\admin\views\v_nm_nlt_data.vw;

START .\admin\views\v_nm_datum_themes.vw;

START .\admin\views\V_LB_PATH_BETWEEN_POINTS.vw;

START .\admin\pck\create_nlt_geometry_view.prc;


BEGIN
    create_nlt_geometry_view;
END;
/

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_LB_NLT_GEOMETRY2', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_LB_NLT_GEOMETRY2'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_LB_TYPE_NW_FLAGS', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_LB_TYPE_NW_FLAGS'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_NM_DATUM_THEMES', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_NM_DATUM_THEMES'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_NLT_XSPS', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE object_name = 'V_NLT_XSPS' AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_NLT_ELEMENT_XSPS', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_NLT_ELEMENT_XSPS'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_NLT_XSP_RVRS', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_NLT_XSP_RVRS'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_NM_ELEMENT_XSP', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_NM_ELEMENT_XSP'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_NM_ELEMENT_XSP_RVRS', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_NM_ELEMENT_XSP_RVRS'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'V_NM_ELEMENT_XSP_RVRS', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'V_NM_ELEMENT_XSP_RVRS'
                       AND object_type = 'VIEW');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'LB_XRPT', 'TYPE'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE object_name = 'LB_XRPT' AND object_type = 'TYPE');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'LB_XRPT_TAB', 'TYPE'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE object_name = 'LB_XRPT_TAB' AND object_type = 'TYPE');

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'NM_LOCATIONS_FULL', 'VIEW'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE     object_name = 'NM_LOCATIONS_FULL'
                       AND object_type = 'VIEW');

PROMPT Package Headers ...

PROMPT package lb_ref.pkh

START .\admin\pck\lb_ref.pkh;

PROMPT package lb_ops.pkh

START .\admin\pck\lb_ops.pkh;

PROMPT package lb_reg.pkh

START .\admin\pck\lb_reg.pkh;

PROMPT package lb_get.pkh

START .\admin\pck\lb_get.pkh;

PROMPT package lb_load.pkh

START .\admin\pck\lb_load.pkh;

PROMPT package lb_loc.pkh

START .\admin\pck\lb_loc.pkh;

PROMPT package lb_nw_edit.pkh

START .\admin\pck\lb_nw_edit.pkh;

PROMPT package lb_path_reg.pkh

START .\admin\pck\lb_path_reg.pkh;

PROMPT package lb_path.pkh

START .\admin\pck\lb_path.pkh;

PROMPT package lb_net_code.pkh

START .\admin\pck\lb_net_code.pkh;

--
PROMPT Package Bodies ...

PROMPT package lb_ref.pkb

START .\admin\pck\lb_ref.pkb;

PROMPT package lb_ops.pkb

START .\admin\pck\lb_ops.pkb;

PROMPT package lb_reg.pkb

START .\admin\pck\lb_reg.pkb;

PROMPT package lb_get.pkb

START .\admin\pck\lb_get.pkb;

PROMPT package lb_load.pkb

START .\admin\pck\lb_load.pkb;

PROMPT package lb_loc.pkb

START .\admin\pck\lb_loc.pkb;

PROMPT package lb_nw_edit.pkb

START .\admin\pck\lb_nw_edit.pkb;

PROMPT package lb_path_reg.pkb

START .\admin\pck\lb_path_reg.pkb;

--defer changes to lb_path until after nw tables are created

PROMPT package lb_net_code.pkb

START .\admin\pck\lb_net_code.pkb;

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'LB_SNAP', 'TYPE'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE object_name = 'LB_SNAP' AND object_type = 'TYPE');
/

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'LB_SNAP_TAB', 'TYPE'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE object_name = 'LB_SNAP_TAB' AND object_type = 'TYPE');
/

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'LB_NET_CODE', 'PACKAGE'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE object_name = 'LB_NET_CODE' AND object_type = 'PACKAGE');
/

INSERT INTO lb_objects (object_name, object_type)
    SELECT 'LB_NET_CODE', 'PACKAGE BODY'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM lb_objects
                 WHERE object_name = 'LB_NET_CODE' AND object_type = 'PACKAGE BODY');
/



START .\admin\eB_Interface\UpdateLinearLocation.prc

START .\admin\eB_Interface\CreateLinearRange.prc


PROMPT Creating synonyms

DECLARE
    CURSOR c1 IS
        SELECT *
          FROM lb_objects l
         WHERE object_type IN ('PACKAGE',
                               'TABLE',
                               'VIEW',
                               'PROCEDURE',
                               'SEQUENCE',
                               'TYPE',
                               'FUNCTION');
BEGIN
    IF NVL (hig.get_sysopt ('HIGPUBSYN'), 'Y') = 'Y'
    THEN
        FOR irec IN c1
        LOOP
            NM3DDL.CREATE_SYNONYM_FOR_OBJECT (irec.object_name, 'PUBLIC');
        END LOOP;
    ELSE
        NM3DDL.REFRESH_PRIVATE_SYNONYMS;
    END IF;
END;
/

PROMPT upgrades for dynamic network graph generation and path calculations
--
PROMPT drop existing graph metadata

BEGIN
    FOR irec IN (SELECT * FROM user_sdo_network_metadata)
    LOOP
        LB_PATH_REG.DROP_NETWORK (irec.network);
    END LOOP;
END;
/

--
--
PROMPT create LB_NETWORK metadata

INSERT INTO user_sdo_network_metadata (network,
                                       network_id,
                                       network_category,
                                       no_of_hierarchy_levels,
                                       no_of_partitions,
                                       node_table_name,
                                       node_cost_column,
                                       link_table_name,
                                       link_direction,
                                       link_cost_column,
                                       path_table_name,
                                       path_link_table_name,
                                       subpath_table_name)
     VALUES ('LB_NETWORK',
             1,
             'LOGICAL',
             1,
             0,
             'LB_NETWORK_NO',
             'XNO_COST',
             'LB_NETWORK_LINK',
             'UNDIRECTED',
             'XNW_COST',
             'LB_NETWORK_PATH',
             'LB_NETWORK_PATH_LINK',
             'LB_NETWORK_SUB_PATH');

--

PROMPT Create LB_NETWORK objects

CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_LINK
(
    LINK_ID          NUMBER,
    LINK_NAME        VARCHAR2 (200),
    START_NODE_ID    NUMBER NOT NULL,
    END_NODE_ID      NUMBER NOT NULL,
    LINK_TYPE        VARCHAR2 (200),
    ACTIVE           VARCHAR2 (1),
    LINK_LEVEL       NUMBER,
    XNW_COST         NUMBER
)
/


BEGIN
    NM3DDL.CREATE_SYNONYM_FOR_OBJECT ('LB_NETWORK_LINK');
END;
/


ALTER TABLE LB_NETWORK_LINK
    ADD (PRIMARY KEY (LINK_ID) USING INDEX ENABLE VALIDATE);


CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_NO
(
    NODE_ID         NUMBER,
    NODE_NAME       VARCHAR2 (200 BYTE),
    NODE_TYPE       VARCHAR2 (200 BYTE),
    ACTIVE          VARCHAR2 (1 BYTE),
    PARTITION_ID    NUMBER,
    XNO_COST        NUMBER
)
/

BEGIN
    nm3ddl.create_synonym_for_object ('LB_NETWORK_NO');
END;
/


ALTER TABLE LB_NETWORK_NO
    ADD (PRIMARY KEY (NODE_ID) USING INDEX ENABLE VALIDATE);

CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_PATH
(
    PATH_ID          NUMBER,
    PATH_NAME        VARCHAR2 (200 BYTE),
    PATH_TYPE        VARCHAR2 (200 BYTE),
    START_NODE_ID    NUMBER NOT NULL,
    END_NODE_ID      NUMBER NOT NULL,
    COST             NUMBER,
    SIMPLE           VARCHAR2 (1 BYTE)
)
/

BEGIN
    NM3DDL.CREATE_SYNONYM_FOR_OBJECT ('LB_NETWORK_PATH');
END;
/



ALTER TABLE LB_NETWORK_PATH
    ADD (PRIMARY KEY (PATH_ID) USING INDEX ENABLE VALIDATE);



CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_PATH_LINK
(
    PATH_ID    NUMBER NOT NULL,
    LINK_ID    NUMBER NOT NULL,
    SEQ_NO     NUMBER
)
/

BEGIN
    NM3DDL.CREATE_SYNONYM_FOR_OBJECT ('LB_NETWORK_PATH_LINK');
END;
/

CREATE INDEX LB_NETWORK_PATH_LINK_IDX$
    ON LB_NETWORK_PATH_LINK (PATH_ID)
/

ALTER TABLE LB_NETWORK_PATH_LINK
    ADD (PRIMARY KEY (PATH_ID, LINK_ID, SEQ_NO) USING INDEX ENABLE VALIDATE);


CREATE GLOBAL TEMPORARY TABLE LB_NETWORK_SUB_PATH
(
    SUBPATH_ID           NUMBER,
    SUBPATH_NAME         VARCHAR2 (200 BYTE),
    SUBPATH_TYPE         VARCHAR2 (200 BYTE),
    REFERENCE_PATH_ID    NUMBER NOT NULL,
    START_LINK_INDEX     NUMBER NOT NULL,
    END_LINK_INDEX       NUMBER NOT NULL,
    START_PERCENTAGE     NUMBER NOT NULL,
    END_PERCENTAGE       NUMBER NOT NULL,
    COST                 NUMBER
)
/

BEGIN
    NM3DDL.CREATE_SYNONYM_FOR_OBJECT ('LB_NETWORK_SUB_PATH');
END;
/

ALTER TABLE LB_NETWORK_SUB_PATH
    ADD (
        PRIMARY KEY
            (SUBPATH_ID, REFERENCE_PATH_ID)
            USING INDEX ENABLE VALIDATE);

PROMPT package and procedures dependent on nw tables
PROMPT package lb_path.pkb;

START .\admin\pck\lb_path.pkb;

PROMPT make_nw_from_lrefs.prc

START .\admin\pck\make_nw_from_lrefs.prc;

INSERT INTO lb_objects (object_name, object_type)
    SELECT o.object_name, o.object_type
      FROM user_objects o
     WHERE     o.object_name IN ('LB_NW_EDIT',
                                 'LB_ELEMENT_HISTORY',
                                 'LB_EDIT_TRANSACTION',
                                 'LB_EDIT_TRANSACTION_TAB',
                                 'MAKE_NW_FROM_LREFS',
                                 'V_NM_ELEMENT_XSP',
                                 'V_NM_ELEMENT_XSP_RVRS',
                                 'LB_XRPT',
                                 'LB_XRPT_TAB',
                                 'V_NLT_XSPS',
                                 'V_NLT_ELEMENT_XSPS',
                                 'V_NLT_XSP_RVRS',
                                 'LB_NETWORK_NO',
                                 'LB_NETWORK_SUB_PATH',
                                 'LB_NETWORK_LINK',
                                 'LB_NETWORK_PATH',
                                 'LB_NETWORK_PATH_LINK')
           AND NOT EXISTS
                   (SELECT 1
                      FROM lb_objects l
                     WHERE     l.object_name = o.object_name
                           AND l.object_type = o.object_type);



WHENEVER SQLERROR CONTINUE;

--no need to check synonyms for old path-related objects
--DECLARE
--   CURSOR c1
--   IS
--      SELECT *
--        FROM (WITH nw
--                   AS (SELECT sdo_owner,
--                              network,
--                              node_table_name,
--                              link_table_name
--                         FROM mdsys.sdo_network_metadata_table)
--              SELECT sdo_owner,
--                     network,
--                     'Node',
--                     node_table_name nw_table_name
--                FROM nw
--              UNION ALL
--              SELECT sdo_owner,
--                     network,
--                     'Link View',
--                     link_table_name
--                FROM nw
--              UNION ALL
--              SELECT sdo_owner,
--                     network,
--                     'Link Table',
--                     link_table_name || '_TABLE'
--                FROM nw)
--       WHERE sdo_owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER');
--
--   --
--   object_not_exists         EXCEPTION;
--   PRAGMA EXCEPTION_INIT (object_not_exists, -20301);
--   object_not_exists_error   VARCHAR2 (10) := 'FALSE';
----
--BEGIN
--   IF NVL (hig.get_sysopt ('HIGPUBSYN'), 'Y') = 'Y'
--   THEN
--      FOR irec IN c1
--      LOOP
--         BEGIN
--            NM3DDL.CREATE_SYNONYM_FOR_OBJECT (irec.nw_table_name, 'PUBLIC');
--         EXCEPTION
--            WHEN object_not_exists
--            THEN
--               object_not_exists_error := 'TRUE';
--         END;
--      END LOOP;
--   --    private synonyms accounted for in previous block
--   END IF;
--
--   IF object_not_exists_error = 'TRUE'
--   THEN
--      raise_application_error (
--         -20001,
--         'There was a problem with the Oracle network metadata, please check the objects referenced in the metadata exist');
--   END IF;
--END;
--/
--
PROMPT refreshing spatial metadata and indexes where necessary

DECLARE
    duplicates   EXCEPTION;
    PRAGMA EXCEPTION_INIT (duplicates, -13223);
    l_diminfo    sdo_dim_array;
    l_srid       INTEGER;
BEGIN
    NM3SDO.SET_DIMINFO_AND_SRID (NM3SDO.GET_NW_THEMES, l_diminfo, l_srid);

    BEGIN
        INSERT INTO user_sdo_geom_metadata (table_name,
                                            column_name,
                                            diminfo,
                                            srid)
            SELECT 'NM_ASSET_GEOMETRY_ALL',
                   'NAG_GEOMETRY',
                   SDO_LRS.convert_to_std_dim_array (l_diminfo),
                   l_srid
              FROM DUAL;
    EXCEPTION
        WHEN duplicates
        THEN
            NULL;
    END;

    --
    BEGIN
        INSERT INTO user_sdo_geom_metadata (table_name,
                                            column_name,
                                            diminfo,
                                            srid)
            SELECT 'NM_LOCATION_GEOMETRY',
                   'NLG_GEOMETRY',
                   SDO_LRS.convert_to_std_dim_array (l_diminfo),
                   l_srid
              FROM DUAL;
    EXCEPTION
        WHEN duplicates
        THEN
            NULL;
    END;
END;
/

DECLARE
    CURSOR c1 IS
        (SELECT i.index_name,
                i.table_name,
                c.column_name,
                status,
                domidx_status,
                domidx_opstatus
           FROM user_indexes i, lb_objects, user_ind_columns c
          WHERE     i.index_type LIKE '%DOMAIN%'
                AND i.ityp_name = 'SPATIAL_INDEX'
                AND i.table_name = object_name
                AND i.index_name = c.index_name
                AND (domidx_status <> 'VALID' OR domidx_opstatus <> 'VALID'));
BEGIN
    FOR irec IN c1
    LOOP
        BEGIN
            EXECUTE IMMEDIATE   'ALTER INDEX '
                             || irec.index_name
                             || ' rebuild ';
        EXCEPTION
            WHEN OTHERS
            THEN
                EXECUTE IMMEDIATE 'drop index ' || irec.index_name;

                EXECUTE IMMEDIATE   'create index '
                                 || irec.index_name
                                 || ' on '
                                 || irec.table_name
                                 || ' ( '
                                 || irec.column_name
                                 || ') index type is mdsys.spatial_index ';
        END;
    END LOOP;
END;
/


PROMPT Creating synonyms

DECLARE
    CURSOR c1 IS
        SELECT *
          FROM lb_objects l
         WHERE object_type IN ('PACKAGE',
                               'TABLE',
                               'VIEW',
                               'PROCEDURE',
                               'SEQUENCE',
                               'TYPE',
                               'FUNCTION');
BEGIN
    IF NVL (hig.get_sysopt ('HIGPUBSYN'), 'Y') = 'Y'
    THEN
        FOR irec IN c1
        LOOP
            NM3DDL.CREATE_SYNONYM_FOR_OBJECT (irec.object_name, 'PUBLIC');
        END LOOP;
    ELSE
        NM3DDL.REFRESH_PRIVATE_SYNONYMS;
    END IF;
END;
/

PROMPT Location Bridge Unit Translation Data

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 50,
           'METRE',
           1,
           'Metres'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 1)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 1);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 236,
           'KILOMETRE',
           2,
           'Kilometers'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 2)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 2);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 51,
           'CENTIMETRE',
           3,
           'Centimetres'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 3)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 3);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 321,
           'MILE',
           4,
           'Miles'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 4)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 4);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 77,
           'DEGREE',
           5,
           'Degrees'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 5)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 5);

INSERT INTO LB_UNITS (EXTERNAL_UNIT_ID,
                      EXTERNAL_UNIT_NAME,
                      EXOR_UNIT_ID,
                      EXOR_UNIT_NAME)
    SELECT 13,
           'RADIAN',
           6,
           'Radians'
      FROM DUAL
     WHERE     NOT EXISTS
                   (SELECT 1
                      FROM lb_units
                     WHERE exor_unit_id = 6)
           AND EXISTS
                   (SELECT 1
                      FROM nm_units
                     WHERE un_unit_id = 6);

COMMIT;


PROMPT improved link from Exor to Oracle SDO units of measure

update nm_units
set un_unit_name = 'Meter' where un_unit_id = 1;

update nm_units
set un_unit_name = 'Kilometer' where un_unit_id = 2;

update nm_units
set un_unit_name = 'Centimeter' where un_unit_id = 3;

update nm_units
set un_unit_name = 'Mile' where un_unit_id = 4;

CREATE OR REPLACE FUNCTION NULL_CONVERSION ( UNITSIN IN NUMBER )RETURN NUMBER IS RETVAL NUMBER; BEGIN   RETVAL := UNITSIN;   RETURN RETVAL; END;
/

insert into nm_unit_conversions
select un_unit_id, un_unit_id, 'NULL_CONVERSION', 'CREATE OR REPLACE FUNCTION NULL_CONVERSION ( UNITSIN IN NUMBER )RETURN NUMBER IS RETVAL NUMBER; BEGIN   RETVAL := UNITSIN;   RETURN RETVAL; END;', 1
from nm_units
where not exists ( select 1 from nm_unit_conversions where uc_unit_id_in = un_unit_id and uc_unit_id_out = un_unit_id )
/

update lb_units set exor_unit_name = ( select un_unit_name from nm_units where un_unit_id = exor_unit_id ) 
/

COMMIT;

PROMPT New System option for network graph generation

INSERT INTO hig_option_list (hol_id,
                             hol_product,
                             hol_name,
                             hol_remarks,
                             hol_domain,
                             hol_datatype,
                             hol_mixed_case,
                             hol_user_option,
                             hol_max_length)
    SELECT 'LBNWBUFFER',
           'LB',
           'LB Graph Buffer',
           'The size of the buffer in meters around an object to from the spatial intersection for construction of a dynamic network property graph',
           NULL,
           'NUMBER',
           'N',
           'N',
           2000
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM hig_option_list
                 WHERE hol_id = 'LBNWBUFFER');

INSERT INTO hig_option_values (hov_id, hov_value)
    SELECT 'LBNWBUFFER', '200'
      FROM DUAL
     WHERE NOT EXISTS
               (SELECT 1
                  FROM hig_option_values
                 WHERE hov_id = 'LBNWBUFFER');

COMMIT;

--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT Logging the upgrade
--
SET FEEDBACK ON

BEGIN
    --
    hig2.upgrade (
        p_product          => 'LB',
        p_upgrade_script   => 'exnm04070014en_updt55.sql',
        p_remarks          => 'NET 4700 FIX 55 Build 14 - LB version 4.7.0.8',
        p_to_version       => '4.7.0.8');
    --
    COMMIT;
--
EXCEPTION
    WHEN OTHERS
    THEN
        NULL;
END;
/

SET FEEDBACK OFF
SPOOL OFF

EXIT;
--