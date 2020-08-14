CREATE OR REPLACE PACKAGE BODY hig_log_api 
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/hig_log_api.pkb-arc   1.0   Aug 14 2020 17:04:26   Upendra.Hukeri  $
    --       Module Name      : $Workfile:   hig_log_api.pkb  $
    --       Date into PVCS   : $Date:   Aug 14 2020 17:04:26  $
    --       Date fetched Out : $Modtime:   Aug 14 2020 17:03:16  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : U. S. Hukeri
    --
    --   Package for calling ExorLogDispatcher Web Service 
    --
    ------------------------------------------------------------------------------------------------
    -- Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
    ------------------------------------------------------------------------------------------------
	--
	FUNCTION is_log_dispatched RETURN VARCHAR2 IS
	BEGIN 
		RETURN log_dispatched; 
	END; 
	--
	PROCEDURE set_log_dispatched(pi_log_dispatched IN VARCHAR2) IS
	BEGIN 
		log_dispatched := pi_log_dispatched; 
	END;
	--
    PROCEDURE dispatch_log(
		 pi_level            IN VARCHAR2
        ,pi_activity_id      IN VARCHAR2
        ,pi_activity_name    IN VARCHAR2
		,pi_host_name        IN VARCHAR2
		,pi_gprid            IN NUMBER
		,pi_client_ip        IN VARCHAR2
		,pi_email            IN VARCHAR2
		,pi_ims_user_id      IN VARCHAR2
		,pi_username         IN VARCHAR2
		,pi_project_id       IN VARCHAR2
		,pi_version          IN VARCHAR2
		,pi_timestamp        IN VARCHAR2
		,pi_log_message_type IN VARCHAR2
		,pi_country_iso      IN VARCHAR2
		,pi_ultimate_id      IN NUMBER
		,pi_message          IN VARCHAR2 
	) 
    IS
		v_soap_request  VARCHAR2(30000);
		v_soap_respond  VARCHAR2(32767);
		v_http_req      utl_http.req;
		v_http_resp     utl_http.resp;
		v_resp          XMLTYPE;
		v_soap_err      EXCEPTION;
		v_code          VARCHAR2(200);
		v_msg           VARCHAR2(1800);
		v_len           NUMBER;
		v_txt           VARCHAR2(32767);
		v_response      VARCHAR2(32767); 
		--              
		v_job_id        NUMBER := SYS_CONTEXT('USERENV', 'BG_JOB_ID'); 
		v_temp          NUMBER; 
		--              
		v_username      hig_users.hus_name%TYPE; 
		v_db_username   hig_users.hus_username%TYPE; 
		v_email_address nm_mail_users.nmu_email_address%TYPE; 
		v_hig_log_url   hig_options.hop_value%TYPE := hig.get_user_or_sys_opt('HIGLOGURL'); 
	BEGIN 
        nm_debug.debug_on;
		nm_debug.debug('dispatch_log: [' || v_job_id || '] start - ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS')); 
		--
		IF v_hig_log_url IS NULL THEN 
			RAISE_APPLICATION_ERROR(-20001, 'Missing Product Option - HIGLOGURL'); 
		END IF; 
		--
		v_db_username := SYS_CONTEXT('NM3_SECURITY_CTX', 'USERNAME'); 
		--
		IF pi_username IS NULL THEN 
            SELECT hus_name 
              INTO v_username 
              FROM hig_users
             WHERE hus_username = v_db_username; 
		ELSE 
			v_username := pi_username; 
		END IF; 
		--
		IF pi_email IS NULL THEN 
            SELECT nmu.nmu_email_address 
              INTO v_email_address
              FROM nm_mail_users nmu, 
                   hig_users     hu
             WHERE nmu_hus_user_id = hu.hus_user_id
               AND hu.hus_username = v_db_username; 
		ELSE 
			v_email_address := pi_email; 
		END IF; 
		--
		v_soap_request := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
							 <soapenv:Header/>
							 <soapenv:Body>
								<tem:Dispatch>
								   <tem:Level>'          || pi_level            || '</tem:Level>
								   <tem:ActivityID>'     || pi_activity_id      || '</tem:ActivityID>
								   <tem:ActivityName>'   || pi_activity_name    || '</tem:ActivityName>
								   <tem:HostName>'       || pi_host_name        || '</tem:HostName>
								   <tem:Gprid>'          || pi_gprid            || '</tem:Gprid>
								   <tem:ClientIP>'       || pi_client_ip        || '</tem:ClientIP>
								   <tem:Email>'          || v_email_address     || '</tem:Email>
								   <tem:ImsUserID>'      || pi_ims_user_id      || '</tem:ImsUserID>
								   <tem:UserName>'       || v_username          || '</tem:UserName>
								   <tem:ProjectID>'      || pi_project_id       || '</tem:ProjectID>
								   <tem:Version>'        || pi_version          || '</tem:Version>
								   <tem:TimeStamp>'      || pi_timestamp        || '</tem:TimeStamp>
								   <tem:LogMessageType>' || pi_log_message_type || '</tem:LogMessageType>
								   <tem:CountryISO>'     || pi_country_iso      || '</tem:CountryISO>
								   <tem:UltimateID>'     || pi_ultimate_id      || '</tem:UltimateID>
								   <tem:Message>'        || pi_message          || '</tem:Message>
								</tem:Dispatch>
							 </soapenv:Body>
						  </soapenv:Envelope>';
		--
		nm_debug.debug('dispatch_log: [' || v_job_id || '] sending soap request...'); 
		--
		v_http_req := utl_http.begin_request
				  (v_hig_log_url || '/ExorLogDispatcher/LogDispatcher.asmx'
				  ,'POST'
				  ,'HTTP/1.1'
				  );
		--
		utl_http.set_header(v_http_req, 'Content-Type', 'text/xml');
		utl_http.set_header(v_http_req, 'Content-Length', LENGTH(v_soap_request));
		utl_http.write_text(v_http_req, v_soap_request);
		--
		nm_debug.debug('dispatch_log: [' || v_job_id || '] getting soap response...'); 
		--
		v_http_resp:= utl_http.get_response(v_http_req);
		--
		utl_http.get_header_by_name(v_http_resp, 'Content-Length', v_len, 1);
		--
		nm_debug.debug('dispatch_log: [' || v_job_id || '] soap response length - ' || v_len); 
		--
		FOR i in 1..CEIL(v_len/32767) LOOP
			utl_http.read_text(v_http_resp, v_txt, CASE WHEN i < CEIL(v_len/32767) THEN 32767 ELSE MOD(v_len, 32767) END);
			v_soap_respond := v_soap_respond || v_txt; 
		END LOOP; 
		--
		utl_http.end_response(v_http_resp); 
		--
		nm_debug.debug('dispatch_log: [' || v_job_id || '] soap response read successfully'); 
		--
		IF INSTR(v_soap_respond, '<!DOCTYPE') <= 0 THEN
            v_resp := XMLType(v_soap_respond); 
            -- 
            nm_debug.debug('dispatch_log: [' || v_job_id || '] extracting result from soap xml response...'); 
            -- 
            SELECT extractValue
                   (
                        v_resp, 
                        '/soap:Envelope/soap:Body/DispatchResponse/DispatchResult',
                        'xmlns="http://tempuri.org/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
                   )
              INTO v_response 
              FROM DUAL; 
            --
            nm_debug.debug('dispatch_log: [' || v_job_id || '] result from soap xml response - ' || v_response); 
        ELSE 
            nm_debug.debug('dispatch_log: **Error: Something went wrong: [' || v_job_id || '] - ' || v_soap_respond);            
		END IF;
        --
		nm_debug.debug_off;
	EXCEPTION 
        WHEN OTHERS THEN
            nm_debug.debug('**Error: ' || dbms_utility.format_error_stack || CHR(10) || dbms_utility.format_error_backtrace);
	END;
	--
	PROCEDURE dispatch_log_job(
		 pi_level            IN VARCHAR2
        ,pi_activity_id      IN VARCHAR2
        ,pi_activity_name    IN VARCHAR2
		,pi_host_name        IN VARCHAR2
		,pi_gprid            IN NUMBER
		,pi_client_ip        IN VARCHAR2
		,pi_email            IN VARCHAR2
		,pi_ims_user_id      IN VARCHAR2
		,pi_username         IN VARCHAR2
		,pi_project_id       IN VARCHAR2
		,pi_version          IN VARCHAR2
		,pi_timestamp        IN VARCHAR2
		,pi_log_message_type IN VARCHAR2
		,pi_country_iso      IN VARCHAR2
		,pi_ultimate_id      IN NUMBER
		,pi_message          IN VARCHAR2 
	) 
	IS
		PRAGMA AUTONOMOUS_TRANSACTION; 
		--
		v_job_id       BINARY_INTEGER; 
		v_dispatch_log VARCHAR2(32767); 
	BEGIN 
        nm_debug.debug_on;
		nm_debug.debug('dispatch_log_job: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS')); 
		-- 
		v_dispatch_log := 'BEGIN '; 
		v_dispatch_log := v_dispatch_log || 'hig_log_api.dispatch_log('; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_level || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_activity_id || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_activity_name || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_host_name || ']'','; 
		v_dispatch_log := v_dispatch_log || pi_gprid || ','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_client_ip || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_email || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_ims_user_id || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_username || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_project_id || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_version || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_timestamp || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_log_message_type || ']'','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_country_iso || ']'','; 
		v_dispatch_log := v_dispatch_log || pi_ultimate_id || ','; 
		v_dispatch_log := v_dispatch_log || 'q''[' || pi_message || ']'''; 
		v_dispatch_log := v_dispatch_log || '); ';  
		v_dispatch_log := v_dispatch_log || 'END;'; 
		--
		nm_debug.debug('dispatch_log_job: ' || v_dispatch_log); 
		-- 
		dbms_job.submit( 
		   job       => v_job_id,
		   what      => v_dispatch_log, 
		   next_date => SYSDATE,
		   interval  => NULL
		   );
		--
		COMMIT;
	EXCEPTION 
        WHEN OTHERS THEN
            nm_debug.debug('**Error: ' || dbms_utility.format_error_stack || CHR(10) || dbms_utility.format_error_backtrace);
	END;
END hig_log_api;
/