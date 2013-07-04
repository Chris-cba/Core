create or replace package body higgri_disco as
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)higgri_disco.pkb	1.1 03/01/01
--       Module Name      : higgri_disco.pkb
--       Date into SCCS   : 01/03/01 16:22:59
--       Date fetched Out : 07/06/13 14:10:36
--       SCCS Version     : 1.1
--
--
--   Author : Nik Stace
--
--   HIGGRI_DISCO package
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"@(#)higgri_disco.pkb	1.1 03/01/01"';
--  g_body_sccsid is the SCCS ID for the package body
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
function get_param_value (p_job_id in number
                         ,p_grp_param in varchar2
                         ) return varchar2 is
--
  CURSOR cs_grp (p_grp_job_id gri_run_parameters.grp_job_id%TYPE
                ,p_grp_param  gri_run_parameters.grp_param%TYPE
                ) IS
  SELECT grp_value
   FROM  gri_run_parameters
  WHERE  grp_job_id = p_grp_job_id
   AND   grp_param  = p_grp_param;
--
   l_retval gri_run_parameters.grp_value%TYPE;
--
begin
--
   OPEN  cs_grp (p_job_id, p_grp_param);
   FETCH cs_grp INTO l_retval;
   IF cs_grp%NOTFOUND
    THEN
      CLOSE cs_grp;
      RAISE_APPLICATION_ERROR(-20001,'gri_run_parameters record not found');
   END IF;
   CLOSE cs_grp;
--
   RETURN l_retval;
--
end get_param_value;
--
-----------------------------------------------------------------------------
--
function get_time_range(p_time in number) return varchar2 is
--
   l_retval       VARCHAR2(20) := 'UNKNOWN';
   l_hour_portion VARCHAR2(2);
--
begin
--
   IF p_time BETWEEN 0 AND 2400
    THEN
      l_hour_portion := substr(ltrim(to_char(p_time,'0000')),1,2);
      l_retval       := l_hour_portion||'.00 - '||l_hour_portion||'.59';
   END IF;
--
   RETURN l_retval;
--
--   if p_time < 100 then
--           return '00.00 - 00.59';
--   elsif p_time < 200 then
--           return '01.00 - 01.59';
--   elsif p_time < 300 then
--           return '02.00 - 02.59';
--   elsif p_time < 400 then
--           return '03.00 - 03.59';
--   elsif p_time < 500 then
--           return '04.00 - 04.59';
--   elsif p_time < 600 then
--           return '05.00 - 05.59';
--   elsif p_time < 700 then
--           return '06.00 - 06.59';
--   elsif p_time < 800 then
--           return '07.00 - 07.59';
--   elsif p_time < 900 then
--           return '08.00 - 08.59';
--   elsif p_time < 1000 then
--           return '09.00 - 09.59';
--   elsif p_time < 1100 then
--           return '10.00 - 10.59';
--   elsif p_time < 1200 then
--           return '11.00 - 11.59';
--   elsif p_time < 1300 then
--           return '12.00 - 12.59';
--   elsif p_time < 1400 then
--           return '13.00 - 13.59';
--   elsif p_time < 1500 then
--           return '14.00 - 14.59';
--   elsif p_time < 1600 then
--           return '15.00 - 15.59';
--   elsif p_time < 1700 then
--           return '16.00 - 16.59';
--   elsif p_time < 800 then
--           return '17.00 - 17.59';
--   elsif p_time < 1900 then
--           return '18.00 - 18.59';
--   elsif p_time < 2000 then
--           return '19.00 - 19.59';
--   elsif p_time < 2100 then
--           return '20.00 - 20.59';
--   elsif p_time < 2200 then
--           return '21.00 - 21.59';
--   elsif p_time < 2300 then
--           return '22.00 - 22.59';
--   elsif p_time < 2400 then
--           return '23.00 - 23.59';
--   else
--           return 'UNKNOWN';
--   end if;
--   return 'UNKNOWN';
end get_time_range;
--
-----------------------------------------------------------------------------
--
end higgri_disco;
/
