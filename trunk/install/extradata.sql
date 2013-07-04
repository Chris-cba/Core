--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/extradata.sql-arc   2.1   Jul 04 2013 13:45:30   James.Wadsworth  $
--       Module Name      : $Workfile:   extradata.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:00:00  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM SCCS ID Keyword, do no remove
define sccsid = '@(#)extradata.sql	1.1 03/02/01';

insert into HIG_DOMAINS (
HDO_DOMAIN
,HDO_PRODUCT
,HDO_TITLE
,HDO_CODE_LENGTH
) select
'PBI_CONDITION'
,'MAI'
,'SQL Condition Types'
,10
from dual
where not exists (
 select 'not exists'
 from HIG_DOMAINS
where HDO_DOMAIN = 'PBI_CONDITION'
);

insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'<'
,'Less than'
,'Y'
,195
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = '<'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'<='
,'<='
,'Y'
,196
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = '<='
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'='
,'Equal to'
,'Y'
,197
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = '='
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'>'
,'Greater than'
,'Y'
,198
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = '>'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'>='
,'>='
,'Y'
,199
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = '>='
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'BETWEEN'
,'between'
,'Y'
,200
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = 'BETWEEN'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'IN'
,'In'
,'Y'
,201
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = 'IN'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'IS NOT NULL'
,'is not null'
,'Y'
,202
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = 'IS NOT NULL'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'IS NULL'
,'is null'
,'Y'
,203
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = 'IS NULL'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'LIKE'
,'Like'
,'Y'
,204
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = 'LIKE'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'NOT IN'
,'Not in'
,'Y'
,205
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = 'NOT IN'
);
insert into HIG_CODES (
HCO_DOMAIN
,HCO_CODE
,HCO_MEANING
,HCO_SYSTEM
,HCO_SEQ
,HCO_START_DATE
,HCO_END_DATE
) select
'PBI_CONDITION'
,'NOT LIKE'
,'Not like'
,'Y'
,206
,null
,null
from dual
where not exists (
 select 'not exists'
 from HIG_CODES
where HCO_DOMAIN = 'PBI_CONDITION'
 and HCO_CODE = 'NOT LIKE'
);
commit;
