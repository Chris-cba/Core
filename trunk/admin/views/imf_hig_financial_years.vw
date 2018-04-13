CREATE OR REPLACE FORCE VIEW imf_hig_financial_years
(
   financial_year,
   financial_year_start_date,
   financial_year_end_date
)
AS
SELECT
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/imf_hig_financial_years.vw-arc   3.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   imf_hig_financial_years.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:32:38  $
--       Version          : $Revision:   3.3  $
-- Foundation view displaying financial years
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   fyr_id,
   fyr_start_date,
   fyr_end_date
FROM financial_years
/

COMMENT ON TABLE IMF_HIG_FINANCIAL_YEARS IS 'Highways core foundation view of all Financial years, showing start and end dates of financial years. ';

COMMENT ON COLUMN IMF_HIG_FINANCIAL_YEARS.FINANCIAL_YEAR IS 'The budget financial year';
COMMENT ON COLUMN IMF_HIG_FINANCIAL_YEARS.FINANCIAL_YEAR_START_DATE IS 'The date the budget financial year starts';
COMMENT ON COLUMN IMF_HIG_FINANCIAL_YEARS.FINANCIAL_YEAR_END_DATE IS 'The date the budget financial year ends';

