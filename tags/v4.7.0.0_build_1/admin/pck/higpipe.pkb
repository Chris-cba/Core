
create or replace package body higpipe is
--   PVCS Identifiers :-
--
--       pvcsid               : $Header:   //vm_latest/archives/nm3/admin/pck/higpipe.pkb-arc   2.2   Jul 04 2013 15:01:12   James.Wadsworth  $
--       Module Name          : $Workfile:   higpipe.pkb  $
--       Date into PVCS       : $Date:   Jul 04 2013 15:01:12  $
--       Date fetched Out     : $Modtime:   Jul 04 2013 14:25:06  $
--       PVCS Version         : $Revision:   2.2  $
--       Based on SCCS Version     : 1.4
--
--   Author :
--
--   Highways Pipes package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

/* History
  11.03.07 PT check_pipe() now uses higgrirp.write_gri_spool()
*/

   g_body_sccsid            constant  varchar2(200) := '"$Revision:   2.2  $"';
   g_package_name           constant varchar2(30) := 'higpipe';

   
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
/*
Places the message in the pipe
specified by current value of toggle

If the File pointed to by fle_handle is open then
message is written to the file.
Messages of format '<job id>,<message>'
will be written to the gri_spool table
IF <job id> is missing nothing is written to the table.

It is possible to write to a file and not the table
by using an open file handle and no job id
Or to the table and not the file by sending an unopened
file handle and a valid job id
*/
procedure write_pipe (pipe_message varchar2, file_handle utl_file.file_type) is

    s number;

begin

    dbms_pipe.pack_message (pipe_message);

    if toggle = 1 then
        s := dbms_pipe.send_message (pipe1, 10, 1000);
        toggle := 2;
    else
        s := dbms_pipe.send_message (pipe2, 10, 1000);
        toggle := 1;
    end if;

    /* If the file passed is open then write to the file */
    /* opening and closing the file should be handeled by the calling routine */
    IF utl_file.is_open( file_handle ) THEN
       utl_file.put_line( file_handle, pipe_message);
       utl_file.fflush( file_handle );
    END IF;

end;


/*
checks the pipe specified by pipe_name for a message
and inserts the message into gri_spool

the job_id must be the first value on the
message line, ie '<job id>,<message>' to insert into
gri_spool
*/
function check_pipe (pipe_name varchar2) return integer is

	info varchar2(2000);
	s number;
	seqno number;
	pipenum number;
	jobnum varchar2(10);
	commapos number;

    txt varchar2(10);

begin

    s := dbms_pipe.receive_message(pipe_name, 1);

    if s = 0 then

        dbms_pipe.unpack_message( info );

		/*
		get job id and message from received message
		format of message: '<sequence>,<job id>,<message>'
        Will only insert to gri spool if there is a job id
		*/

		/* get job id */
		commapos := instr (info, ',');
        IF  commapos < 10 THEN
           jobnum := substr (info, 1, commapos - 1);
        END IF;

		/* actual message */
		info := substr (info, commapos + 1);

    if jobnum is not null then

      -- this does autonomous commit
      higgrirp.write_gri_spool(
         a_job_id   => jobnum
        ,a_message  => info
      );
      
            /* get the next sequence number */
--             SELECT nvl(max(GRS_LINE_NO),0) + 1
--             INTO   seqno
--             FROM gri_spool
--             WHERE GRS_JOB_ID = jobnum;
-- 
-- 			INSERT INTO gri_spool
-- 			(
-- 				GRS_JOB_ID,
-- 				GRS_LINE_NO,
-- 				GRS_TEXT
-- 			)
-- 			VALUES
-- 			(
-- 				jobnum,
-- 				seqno,
-- 				info
-- 			);
-- 
-- 			commit;

		else

			s := 6;

		end if;

		if info = 'STOP' then
			s := 5;
		end if;

	end if;

    return s;

    exception
    when others then
       return s;

end;

/*
Create pipes
*/
function cre_pipes return integer is
	s number;

begin
	s := dbms_pipe.create_pipe (pipe1, 10000, false);
	s := dbms_pipe.create_pipe (pipe2, 10000, false) + s;

	if s = 0 then
		pipe_check := 1;
	else
		pipe_check := 0;
	end if;

	/* exit if pipes not created properly */
	if pipe_check = 0 then
		return 0;
	end if;

	dbms_pipe.purge (pipe1);
	dbms_pipe.purge (pipe2);

	dbms_pipe.reset_buffer;

    return 1;

end cre_pipes ;

/*
remove the pipes
*/
function del_pipes return integer IS

   s number ;

begin

   dbms_pipe.reset_buffer;

   s := dbms_pipe.remove_pipe (pipe1);
   s := dbms_pipe.remove_pipe (pipe2);

   return s;

end del_pipes;

/* check each pipe for messages
*/
function msg_check return integer IS

	info varchar2(2000);
	s number;
	seqno number;

begin
	/*
	s=0 pipe message received OK
	s=1 pipe time out
	s=5 STOP message received
	s=6 null job id
	*/

    if pipe_check = 1 then
	   s := check_pipe (pipe1);
	end if;

	if pipe_check = 2 then
		s := check_pipe (pipe2);
	end if;

	/*
	toggle pipe check only if the
	current pipe was valid
	*/
	if s = 0 then
		if pipe_check=1 then
			pipe_check := 2;
		else
			pipe_check := 1;
		end if;
	end if;

    return s;

end msg_check;
/*
starts the pl/sql listner
This is done with 'C' program use this for testing !
*/
procedure gri0207 is

	info varchar2(2000);
	s number;
	seqno number;

begin

    s := cre_pipes;
    if s = 0 then
       return;
    end if;
	/*
	loop until the STOP message is received
	s=0 pipe message received OK
	s=1 pipe time out
	s=5 STOP message received
	s=6 null job id
	*/
	loop

       s := msg_check;
       if s = 5 then
          exit;
       end if;

	end loop;

	s := del_pipes;

end;

end higpipe;
/
