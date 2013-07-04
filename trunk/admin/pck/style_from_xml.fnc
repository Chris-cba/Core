CREATE OR REPLACE FUNCTION STYLE_FROM_XML ( STYLE IN VARCHAR2 ) RETURN VARCHAR2 IS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)style_from_xml.fnc	1.1 07/13/04
--       Module Name      : style_from_xml.fnc
--       Date into SCCS   : 04/07/13 09:36:06
--       Date fetched Out : 07/06/13 14:14:01
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  RETVAL VARCHAR2(2000);
BEGIN
  RETVAL :=
         to_char(substr(style,
                  instr(style, 'features style', 1, 1) + 16,
                 (instr(style, '>' , instr( style, 'features style', 1, 1), 1)) -
                 (instr(style, 'features style', 1, 1)) -17
           )
         );
  RETURN RETVAL;
END;
/
