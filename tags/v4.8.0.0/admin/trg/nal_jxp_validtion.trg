CREATE OR REPLACE TRIGGER nal_jxp_validation
BEFORE INSERT OR UPDATE
ON NM_ASSET_LOCATIONS_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/admin/trg/nal_jxp_validtion.trg-arc   1.1   Jan 02 2019 09:56:08   Chris.Baugh  $
--       Module Name      : $Workfile:   nal_jxp_validtion.trg  $
--       Date into PVCS   : $Date:   Jan 02 2019 09:56:08  $
--       Date fetched Out : $Modtime:   Jan 02 2019 09:55:38  $
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
retval integer;
begin
  if :new.nal_jxp is not null then
    select 1
    into retval
    from NM_ASSET_TYPE_JUXTAPOSITIONS, nm_juxtapositions
    where njx_njxt_id = najx_njxt_id
    and njx_code = :new.nal_jxp
    and najx_inv_type = :new.nal_nit_type;
--
  end if;
exception
  when no_data_found then
    raise_application_error( -20001, 'JXP value is invalid' );
end;
/
