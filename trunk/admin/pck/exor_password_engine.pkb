CREATE OR REPLACE PACKAGE BODY exor_password_engine AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/exor_password_engine.pkb-arc   1.0   Apr 19 2016 08:02:00   Vikas.Mhetre  $
--       Module Name      : $Workfile:   exor_password_engine.pkb  $
--       Date into PVCS   : $Date:   Apr 19 2016 08:02:00  $
--       Date fetched Out : $Modtime:   Apr 19 2016 07:58:38  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Vikas Mhetre
--
-----------------------------------------------------------------------------
-- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
-- all global package variables here
--
   g_body_sccsid     constant varchar2(30) :='"$Revision:   1.0  $"';
--
   g_package_name    CONSTANT  VARCHAR2(30) := 'exor_password_engine';
--
--------------------------------------------------------------------------------------------------
--
-- ------------------------------------------------------------------
-- Overview:
-- ---------
-- Based upon the Oracle supplied password validation function 
-- utlpwdmg.sql. This package contains a function which will
-- validate a supplied password (f_verify) and a function which
-- will generate a random password (f_generate).
--
-- The f_verify function checks the following rules (as per utlpwdmg)
-- 
--   1) Password length has to be at least eight characters
--   2) Username is not the same as the password
--   3) Password is not username[1-100], eg username fred, password  fred10
--   4) Password is not the same as the username reversed
--   5) Password is not the same as the database name
--   6) Password is not database name[1-100]
--   7) Password is not one of welcome1,
--                             database1,
--                             account1, 
--                             user1234,
--                             password1,
--                             oracle123,
--                             computer1,
--                             abcdfeg1,
--                             change_on_install
--  8) Password must contain 3 of 4 character types - one digit, one uppercase letter,  one lowercase letter, one special character
--  9) New password must differ from the previous by at least 3 chars
-- 10) Password must not contain consecutive letters or numbers 
-- ------------------------------------------------------------------

pgDatabaseServer sys.v$database.name%TYPE;

TYPE pgInvalidPassword_t IS TABLE OF VARCHAR2(20);

ePasswordShort EXCEPTION;
PRAGMA EXCEPTION_INIT(ePasswordShort,    -20001);

ePasswordSimilar EXCEPTION;
PRAGMA EXCEPTION_INIT(ePasswordSimilar,  -20002);

ePasswordReversed EXCEPTION;
PRAGMA EXCEPTION_INIT(ePasswordReversed, -20003);

ePasswordSimple EXCEPTION;
PRAGMA EXCEPTION_INIT(ePasswordSimple,   -20006);

eOneDigitAndChar EXCEPTION;
PRAGMA EXCEPTION_INIT(eOneDigitAndChar,  -20007);

eNotEnoughDiffs EXCEPTION;
PRAGMA EXCEPTION_INIT(eNotEnoughDiffs,   -20008);

eConsecutiveNumChar EXCEPTION;
PRAGMA EXCEPTION_INIT(eConsecutiveNumChar,  -20009);

eInvalidSpecialChar EXCEPTION;
PRAGMA EXCEPTION_INIT(eInvalidSpecialChar,  -20010);

-- ------------------------------------------------------------------

-- ************************
-- * Forward Declarations *
-- ************************

PROCEDURE p_CheckForSimilarName     ( pCompName IN VARCHAR2,
                                      pPassword IN VARCHAR2,
                                      pErrorMsg IN VARCHAR2 
                                        DEFAULT 'Password too simple' );

PROCEDURE p_CheckForReverse         ( pUserName    IN VARCHAR2,
                                      pPassword    IN VARCHAR2 );

PROCEDURE p_CheckForInvalidPw       ( pPassword    IN VARCHAR2,
                                      pVaInvalidPasswds 
                                                   IN pgInvalidPassword_t );

PROCEDURE p_CheckInvalidSpecialChar( pPassword IN VARCHAR2 );

PROCEDURE p_CheckForDigitAndChar    ( pPassword    IN VARCHAR2 );

PROCEDURE p_CheckForThreeDifferences( pPassword    IN VARCHAR2,
                                      pOldPassword IN VARCHAR2);

PROCEDURE p_CheckConsecutiveNumChar( pPassword     IN VARCHAR2 );

-- ------------------------------------------------------------------

-- ********************
-- * Public Functions *
-- ********************

FUNCTION f_verify( pUserName    IN VARCHAR2,
                   pPassword    IN VARCHAR2,
                   pOldPassword IN VARCHAR ) RETURN BOOLEAN 
IS
    vaInvalidPasswords pgInvalidPassword_t :=
         pgInvalidPassword_t( 'welcome1',
                              'database1',
                              'account1',
                              'user1234',
                              'password1',
                              'oracle123',
                              'computer1',
                              'abcdefg1',
                              'change_on_install' );
BEGIN

    IF LENGTH( pPassword ) < 8
    THEN
      RAISE_APPLICATION_ERROR( -20001,
                               'Password Length less than 8' );
    END IF;

    p_CheckForSimilarName( pUserName,
                           pPassword,
                           'Password same as or similar to user name' );

    p_CheckForSimilarName( pgDatabaseServer,
                           pPassword,
                           'Password same as or similar to server name' );

    p_CheckForSimilarName( 'oracle', pPassword );

    p_CheckForReverse( pUserName, pPassword );

    p_CheckForInvalidPw( pPassword, vaInvalidPasswords );
    
    p_CheckInvalidSpecialChar( pPassword ); 

    p_CheckForDigitAndChar( pPassword );

    p_CheckConsecutiveNumChar( pPassword );

    p_CheckForThreeDifferences( pPassword, pOldPassword );

    RETURN TRUE;

END f_verify;
-- ------------------------------------------------------------------

FUNCTION f_generate( pUsername IN VARCHAR2 ) RETURN VARCHAR2 
IS
   iPwdLength     INTEGER;
   bPasswordValid BOOLEAN := FALSE;
   vGenPassword   VARCHAR2( 12 );
BEGIN

   -- Pick a random password length between 8 and 12

   iPwdLength := 8+MOD(ABS(DBMS_RANDOM.RANDOM), 5);

   -- Generate the Password and validate it with the verify function

   WHILE NOT bPasswordValid
   LOOP
       BEGIN
           vGenPassword := DBMS_RANDOM.STRING( 'p', iPwdLength );
           
           bPasswordValid := f_verify( pUsername, vGenPassword, NULL );

       EXCEPTION
        WHEN ePasswordShort      OR
             ePasswordSimilar    OR
             ePasswordReversed   OR
             ePasswordSimple     OR
             eInvalidSpecialChar OR
             eOneDigitAndChar    OR
             eNotEnoughDiffs     OR
             eConsecutiveNumChar 
        THEN
             bPasswordValid := FALSE;
        END;
   END LOOP;

   RETURN( vGenPassword );
   
END f_generate;

-- ------------------------------------------------------------------

-- ************************
-- * Private Declarations *
-- ************************

----------------------------------------------------------------
-- * Check that the password is similar to the username
-- * the check is comprised of a direct comparision and the
-- * the user name with a digit suffix
----------------------------------------------------------------

PROCEDURE p_CheckForSimilarName( pCompName IN VARCHAR2,
                                 pPassword IN VARCHAR2,
                                 pErrorMsg IN VARCHAR2 
                                     DEFAULT 'Password too simple' )
IS
   nDummy NUMBER;

BEGIN
   --
   -- Direct comparison
   --

   IF LOWER( pCompName ) = LOWER( pPassword )
   THEN
      RAISE_APPLICATION_ERROR( -20002, PErrorMsg );
   END IF;

   -- Check for password of Compname + trailing digits 
  
   IF LOWER( pCompName ) = SUBSTR( LOWER(pPassword), 1, LENGTH( pCompName ) )
   THEN
       BEGIN
           nDummy := TO_NUMBER( SUBSTR( pPassword, length( pCompName )+1));
           RAISE_APPLICATION_ERROR( -20002, PErrorMsg );
       EXCEPTION
          WHEN INVALID_NUMBER OR VALUE_ERROR
          THEN
              NULL;
       END;
   END IF;

END p_CheckForSimilarName;

----------------------------------------------------------------
-- * Check that the password is not the reverse of the user name
----------------------------------------------------------------

PROCEDURE p_CheckForReverse( pUserName IN VARCHAR2,
                             pPassword IN VARCHAR2 )
IS 
   iLenPasswd INTEGER := LENGTH( pPassword );
BEGIN
    -- Only bother to check if they are the same length

    IF LENGTH( pUserName ) = iLenPasswd
    THEN
        FOR i in 1..iLenPasswd
        LOOP
           EXIT WHEN LOWER( SUBSTR( pUserName, i,1 ) )
                          !=
                          LOWER( SUBSTR( pPassword, (iLenPasswd+1)-i,1 ));

           IF i = iLenPasswd 
           THEN
              RAISE_APPLICATION_ERROR( -20003,
                       'Password same as username reversed' );
           END IF;
 
        END LOOP;
    END IF;

END p_CheckForReverse;

---------------------------------------------------------------
-- * Check that the password is not in the invalid list 
---------------------------------------------------------------

PROCEDURE p_CheckForInvalidPw( pPassword         IN VARCHAR2,
                               pVaInvalidPasswds IN pgInvalidPassword_t )
IS
BEGIN

   FOR InvPasswd IN 1..pVaInvalidPasswds.COUNT
   LOOP
      IF LOWER( pPassword ) = LOWER( pVaInvalidPasswds( InvPasswd ) )
      THEN
          RAISE_APPLICATION_ERROR( -20006, 'Password too simple' );
      END IF;

   END LOOP;

END p_CheckForInvalidPw;

---------------------------------------------------------------
-- * Check that the password not contains a invalid special character 
---------------------------------------------------------------

PROCEDURE p_CheckInvalidSpecialChar( pPassword IN VARCHAR2 )
IS
   Cnt               INTEGER  :=0;
   InvalidCharString VARCHAR2(100);
BEGIN
   SELECT TRANSLATE (pPassword,'?0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_:*!£$.,\', '?') 
   INTO InvalidCharString
   FROM dual; 
   --vik_debug('pPassword = ' || pPassword || ' = InvalidCharString = ' || InvalidCharString);
   IF InvalidCharString IS NOT NULL THEN
      RAISE_APPLICATION_ERROR( -20010, 'Special Characters ' || InvalidCharString || ' not allowed in Password.' );
   END IF;

--EXCEPTION
--   WHEN OTHERS THEN
--     NULL;
END p_CheckInvalidSpecialChar;

------------------------------------------------------------------
-- * Check at least 3 out of the 4 criteria are met
------------------------------------------------------------------

PROCEDURE p_CheckForDigitAndChar( pPassword IN VARCHAR2 )
IS
   Cnt  INTEGER  :=0;
BEGIN
   -- Check if the password contains atleast one Number
   IF REGEXP_INSTR(pPassword,'[[:digit:]]') > 0 THEN -- 0123456789
     Cnt := Cnt + 1;
   END IF;
   
   -- Check if the password contains atleast one Upper case      
   IF REGEXP_INSTR(pPassword,'[[:upper:]]') > 0 THEN -- ABCDEFGHIJKLMNOPQRSTUVWXYZ
     Cnt := Cnt + 1;
   END IF;

   -- Check if the password contains atleast one Lower case
   IF REGEXP_INSTR(pPassword,'[[:lower:]]') > 0 THEN -- abcdefghijklmnopqrstuvwxyz
     Cnt := Cnt + 1;
   END IF;

   -- Check if the password contains punctuation i.e special character
-- IF REGEXP_INSTR(pPassword,'[[:punct:]]') > 0 THEN
   IF REGEXP_INSTR(pPassword,'[-_:*!£$.,\]') > 0 THEN  -- -_:'*!£$.,\
     Cnt := Cnt + 1;
   END IF;

   IF Cnt < 3 THEN
     RAISE_APPLICATION_ERROR(-20007,
                            'Password must contain at least 3 of the 4 character types - 1 number, 1 upper and 1 lower case letter, 1 special character');
   END IF;

END p_CheckForDigitAndChar;

---------------------------------------------------------------
-- * Ensure that the new password differs from the new password 
-- * in 3 or more places
---------------------------------------------------------------

PROCEDURE p_CheckForThreeDifferences( pPassword    IN VARCHAR2,
                                      pOldPassword IN VARCHAR2) 
IS
   iBiggestPwLen INTEGER;
   iNumDiffs     INTEGER := 0;
BEGIN

   IF pOldPassword IS NOT NULL
      AND
      ABS( LENGTH( pPassword ) - LENGTH( pOldPassword ) ) < 3  
   THEN
       IF ( LENGTH( pPassword ) > LENGTH( pOldPassword ) )
       THEN
          iBiggestPwLen := LENGTH( pPassword );
       ELSE
          iBiggestPwLen := LENGTH( pOldPassword );
       END IF;

       FOR i IN 1..iBiggestPwLen
       LOOP
           IF SUBSTR( pPassword, i, 1) != SUBSTR( pOldPassword, i,1 )
           THEN
                iNumDiffs := iNumDiffs + 1;
           END IF;
       END LOOP;

       IF iNumDiffs < 3
       THEN
          RAISE_APPLICATION_ERROR( -20008,
                          'Password should differ from the old password'
                          || ' by at least 3 characters' );
       END IF;
   END IF;

END p_CheckForThreeDifferences;

---------------------------------------------------------------
-- * Check if the password contains consecutive letters or numbers 
---------------------------------------------------------------

PROCEDURE p_CheckConsecutiveNumChar( pPassword IN VARCHAR2 ) IS
BEGIN
   IF REGEXP_SUBSTR(pPassword,'([[:alnum:]])\1',1,1,'i') IS NOT NULL THEN

     RAISE_APPLICATION_ERROR(-20009, 
                             'Password must not contain consecutive letters or number');

   END IF;
END p_CheckConsecutiveNumChar;

----------------------------------------------------------------
-- * Main Body
----------------------------------------------------------------

BEGIN

-- Package Initialisation

SELECT name 
INTO pgDatabaseServer
FROM sys.v$database;

----------------------------------------------------------------

END exor_password_engine;
/