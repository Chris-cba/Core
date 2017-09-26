CREATE OR REPLACE PACKAGE BODY hig_sso_api
AS
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/hig_sso_api.pkb-arc   1.3   Sep 26 2017 14:00:46   Chris.Baugh  $
  --       Module Name      : $Workfile:   hig_sso_api.pkb  $
  --       Date into PVCS   : $Date:   Sep 26 2017 14:00:46  $
  --       Date fetched Out : $Modtime:   Sep 26 2017 13:59:56  $
  --       Version          : $Revision:   1.3  $
  --       Based on SCCS version :
  ------------------------------------------------------------------
  --   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
  ------------------------------------------------------------------
  --
  --all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.3  $';

  g_package_name   CONSTANT VARCHAR2 (30) := 'hig_sso_api';
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;

  --
  -----------------------------------------------------------------------------
  --
  
  PROCEDURE get_relationship_orm(po_cursor     OUT sys_refcursor
                                ,pi_attribute1 IN  hig_relationship.hir_attribute1%TYPE) 
  IS
  BEGIN
    --
    -- VB6 can't cope with overloading, and Nhibernate requires ref_cursor as first param.
    -- 
    get_relationship(pi_attribute1 => pi_attribute1
                    ,po_cursor     => po_cursor);    
    --                    
  END get_relationship_orm;
 --
  PROCEDURE get_relationship(pi_attribute1 IN  hig_relationship.hir_attribute1%TYPE
                            ,po_cursor     OUT sys_refcursor)

  IS
    --
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT hig_relationship_api.decrypt_input(pi_input_string => hir_attribute2,
                                              pi_key         => hir_attribute4) attribute1
      FROM hig_relationship,
           dba_users,
           hig_users
     WHERE LOWER(hir_attribute1) = LOWER(pi_attribute1)
       AND NVL(account_status, 'MISSING') != 'LOCKED'
       AND username = hus_username
       AND hus_username = hig_relationship_api.decrypt_input(pi_input_string => hir_attribute2,
                                                             pi_key         => hir_attribute4)
       AND NVL(hus_end_date, TRUNC(sysdate+1)) >= TRUNC(sysdate);
    --
  END get_relationship;
--
-----------------------------------------------------------------------------
--
END hig_sso_api;
/