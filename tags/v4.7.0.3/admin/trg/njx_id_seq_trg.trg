CREATE OR REPLACE TRIGGER NJX_ID_SEQ_TRG
BEFORE INSERT ON NM_JUXTAPOSITIONS
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
BEGIN
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/njx_id_seq_trg.trg-arc   1.0   Aug 11 2017 13:26:20   Rob.Coupe  $
--       Module Name      : $Workfile:   njx_id_seq_trg.trg  $
--       Date into PVCS   : $Date:   Aug 11 2017 13:26:20  $
--       Date fetched Out : $Modtime:   Aug 11 2017 13:25:30  $
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
  if :new.njx_id is null then
    :new.NJX_ID := NJX_ID_SEQ.nextval;
  end if;
END  NJX_ID_SEQ_TRG;
/
