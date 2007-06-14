@echo off
rem --
rem --       sccsid           : @(#)doUtil.cmd	1.1 12/09/05
rem --       Module Name      : doUtil.cmd
rem --       Date into SCCS   : 05/12/09 11:02:32
rem --       Date fetched Out : 07/06/13 17:07:19
rem --       SCCS Version     : 1.1
rem --
rem -- Used to compile util.sqlj into a class that can be shipped
rem --
rem --
echo Please edit the variables to set java_home, ora_home, sqlj_home and jdbc_home 
echo to match your Oracle and Java installations

set ora_home=D:\ora9i\
set sqlj_home=%ora_home%\sqlj\lib\
set jdbc_home=%ora_home%\jdbc\lib\
set CLASSPATH=%sqlj_home%translator.jar
set CLASSPATH=%CLASSPATH%;%sqlj_home%runtime12.jar
set CLASSPATH=%CLASSPATH%;%sqlj_home%runtime12ee.jar
set CLASSPATH=%CLASSPATH%;%jdbc_home%classes12.jar
set JAVA_HOME=d:\Program Files\j2sdk_nb\j2sdk1.4.2\
PATH %java_home%bin;%PATH%
java -version
sqlj Util.sqlj
