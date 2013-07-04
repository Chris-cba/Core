-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xkytc_sec_inv_cr8tab.sql	1.1 02/02/04
--       Module Name      : xkytc_sec_inv_cr8tab.sql
--       Date into SCCS   : 04/02/02 16:26:53
--       Date fetched Out : 07/06/13 13:59:32
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Kentucky Securing inventory tables
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

DROP TABLE xkytc_securing_inventory CASCADE CONSTRAINTS
/

CREATE TABLE xkytc_securing_inventory
    (xsi_nt_type      VARCHAR2(4) NOT NULL
    ,xsi_nit_inv_type VARCHAR2(4) NOT NULL
    )
/

ALTER TABLE xkytc_securing_inventory
  ADD CONSTRAINT xsi_pk
  PRIMARY KEY (xsi_nt_type,xsi_nit_inv_type)
/

ALTER TABLE xkytc_securing_inventory
  ADD CONSTRAINT xsi_nit_fk
  FOREIGN KEY (xsi_nit_inv_type)
  REFERENCES nm_inv_types_all (nit_inv_type)
  ON DELETE CASCADE
/

ALTER TABLE xkytc_securing_inventory
  ADD CONSTRAINT xsi_nt_fk
  FOREIGN KEY (xsi_nt_type)
  REFERENCES nm_types (nt_type)
  ON DELETE CASCADE
/

ALTER TABLE xkytc_securing_inventory
  ADD CONSTRAINT xsi_nin_fk
  FOREIGN KEY (xsi_nt_type,xsi_nit_inv_type)
  REFERENCES nm_inv_nw_all (nin_nw_type,nin_nit_inv_code)
  ON DELETE CASCADE
/

