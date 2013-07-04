Create or Replace Package Body Templates AS
--   SCCS Identifiers :-
--
--       sccsid           : @(#)template.pkb	1.1 03/01/01
--       Module Name      : template.pkb
--       Date into SCCS   : 01/03/01 16:24:17
--       Date fetched Out : 07/06/13 14:14:02
--       SCCS Version     : 1.1
--
--
--   Author : Ian Smith
--
--  Package of functions for reporting on OLE templates
--  to be used in conjunction with the word template template.dot
--  It will produce a report of the columns defined within an OLE
--  template.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"@(#)template.pkb	1.1 03/01/01"';
--  g_body_sccsid is the SCCS ID for the package body
--
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
function Get_Base_Field(intLine IN INTEGER,
Template IN VARCHAR2)
RETURN VARCHAR2 IS
	Cursor Base_Field is
		SELECT DTC_COL_NAME
		FROM DOC_TEMPLATE_COLUMNS
		WHERE DTC_TEMPLATE_NAME = Template
		ORDER BY DTC_COL_SEQ;

	intRecordCount INTEGER :=1;
	strLine	VARCHAR2(250);

begin
	For Recs in Base_Field LOOP
		if intRecordCount = intLine then
			strLine := Recs.DTC_COL_NAME;
			exit;
		end if;
		intRecordCount := intRecordCount + 1;
	End Loop;

	return strLine;
end;

function Get_Base_Type(intLine IN INTEGER,
Template IN VARCHAR2)
RETURN VARCHAR2 IS
	Cursor Base_Type is
		SELECT DTC_COL_TYPE
		FROM DOC_TEMPLATE_COLUMNS
		WHERE DTC_TEMPLATE_NAME = Template
		ORDER BY DTC_COL_SEQ;

	intRecordCount INTEGER :=1;
	strLine	VARCHAR2(10);

begin
	For Recs in Base_Type LOOP
		if intRecordCount = intLine then
			strLine := Recs.DTC_COL_TYPE;
			exit;
		end if;
		intRecordCount := intRecordCount + 1;
	End Loop;

	return strLine;
end;


function Get_Word_Field(intLine IN INTEGER,
Template IN VARCHAR2)
RETURN VARCHAR2 IS
	Cursor Base_Word is
		SELECT DTC_COL_ALIAS
		FROM DOC_TEMPLATE_COLUMNS
		WHERE DTC_TEMPLATE_NAME = Template
		ORDER BY DTC_COL_SEQ;

	intRecordCount INTEGER :=1;
	strLine	VARCHAR2(30);

begin
	For Recs in Base_Word LOOP
		if intRecordCount = intLine then
			strLine := Recs.DTC_COL_ALIAS;
			exit;
		end if;
		intRecordCount := intRecordCount + 1;
	End Loop;

	return strLine;
end;

function Get_Media(Template IN VARCHAR2) RETURN VARCHAR2 IS
	Cursor c1 is
		SELECT DMD_DESCR
		FROM DOC_MEDIA
		WHERE DMD_ID =
			(SELECT DTG_DMD_ID
			FROM DOC_TEMPLATE_GATEWAYS
			WHERE DTG_TEMPLATE_NAME = Template);

	strReturn VARCHAR2(250);

begin
	Open c1;
	Fetch c1 into strReturn;
	Close c1;

	Return strReturn;

end;

function Get_Location(Template IN VARCHAR2) RETURN VARCHAR2 IS
	Cursor c1 is
		SELECT DLC_NAME||' ['||DLC_PATHNAME||']' DESCR
		FROM DOC_LOCATIONS
		WHERE DLC_ID =
			(SELECT DTG_DLC_ID
			FROM DOC_TEMPLATE_GATEWAYS
			WHERE DTG_TEMPLATE_NAME = Template);

	strReturn VARCHAR2(250);

begin
	Open c1;
	Fetch c1 into strReturn;
	Close c1;

	Return strReturn;

end;


end Templates;
/
