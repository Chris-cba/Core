
PROMPT Create the Package Body HIGDDUE
CREATE OR REPLACE PACKAGE BODY higddue AS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)higddue.pkb	1.2 03/23/05
--       Module Name      : higddue.pkb
--       Date into SCCS   : 05/03/23 11:18:29
--       Date fetched Out : 07/06/13 14:10:30
--       SCCS Version     : 1.2
--
--
--   Author :
--
--   HIGHWAYS application generic utilities package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   g_body_sccsid     CONSTANT  VARCHAR2(80) := '"@(#)higddue.pkb	1.2 03/23/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
    cursor c_start_day(sdate date) is
    select to_number(to_char( sdate, 'D' ))
    from dual;

    cursor c_interval( p_date date, p_int_code varchar2) is
    select add_months(
                   p_date+nvl(int_days,0)+nvl(int_hrs/24,0),
                  (nvl(int_months,0)+nvl(int_yrs*12,0)))
    from intervals
    where int_code = p_int_code;

    cursor c_holidays( c_start_date date, c_end_date date ) is
    select count(*) from hig_holidays
    where hho_id between c_start_date and c_end_date;

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
  -----------------------------------------------------------------------------
  -- Fetch the value for a particular system option.
  -- The call to get_product removed by RAC on 15th September 1997.
  -- Overloaded function using the product code as argument has been removed.

  FUNCTION GET_SYSOPT
          (p_option_id         hig_options.hop_id%type)
           return varchar2 is

  cursor c_sys_opt is
     select hop_value
     from hig_options
     where hop_id = p_option_id;

  l_option_value hig_options.hop_value%type;

  begin

     open c_sys_opt;
     fetch c_sys_opt into l_option_value;
     close c_sys_opt;

     return( l_option_value );
  end get_sysopt;
  -----------------------------------------------------------------------------

  FUNCTION we_in_period( sdate in date, edate in date)
        return number is

  lwedays    number(3);  /*No of non-working days in a week*/
  nrem       number(3);  /*remainder of days over an integer no of weeks*/
  nweeks     number(3);  /*whole number of weeks in period*/
  sday       number(3);  /*The start day number*/
  ldays      number(3);  /*Return variable*/
  l_we       varchar2(20); /*String of weekend days from system options*/
  n_we       number;      /* Number of weekend days */
  icount     number;      /* count of characters in a string*/
  --
  begin
  --
    l_we := get_sysopt('WEEKEND');
    n_we := 0;
  <<loop_start>>
    if length(l_we) > 0 then
       icount := instr(l_we, ',' );
       if icount > 0 then
          l_we := substr( l_we, icount + 1 );
          n_we := n_we + 1;
          goto loop_start;
       end if;
       lwedays := n_we + 1;
    end if;
  --
    nweeks := trunc( ( edate - sdate )/ 7 );
    nrem   := mod( (edate-sdate), 7 );
  --
    open c_start_day(sdate);
    fetch c_start_day into sday;
    close c_start_day;
  --
    ldays := nweeks * lwedays + work_days( sday, nrem ) - nrem;
    return ldays;
  end we_in_period;
 -----------------------------------------------------------------------------

  FUNCTION work_days( sday in number, ndays in number)
           return number is

  ldays  number(2);
  istart number(2);
  iend   number(2);
  iday   number(2);
  day_string varchar2(10);
  --
  begin
  --
    ldays := ndays;
  --
    day_string := get_sysopt('WEEKEND');
    if day_string is null then
       null;
    else
  --
       istart := 1;
       iend   := instr( day_string, ',' )-1;
       if iend < 0 then
          iend := length( day_string );
       end if;
  --
  <<loop_start>>
  --
       iday := to_number( substr( day_string, istart, iend ));
  --
       if iday < sday then
          if iday + 7 <= sday + ldays + 1 then
             ldays := ldays + 1;
          end if;
       elsif iday > sday then
          if iday <= sday + ldays then
             ldays := ldays + 1;
          end if;
       else
          ldays := ldays + 1;
       end if;
  --
       day_string := substr( day_string, iend+2);
  --
       iend := instr( day_string, ',') -1;
       if iend < 0 then
          iend := length( day_string );
       end if;
  --
       if length( day_string ) > 0  then
          goto loop_start;
       end if;
  --
    end if;
  --
    return ldays;
  end work_days;
 -------------------------------------------------------------------------------
  FUNCTION date_due( p_date in date, p_int_code in varchar2,
                      p_week_days in boolean)
          return date is

    n_int   number;        /* number of days in interval */
    n_hol   number;        /* number of days holiday in the period */
    n_we    number;        /* number of weekend days in the period */

    n_hol_sav number;      /* no. of holdays in last iteration period */
    n_we_sav  number;      /* no. of weeekend days in last iter. period */

    l_end_date      date;  /* The end of the iteration period */
    l_end_date_new  date;  /* The end of the new iteration period */

    it_count number;       /* Iteration count */

 BEGIN

    open c_interval( p_date, p_int_code );
    fetch c_interval into l_end_date;
    if c_interval%notfound then
       close c_interval;
    else
       close c_interval;
    end if;

    if p_week_days then

 --   The interval represents a number of working days, adjust for
 --   holidays and weekend days.
 --
      n_hol_sav := 0;
      n_we_sav  := 0;
 --
      it_count := 0;
 --
 <<loop_start>>
 --
    if it_count > 10 then
       goto end_of_lp;
    end if;
 --
 -- Pick up the count of holidays in this (increment) period.
 --
          open c_holidays( p_date, l_end_date );
          fetch c_holidays into n_hol;
          close c_holidays;
 --
 -- Get the number of weekend days in the period after adding the number
 -- of days holiday.
 --
 --
          n_we := we_in_period( p_date, l_end_date+n_hol-n_hol_sav);
 --
 --
          l_end_date_new := l_end_date+n_hol-n_hol_sav+n_we-n_we_sav;
 --
 -- test for convergence of the end_dates
 --
          if to_char( l_end_date,'DD-MON-YYYY') =
             to_char( l_end_date_new, 'DD-MON-YYYY') then
             goto end_of_lp;
          else
             l_end_date := l_end_date_new;
             n_hol_sav  := n_hol;
             n_we_sav   := n_we;
             it_count := it_count + 1;
             goto loop_start;
          end if;
       end if;
 <<end_of_lp>>
    return l_end_date;
 --
 end date_due;
 ------------------------------------------------------------------------------
  FUNCTION date_due( p_date in varchar2, p_int_code in varchar2,
                      p_week_days in boolean)
          return varchar2 is

    n_int   number;        /* number of days in interval */
    n_hol   number;        /* number of days holiday in the period */
    n_we    number;        /* number of weekend days in the period */

    n_hol_sav number;      /* no. of holdays in last iteration period */
    n_we_sav  number;      /* no. of weeekend days in last iter. period */

    l_end_date      date;  /* The end of the iteration period */
    l_end_date_new  date;  /* The end of the new iteration period */
    l_date          date;  /* Used instead of p_date */
    l_date_returned varchar2(11);

    it_count number;       /* Iteration count */

 BEGIN
    l_date := to_date(p_date,'DD-MON-YYYY');
    open c_interval( l_date, p_int_code );
    fetch c_interval into l_end_date;
    if c_interval%notfound then
       close c_interval;
    ELSE
       close c_interval;
    END IF;

    if p_week_days then

 --   The interval represents a number of working days, adjust for
 --   holidays and weekend days.
 --
      n_hol_sav := 0;
      n_we_sav  := 0;
 --
      it_count := 0;
 --
 <<loop_start>>
 --
    if it_count > 10 then
       goto end_of_lp;
    end if;
 --
 -- Pick up the count of holidays in this (increment) period.
 --
          open c_holidays( l_date, l_end_date );
          fetch c_holidays into n_hol;
          close c_holidays;
 --
 -- Get the number of weekend days in the period after adding the number
 -- of days holiday.
 --
 --
          n_we := we_in_period( l_date, l_end_date+n_hol-n_hol_sav);
 --
 --
          l_end_date_new := l_end_date+n_hol-n_hol_sav+n_we-n_we_sav;
 --
 -- test for convergence of the end_dates
 --
          if to_char( l_end_date,'DD-MON-YYYY') =
             to_char( l_end_date_new, 'DD-MON-YYYY') then
             goto end_of_lp;
          else
             l_end_date := l_end_date_new;
             n_hol_sav  := n_hol;
             n_we_sav   := n_we;
             it_count := it_count + 1;
             goto loop_start;
          end if;
       end if;
 <<end_of_lp>>
    l_date_returned := to_char(l_end_date,'DD-MON-YYYY');
    return (l_date_returned);
 --
 end date_due;
--
END higddue;
/
  -------------------------------------------------------------------------------


