CREATE OR REPLACE FORCE VIEW imf_hig_financial_years
(
   financial_year,
   financial_year_start_date,
   financial_year_end_date,
)
AS
SELECT
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_hig_financial_years.vw-arc   3.0   Apr 08 2009 14:52:18   smarshall  $
--       Module Name      : $Workfile:   imf_hig_financial_years.vw  $
--       Date into PVCS   : $Date:   Apr 08 2009 14:52:18  $
--       Date fetched Out : $Modtime:   Apr 08 2009 14:51:58  $
--       Version          : $Revision:   3.0  $
-- Foundation view displaying financial years
-------------------------------------------------------------------------
   fyr_id,
   fyr_start_date,
   fyr_end_date
FROM financial_years
/

COMMENT ON COLUMN IMF_HIG_FINANCIAL_YEARS.FINANCIAL_YEAR IS 'The budget financial year';
COMMENT ON COLUMN IMF_HIG_FINANCIAL_YEARS.FINANCIAL_YEAR_START_DATE IS 'The date the budget financial year starts';
COMMENT ON COLUMN IMF_HIG_FINANCIAL_YEARS.FINANCIAL_YEAR_END_DATE IS 'The date the budget financial year ends';

