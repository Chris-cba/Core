CREATE OR REPLACE TRIGGER nm_gty_aggr_sdo_types_who
    BEFORE INSERT OR UPDATE
    ON NM_GTY_AGGR_SDO_TYPES
    FOR EACH ROW
DECLARE
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_gty_aggr_sdo_types_who.trg-arc   1.0   Jan 10 2019 15:09:30   Rob.Coupe  $
    --       Module Name      : $Workfile:   nm_gty_aggr_sdo_types_who.trg  $
    --       Date into PVCS   : $Date:   Jan 10 2019 15:09:30  $
    --       Date fetched Out : $Modtime:   Jan 10 2019 15:08:00  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : Rob Coupe
    --
    -- TRIGGER ins_nm_members
    --       BEFORE  INSERT OR UPDATE
    --       ON      NM_MEMBERS_ALL
    --       FOR     EACH ROW
    --
    -----------------------------------------------------------------------------
    --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    l_sysdate   DATE;
    l_user      VARCHAR2 (30);
BEGIN
    SELECT SYSDATE, SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
      INTO l_sysdate, l_user
      FROM DUAL;

    --
    IF INSERTING
    THEN
        :new.DATE_CREATED := l_sysdate;
        :new.CREATED_BY := l_user;
    END IF;

    --
    :new.DATE_MODIFIED := l_sysdate;
    :new.MODIFIED_BY := l_user;
--
END nm_gty_aggr_sdo_types_who;
/
