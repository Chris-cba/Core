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
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/njxt_id_seq_trg.trg-arc   1.0   Dec 19 2017 15:09:16   Rob.Coupe  $
--       Module Name      : $Workfile:   njxt_id_seq_trg.trg  $
--       Date into PVCS   : $Date:   Dec 19 2017 15:09:16  $
--       Date fetched Out : $Modtime:   Dec 19 2017 15:08:44  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

  if :new.njxt_id is null then
     :new.NJXT_ID := NJXT_ID_SEQ.nextval;
  end if;
END  NJXT_ID_SEQ_TRG;
/
