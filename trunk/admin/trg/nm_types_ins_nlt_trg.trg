CREATE OR REPLACE TRIGGER nm_types_ins_nlt_trg
 AFTER INSERT
 ON NM_TYPES
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_types_ins_nlt_trg.trg	1.2 09/03/03
--       Module Name      : nm_types_ins_nlt_trg.trg
--       Date into SCCS   : 03/09/03 14:56:57
--       Date fetched Out : 07/06/13 17:03:42
--       SCCS Version     : 1.2
--
--
--   Author : Adrian Edwards
--
--   Create NM_LINEAR_TYPES trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

   l_rec_nlt NM_LINEAR_TYPES%ROWTYPE;

BEGIN

   IF :NEW.nt_datum = 'Y' AND :NEW.nt_linear = 'Y'
   AND INSERTING
    THEN

	l_rec_nlt.nlt_id            	:=  nm3seq.next_nlt_id_seq;
	l_rec_nlt.nlt_nt_type       	:= :NEW.nt_type;
	l_rec_nlt.nlt_descr         	:= :NEW.nt_descr;
	l_rec_nlt.nlt_seq_no		:=  1;
	l_rec_nlt.nlt_units		:= :NEW.nt_length_unit;
	l_rec_nlt.nlt_start_date	:=  trunc(sysdate);
	l_rec_nlt.nlt_admin_type	:= :NEW.nt_admin_type;
	l_rec_nlt.nlt_g_i_d		:= 'D';

	nm3ins.ins_nlt(p_rec_nlt => l_rec_nlt);

   END IF;
--
END nm_types_ins_nlt_trg;
/

