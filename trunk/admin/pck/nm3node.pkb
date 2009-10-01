create or replace package body nm3node as
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3node.pkb-arc   3.0   Oct 01 2009 14:58:20   rcoupe  $
--       Module Name      : $Workfile:   nm3node.pkb  $
--       Date into PVCS   : $Date:   Oct 01 2009 14:58:20  $
--       Date fetched Out : $Modtime:   Oct 01 2009 14:56:06  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--
-- g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   3.0  $"';
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3node';

FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
---------------------------------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
---------------------------------------------------------------------------------------------------
procedure update_element
                (p_old_ne_id         IN     nm_elements.ne_id%TYPE
                ,p_new_ne            IN     nm_elements%ROWTYPE
                ,p_new_ne_id         OUT    nm_elements.ne_id%TYPE
                ) IS
begin
  update  nm_elements_all
  set NE_UNIQUE          = p_new_ne.NE_UNIQUE,
      NE_TYPE            = p_new_ne.NE_TYPE,
      NE_NT_TYPE         = p_new_ne.NE_NT_TYPE,
      NE_DESCR           = p_new_ne.NE_DESCR,
      NE_LENGTH          = p_new_ne.NE_LENGTH,
      NE_ADMIN_UNIT      = p_new_ne.NE_ADMIN_UNIT,
      NE_END_DATE        = p_new_ne.NE_END_DATE,
      NE_GTY_GROUP_TYPE  = p_new_ne.NE_GTY_GROUP_TYPE,
      NE_OWNER           = p_new_ne.NE_OWNER,
      NE_NAME_1          = p_new_ne.NE_NAME_1,
      NE_NAME_2          = p_new_ne.NE_NAME_2,
      NE_PREFIX          = p_new_ne.NE_PREFIX,
      NE_NUMBER          = p_new_ne.NE_NUMBER,
      NE_SUB_TYPE        = p_new_ne.NE_SUB_TYPE,
      NE_GROUP           = p_new_ne.NE_GROUP,
      NE_NO_START        = p_new_ne.NE_NO_START,
      NE_NO_END          = p_new_ne.NE_NO_END,
      NE_SUB_CLASS       = p_new_ne.NE_SUB_CLASS,
      NE_NSG_REF         = p_new_ne.NE_NSG_REF,
      NE_VERSION_NO      = p_new_ne.NE_VERSION_NO
   where ne_id = p_old_ne_id;

   p_new_ne_id := p_old_ne_id;
end;

end nm3node;