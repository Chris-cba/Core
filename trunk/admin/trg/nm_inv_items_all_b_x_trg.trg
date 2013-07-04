CREATE OR REPLACE TRIGGER nm_inv_items_all_b_X_trg
  BEFORE INSERT OR UPDATE
ON NM_INV_ITEMS_ALL
FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_b_x_trg.trg	1.5 09/20/01
--       Module Name      : nm_inv_items_all_b_x_trg.trg
--       Date into SCCS   : 01/09/20 14:32:54
--       Date fetched Out : 07/06/13 17:02:54
--       SCCS Version     : 1.5
--
--  BEFORE INSERT
--    OR UPDATE
--  ON NM_INV_ITEMS_ALL
--  FOR EACH ROW
--
--   Author : Rob Coupe
--
--   Inventory Cross-Attribute Validation Trigger
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
  x_exception EXCEPTION;
  x_error     NUMBER;
--
BEGIN
--
  IF :NEW.iit_inv_type = 'HOAL' THEN
    IF :NEW.IIT_X_SECT = 'STRA' THEN
      IF :NEW.IIT_NUM_ATTRIB16 IS NOT NULL OR
        :NEW.IIT_CHR_ATTRIB26 IS NOT NULL OR
        :NEW.IIT_NUM_ATTRIB17 IS NOT NULL  THEN
                x_error := 401;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_X_SECT IN ('LCUR','RCUR') THEN
      IF :NEW.IIT_NUM_ATTRIB16 IS NULL OR
         :NEW.IIT_CHR_ATTRIB26 IS  NULL  THEN
        x_error := 402;
        RAISE x_exception;
      END IF;
    END IF;
--
--  end of HOAL
--
  ELSIF :NEW.iit_inv_type = 'PAOR' THEN
    IF :NEW.IIT_NUM_ATTRIB18 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB18 < :NEW.IIT_NUM_ATTRIB16 THEN
        x_error := 41;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_NUM_ATTRIB18 IS NOT NULL THEN
      IF :NEW.IIT_CHR_ATTRIB26 IS NULL AND
         :NEW.IIT_CHR_ATTRIB28 IS NULL THEN
        x_error := 42;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB19 IS NULL THEN
        x_error := 101;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IS NULL THEN
      IF :NEW.IIT_NUM_ATTRIB19 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB27 IS NOT NULL THEN
        x_error := 102;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB20 IS NULL THEN
        x_error := 103;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 IS NULL THEN
      IF :NEW.IIT_NUM_ATTRIB20 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB29 IS NOT NULL THEN
        x_error := 104;
        RAISE x_exception;
      END IF;
     END IF;

     IF :NEW.IIT_CHR_ATTRIB26 NOT IN ('2','7') THEN
       IF :NEW.IIT_CHR_ATTRIB27 IS NOT NULL THEN
         x_error := 105;
        RAISE x_exception;
       END IF;
     END IF;

     IF :NEW.IIT_CHR_ATTRIB28 NOT IN ('2','7') THEN
       IF :NEW.IIT_CHR_ATTRIB29 IS NOT NULL THEN
         x_error := 106;
        RAISE x_exception;
       END IF;
     END IF;
--
--  end of PAOR
--

  ELSIF :NEW.iit_inv_type = 'PASH' THEN
    IF  :NEW.IIT_NUM_ATTRIB17 IS NOT NULL THEN
      IF :NEW.IIT_CHR_ATTRIB26 IS NULL AND
         :NEW.IIT_CHR_ATTRIB28 IS NULL  THEN
        x_error := 622;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB18 IS NULL THEN
        x_error := 101;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IS NULL THEN
      IF :NEW.IIT_NUM_ATTRIB18 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB27 IS NOT NULL THEN
        x_error := 102;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB18 IS NULL THEN
        x_error := 103;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 IS NULL THEN
      IF :NEW.IIT_NUM_ATTRIB19 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB29 IS NOT NULL THEN
        x_error := 104;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 NOT IN ('2','7') THEN
      IF :NEW.IIT_CHR_ATTRIB27 IS NOT NULL THEN
        x_error := 105;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 NOT IN ('2','7') THEN
      IF :NEW.IIT_CHR_ATTRIB29 IS NOT NULL THEN
        x_error := 106;
        RAISE x_exception;
      END IF;
    END IF;

--
--  end of PASH
--

  ELSIF :NEW.iit_inv_type = 'PAWI' THEN
    IF  :NEW.IIT_NUM_ATTRIB17 IS NOT NULL THEN
      IF :NEW.IIT_CHR_ATTRIB26 IS NULL AND
         :NEW.IIT_CHR_ATTRIB28 IS NULL  THEN
        x_error := 322;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB18 IS NULL THEN
        x_error := 101;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IS NULL THEN
      IF :NEW.IIT_NUM_ATTRIB18 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB27 IS NOT NULL THEN
        x_error := 102;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB19 IS NULL THEN
        x_error := 103;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 IS NULL THEN
      IF :NEW.IIT_NUM_ATTRIB19 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB29 IS NOT NULL THEN
        x_error := 104;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 NOT IN ('2','7') THEN
      IF :NEW.IIT_CHR_ATTRIB27 IS NOT NULL THEN
        x_error := 105;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 NOT IN ('2','7') THEN
      IF :NEW.IIT_CHR_ATTRIB29 IS NOT NULL THEN
        x_error := 106;
        RAISE x_exception;
      END IF;
    END IF;

--
--  end of PAWI
--

  ELSIF :NEW.IIT_INV_TYPE = 'RALI' THEN
    IF :NEW.IIT_NUM_ATTRIB18 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB19 IS NULL OR
         :NEW.IIT_NUM_ATTRIB19 < :NEW.IIT_NUM_ATTRIB18 THEN
        x_error := 301;
        RAISE x_exception;
      END IF;
    END IF;
--
--  end of RALI
--

  ELSIF :NEW.IIT_INV_TYPE = 'RACR' THEN
    IF :NEW.IIT_CHR_ATTRIB28 IN ('4','5') THEN
      IF :NEW.IIT_DATE_ATTRIB86 IS NOT NULL THEN
        x_error := 302;
        RAISE x_exception;
      END IF;
    END IF;
--
--  end of RACR
--

  ELSIF :NEW.IIT_INV_TYPE = 'ROCL' THEN
    IF :NEW.IIT_END_DATE IS NOT NULL THEN
      IF :NEW.IIT_DATE_ATTRIB89 IS NULL OR
         :NEW.IIT_DATE_ATTRIB88 IS NULL THEN
        x_error := 351;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_DATE_ATTRIB89 IS NOT NULL THEN
      IF :NEW.IIT_DATE_ATTRIB86 IS NULL OR
         :NEW.IIT_DATE_ATTRIB86 > :NEW.IIT_DATE_ATTRIB89 OR
        (:NEW.IIT_DATE_ATTRIB86  = :NEW.IIT_DATE_ATTRIB89 AND
         :NEW.IIT_DATE_ATTRIB87 >= :NEW.IIT_DATE_ATTRIB88 ) THEN
        x_error := 352;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB28 = 'Y' THEN
      IF :NEW.IIT_CHR_ATTRIB29 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB30 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB31 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB32 IS NOT NULL OR
         :NEW.IIT_CHR_ATTRIB33 IS NOT NULL THEN
        x_error := 353;
        RAISE x_exception;
      END IF;
    END IF;
--
--  end of ROCL
--

  ELSIF :NEW.IIT_INV_TYPE = 'SULA' THEN
    IF :NEW.IIT_NUM_ATTRIB19 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB17 > :NEW.IIT_NUM_ATTRIB19 THEN
        x_error := 203;
        RAISE x_exception;
      END IF;
    END IF;
--
--  end of SULA
--
  ELSIF :NEW.IIT_INV_TYPE = 'SUSH' THEN
    IF :NEW.IIT_NUM_ATTRIB19 IS NOT NULL THEN
      IF :NEW.IIT_NUM_ATTRIB17 > :NEW.IIT_NUM_ATTRIB19 THEN
        x_error := 232;
        RAISE x_exception;
      END IF;
    END IF;
--
--  end of SUSH
--


  ELSIF :NEW.IIT_INV_TYPE = 'VEAL' THEN
    IF :NEW.IIT_CHR_ATTRIB26 = '1' THEN
      if :NEW.IIT_NUM_ATTRIB16 IS NOT NULL OR
         :NEW.IIT_NUM_ATTRIB17 IS NOT NULL OR
         :NEW.IIT_NUM_ATTRIB18 IS NOT NULL THEN
        x_error := 451;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IN ('2','3') THEN
      if :NEW.IIT_NUM_ATTRIB17 IS NOT NULL OR
         :NEW.IIT_NUM_ATTRIB18 IS NOT NULL THEN
        x_error := 4522;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 IN ('2','3') THEN
      if :NEW.IIT_NUM_ATTRIB16 IS NULL THEN
        x_error := 4521;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 = '4' THEN
      if :NEW.IIT_NUM_ATTRIB16 IS NOT NULL THEN
        x_error := 4532;
        RAISE x_exception;
      END IF;
    END IF;

    IF :NEW.IIT_CHR_ATTRIB26 = '4' THEN
      if :NEW.IIT_NUM_ATTRIB17 IS NULL THEN
        x_error := 4531;
        RAISE x_exception;
      END IF;
    END IF;


  END IF; --item type
--
--end of type 3 triggers
--insert the remaining item types into an array if reflected in the rules for
--mutating triggers.
--
EXCEPTION
  WHEN x_exception THEN
     RAISE_APPLICATION_ERROR( -20760, Get_Error_String(x_error));
END;
/

