CREATE OR REPLACE PACKAGE BODY lb_unit
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_unit.pkb-arc   1.0   Oct 05 2015 11:42:42   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_unit.pkb  $
   --       Date into PVCS   : $Date:   Oct 05 2015 11:42:42  $
   --       Date fetched Out : $Modtime:   Oct 05 2015 11:42:18  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Package designed to handle LB unit translations
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   --
--    FUNCTION tokenize (pi_text IN VARCHAR2, pi_delimiter IN CHAR) RETURN DBMS_SQL.VARCHAR2_TABLE IS
--        v_retval DBMS_SQL.VARCHAR2_TABLE;
--    BEGIN
--        IF pi_text IS NOT NULL
--        THEN
--            FOR i in 1 .. length(pi_text)-length(replace(pi_text,pi_delimiter,''))+1
--            LOOP
--                v_retval(i) := substr (pi_delimiter||pi_text||pi_delimiter,
--                            instr(pi_delimiter||pi_text||pi_delimiter, pi_delimiter, 1, i  ) + 1,
--                            instr (pi_delimiter||pi_text||pi_delimiter, pi_delimiter, 1, i+1) -
--                            instr (pi_delimiter||pi_text||pi_delimiter, pi_delimiter, 1, i) -1);
--            END LOOP;
--        END IF;
--        RETURN v_retval;
--    END tokenize;
--
   FUNCTION convert_exor_unit (pi_un_id_in    IN nm_units.UN_UNIT_ID%TYPE,
                               pi_un_id_out   IN nm_units.UN_UNIT_ID%TYPE,
                               pi_value       IN NUMBER)
      RETURN NUMBER
   IS
      l_rec_uc   nm_unit_conversions%ROWTYPE;
      l_retval   NUMBER := 0;
   BEGIN
      --
      --Why not use basic exor function- commented code is from original CTDOT package
      --
      l_retval :=
         NM3UNIT.CONVERT_UNIT (P_UN_ID_IN    => pi_un_id_in,
                               P_UN_ID_OUT   => pi_un_id_out,
                               P_VALUE       => pi_value);

      --        IF pi_un_id_in = pi_un_id_out
      --        THEN
      --            RETURN pi_value;
      --        END IF;
      ----
      --        l_rec_uc := nm3unit.get_uc(pi_un_id_in,pi_un_id_out);
      --        IF l_rec_uc.uc_conversion_factor IS NULL
      --        THEN
      --            DECLARE
      --                l_cur nm3type.ref_cursor;
      --                l_sql nm3type.max_varchar2;
      --            BEGIN
      --                l_sql := 'SELECT '||l_rec_uc.uc_function||'(:l_old_value) FROM DUAL';
      --                OPEN  l_cur FOR l_sql USING pi_value;
      --                FETCH l_cur INTO l_retval;
      --                CLOSE l_cur;
      ----
      --                EXCEPTION
      --                WHEN invalid_number
      --                THEN
      --                   IF l_cur%ISOPEN
      --                   THEN
      --                       CLOSE l_cur;
      --                   END IF;
      --                   RAISE_APPLICATION_ERROR(-20001,'Unit conversion failed '||l_rec_uc.uc_function
      --                                           ||'('||pi_value||')');
      --            END;
      --        ELSE
      --            l_retval := pi_value * l_rec_uc.uc_conversion_factor;
      --        END IF;
      RETURN l_retval;
   END convert_exor_unit;

   --


   --
   -- Function to convert unit values between eB (External) units and Exor
   --
   FUNCTION convert_lb_unit_to_exor (
      pi_external_unit_id   IN lb_units.EXTERNAL_UNIT_ID%TYPE,
      pi_un_id_out          IN nm_units.UN_UNIT_ID%TYPE,
      pi_value              IN NUMBER)
      RETURN NUMBER
   IS
   retval number;
   BEGIN
   
      select * into retval from (
      select pi_value * uc_conversion_factor
from nm_unit_conversions c,
     lb_units l1,
     nm_units  u
where uc_unit_id_out = pi_un_id_out
and u.un_unit_id = uc_unit_id_out
and external_unit_id = pi_external_unit_id
and uc_unit_id_in = exor_unit_id
      union all
      select pi_value
      from lb_units, nm_units
      where un_unit_id = exor_unit_id
      and exor_unit_id = pi_un_id_out
      and external_unit_id = pi_external_unit_id );
      
      return retval;

   END;
   

   --
   -- Function to convert unit values between Exor and eB (External) units
   --

   FUNCTION convert_exor_unit_to_lb (
      pi_un_id_in           IN nm_units.UN_UNIT_ID%TYPE,
      pi_external_unit_id   IN lb_units.EXTERNAL_UNIT_ID%TYPE,
      pi_value              IN NUMBER)
      RETURN NUMBER
   IS
   retval number;
   BEGIN
--     select pi_value 
      RETURN NULL;
   END;


   --
   -- Function to transform lengths using Oracle SRIDs - originally coded in CTDOT package
   --
   FUNCTION transform_length (pi_length      IN NUMBER,
                              pi_from_srid   IN NUMBER,
                              pi_to_srid     IN NUMBER)
      RETURN NUMBER IS
        v_converted_length NUMBER;
    BEGIN
        IF pi_from_srid = pi_to_srid
        THEN
            RETURN pi_length;
        END IF;

        select
            pi_length * from_uom.FACTOR_B / from_uom.FACTOR_C * to_uom.FACTOR_C / to_uom.FACTOR_B
        into
            v_converted_length
        from
            SDO_COORD_REF_SYS from_crs
                inner join SDO_COORD_AXES from_axes on from_axes.COORD_SYS_ID = from_crs.COORD_SYS_ID
                inner join SDO_UNITS_OF_MEASURE from_uom on from_uom.UOM_ID = from_axes.UOM_ID,
            SDO_COORD_REF_SYS to_crs
                inner join SDO_COORD_AXES to_axes on to_axes.COORD_SYS_ID = to_crs.COORD_SYS_ID
                inner join SDO_UNITS_OF_MEASURE to_uom on to_uom.UOM_ID = to_axes.UOM_ID
        where
            from_crs.SRID = pi_from_srid and
            from_axes."ORDER" = 1 and
            from_uom.UNIT_OF_MEAS_TYPE = 'length' and
            to_crs.SRID = pi_to_srid and
            to_axes."ORDER" = 1 and
            to_uom.UNIT_OF_MEAS_TYPE = 'length';

        return v_converted_length;
    END transform_length;

   --
   --
   -- Generic distance converter uses units in SDO system-from Spatial Advisor
   --
   FUNCTION Convert_Distance (p_srid    IN NUMBER,
                              p_value   IN NUMBER,
                              p_unit    IN VARCHAR2 := 'Meter')
      RETURN NUMBER
IS
   v_unit                     VARCHAR2 (1000) := UPPER (p_unit);
   v_unit_conversion_factor   NUMBER;
   v_srid_conversion_factor   NUMBER;
   v_radius_of_earth          NUMBER := 6378137;                    -- Default
   v_length                   NUMBER;
   v_srid                     MDSYS.cs_srs.SRID%TYPE;
   v_token_id                 NUMBER;
   v_token                    VARCHAR2 (4000);
   v_geocs                    BOOLEAN;

   CURSOR c_cs_tokens (
      p_srid   IN NUMBER)
   IS
      SELECT ptr_id AS id,
             SUBSTR (TRIM (BOTH ' ' FROM REPLACE (b.ptr_value, '"')),
                     1,
                     40)
                AS token
        FROM mdsys.cs_srs a, TABLE (Tokenize (a.wktext, ',[]')) b
       WHERE srid = p_srid;
BEGIN
   IF (p_srid IS NULL)
   THEN
      -- Normally Oracle assumes a NULL srid is planar but
      -- this could be planar feet, or meters etc so throw an error
      raise_application_error (-20014, 'Cannot operate on a NULL SRID');
   END IF;

   IF (p_value IS NULL)
   THEN
      raise_application_error (-20014, 'Cannot operate on a NULL value ');   END IF;

   -- Check if p_unit exists by getting the necessary conversion factor to meters
   BEGIN
      -- Note that the conversion_factor is a conversion factor between v_unit and 1 metre.
      SELECT conversion_factor
        INTO v_unit_conversion_factor
        FROM mdsys.sdo_dist_units
       WHERE sdo_unit = v_unit AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error ( -20015, 'Invalid Unit Specifier');
   END;

   -- Check if SRID exists
   BEGIN
      SELECT srid
        INTO v_srid
        FROM mdsys.cs_srs
       WHERE srid = p_srid;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20015, 'Invalid SRID');
   END;

   -- We need to get the conversion factor to meters and earth's radius for the supplied SRID.
   -- This can only be gotten by getting the WKTEXT in mdsys.cs_srs, breaking it into tokens,
   -- and finding the right ones:
   -- SPHEROID + 2 tokens = Radius
   -- Last UNIT + 1 = conversion unit
   -- Last UNIT + 2 = conversion unit value
   FOR rec IN c_cs_tokens (p_srid)
   LOOP
      IF (rec.id = 1)
      THEN
         v_geocs := CASE rec.token WHEN 'GEOGCS' THEN TRUE ELSE FALSE END;
      ELSIF (rec.token = 'SPHEROID')
      THEN
         v_token := rec.token;
         v_token_id := rec.id + 2;
      ELSIF (rec.token = 'UNIT')
      THEN
         v_token := rec.token;
         v_token_id := rec.id + 2;
      END IF;

      IF (rec.id = v_token_id)
      THEN
         IF (v_token = 'SPHEROID')
         THEN
            v_radius_of_earth := TO_NUMBER (rec.token);
         ELSIF (v_token = 'UNIT')
         THEN
            v_srid_conversion_factor := TO_NUMBER (rec.token);
         END IF;
      END IF;
   END LOOP;

   IF (v_geocs)
   THEN
      v_srid_conversion_factor := v_srid_conversion_factor * v_radius_of_earth;
   END IF;

   -- OK, now we have a conversion factor from p_unit to meters
   -- and a conversion factor for the units to meters
   -- The returned value is: p_value * v_srid_conversion_factor (to get value in meters) / v_unit_conversion_factor (to convert from meters to the unit)
   --
   RETURN (p_value * v_srid_conversion_factor) / v_unit_conversion_factor;
END Convert_Distance;


--Function to convert spatial units to Exor - note it needs a matching unit string else
--( -20015, 'Invalid Unit Specifier') will arise
--
   FUNCTION Convert_Distance (p_srid    IN NUMBER,
                              p_value   IN NUMBER,
                              p_unit    IN nm_units.un_unit_id%type)
      RETURN NUMBER 
IS
--   v_unit                     VARCHAR2 (1000) := UPPER (p_unit);
   v_unit_conversion_factor   NUMBER;
   v_srid_conversion_factor   NUMBER;
   v_radius_of_earth          NUMBER := 6378137;                    -- Default
   v_length                   NUMBER;
   v_srid                     MDSYS.cs_srs.SRID%TYPE;
   v_token_id                 NUMBER;
   v_token                    VARCHAR2 (4000);
   v_geocs                    BOOLEAN;

   CURSOR c_cs_tokens (
      p_srid   IN NUMBER)
   IS
      SELECT ptr_id AS id,
             SUBSTR (TRIM (BOTH ' ' FROM REPLACE (b.ptr_value, '"')),
                     1,
                     40)
                AS token
        FROM mdsys.cs_srs a, TABLE (Tokenize (a.wktext, ',[]')) b
       WHERE srid = p_srid;
BEGIN
   IF (p_srid IS NULL)
   THEN
      -- Normally Oracle assumes a NULL srid is planar but
      -- this could be planar feet, or meters etc so throw an error
      raise_application_error (-20014, 'Cannot operate on a NULL SRID');
   END IF;

   IF (p_value IS NULL)
   THEN
      raise_application_error (-20014, 'Cannot operate on a NULL value ');   END IF;

   -- Check if p_unit exists by getting the necessary conversion factor to meters
   BEGIN
      -- Note that the conversion_factor is a conversion factor between v_unit and 1 metre.
      SELECT conversion_factor
        INTO v_unit_conversion_factor
        FROM mdsys.sdo_dist_units, nm_units
       WHERE unit_name = un_unit_name AND ROWNUM = 1
       and un_unit_id = p_unit;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error ( -20015, 'Invalid Unit Specifier');
   END;

   -- Check if SRID exists
   BEGIN
      SELECT srid
        INTO v_srid
        FROM mdsys.cs_srs
       WHERE srid = p_srid;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20015, 'Invalid SRID');
   END;

   -- We need to get the conversion factor to meters and earth's radius for the supplied SRID.
   -- This can only be gotten by getting the WKTEXT in mdsys.cs_srs, breaking it into tokens,
   -- and finding the right ones:
   -- SPHEROID + 2 tokens = Radius
   -- Last UNIT + 1 = conversion unit
   -- Last UNIT + 2 = conversion unit value
   FOR rec IN c_cs_tokens (p_srid)
   LOOP
      IF (rec.id = 1)
      THEN
         v_geocs := CASE rec.token WHEN 'GEOGCS' THEN TRUE ELSE FALSE END;
      ELSIF (rec.token = 'SPHEROID')
      THEN
         v_token := rec.token;
         v_token_id := rec.id + 2;
      ELSIF (rec.token = 'UNIT')
      THEN
         v_token := rec.token;
         v_token_id := rec.id + 2;
      END IF;

      IF (rec.id = v_token_id)
      THEN
         IF (v_token = 'SPHEROID')
         THEN
            v_radius_of_earth := TO_NUMBER (rec.token);
         ELSIF (v_token = 'UNIT')
         THEN
            v_srid_conversion_factor := TO_NUMBER (rec.token);
         END IF;
      END IF;
   END LOOP;

   IF (v_geocs)
   THEN
      v_srid_conversion_factor := v_srid_conversion_factor * v_radius_of_earth;
   END IF;

   -- OK, now we have a conversion factor from p_unit to meters
   -- and a conversion factor for the units to meters
   -- The returned value is: p_value * v_srid_conversion_factor (to get value in meters) / v_unit_conversion_factor (to convert from meters to the unit)
   --
   RETURN (p_value * v_srid_conversion_factor) / v_unit_conversion_factor;
END Convert_Distance;
END;
/
