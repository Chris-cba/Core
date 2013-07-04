CREATE OR REPLACE FORCE VIEW NM3_NETWORK_ATTRIBS(ELEMENT_ID, HIERARCHY, NOMINATED, TOWN, SUB_PARISH, 
 SPARE1, SPARE2, SECTOR, LABEL, SECTION_ID) AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3_network_attribs.vw	1.1 03/16/05
--       Module Name      : nm3_network_attribs.vw
--       Date into SCCS   : 05/03/16 12:53:46
--       Date fetched Out : 07/06/13 17:08:23
--       SCCS Version     : 1.1
--
--
--   Author : %USERNAME%
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
select ni.iit_ne_id            element_id
        , ni.iit_chr_attrib35     hierarchy
        , ni.iit_chr_attrib36     nominated
        , ni.iit_chr_attrib27     town
        , f$get_parish(ni.iit_chr_attrib28)     sub_parish
        , ni.iit_chr_attrib41     spare1
        , ni.iit_chr_attrib42     spare2
        , ni.iit_chr_attrib30     sector
        , ne.ne_unique            label
        , ne.ne_id                section_id
from  nm_elements_all ne
    , nm_group_inv_link_all li
    , nm_inv_items_all ni
where ne.ne_id = li.ngil_ne_ne_id (+)
and   li.ngil_iit_ne_id = ni.iit_ne_id (+)
and   ni.iit_inv_type     ='HERM';
/


