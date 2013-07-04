create or replace package body nm3dbg as
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3dbg.pkb-arc   2.3   Jul 04 2013 15:23:06   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3dbg.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:23:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on sccs version :
--
--   Author : Priidu Tanava
--
--   package to implement indented and timed debug
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
/* History
  22.07.08 PT added rounding to timings to fix 10g different handling of localtimestamp
  06.05.10 PT log 724081: increased the size of l_time varchar2(10) to varchar2(20)
                the previous size overflows when time spent exceeds 28 hours
                this hopefully fixes the random overflows that have been reported
*/


  g_body_sccsid     constant  varchar2(2000) := '"$Revision:   2.3  $"';
  g_package_name    constant  varchar2(30)   := 'nm3dbg';

  
  m_debug           constant number(1) := 3;
  
  m_ind             pls_integer := 0;
  m_debug_on        boolean := false;
  m_timing_on       boolean := false;
  m_timestamp       number := 0;
  

  --
  -----------------------------------------------------------------------------
  --
  function get_version return varchar2
  is
  begin
     return g_sccsid;
  end;
  --
  -----------------------------------------------------------------------------
  --
  function get_body_version return varchar2
  is
  begin
     return g_body_sccsid;
  end;


  
  
  procedure debug_on
  is
  begin
    if not m_debug_on then
      m_debug_on := true;
      m_ind := 0;
      nm_debug.debug_on;
    end if;
  end;
  
  
  -- call only in outer access procedures
  procedure debug_off
  is
    l_time      varchar2(20);
    l_timestamp number;
  begin
    if m_timing_on then
      select to_number(to_char(localtimestamp, 'SSSSS.FF')) t
      into l_timestamp from dual;
      l_time := round(l_timestamp - m_timestamp, 3)||' ';
    end if;
    nm_debug.debug(lpad(' ', m_ind * 2, ' ')||l_time);
    m_debug_on := false;
    m_timing_on := false;
    nm_debug.debug_off;
  end;
  
  
  procedure timing_on
  is
  begin
    m_timing_on := true;
    select to_number(to_char(localtimestamp, 'SSSSS.FF')) t
    into m_timestamp from dual;
  end;
  
  
  procedure ind
  is
  begin
    m_ind := m_ind + 1;
  end;
  
  procedure deind
  is
  begin
    m_ind := greatest(m_ind - 1, 0);
  end;
  
  
  -- We have to wrap the getting of the timestamp into a select from dual
  --  otherwise the package doesn't compile
  -- the funny thing is that this works:
  --   create or replace procedure zz_dudu as
  --     l_timestamp number;
  --   begin
  --     l_timestamp := to_number(to_char(localtimestamp, 'SSSSS.FF'));
  --   end;
  --   /
  procedure putln(p_text in varchar2)
  is
    l_time      varchar2(20);
    l_timestamp number;
  begin
    if m_debug_on then
      if m_timing_on then
        select to_number(to_char(localtimestamp, 'SSSSS.FF')) t
        into l_timestamp from dual;
        l_time := round(l_timestamp - m_timestamp, 3)||' ';
      end if;
      nm_debug.debug(lpad(' ', m_ind * 2, ' ')||l_time||p_text);
    end if;
  end;
  
  
  -- Same as putln but forces the debug on
  -- Todo: it would be good to have an option to turn debug on and off in nm_debug
  --  without inserting the commenting line.
  procedure puterr(p_text in varchar2)
  is
  begin
    if not m_debug_on then
      m_ind := 0;
      nm_debug.debug_on;
    end if;
    nm_debug.debug(lpad(' ', m_ind * 2, ' ')||p_text);
    if not m_debug_on then
      nm_debug.debug_off;
    end if;
    deind;
  end;
  
  
  function to_char(p_value in boolean) return varchar2
  is
  begin
    if p_value then return 'true';
    elsif not p_value then return 'false';
    else return null;
    end if;
  end;
  
  
  
  -- this returns the current max nd_id value from nm_dbug
  function max_id return number
  is
    l_max_id number;
  begin
    select max(nd_id) into l_max_id from nm_dbug;
    return l_max_id;
  end;
  

end;
/
