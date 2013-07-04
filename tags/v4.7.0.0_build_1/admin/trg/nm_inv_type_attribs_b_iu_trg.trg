CREATE OR REPLACE TRIGGER nm_inv_type_attribs_b_iu_trg
   BEFORE INSERT OR UPDATE
    ON    nm_inv_type_attribs_all
    FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_type_attribs_b_iu_trg.trg	1.3 03/02/06
--       Module Name      : nm_inv_type_attribs_b_iu_trg.trg
--       Date into SCCS   : 06/03/02 17:02:55
--       Date fetched Out : 07/06/13 17:03:03
--       SCCS Version     : 1.3
--
--
--   Author : Graeme Johnson
--
--   TRIGGER nm_inv_type_attribs_b_iu_trg
--      BEFORE INSERT OR UPDATE
--       ON    nm_inv_type_attribs_all
--       FOR   EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
 
 l_ita_rec nm_inv_type_attribs_all%ROWTYPE;
 l_index   PLS_INTEGER := nm3inv.g_tab_ita.COUNT+1;

BEGIN

 
     l_ita_rec.ITA_INV_TYPE         := :new.ITA_INV_TYPE;
     l_ita_rec.ITA_ATTRIB_NAME      := :new.ITA_ATTRIB_NAME;
     l_ita_rec.ITA_DYNAMIC_ATTRIB   := :new.ITA_DYNAMIC_ATTRIB;
     l_ita_rec.ITA_DISP_SEQ_NO      := :new.ITA_DISP_SEQ_NO;
     l_ita_rec.ITA_MANDATORY_YN     := :new.ITA_MANDATORY_YN;
     l_ita_rec.ITA_FORMAT           := :new.ITA_FORMAT;
     l_ita_rec.ITA_FLD_LENGTH       := :new.ITA_FLD_LENGTH;
     l_ita_rec.ITA_DEC_PLACES       := :new.ITA_DEC_PLACES;
     l_ita_rec.ITA_SCRN_TEXT        := :new.ITA_SCRN_TEXT;
     l_ita_rec.ITA_ID_DOMAIN        := :new.ITA_ID_DOMAIN;
     l_ita_rec.ITA_VALIDATE_YN      := :new.ITA_VALIDATE_YN;
     l_ita_rec.ITA_DTP_CODE         := :new.ITA_DTP_CODE;
     l_ita_rec.ITA_MAX              := :new.ITA_MAX;
     l_ita_rec.ITA_MIN              := :new.ITA_MIN;
     l_ita_rec.ITA_VIEW_ATTRI       := :new.ITA_VIEW_ATTRI;
     l_ita_rec.ITA_VIEW_COL_NAME    := :new.ITA_VIEW_COL_NAME;
     l_ita_rec.ITA_START_DATE       := :new.ITA_START_DATE;
     l_ita_rec.ITA_END_DATE         := :new.ITA_END_DATE;
     l_ita_rec.ITA_QUERYABLE        := :new.ITA_QUERYABLE;
     l_ita_rec.ITA_UKPMS_PARAM_NO   := :new.ITA_UKPMS_PARAM_NO;
     l_ita_rec.ITA_UNITS            := :new.ITA_UNITS;
     l_ita_rec.ITA_FORMAT_MASK      := :new.ITA_FORMAT_MASK;
     l_ita_rec.ITA_EXCLUSIVE        := :new.ITA_EXCLUSIVE;
     l_ita_rec.ITA_KEEP_HISTORY_YN  := :new.ITA_KEEP_HISTORY_YN;
     l_ita_rec.ITA_DATE_CREATED     := :new.ITA_DATE_CREATED;
     l_ita_rec.ITA_DATE_MODIFIED    := :new.ITA_DATE_MODIFIED;
     l_ita_rec.ITA_MODIFIED_BY      := :new.ITA_MODIFIED_BY;
     l_ita_rec.ITA_CREATED_BY       := :new.ITA_CREATED_BY;
     l_ita_rec.ITA_QUERY            := :new.ITA_QUERY;
     l_ita_rec.ITA_DISPLAYED        := :new.ITA_DISPLAYED;
     l_ita_rec.ITA_DISP_WIDTH       := :new.ITA_DISP_WIDTH;


  nm3inv.g_tab_ita(l_index) := l_ita_rec;

  
/*  GJ 20-MAY-2005 - replaced with above logic
   IF :new.ita_id_domain IS NOT NULL
    THEN
      l_rec_id ::= nm3get.get_id_all (pi_id_domain :=> :new.ita_id_domain);
      IF  (l_rec_id.id_datatype  := nm3type.c_varchar
           AND :new.ita_format  !:= l_rec_id.id_datatype
          )
       OR (l_rec_id.id_datatype  := nm3type.c_number
           AND :new.ita_format   := nm3type.c_date
          )
       OR (l_rec_id.id_datatype  := nm3type.c_date
           AND :new.ita_format   := nm3type.c_number
          )
       THEN
         hig.raise_ner (pi_appl               :=> nm3type.c_net
                       ,pi_id                 :=> 309
                       ,pi_supplementary_info :=> l_rec_id.id_datatype||':'||:new.ita_format
                       );
      END IF;
   END IF;
*/   
--
END nm_inv_type_attribs_b_iu_trg;
/
