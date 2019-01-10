CREATE OR REPLACE TRIGGER nm_gty_aggr_sdo_refresh_who
    BEFORE INSERT OR UPDATE
    ON NM_GTY_AGGR_SDO_REFRESH
    FOR EACH ROW
DECLARE
    --
    --   SCCS Identifiers :-
    --
    --       pvcsid                     : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_gty_aggr_sdo_refresh_who.trg-arc   1.0   Jan 10 2019 15:14:04   Rob.Coupe  $
    --       Module Name                : $Workfile:   nm_gty_aggr_sdo_refresh_who.trg  $
    --       Date into PVCS             : $Date:   Jan 10 2019 15:14:04  $
    --       Date fetched Out           : $Modtime:   Jan 10 2019 15:12:58  $
    --       PVCS Version               : $Revision:   1.0  $
    --
    --   table_name_WHO trigger
    --
    -----------------------------------------------------------------------------
    --    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    l_sysdate   DATE;
    l_user      VARCHAR2 (30);
BEGIN
    --
    SELECT SYSDATE, SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
      INTO l_sysdate, l_user
      FROM DUAL;

    --
    IF INSERTING
    THEN
        :new.NGAS_DATE_CREATED := l_sysdate;
        :new.NGAS_CREATED_BY := l_user;
    END IF;

    --
    :new.NGAS_DATE_MODIFIED := l_sysdate;
    :new.NGAS_MODIFIED_BY := l_user;
--
END nm_gty_aggr_sdo_refresh_who;
/