CREATE OR REPLACE TRIGGER NJXT_ID_SEQ_TRG
BEFORE INSERT ON NM_JUXTAPOSITION_TYPES
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/njxt_id_seq_trg.trg-arc   1.1   Jan 02 2019 10:06:52   Chris.Baugh  $
--       Module Name      : $Workfile:   njxt_id_seq_trg.trg  $
--       Date into PVCS   : $Date:   Jan 02 2019 10:06:52  $
--       Date fetched Out : $Modtime:   Jan 02 2019 10:06:18  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

  if :new.njxt_id is null then
     :new.NJXT_ID := NJXT_ID_SEQ.nextval;
  end if;
END  NJXT_ID_SEQ_TRG;
/
