CREATE OR REPLACE PACKAGE doc_locations_api
AS
--<PACKAGE>
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/doc_locations_api.pkb-arc   2.7   Aug 31 2010 15:02:48   Ade.Edwards  $
--       Module Name      : $Workfile:   doc_locations_api.pkb  $
--       Date into PVCS   : $Date:   Aug 31 2010 15:02:48  $
--       Date fetched Out : $Modtime:   Aug 31 2010 15:01:04  $
--       Version          : $Revision:   2.7  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--</PACKAGE>
--<GLOBVAR>

  -----------
  --constants
  -----------
  --g_sccsid is the SCCS ID for the package
  g_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.7  $';
--
  TYPE rec_file_record
    IS RECORD ( 
                doc_id        NUMBER 
              , revision      NUMBER
              , start_date    DATE
              , end_date      DATE
              , full_path     VARCHAR2(4000)
              , filename      VARCHAR2(4000)
              , content       BLOB
              , audit         VARCHAR2(4000)
              , file_info     VARCHAR2(2000)
              );
--
  TYPE g_tab_dla    IS TABLE OF doc_location_archives%ROWTYPE INDEX BY BINARY_INTEGER;
--
--</GLOBVAR>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_VERSION">
-- This function returns the current SCCS version
FUNCTION get_version RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_BODY_VERSION">
-- This function returns the current SCCS version of the package body
FUNCTION get_body_version RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_TEMP_LOAD_TABLE">
-- 
FUNCTION get_temp_load_table RETURN varchar2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DLC">
-- Get doc location rowtype based on Location Name 
FUNCTION get_dlc ( pi_dlc_name IN doc_locations.dlc_name%TYPE )
  RETURN doc_locations%ROWTYPE;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DLC">
-- Get doc location rowtype based on Location ID
FUNCTION get_dlc ( pi_dlc_id IN doc_locations.dlc_id%TYPE )
  RETURN doc_locations%ROWTYPE;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DLC">
-- Get doc location rowtype based on DOC ID
FUNCTION get_dlc ( pi_doc_id IN docs.doc_id%TYPE )
  RETURN doc_locations%ROWTYPE;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DLC_LOCATION">
-- Get doc location type (i.e. TABLE, URL) and name (i.e. `DOC_FILES_ALL�, `HTTP://<server>/<share>)
-- based on Doc Location ID
PROCEDURE get_dlc_location ( pi_dlc_id             IN doc_locations.dlc_id%TYPE 
                           , po_dlc_location_type OUT doc_locations.dlc_location_type%TYPE
                           , po_dlc_location_name OUT doc_locations.dlc_location_name%TYPE);
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DLC_LOCATION">
-- Get doc location type (i.e. TABLE, URL) and name (i.e. `DOC_FILES_ALL�, `HTTP://<server>/<share>)
-- based on Doc Location Name
PROCEDURE get_dlc_location ( pi_dlc_name           IN doc_locations.dlc_name%TYPE 
                           , po_dlc_location_type OUT doc_locations.dlc_location_type%TYPE
                           , po_dlc_location_name OUT doc_locations.dlc_location_name%TYPE);
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DLC_LOCATION">
-- Get doc location type (i.e. TABLE, URL) and name (i.e. `DOC_FILES_ALL�, `HTTP://<server>/<share>)
-- based on Doc Location ID
PROCEDURE get_dlc_location ( pi_doc_id             IN docs.doc_id%TYPE 
                           , po_dlc_location_type OUT doc_locations.dlc_location_type%TYPE
                           , po_dlc_location_name OUT doc_locations.dlc_location_name%TYPE);

PROCEDURE get_dlc_location ( pi_doc_id             IN docs.doc_id%TYPE
                           , po_name              OUT doc_locations.dlc_name%TYPE
                           , po_location          OUT doc_locations.dlc_location_name%TYPE
                           , po_meaning           OUT doc_locations.dlc_location_name%TYPE );
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DLC_TABLE">
-- Get doc location type (i.e. TABLE, URL) and name (i.e. `DOC_FILES_ALL�, `HTTP://<server>/<share>)
-- based on Doc Location ID
FUNCTION get_dlc_table ( pi_doc_id             IN docs.doc_id%TYPE )
  RETURN VARCHAR2;


FUNCTION get_dlt ( pi_dlc_id             IN doc_locations.dlc_id%TYPE )
  RETURN doc_location_tables%ROWTYPE;
  
    
FUNCTION get_dlt ( pi_doc_id             IN docs.doc_id%TYPE )
  RETURN doc_location_tables%ROWTYPE;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="MAP_TABLE_TO_DOC_LOCATION">
-- 
PROCEDURE map_table_to_doc_location 
            ( pi_dlc_id     IN doc_locations.dlc_id%TYPE
            , pi_table_name IN user_tables.table_name%TYPE 
            , pi_prefix     IN VARCHAR2 DEFAULT NULL
            , pi_tablespace IN user_tablespaces.tablespace_name%TYPE DEFAULT NULL
            , pi_drop_first IN BOOLEAN DEFAULT FALSE );
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_LOCATION_TYPE_LOV_SQL">
--
FUNCTION get_location_type_lov_sql 
  RETURN VARCHAR2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_LOCATION_DESCR">
--
FUNCTION get_location_descr (pi_location_type IN doc_locations.dlc_location_type%TYPE)
  RETURN VARCHAR2;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="INSERT_FILE_RECORD">
-- Insert files record
  PROCEDURE insert_file_record ( pi_rec_df IN rec_file_record );
  PROCEDURE insert_temp_file_record ( pi_rec_df IN doc_file_transfer_temp%ROWTYPE );
--</PROC>
--
--------------------------------------------------------------------------------
--
--<PROC NAME="GET_FILE_RECORD">

  FUNCTION get_file_record ( pi_doc_id   IN docs.doc_id%TYPE
                           , pi_revision IN NUMBER )
    RETURN rec_file_record;
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_ARCHIVE">
  FUNCTION get_archive ( pi_dlc_id IN doc_locations.dlc_id%TYPE ) 
    RETURN doc_location_archives%ROWTYPE;
--
  FUNCTION get_archives ( pi_dlc_id IN doc_locations.dlc_id%TYPE ) 
    RETURN g_tab_dla;
--
  FUNCTION get_archive ( pi_doc_id IN docs.doc_id%TYPE ) 
    RETURN doc_location_archives%ROWTYPE;

  FUNCTION get_archives ( pi_doc_id IN docs.doc_id%TYPE ) 
    RETURN g_tab_dla;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="ARCHIVE_FILE_DOC_BUNDLE">
  PROCEDURE archive_doc_bundle_files ( pi_doc_bundle_id IN NUMBER );
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_TABLE_PREFIX">
  FUNCTION get_table_prefix RETURN VARCHAR2;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DEFAULT_TABLESPACE">
  FUNCTION get_default_tablespace RETURN user_tablespaces.tablespace_name%TYPE;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DOC_PATH">
  FUNCTION get_doc_path ( pi_dlc_id            IN doc_locations.dlc_id%TYPE 
                        , pi_include_end_slash IN BOOLEAN DEFAULT FALSE)
    RETURN doc_locations.dlc_location_name%TYPE;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DOC_URL">
  FUNCTION get_doc_url  ( pi_dlc_id            IN doc_locations.dlc_id%TYPE )
    RETURN doc_locations.dlc_location_name%TYPE;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DOC_URL">
  FUNCTION get_doc_url  ( pi_doc_id            IN docs.doc_id%TYPE )
    RETURN doc_locations.dlc_location_name%TYPE;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DOC_TEMPLATE_PATH">
  FUNCTION get_doc_template_path ( pi_template_name IN doc_template_gateways.dtg_template_name%TYPE )
    RETURN doc_locations.dlc_location_name%TYPE; 
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="IS_TABLE_VALID">
-- Return Y or N depending on whether the table is valid as a document location
--
  FUNCTION is_table_valid ( pi_table_name IN user_tables.table_name%TYPE )
    RETURN VARCHAR2;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
--<PROC NAME="GET_DOC_IMAGE">
-- Used for a table-based Doc Location returning the image through a DAD
  PROCEDURE get_doc_image ( pi_doc_id IN docs.doc_id%TYPE ); 
  --PROCEDURE get_doc_image;
--
--</PROC>
--
-----------------------------------------------------------------------------
--
END doc_locations_api;
/

