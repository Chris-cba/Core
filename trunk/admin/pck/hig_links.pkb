CREATE OR REPLACE package body hig_links as
--<PACKAGE>
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/hig_links.pkb-arc   3.2   Jul 04 2013 14:47:36   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_links.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:47:36  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       SCCS Version     : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--</PACKAGE>
--<GLOBVAR>
    g_sccsid      CONSTANT  VARCHAR2(2000) := '$Revision:   3.2  $';
--  g_sccsid is the SCCS ID for the package
--</GLOBVAR>
--
-----------------------------------------------------------------------------
FUNCTION next_hmlc_id RETURN hig_module_link_calls.hmlc_id%TYPE IS

BEGIN

 RETURN nm3ddl.sequence_nextval('hmlc_id_seq');

END next_hmlc_id;


  procedure create_module_call (
    p_hmlc_id                 in     hig_module_link_calls.hmlc_id%type
   ,p_hmlc_seq                in     hig_module_link_calls.hmlc_seq%type 
   ,p_hmlc_method_id          in     hig_module_link_calls.hmlc_method_id%type
   ,p_hmlc_param_from_value   in     hig_module_link_calls.hmlc_param_from_value%type
  ) is
/*
  purpose:
    creates a module link call, this procedure is used as auto transaction
  from hig_context.pll
  parameters:
    the module link method id
    parameter value
*/
    pragma autonomous_transaction;
  begin
  
    insert into hig_module_link_calls
                (hmlc_id
                ,hmlc_seq
                ,hmlc_method_id
                ,hmlc_param_from_value
--                ,hmlc_date_created
--                ,hmlc_created_by
                )
    values      (p_hmlc_id
                ,p_hmlc_seq
                ,p_hmlc_method_id
                ,p_hmlc_param_from_value
--                ,sysdate
--                ,user
                );

    commit;
  end;

  procedure delete_module_call (p_hmlc_id in hig_module_link_calls.hmlc_id%type) is
/*
  purpose:
    deletes a module link call, this procedure is used as auto transaction from hig_context.pll
  parameters:
    the module link call id
*/
    pragma autonomous_transaction;
  begin
    delete from hig_module_link_calls
    where       hmlc_id = p_hmlc_id;

    commit;
  end;
end;
/

