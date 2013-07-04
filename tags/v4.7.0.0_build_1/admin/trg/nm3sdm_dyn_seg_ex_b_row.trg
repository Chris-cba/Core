CREATE OR REPLACE TRIGGER NM3SDM_DYN_SEG_EX_B_ROW
BEFORE INSERT
ON NM3SDM_DYN_SEG_EX 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
--       sccsid           : @(#)nm3sdm_dyn_seg_ex_b_row.trg	1.2 02/13/06
--       Module Name      : nm3sdm_dyn_seg_ex_b_row.trg
--       Date into SCCS   : 06/02/13 17:04:17
--       Date fetched Out : 07/06/13 17:03:44
--       SCCS Version     : 1.2
--
--
--   Author : R.A. Coupe

l_ndse_id integer;
BEGIN
   l_ndse_id := 0;

   SELECT ndse_id_seq.NEXTVAL INTO l_ndse_id FROM dual;
   :NEW.ndse_id := l_ndse_id;

   EXCEPTION
     WHEN OTHERS THEN
       raise_application_error(-20001, 'Error in nm3sdm_dyn_seg_ex id generation');
END ;
/


