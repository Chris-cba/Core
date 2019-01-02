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
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/najx_id_seq_trg.trg-arc   1.1   Jan 02 2019 09:24:56   Chris.Baugh  $
--       Module Name      : $Workfile:   najx_id_seq_trg.trg  $
--       Date into PVCS   : $Date:   Jan 02 2019 09:24:56  $
--       Date fetched Out : $Modtime:   Dec 07 2018 10:02:06  $
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
  if :new.najx_id is null then
    :new.NAJX_ID := NAJX_ID_SEQ.nextval;
  end if;
END  NAJX_ID_SEQ_TRG;
/