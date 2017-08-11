CREATE OR REPLACE TRIGGER NAJX_ID_SEQ_TRG
BEFORE INSERT ON NM_ASSET_TYPE_JUXTAPOSITIONS
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/najx_id_seq_trg.trg-arc   1.0   Aug 11 2017 13:21:50   Rob.Coupe  $
--       Module Name      : $Workfile:   najx_id_seq_trg.trg  $
--       Date into PVCS   : $Date:   Aug 11 2017 13:21:50  $
--       Date fetched Out : $Modtime:   Aug 11 2017 13:21:14  $
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
  if :new.najx_id is null then
    :new.NAJX_ID := NAJX_ID_SEQ.nextval;
  end if;
END  NAJX_ID_SEQ_TRG;
/