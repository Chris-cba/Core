create or replace package body nm3invband as
--
-----------------------------------------------------------------------------
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3invband.pkb-arc   2.3   Jul 04 2013 16:11:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3invband.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:11:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:12  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.3
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   Inventory Banding package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   --g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"@(#)nm3invband.pkb	1.3 04/19/01"';
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.3  $"';

--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3invband';
--
   g_invband_exception EXCEPTION;
   g_invband_exc_code  NUMBER         := -20001;
   g_invband_exc_msg   VARCHAR2(2000) := 'Unspecified exception within NM3INVBAND';
--
   g_rec_nita           nm_inv_type_attribs%ROWTYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_and_check_inv_type_attrib
      (pi_inv_type    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_band_det
      (pi_inv_type    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ,pi_banding_id  IN     nm_inv_type_attrib_bandings.itb_banding_id%TYPE
      ,pi_value       IN     NUMBER
      ) RETURN nm_inv_type_attrib_bandings.itb_banding_description%TYPE IS
--
   l_retval nm_inv_type_attrib_bandings.itb_banding_description%TYPE := pi_value;
--
   CURSOR cs_itd (p_inv_type    nm_inv_type_attrib_bandings.itb_inv_type%TYPE
                 ,p_attrib_name nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
                 ,p_banding_id  nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                 ,p_value       NUMBER
                 ) IS
   SELECT itd_band_description
    FROM  nm_inv_type_attrib_band_dets
   WHERE  itd_inv_type        = p_inv_type
    AND   itd_attrib_name     = p_attrib_name
    AND   itd_itb_banding_id  = p_banding_id
    AND   p_value BETWEEN itd_band_min_value AND itd_band_max_value;
--
BEGIN
--
   OPEN  cs_itd (pi_inv_type
                ,pi_attrib_name
                ,pi_banding_id
                ,pi_value
                );
   FETCH cs_itd INTO l_retval;
   CLOSE cs_itd;
--
   RETURN l_retval;
--
END get_inv_band_det;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_band_det
      (pi_inv_type    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ,pi_banding_id  IN     nm_inv_type_attrib_bandings.itb_banding_id%TYPE
      ,pi_value       IN     DATE
      ) RETURN nm_inv_type_attrib_bandings.itb_banding_description%TYPE IS
BEGIN
   RETURN get_inv_band_det
             (pi_inv_type    => pi_inv_type
             ,pi_attrib_name => pi_attrib_name
             ,pi_banding_id  => pi_banding_id
             ,pi_value       => TO_NUMBER(TO_CHAR(pi_value,'J'))
             );
END get_inv_band_det;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_itb
      (pi_inv_type    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ,pi_banding_id  IN     nm_inv_type_attrib_bandings.itb_banding_id%TYPE
      ) IS
--
   l_rec_itb            nm_inv_type_attrib_bandings%ROWTYPE;
   l_tab_rec_itd        tab_rec_itd;
   l_smallest_increment NUMBER := 1;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_itb');
--
-- Ensure that the NM_INV_TYPE_ATTRIBS record exists and is suitible for banding
--
   get_and_check_inv_type_attrib
      (pi_inv_type    => pi_inv_type
      ,pi_attrib_name => pi_attrib_name
      );
--
   IF g_rec_nita.ita_dec_places IS NOT NULL
    THEN
      -- If there is ITA_DEC_PLACES specified then work out the smallest increment
      --  to be used when checking for gaps in bands
      l_smallest_increment := nm3flx.ten_to_power(1,0-g_rec_nita.ita_dec_places);
   END IF;
--
-- SELECT the nm_inv_type_attrib_bandings record to ensure it exists
--
   get_itb (pi_inv_type
           ,pi_attrib_name
           ,pi_banding_id
           ,l_rec_itb
           );
--
-- SELECT all of the nm_inv_type_attrib_band_dets records into an array
--
   get_itd (pi_inv_type
           ,pi_attrib_name
           ,pi_banding_id
           ,l_tab_rec_itd
           );
--
   FOR l_count IN 1..(l_tab_rec_itd.COUNT-1)
    LOOP
      DECLARE
--
         -- Declare simple ROWTYPE records to make the code (MUCH) easier to read
         --  than it would be with the array vars
         l_current_rec_itd nm_inv_type_attrib_band_dets%ROWTYPE;
         l_next_rec_itd    nm_inv_type_attrib_band_dets%ROWTYPE;
--
      BEGIN
--
         l_current_rec_itd := l_tab_rec_itd(l_count);
         l_next_rec_itd    := l_tab_rec_itd(l_count+1);
--
         -- LOG 697138:LS23/04/09 
         -- Allowed the min/max baning to have same value
         -- Removed the equal sign
         IF  l_current_rec_itd.itd_band_min_value > l_current_rec_itd.itd_band_max_value
         OR l_next_rec_itd.itd_band_min_value     > l_next_rec_itd.itd_band_max_value
          THEN
            --
            -- If the current MIN is NOT < current MAX
            --
            -- e.g. Current MIN is 1.1
            --      Current MAX is 1
            --  1.1 is >= 1 so ERROR
            --
            -- Also check NEXT as well as CURRENT to catch the last record in the array
            --
            g_invband_exc_code := -20443;
            g_invband_exc_msg  := 'NM_INV_TYPE_ATTRIB_BANDINGS record found with itd_band_min_value NOT < itd_band_max_value';
            RAISE g_invband_exception;
         END IF;
--
         IF g_rec_nita.ita_dec_places IS NOT NULL
          THEN
            IF  TRUNC(l_current_rec_itd.itd_band_min_value,g_rec_nita.ita_dec_places) != l_current_rec_itd.itd_band_min_value
             OR TRUNC(l_current_rec_itd.itd_band_max_value,g_rec_nita.ita_dec_places) != l_current_rec_itd.itd_band_max_value
             OR TRUNC(l_next_rec_itd.itd_band_min_value,g_rec_nita.ita_dec_places)    != l_next_rec_itd.itd_band_min_value
             OR TRUNC(l_next_rec_itd.itd_band_max_value,g_rec_nita.ita_dec_places)    != l_next_rec_itd.itd_band_max_value
             THEN
               -- Check to make sure the value is not specified beyond the number of decimal places allowed
               -- Also check NEXT as well as CURRENT to catch the last record in the array
               g_invband_exc_code := -20448;
               g_invband_exc_msg  := 'Values specified in NM_INV_TYPE_ATTRIB_BAND_DETS to greater precision than allowed specified for INV_TYPE_ATTRIB';
               RAISE g_invband_exception;
            END IF;
         END IF;
--
         IF l_current_rec_itd.itd_band_max_value >= l_next_rec_itd.itd_band_min_value
          THEN
            --
            -- If the current MAX value is NOT less than the next MIN value then error
            --
            -- e.g. Current MAX is 1.1
            --      next    MIN is 1
            --   1.1 is >= 1 so ERROR
            --
            g_invband_exc_code := -20444;
            g_invband_exc_msg  := 'NM_INV_TYPE_ATTRIB_BANDINGS records found with overlapping values';
            RAISE g_invband_exception;
         END IF;
         --
         IF (l_current_rec_itd.itd_band_max_value + l_smallest_increment) != l_next_rec_itd.itd_band_min_value
          THEN
            --
            -- If the current MAX + (a number representing the smallest allowed (by ITA_DEC_PLACES))
            --  is <> to the next MIN
            --
            --  e.g. Current MAX is 1
            --       Next    MIN is 1.1
            --       DP is 1
            --  This results in IF 1 + (1.0E-1) <> 1.1 THEN ERROR
            --  which is IF 1.1 <> 1.1 THEN ERROR
            --
            g_invband_exc_code := -20446;
            g_invband_exc_msg  := 'Gaps found in NM_INV_TYPE_ATTRIB_BANDINGS records';
            RAISE g_invband_exception;
         END IF;
--
      END;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'validate_itb');
--
EXCEPTION
--
   WHEN g_invband_exception
    THEN
      RAISE_APPLICATION_ERROR(g_invband_exc_code,g_invband_exc_msg);
--
END validate_itb;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_itb
      (pi_inv_type    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ,pi_banding_id  IN     nm_inv_type_attrib_bandings.itb_banding_id%TYPE
      ,po_rec_itb        OUT nm_inv_type_attrib_bandings%ROWTYPE
      ) IS
--
   CURSOR cs_itb (p_inv_type    nm_inv_type_attrib_bandings.itb_inv_type%TYPE
                 ,p_attrib_name nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
                 ,p_banding_id  nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                 ) IS
   SELECT *
    FROM  nm_inv_type_attrib_bandings
   WHERE  itb_inv_type    = p_inv_type
    AND   itb_attrib_name = p_attrib_name
    AND   itb_banding_id  = p_banding_id;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_itb');
--
   OPEN  cs_itb (pi_inv_type
                ,pi_attrib_name
                ,pi_banding_id
                );
--
   FETCH cs_itb INTO po_rec_itb;
--
   IF cs_itb%NOTFOUND
    THEN
      CLOSE cs_itb;
      g_invband_exc_code := -20441;
      g_invband_exc_msg  := 'NM_INV_TYPE_ATTRIB_BANDINGS record not found';
      RAISE g_invband_exception;
   END IF;
--
   CLOSE cs_itb;
--
   nm_debug.proc_end(g_package_name,'get_itb');
--
EXCEPTION
--
   WHEN g_invband_exception
    THEN
      RAISE_APPLICATION_ERROR(g_invband_exc_code,g_invband_exc_msg);
--
END get_itb;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_itd
      (pi_inv_type    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ,pi_banding_id  IN     nm_inv_type_attrib_bandings.itb_banding_id%TYPE
      ,po_tab_rec_itb    OUT tab_rec_itd
      ) IS
--
   CURSOR cs_itd (p_inv_type    nm_inv_type_attrib_bandings.itb_inv_type%TYPE
                 ,p_attrib_name nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
                 ,p_banding_id  nm_inv_type_attrib_bandings.itb_banding_id%TYPE
                 ) IS
   SELECT *
    FROM  nm_inv_type_attrib_band_dets
   WHERE  itd_inv_type        = p_inv_type
    AND   itd_attrib_name     = p_attrib_name
    AND   itd_itb_banding_id  = p_banding_id
   ORDER BY itd_band_min_value;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_itd');
--
   po_tab_rec_itb.DELETE;
--
   FOR cs_rec IN cs_itd (pi_inv_type
                        ,pi_attrib_name
                        ,pi_banding_id
                        )
    LOOP
      po_tab_rec_itb(po_tab_rec_itb.COUNT+1) := cs_rec;
   END LOOP;
--
   IF po_tab_rec_itb.COUNT = 0
    THEN
      g_invband_exc_code := -20442;
      g_invband_exc_msg  := 'No NM_INV_TYPE_ATTRIB_BAND_DETS records found';
      RAISE g_invband_exception;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_itd');
--
EXCEPTION
--
   WHEN g_invband_exception
    THEN
      RAISE_APPLICATION_ERROR(g_invband_exc_code,g_invband_exc_msg);
--
END get_itd;
--
-----------------------------------------------------------------------------
--
PROCEDURE duplicate_bandings
      (pi_inv_type_to_copy    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name_to_copy IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ,pi_banding_id_to_copy  IN     nm_inv_type_attrib_bandings.itb_banding_id%TYPE
      ,pi_inv_type_new        IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name_new     IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ,po_banding_id_new         OUT nm_inv_type_attrib_bandings.itb_banding_id%TYPE
      ) IS
--
   l_rec_itb            nm_inv_type_attrib_bandings%ROWTYPE;
   l_tab_rec_itd        tab_rec_itd;
--
   l_new_rec_itb        nm_inv_type_attrib_bandings%ROWTYPE;
--
   l_rec_nita_for_copy  nm_inv_type_attribs%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'duplicate_bandings');
--
-- Ensure that the NM_INV_TYPE_ATTRIBS record exists and is suitible for banding
--
   get_and_check_inv_type_attrib
      (pi_inv_type    => pi_inv_type_to_copy
      ,pi_attrib_name => pi_attrib_name_to_copy
      );
   l_rec_nita_for_copy := g_rec_nita;
   get_and_check_inv_type_attrib
      (pi_inv_type    => pi_inv_type_new
      ,pi_attrib_name => pi_attrib_name_new
      );
   -- Make sure the INV_TYPE_ATTRIB from which we are copying the bandings
   --  has the same ITA_FORMAT
   IF g_rec_nita.ita_format != l_rec_nita_for_copy.ita_format
    THEN
      g_invband_exc_code := -20449;
      g_invband_exc_msg  := 'INV_TYPE_ATTRIB having its bandings copied is of different ITA_FORMAT';
      RAISE g_invband_exception;
   END IF;
--
-- SELECT the nm_inv_type_attrib_bandings record to ensure it exists
--
   get_itb (pi_inv_type_to_copy
           ,pi_attrib_name_to_copy
           ,pi_banding_id_to_copy
           ,l_rec_itb
           );
--
-- SELECT all of the nm_inv_type_attrib_band_dets records into an array
--  Do it this way rather than just a simple insert so that we can re-use existing code
--   to raise an error is no ITD records exist
--
   get_itd (pi_inv_type_to_copy
           ,pi_attrib_name_to_copy
           ,pi_banding_id_to_copy
           ,l_tab_rec_itd
           );
--
   -- Get the new itb_banding_id_seq
   po_banding_id_new := get_itb_banding_id_seq;
--
   -- Copy the old itb record to the new one
   l_new_rec_itb                 := l_rec_itb;
   -- Replace the values which we know are different
   l_new_rec_itb.itb_inv_type    := pi_inv_type_new;
   l_new_rec_itb.itb_attrib_name := pi_attrib_name_new;
   l_new_rec_itb.itb_banding_id  := po_banding_id_new;
--
   ins_itb (l_new_rec_itb);
--
   FOR l_count IN 1..l_tab_rec_itd.COUNT
    LOOP
      DECLARE
         -- Declare simple ROWTYPE record to make the code (MUCH) easier to read
         --  than it would be with the array vars
         l_rec_itd nm_inv_type_attrib_band_dets%ROWTYPE;
      BEGIN
--
         l_rec_itd := l_tab_rec_itd(l_count);
--
         l_rec_itd.itd_inv_type       := l_new_rec_itb.itb_inv_type;
         l_rec_itd.itd_attrib_name    := l_new_rec_itb.itb_attrib_name;
         l_rec_itd.itd_itb_banding_id := l_new_rec_itb.itb_banding_id;
         l_rec_itd.itd_band_seq       := get_itd_band_seq_seq;
--
         ins_itd (l_rec_itd);
--
      END;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'duplicate_bandings');
--
EXCEPTION
--
   WHEN g_invband_exception
    THEN
      RAISE_APPLICATION_ERROR(g_invband_exc_code,g_invband_exc_msg);
--
END duplicate_bandings;
--
-----------------------------------------------------------------------------
--
FUNCTION get_itb_banding_id_seq RETURN NUMBER IS
--
   CURSOR cs_nextval IS
   SELECT itb_banding_id_seq.NEXTVAL
    FROM  dual;
--
   l_retval NUMBER;
--
BEGIN
--
   OPEN  cs_nextval;
   FETCH cs_nextval INTO l_retval;
   CLOSE cs_nextval;
--
   RETURN l_retval;
--
END get_itb_banding_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION get_itd_band_seq_seq RETURN NUMBER IS
--
   CURSOR cs_nextval IS
   SELECT itd_band_seq_seq.NEXTVAL
    FROM  dual;
--
   l_retval NUMBER;
--
BEGIN
--
   OPEN  cs_nextval;
   FETCH cs_nextval INTO l_retval;
   CLOSE cs_nextval;
--
   RETURN l_retval;
--
END get_itd_band_seq_seq;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_itb (pi_rec_itb IN     nm_inv_type_attrib_bandings%ROWTYPE) IS
BEGIN
--
   INSERT INTO nm_inv_type_attrib_bandings
          (itb_inv_type
          ,itb_attrib_name
          ,itb_banding_id
          ,itb_banding_description
          )
   VALUES (pi_rec_itb.itb_inv_type
          ,pi_rec_itb.itb_attrib_name
          ,pi_rec_itb.itb_banding_id
          ,pi_rec_itb.itb_banding_description
          );
--
END ins_itb;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_itd (pi_rec_itd IN     nm_inv_type_attrib_band_dets%ROWTYPE) IS
BEGIN
--
   INSERT INTO nm_inv_type_attrib_band_dets
          (itd_inv_type
          ,itd_attrib_name
          ,itd_itb_banding_id
          ,itd_band_seq
          ,itd_band_min_value
          ,itd_band_max_value
          ,itd_band_description
          )
   VALUES (pi_rec_itd.itd_inv_type
          ,pi_rec_itd.itd_attrib_name
          ,pi_rec_itd.itd_itb_banding_id
          ,pi_rec_itd.itd_band_seq
          ,pi_rec_itd.itd_band_min_value
          ,pi_rec_itd.itd_band_max_value
          ,pi_rec_itd.itd_band_description
          );
--
END ins_itd;
--
-----------------------------------------------------------------------------
--
FUNCTION ita_format_valid_for_banding
      (pi_ita_format IN     nm_inv_type_attribs.ita_format%TYPE
      ) RETURN BOOLEAN IS
BEGIN
   RETURN (pi_ita_format IN ('DATE','NUMBER'));
END ita_format_valid_for_banding;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_and_check_inv_type_attrib
      (pi_inv_type    IN     nm_inv_type_attrib_bandings.itb_inv_type%TYPE
      ,pi_attrib_name IN     nm_inv_type_attrib_bandings.itb_attrib_name%TYPE
      ) IS
BEGIN
--
-- Get the NM_INV_TYPE_ATTRIBS record
--
   g_rec_nita := nm3inv.get_inv_type_attr(pi_inv_type, pi_attrib_name);
   IF g_rec_nita.ita_inv_type IS NULL
    THEN
      g_invband_exc_code := -20445;
      g_invband_exc_msg  := 'NM_INV_TYPE_ATTRIBS record not found';
      RAISE g_invband_exception;
   END IF;
--
   IF NOT ita_format_valid_for_banding(g_rec_nita.ita_format)
    THEN
      g_invband_exc_code := -20447;
      g_invband_exc_msg  := 'Bandings only allowed for DATE or NUMBER fields';
      RAISE g_invband_exception;
   END IF;
--
END get_and_check_inv_type_attrib;
--
-----------------------------------------------------------------------------
--
end nm3invband;
/
