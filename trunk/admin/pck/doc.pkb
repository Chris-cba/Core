CREATE OR REPLACE PACKAGE BODY doc AS
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/doc.pkb-arc   2.4   Jul 04 2013 14:31:26   James.Wadsworth  $
--       Module Name      : $Workfile:   doc.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:31:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:06  $
--       SCCS Version     : $Revision:   2.4  $
--       Based on SCCS Version     : 1.12
--
--
--   Author :
--
--   DOCUMENTS application generic utilities package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.4  $"';
   g_package_name    CONSTANT varchar2(30) := 'doc';
--  g_body_sccsid is the SCCS ID for the package body
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_doc_id RETURN NUMBER IS
CURSOR c1 IS
   SELECT doc_id_seq.NEXTVAL
   FROM dual;
retval NUMBER;
BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_table_descr(p_table IN VARCHAR2) RETURN VARCHAR2 IS
CURSOR c1 IS
   SELECT dgt_table_descr
   FROM doc_gateways
   WHERE dgt_table_name = p_table;
retval doc_gateways.dgt_table_descr%TYPE;
BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  CLOSE c1;
  RETURN retval;
END;
--
-------------------------------------------------------------------------------------------------------
--
/* Formatted on 07/05/2010 10:56:02 (QP5 v5.139.911.3011) */
FUNCTION check_doc_assocs ( p_doc_id      IN docs.doc_id%TYPE
                          , p_rse_he_id   IN road_segs.rse_he_id%TYPE )
  RETURN NUMBER
IS
  l_dummy   NUMBER;
  retval    NUMBER;

  CURSOR c1
  IS
    SELECT 1
      FROM doc_assocs
     WHERE das_doc_id = p_doc_id AND das_table_name = 'ROAD_SEGMENTS_ALL'
           AND das_rec_id IN
                 (SELECT TO_CHAR ( p_rse_he_id ) FROM dual
                  UNION
                      SELECT TO_CHAR ( rsm_rse_he_id_of )
                        FROM road_seg_membs
                  CONNECT BY PRIOR rsm_rse_he_id_in = rsm_rse_he_id_of
                  START WITH rsm_rse_he_id_in = p_rse_he_id
                  UNION
                      SELECT TO_CHAR ( rsm_rse_he_id_in )
                        FROM road_seg_membs
                  CONNECT BY PRIOR rsm_rse_he_id_of = rsm_rse_he_id_in
                  START WITH rsm_rse_he_id_of = p_rse_he_id);
BEGIN
  OPEN c1;

  FETCH c1 INTO l_dummy;

  IF c1%FOUND
  THEN
    CLOSE c1;

    retval := 1;
  ELSE
    CLOSE c1;

    retval := 0;
  END IF;

  RETURN retval;
END;
--
-------------------------------------------------------------------------------------------------------
--
  FUNCTION   file_exists ( p_dlc_id IN NUMBER, p_file_name IN VARCHAR2 ) RETURN NUMBER IS
  CURSOR c1 IS
    SELECT doc_id FROM docs
    WHERE doc_dlc_id = p_dlc_id
    AND   doc_file   = p_file_name;

  retval docs.doc_id%TYPE;

  BEGIN
    OPEN c1;
    FETCH c1 INTO retval;
    IF c1%NOTFOUND THEN
      retval := NULL;
    END IF;
    CLOSE c1;

    RETURN retval;

  END;
--
-------------------------------------------------------------------------------------------------------
--
  FUNCTION  doc_type_exists ( p_dlc_id IN NUMBER, p_file_name IN VARCHAR2 ) RETURN VARCHAR2 IS

   CURSOR c1 IS
    SELECT doc_dtp_code FROM docs WHERE doc_dlc_id = p_dlc_id AND doc_file = p_file_name;

    retval docs.doc_dtp_code%TYPE;

  BEGIN

    OPEN c1;
     FETCH c1 INTO retval;
      IF c1%NOTFOUND THEN
	  retval := NULL;
	END IF;
    CLOSE c1;

    RETURN retval;

  END;
--
-------------------------------------------------------------------------------------------------------
--
  -- Procedure used to carry out some dynamic sql
  --
  PROCEDURE  doc_sql (sql_in    IN VARCHAR2,
                          output   OUT VARCHAR2,
                          feedback OUT INTEGER)
  IS
    err_string VARCHAR2(80) := NULL;
    cur        INTEGER      := dbms_sql.open_cursor;
    COL        VARCHAR2(2000);

  BEGIN
    dbms_sql.parse (cur, sql_in, dbms_sql.v7);
    dbms_sql.define_column(cur, 1, COL, 2000);
    feedback := dbms_sql.EXECUTE(cur);
    IF dbms_sql.fetch_rows(cur) > 0 THEN
       dbms_sql.column_value(cur, 1, output);
    END IF;
    dbms_sql.close_cursor (cur);
  EXCEPTION
    WHEN OTHERS THEN

    /* trap the error string */

       err_string := SQLERRM;

      IF dbms_sql.is_open(cur) THEN
         dbms_sql.close_cursor (cur);
      END IF;

      RAISE_APPLICATION_ERROR( -20001, err_string );
  END;
--
-------------------------------------------------------------------------------------------------------
--
  /* Formatted on 07/05/2010 10:56:11 (QP5 v5.139.911.3011) */
PROCEDURE create_doc ( intdocid       IN NUMBER
                     , strtitle       IN VARCHAR2
                     , strfile        IN VARCHAR2
                     , mediaid        IN NUMBER
                     , locationid     IN NUMBER
                     , strdoctype     IN VARCHAR2
                     , strpkid        IN VARCHAR2
                     , strtablename   IN VARCHAR2
                     , strdescflag    IN VARCHAR2
                     , strcreassoc    IN VARCHAR2 )
IS
  new_doc_id   docs.doc_id%TYPE;
  strdescr     docs.doc_descr%TYPE := 'Not Set';
BEGIN
  IF strdescflag = 'T'
  THEN
    strdescr := 'Document automatically created by template';
  ELSIF strdescflag = 'N'
  THEN
    strdescr := 'Document automatically created by new file association';
  END IF;

  ---Create the base document
  INSERT INTO docs ( doc_id
                   , doc_title
                   , doc_dtp_code
                   , doc_date_issued
                   , doc_file
                   , doc_dlc_dmd_id
                   , doc_dlc_id
                   , doc_reference_code
                   , doc_descr )
       VALUES ( intdocid
              , strtitle
              , strdoctype
              , SYSDATE
              , strfile
              , mediaid
              , locationid
              , strfile
              , strdescr );

  IF strcreassoc = 'Y'
  THEN
    create_doc_assoc ( strtablename, strpkid, intdocid );
  END IF;

  COMMIT;
END;
--
-------------------------------------------------------------------------------------------------------
--
-- overloaded due to extra parameters for auto creation/association

  /* Formatted on 07/05/2010 10:56:16 (QP5 v5.139.911.3011) */
PROCEDURE create_doc ( intdocid       IN NUMBER
                     , strtitle       IN VARCHAR2
                     , strfile        IN VARCHAR2
                     , mediaid        IN NUMBER
                     , locationid     IN NUMBER
                     , strdoctype     IN VARCHAR2
                     , strpkid        IN VARCHAR2
                     , strtablename   IN VARCHAR2 )
IS
  new_doc_id   docs.doc_id%TYPE;
  strdescr     docs.doc_descr%TYPE := 'Created through Template';
BEGIN
  ---Create the base document
  INSERT INTO docs ( doc_id
                   , doc_title
                   , doc_dtp_code
                   , doc_date_issued
                   , doc_file
                   , doc_dlc_dmd_id
                   , doc_dlc_id
                   , doc_reference_code
                   , doc_descr )
       VALUES ( intdocid
              , strtitle
              , strdoctype
              , SYSDATE
              , strfile
              , mediaid
              , locationid
              , strfile
              , strdescr );

  create_doc_assoc ( strtablename, strpkid, intdocid );

  COMMIT;
END;

PROCEDURE create_doc_assoc ( p_table    IN VARCHAR2
                           , p_pk       IN VARCHAR2
                           , p_doc_id   IN NUMBER )
IS
BEGIN
  INSERT INTO doc_assocs ( das_table_name, das_rec_id, das_doc_id )
       VALUES ( p_table, p_pk, p_doc_id );

  COMMIT;
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_image ( strentity      IN VARCHAR2
                   , strentitypk    IN VARCHAR2
                   , strimagetype   IN VARCHAR2
                   , intimageno     IN NUMBER )
  RETURN VARCHAR2
IS
  strreturn   doc_locations.DLC_PATHNAME%TYPE;
  ---strImageType VARCHAR2(100);
  intlocid    NUMBER;
  intcount    NUMBER := 1;

  CURSOR images
  IS
    SELECT doc_id, doc_file, doc_dlc_id
      FROM docs
     WHERE doc_id IN
             (SELECT das_doc_id
                FROM doc_assocs
               WHERE das_table_name = strentity AND das_rec_id = strentitypk)
           AND doc_dtp_code = strimagetype;

  CURSOR doc_loc
  IS
    SELECT dlc_pathname
      FROM doc_locations
     WHERE dlc_id = intlocid AND dlc_end_date IS NULL;
BEGIN
  ---Do we have a type
  IF strimagetype IS NULL
  THEN
    RETURN NULL;
  END IF;

  FOR recs IN images
  LOOP
    IF intimageno = intcount
    THEN
      intlocid := recs.doc_dlc_id;

--      OPEN doc_loc;
--      FETCH doc_loc INTO strreturn;
--      CLOSE doc_loc;

      strreturn := doc_locations_api.get_doc_path ( pi_dlc_id            => recs.doc_dlc_id 
                                                  , pi_include_end_slash => TRUE );

      strreturn := strreturn || recs.doc_file;
    END IF;

    intcount := intcount + 1;
  END LOOP;

  RETURN strreturn;
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_location_directory ( p_location IN NUMBER )
        RETURN VARCHAR2 IS

CURSOR c1 IS
  SELECT dlc_pathname
  FROM doc_locations
  WHERE dlc_id = p_location;

retval doc_locations.DLC_PATHNAME%TYPE;
BEGIN

--  OPEN c1;
--  FETCH c1 INTO retval;
--  IF c1%NOTFOUND THEN
--    retval := NULL;
--  END IF;
--  CLOSE c1;
--
  RETURN doc_locations_api.get_doc_path ( pi_dlc_id            => p_location
                                        , pi_include_end_slash => TRUE );
--
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_media_filetype( p_dmd_id IN NUMBER )
        RETURN VARCHAR2 IS

CURSOR c1 IS
  SELECT dmd_file_extension
  FROM doc_media
  WHERE dmd_id = p_dmd_id;

retval VARCHAR2(4);

BEGIN

  OPEN c1;
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    retval := NULL;
  END IF;
  CLOSE c1;
  RETURN retval;
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_media_filetype( p_dmd_name IN VARCHAR2 )
        RETURN VARCHAR2 IS

CURSOR c1 IS
  SELECT dmd_file_extension
  FROM doc_media
  WHERE dmd_name = p_dmd_name;

retval VARCHAR2(4);

BEGIN

  OPEN c1;
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    retval := NULL;
  END IF;
  CLOSE c1;
  RETURN retval;
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION find_char_start(pc_string IN VARCHAR2) RETURN NUMBER IS
BEGIN
  FOR i IN 1..LENGTH(pc_string) LOOP
    IF SUBSTR(pc_string,i,1) NOT IN('1','2','3','4','5','6','7','8','9','0') THEN
      RETURN i;
    END IF;
  END LOOP;
  RETURN LENGTH(pc_string) + 1;
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION building_no_number ( pc_building_number VARCHAR2 ) RETURN NUMBER IS
BEGIN
  IF pc_building_number IS NULL THEN
    RETURN NULL;
  END IF;
  RETURN TO_NUMBER(SUBSTR(pc_building_number,1,find_char_start(pc_building_number)-1));
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION building_no_char ( pc_building_number VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN
  IF pc_building_number IS NULL THEN
    RETURN NULL;
  END IF;
  RETURN SUBSTR(pc_building_number,find_char_start(pc_building_number));
END;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_con_code( p_det_con_id IN NUMBER)
RETURN VARCHAR2
IS
  l_con_code VARCHAR2(100);
BEGIN
   l_con_code := NULL;
   IF hig.is_product_licensed( pi_product => 'ENQ')
    THEN
      EXECUTE IMMEDIATE 'DECLARE '
            ||CHR(10)|| '  CURSOR c1 (c_det_con_id number)'
            ||CHR(10)|| '  IS'
            ||CHR(10)|| '  SELECT con_code'
            ||CHR(10)|| '  FROM contracts'
            ||CHR(10)|| '  WHERE con_id = c_det_con_id;'
            ||CHR(10)|| 'BEGIN'
            ||CHR(10)|| ' OPEN c1 (:p_det_con_id);'
            ||CHR(10)|| ' FETCH c1 INTO :l_con_code;'
            ||CHR(10)|| ' CLOSE c1;'
            ||CHR(10)|| ' EXCEPTION'
            ||CHR(10)|| '  WHEN NO_DATA_FOUND THEN'
            ||CHR(10)|| '    NULL;'
            ||CHR(10)|| 'END;'
      USING IN p_det_con_id,
            IN OUT l_con_code;
   END IF;
   RETURN l_con_code;
END get_con_code;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_con_id( p_det_con_code IN VARCHAR2)
RETURN NUMBER
IS
  l_con_id NUMBER;
BEGIN
   l_con_id := NULL;
   IF hig.is_product_licensed( pi_product => 'ENQ')
    THEN
      EXECUTE IMMEDIATE 'DECLARE '
            ||CHR(10)|| '  CURSOR c1 (c_det_con_code varchar2)'
            ||CHR(10)|| '  IS'
            ||CHR(10)|| '  SELECT con_id'
            ||CHR(10)|| '  FROM contracts'
            ||CHR(10)|| '  WHERE con_code = c_det_con_code;'
            ||CHR(10)|| 'BEGIN'
            ||CHR(10)|| ' OPEN c1 (:p_det_con_code);'
            ||CHR(10)|| ' FETCH c1 INTO :l_con_id;'
            ||CHR(10)|| ' CLOSE c1;'
            ||CHR(10)|| ' EXCEPTION'
            ||CHR(10)|| '  WHEN NO_DATA_FOUND THEN'
            ||CHR(10)|| '    NULL;'
            ||CHR(10)|| 'END;'
      USING IN p_det_con_code,
            IN OUT l_con_id;
   END IF;
   RETURN l_con_id;
END get_con_id;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_tab_current_gateways(
                                  pi_dgt_table_name  IN  doc_gateways.dgt_table_name%TYPE
								 ,pi_as_at_date      IN  DATE default TRUNC(SYSDATE)
                                 ) RETURN t_dgt_tab IS

  l_retval  t_dgt_tab;

BEGIN

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_tab_current_gateways');

  -------------------------------------------------------------------------
  -- Get a list of currently available document gateways for a given table
  -------------------------------------------------------------------------
  SELECT
        *
  BULK COLLECT INTO
        l_retval
  FROM
        doc_gateways dgt
  WHERE
       (
        dgt_table_name = UPPER(pi_dgt_table_name)
        OR EXISTS      ( SELECT 'document gateway synonym'
                         FROM   doc_gate_syns dgs
                         WHERE  dgs.dgs_table_syn      = UPPER(pi_dgt_table_name)
                         AND    dgs.dgs_dgt_table_name = dgt.dgt_table_name )
       )
  AND
       NVL(dgt_start_date,pi_as_at_date) >= pi_as_at_date
  AND
       NVL(dgt_end_date,pi_as_at_date+1) >= pi_as_at_date;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_tab_current_gateways');

  RETURN(l_retval);

END get_tab_current_gateways;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_tab_das_docs(
                          pi_das_table_name  IN  doc_assocs.das_table_name%TYPE
     				     ,pi_das_rec_id      IN  doc_assocs.das_rec_id%TYPE
                         ) RETURN t_docs_tab IS

  l_retval  t_docs_tab;

BEGIN

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_tab_das_docs');


  ------------------------------------------------------------------
  -- Get a list of available documents for a given record in a table
  ------------------------------------------------------------------
  SELECT
        docs.*
  BULK COLLECT INTO
        l_retval
  FROM
        doc_assocs das
	   ,docs       docs
  WHERE
        das.das_table_name = pi_das_table_name
  AND
        das.das_rec_id     = pi_das_rec_id
  AND
        docs.doc_id        = das.das_doc_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_tab_das_docs');

  RETURN(l_retval);

END get_tab_das_docs;
--
-------------------------------------------------------------------------------------------------------
--
FUNCTION get_doc_url( pi_doc_id  IN docs.doc_id%TYPE
                    , pi_ret_ext IN boolean DEFAULT TRUE
                    ) RETURN VARCHAR2 IS

  l_url          doc_locations.DLC_PATHNAME%TYPE;
  l_dlc          doc_locations%ROWTYPE;
  l_dmd          doc_media%ROWTYPE;
  l_docs         docs%ROWTYPE;
--
BEGIN
--
  RETURN doc_locations_api.get_doc_url(pi_doc_id => pi_doc_id);
--
--
--  BEGIN
--     l_docs := nm3get.get_doc(pi_doc_id  => pi_doc_id);
--  EXCEPTION
--     WHEN others THEN
--	    RETURN(Null);
--  END;
--
--  ---------------------------------------------------
--  -- if we have an associated doc location record
--  -- then get the details to add into the url
--  -- if it goes pear shaped then return NULL
--  ---------------------------------------------------
--  IF l_docs.doc_dlc_id IS NOT NULL
--  THEN
--
--	  BEGIN
--		  l_dlc := nm3get.get_dlc(pi_dlc_id => l_docs.doc_dlc_id);
--      EXCEPTION
--    	WHEN others
--    	THEN
--    	  	RETURN(Null);
--      END;
--
--  END IF;
--
--
--  ---------------------------------------------------
--  -- if we have an associated doc media record
--  -- then get the details to add into the url
--  -- if it goes pear shaped then return NULL
--  ---------------------------------------------------
--  IF l_docs.doc_dlc_dmd_id IS NOT NULL
--  THEN
--
--       BEGIN
--         l_dmd := nm3get.get_dmd(pi_dmd_id => l_docs.doc_dlc_dmd_id);
--       EXCEPTION
--       	 WHEN others
--    	 THEN
--    	  	RETURN(Null);
--       END;
--
--  END IF;
--
--  -- set the url to be the url path plus filename of the document
--  --l_url      := l_dlc.dlc_url_pathname || l_docs.doc_file;
----
--  l_url := doc_locations_api.get_doc_url  ( pi_dlc_id => l_dlc.dlc_id)|| l_docs.doc_file;
----
--  -- if there is an associated file extension with this document and the document does not already have a file extension then
--  -- append this extension on to the url
--  --
--  -- MJA log 706710 (inc 49707 and 702638)
--  -- Do not add extension if pi_ret_ext passed as false
----  If pi_ret_ext
----  Then
----    IF l_dmd.dmd_file_extension IS NOT NULL AND INSTR(l_docs.doc_file,'.') = 0
----    THEN
----      l_url := l_url || '.' || l_dmd.dmd_file_extension;
----    END IF;
----  End If;
--  --
----  RETURN(
----          nm3web.string_to_url(pi_str               => l_url)
----
----         );
---- GJ removed the string to url conversion cos it's not needed
---- i.e. it was screwing up filenames with + characters in them by replacing
---- them with %43 - when the raw filename was fine anyway
--  RETURN(l_url);


END;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION das_against_asset (pi_das_table_name IN doc_assocs.das_table_name%TYPE) RETURN BOOLEAN IS


 CURSOR c1 IS
 SELECT *
 FROM doc_gate_syns
 WHERE  dgs_dgt_table_name IN ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS')
 AND    dgs_table_syn = pi_das_table_name;

 l_dgs_rec doc_gate_syns%ROWTYPE;

 l_retval BOOLEAN := FALSE;  -- assign default value to return item

BEGIN

 IF pi_das_table_name in ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS') THEN
   l_retval := TRUE;
 ELSE -- assoc isn't directly on a table in our hit list - so we need to check the table synonymns to see if it ties back to our possible tables
   OPEN c1;
   FETCH c1 INTO l_dgs_rec;
   CLOSE c1;

   IF l_dgs_rec.dgs_dgt_table_name IS NOT NULL THEN
    l_retval := TRUE;
   END IF;

 END IF;

 RETURN(l_retval);

END das_against_asset;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION das_against_network (pi_das_table_name IN doc_assocs.das_table_name%TYPE) RETURN BOOLEAN IS


 CURSOR c1 IS
 SELECT *
 FROM doc_gate_syns
 WHERE  dgs_dgt_table_name IN ('NM_ELEMENTS_ALL','NM_ELEMENTS','ROAD_SEGMENTS_ALL','ROAD_SEGMENTS')
 AND    dgs_table_syn = pi_das_table_name;

 l_dgs_rec doc_gate_syns%ROWTYPE;

 l_retval BOOLEAN := FALSE;  -- assign default value to return item

BEGIN

 IF pi_das_table_name in ('NM_ELEMENTS_ALL','NM_ELEMENTS','ROAD_SEGMENTS_ALL','ROAD_SEGMENTS') THEN
   l_retval := TRUE;
 ELSE -- assoc isn't directly on a table in our hit list - so we need to check the table synonymns to see if it ties back to our possible tables
   OPEN c1;
   FETCH c1 INTO l_dgs_rec;
   CLOSE c1;

   IF l_dgs_rec.dgs_dgt_table_name IS NOT NULL THEN
    l_retval := TRUE;
   END IF;

 END IF;

 RETURN(l_retval);

END das_against_network;
--
---------------------------------------------------------------------------------------------------
--
  -- AE
  -- DORSET enhancements for ATLAS.
  -- Changes for DOC0150 to zoom to postcode/section/intial
  --   a) Road section if present
  --   b) or Postcode XY
  --   c) else Initial extent of map
  --
--
---------------------------------------------------------------------------------------------------
-- This procedure returns XY coords for a given postcode/building number

  PROCEDURE get_address_xy
              ( pi_postcode     IN  hig_address.had_postcode%TYPE
              , pi_building_no  IN  hig_address.had_building_no%TYPE
              , po_x            OUT NUMBER
              , po_y            OUT NUMBER )
  IS
  --
    CURSOR get_xy_from_hdp
      ( cp_postcode     IN  hig_address_point.hdp_postcode%TYPE
      , cp_building_no  IN  hig_address_point.hdp_building_no%TYPE )
      IS
      SELECT hdp_xco, hdp_yco
        FROM hig_address_point
       WHERE hdp_postcode    = cp_postcode
         AND hdp_building_no = cp_building_no;
  --
    CURSOR get_xy_from_had
      ( cp_postcode     IN  hig_address.had_postcode%TYPE
      , cp_building_no  IN  hig_address.had_building_no%TYPE )
      IS
      SELECT had_xco, had_yco
        FROM hig_address
       WHERE had_postcode    = cp_postcode
         AND had_building_no = cp_building_no;
  --
    l_x                        NUMBER;
    l_y                        NUMBER;
    e_no_coords                EXCEPTION;
  --
  BEGIN
    ----------------------------------------
    -- Get XYs from HIG_ADDRESS_POINT first
    ----------------------------------------
    OPEN  get_xy_from_hdp ( pi_postcode, pi_building_no );
    FETCH get_xy_from_hdp INTO l_x, l_y;
    CLOSE get_xy_from_hdp;

    --
    IF l_x IS NULL
    OR l_y IS NULL
    THEN

    ---------------------------------------------------------------
    -- Get XYs from HIG_ADDRESS if not exists in HIG_ADDRESS_POINT
    ---------------------------------------------------------------

    /*
      Please note, the code here is used to try and make sense of the dodgy
      coordinates that seem to be on Hig_Address/_Point tables
      If it's wrong, it's wrong.. the data I had to work with at the time
      determined this logic.

      Coords are assumed to be a length of 6 digits (not including DPs).
    */
      OPEN  get_xy_from_had ( pi_postcode, pi_building_no );
      FETCH get_xy_from_had INTO l_x, l_y;
      CLOSE get_xy_from_had;
    --
      IF  l_x IS NOT NULL
      AND l_y IS NOT NULL THEN
      --
      -- If X coord is more than 6 length, then divide by factor of 10
        IF length(round(l_x)) > 6	THEN
          --
          FOR i IN 6..(length(round(l_x))-1) LOOP
            l_x := l_x/10;
          END LOOP;

      -- If X coord is less than 6 length, then multiply by factor of 10
        ELSIF length(round(l_x)) < 6 THEN
          --
          FOR i IN (length(round(l_x))+1)..6 LOOP
          	l_x := l_x*10;
          END LOOP;
          --
        END IF;
      --
        po_x := l_x;
      --
      -- If Y coord is more than 6 length, then multiply by factor of 10
        IF length(round(l_y)) > 6	THEN
          --
          FOR i IN 6..(length(round(l_y))-1) LOOP
            l_y := l_y/10;
          END LOOP;
          --
      -- If Y coord is less than 6 length, then divide by factor of 10
        ELSIF length(round(l_y)) < 6
          THEN
          --
          FOR i IN (length(round(l_y))+1)..6 LOOP
          	l_y := l_y*10;
          END LOOP;
          --
        END IF;
      --
        po_y := l_y;
      --
      ELSE
        po_x := NULL;
        po_y := NULL;
      --
      END IF;
    --
    ELSE
    --
      po_x := l_x;
      po_y := l_y;
    --
    END IF;
  --
  EXCEPTION
    WHEN e_no_coords
    THEN
      RAISE_APPLICATION_ERROR(-20501,'No coordinates exist for '||pi_postcode||' No. - '||pi_building_no);
    WHEN OTHERS
    THEN
      RAISE;
  END get_address_xy;
--
-----------------------------------------------------------------------------
--
-- This procedure returns XY coords for a given postcode/building name

  PROCEDURE get_address_xy
              ( pi_postcode       IN  hig_address.had_postcode%TYPE
              , pi_building_name  IN  hig_address.had_building_name%TYPE
              , po_x             OUT NUMBER
              , po_y             OUT NUMBER )
  IS
  --

  -- Cannot guarantee uniquness - bring back the first row we find.
    CURSOR get_xy_from_hdp
      ( cp_postcode       IN  hig_address_point.hdp_postcode%TYPE
      , cp_building_name  IN  hig_address_point.hdp_building_name%TYPE )
      IS
      SELECT hdp_xco, hdp_yco
        FROM hig_address_point
       WHERE hdp_postcode    = cp_postcode
         AND hdp_building_name = cp_building_name
         AND hdp_xco IS NOT NULL
         AND hdp_yco IS NOT NULL
         AND ROWNUM = 1;
  -- Cannot guarantee uniquness - bring back the first row we find.
    CURSOR get_xy_from_had
      ( cp_postcode       IN  hig_address.had_postcode%TYPE
      , cp_building_name  IN  hig_address.had_building_name%TYPE )
      IS
      SELECT had_xco, had_yco
        FROM hig_address
       WHERE had_postcode    = cp_postcode
         AND had_building_name = cp_building_name
         AND had_xco IS NOT NULL
         AND had_yco IS NOT NULL
         AND ROWNUM = 1;
  --
    l_x                        NUMBER;
    l_y                        NUMBER;
    e_no_coords                EXCEPTION;
  --
  BEGIN
    ----------------------------------------
    -- Get XYs from HIG_ADDRESS_POINT first
    ----------------------------------------
    OPEN  get_xy_from_hdp ( pi_postcode, pi_building_name );
    FETCH get_xy_from_hdp INTO l_x, l_y;
    CLOSE get_xy_from_hdp;

    --
    IF l_x IS NULL
    OR l_y IS NULL
    THEN

    ---------------------------------------------------------------
    -- Get XYs from HIG_ADDRESS if not exists in HIG_ADDRESS_POINT
    ---------------------------------------------------------------

    /*
      Please note, the code here is used to try and make sense of the dodgy
      coordinates that seem to be on Hig_Address/_Point tables
      If it's wrong, it's wrong.. the data I had to work with at the time
      determined this logic.

      Coords are assumed to be a length of 6 digits (not including DPs).
    */
      OPEN  get_xy_from_had ( pi_postcode, pi_building_name );
      FETCH get_xy_from_had INTO l_x, l_y;
      CLOSE get_xy_from_had;
    --
      IF  l_x IS NOT NULL
      AND l_y IS NOT NULL THEN
      --
      -- If X coord is more than 6 length, then divide by factor of 10
        IF length(round(l_x)) > 6 THEN
          --
          FOR i IN 6..(length(round(l_x))-1) LOOP
            l_x := l_x/10;
          END LOOP;

      -- If X coord is less than 6 length, then multiply by factor of 10
        ELSIF length(round(l_x)) < 6 THEN
          --
          FOR i IN (length(round(l_x))+1)..6 LOOP
           l_x := l_x*10;
          END LOOP;
          --
        END IF;
      --
        po_x := l_x;
      --
      -- If Y coord is more than 6 length, then multiply by factor of 10
        IF length(round(l_y)) > 6 THEN
          --
          FOR i IN 6..(length(round(l_y))-1) LOOP
            l_y := l_y/10;
          END LOOP;
          --
      -- If Y coord is less than 6 length, then divide by factor of 10
        ELSIF length(round(l_y)) < 6
          THEN
          --
          FOR i IN (length(round(l_y))+1)..6 LOOP
           l_y := l_y*10;
          END LOOP;
          --
        END IF;
      --
        po_y := l_y;
      --
      ELSE
        po_x := NULL;
        po_y := NULL;
      --
      END IF;
    --
    ELSE
    --
      po_x := l_x;
      po_y := l_y;
    --
    END IF;
  --
  EXCEPTION
    WHEN e_no_coords
    THEN
      RAISE_APPLICATION_ERROR(-20501,'No coordinates exist for '||pi_postcode||' Name - '||pi_building_name);
    WHEN OTHERS
    THEN
      RAISE;
  END get_address_xy;
--
-----------------------------------------------------------------------------
--
-- This procedure inserts gdo for a given postcode/building no. using the proc
-- get_address_xy
  PROCEDURE set_address_xy_gdo
              ( pi_doc_id          IN  docs.doc_id%TYPE
              , pi_postcode        IN  hig_address.had_postcode%TYPE
              , pi_building_no     IN  hig_address.had_building_no%TYPE
              , po_gis_session_id OUT gis_data_objects.gdo_session_id%TYPE)
  IS
    l_x    NUMBER;
    l_y    NUMBER;
    l_sess NUMBER;
  BEGIN
  --
    get_address_xy ( pi_postcode     => pi_postcode
                   , pi_building_no  => pi_building_no
                   , po_x            => l_x
                   , po_y            => l_y
                   );
  --
    IF l_x IS NOT NULL
    AND l_y IS NOT NULL
    THEN
    --
      l_sess := higgis.get_session_id;
    --
    -- Set gdo_string to DOC_ID PK value so that Locator knows we are doing this particular bit
    -- of processing - i.e. it knows what to return to GDO.

      INSERT INTO gis_data_objects
        (gdo_session_id, gdo_pk_id, gdo_rse_he_id, gdo_st_chain, gdo_end_chain, gdo_x_val,gdo_y_val
        ,gdo_theme_name, gdo_feature_id, gdo_xsp, gdo_offset, gdo_seq_no, gdo_dynamic_theme ,gdo_string)
      VALUES
        (l_sess,nvl(hig.get_user_or_sys_opt ('SDOPTZOOM'),150),NULL,NULL,NULL,l_x,l_y
        ,NULL,NULL,NULL,NULL,NULL,'N',pi_doc_id);
    --
    ELSE
    -- NO XYs so zoom to initial extent;
      reset_map (l_sess);
    --
      UPDATE gis_data_objects
         SET gdo_string = pi_doc_id
       WHERE gdo_session_id = l_sess;
    --
    END IF;
  --
    po_gis_session_id  :=  l_sess;
  --
  END set_address_xy_gdo;
--
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--
-- This procedure inserts gdo for a given postcode/building name. using the proc
-- get_address_xy
  PROCEDURE set_address_xy_gdo
              ( pi_doc_id          IN  docs.doc_id%TYPE
              , pi_postcode        IN  hig_address.had_postcode%TYPE
              , pi_building_name   IN  hig_address.had_building_name%TYPE
              , po_gis_session_id OUT gis_data_objects.gdo_session_id%TYPE)
  IS
    l_x    NUMBER;
    l_y    NUMBER;
    l_sess NUMBER;
  BEGIN
  --
    get_address_xy ( pi_postcode       => pi_postcode
                   , pi_building_name  => pi_building_name
                   , po_x              => l_x
                   , po_y              => l_y
                   );
  --
    IF l_x IS NOT NULL
    AND l_y IS NOT NULL
    THEN
    --
      l_sess := higgis.get_session_id;
    --
    -- Set gdo_string to DOC_ID PK value so that Locator knows we are doing this particular bit
    -- of processing - i.e. it knows what to return to GDO.

      INSERT INTO gis_data_objects
        (gdo_session_id, gdo_pk_id, gdo_rse_he_id, gdo_st_chain, gdo_end_chain, gdo_x_val,gdo_y_val
        ,gdo_theme_name, gdo_feature_id, gdo_xsp, gdo_offset, gdo_seq_no, gdo_dynamic_theme ,gdo_string)
      VALUES
        (l_sess,nvl(hig.get_user_or_sys_opt ('SDOPTZOOM'),150),NULL,NULL,NULL,l_x,l_y
        ,NULL,NULL,NULL,NULL,NULL,'N',pi_doc_id);
    --
    ELSE
    -- NO XYs so zoom to initial extent;
      reset_map (l_sess);
    --
      UPDATE gis_data_objects
         SET gdo_string = pi_doc_id
       WHERE gdo_session_id = l_sess;
    --
    END IF;
  --
    po_gis_session_id  :=  l_sess;
  --
  END set_address_xy_gdo;
--
-----------------------------------------------------------------------------
--
-- Creates GDO for map to zoom back to initial extent
-- Call this, then call plib$call_gis in the form
  PROCEDURE reset_map
              ( po_gis_session_id OUT gis_data_objects.gdo_session_id%TYPE )
  IS
    l_x    NUMBER;
    l_y    NUMBER;
    l_z    NUMBER;
    l_sess NUMBER;
  BEGIN
  --
    mapviewer.set_cent_size_theme;
  --
    SELECT getx, gety, getcent
      INTO l_x, l_y, l_z
      FROM dual;
  --
    l_sess := higgis.get_session_id;
  --
    higgis.insert_gis_autonomous
      ( p_gdo_session_id  => l_sess
      , p_gdo_pk_id       => l_z
      , p_gdo_rse_he_id   => NULL
      , p_gdo_st_chain    => NULL
      , p_gdo_end_chain   => NULL
      , p_gdo_x_val       => l_x
      , p_gdo_y_val       => l_y
      , p_gdo_theme_name  => NULL
      , p_gdo_feature_id  => NULL
      , p_gdo_xsp         => NULL
      , p_gdo_offset      => NULL
      , p_gdo_seq_no      => NULL );
  --
    po_gis_session_id := l_sess;
  --
  END reset_map;
--
---------------------------------------------------------------------------------------------------
--
  PROCEDURE update_pem_with_rse_from_gdo
              ( pi_session_id      IN gis_data_objects.gdo_session_id%TYPE
              , pi_doc_id          IN docs.doc_id%TYPE )
  IS
    l_rec_gdo gis_data_objects%ROWTYPE;
  BEGIN
  --
    SELECT * INTO l_rec_gdo FROM gis_data_objects
    WHERE gdo_session_id = pi_session_id
      AND gdo_pk_id      = pi_doc_id;
  --
    IF  l_rec_gdo.gdo_rse_he_id IS NOT NULL
    AND l_rec_gdo.gdo_st_chain  IS NOT NULL
    THEN
    --
      BEGIN
        EXECUTE IMMEDIATE
          'BEGIN '||chr(10)||
          ' DELETE doc_assocs '||chr(10)||
          '  WHERE das_doc_id = :pi_doc_id '||chr(10)||
          '    AND das_table_name = pem.get_pem_dgt_table_name_net; '||chr(10)||
          'EXCEPTION '||chr(10)||
          '  WHEN NO_DATA_FOUND THEN NULL; '||chr(10)||
          'END;'
        USING pi_doc_id;
      EXCEPTION
        WHEN OTHERS
        THEN NULL;
      END;
      --
      BEGIN
        EXECUTE IMMEDIATE
          'INSERT INTO doc_assocs '||chr(10)||
          ' (das_table_name, das_rec_id, das_doc_id) '||chr(10)||
          'VALUES '||chr(10)||
          ' (pem.get_pem_dgt_table_name_net,:gdo_rse_he_id,:pi_doc_id) '
        USING l_rec_gdo.gdo_rse_he_id, pi_doc_id;
      EXCEPTION
        WHEN OTHERS
        THEN NULL;
      END;
    --
    END IF;
  --
    UPDATE docs
       SET doc_compl_east  = l_rec_gdo.gdo_x_val
         , doc_compl_north = l_rec_gdo.gdo_y_val
     WHERE doc_id = pi_doc_id;

  --
  END update_pem_with_rse_from_gdo;
--
---------------------------------------------------------------------------------------------------
--
  FUNCTION get_locator_results
    RETURN tab_loc_results
  IS
    retval tab_loc_results;
  BEGIN
  --
    SELECT a.* BULK COLLECT INTO retval
      FROM TABLE(CAST(nm3locator.get_selected_items AS nm_id_tbl)) a;
  --
    RETURN retval;
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      RETURN retval;
    WHEN OTHERS
    THEN RAISE;
  END get_locator_results;
--
---------------------------------------------------------------------------------------------------
--
  -- AE
  -- End of DORSET enhancements for ATLAS.
  --
--
---------------------------------------------------------------------------------------------------
--
END doc;
/
