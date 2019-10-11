CREATE OR REPLACE PACKAGE BODY sdl_audit
AS
    --<PACKAGE>
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_audit.pkb-arc   1.0   Oct 11 2019 13:48:58   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_audit.pkb  $
    --       Date into PVCS   : $Date:   Oct 11 2019 13:48:58  $
    --       Date fetched Out : $Modtime:   Oct 11 2019 13:47:42  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the audits of processing of SDL data
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this package is to provide tools for auditting and locking of SDL processes and data

    --</PACKAGE>


    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_AUDIT';

    c_start          CONSTANT VARCHAR2 (5) := 'START';
    c_end            CONSTANT VARCHAR2 (3) := 'END';

    PROCEDURE lock_process (p_rowid IN ROWID);

    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    PROCEDURE check_process (p_batch_id   IN NUMBER,
                             p_process    IN VARCHAR2,
                             p_sld_key    IN NUMBER,
                             p_op         IN VARCHAR2)
    IS
        l_spa_id         NUMBER;
        l_rowid          ROWID;
        l_last_process   VARCHAR2 (30);
        l_status         VARCHAR2 (30);
        l_started        TIMESTAMP;
        l_ended          TIMESTAMP;
    --    pragma autonomous_transaction;
    BEGIN
        IF p_op = c_start
        THEN
            --test if the same process is operating on the same data and prevent operation if so
            DECLARE
                same_process_exec   EXCEPTION;
                PRAGMA EXCEPTION_INIT (same_process_exec, -20010);
            BEGIN
                  SELECT a.ROWID,
                         spa_id,
                         spa_process,
                         spa_started,
                         spa_ended
                    INTO l_rowid,
                         l_spa_id,
                         l_last_process,
                         l_started,
                         l_ended
                    FROM sdl_process_audit a, hig_codes
                   WHERE     spa_sfs_id = p_batch_id
                         AND NVL (spa_sld_key, -999) = NVL (p_sld_key, -999)
                         AND spa_process = p_process
                         AND spa_ended IS NULL
                         AND hco_domain = 'SDL_PROCESSES'
                         AND ROWNUM = 1
                ORDER BY spa_started;

                --
                raise_application_error (
                    -20010,
                       'The same process ('
                    || p_process
                    || ') is being executed on this batch ('
                    || p_batch_id
                    || ')');
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    NULL;
                WHEN same_process_exec
                THEN
                    raise_application_error (
                        -20011,
                           'The same process ('
                        || p_process
                        || ') is being executed on this batch ('
                        || p_batch_id
                        || ')');
                WHEN OTHERS
                THEN
                    raise_application_error (
                        -20001,
                        'No processes have been logged for this batch - check the fileload status');
            END;
        END IF;

        IF p_sld_key IS NULL
        THEN
            --        this is a batch-based process
            BEGIN
                SELECT sfs_status
                  INTO l_status
                  FROM sdl_file_submissions
                 WHERE sfs_id = p_batch_id;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    raise_application_error (-20009,
                                             'The batch does not exist');
            END;

            IF l_status = 'NEW'
            THEN
                IF p_process NOT IN ('REJECT', 'LOAD')
                THEN
                    raise_application_error (
                        -20002,
                           'The batch status of NEW prevents this '
                        || p_process
                        || ' operation');
                ELSE
                    -- ok?
                    NULL;
                END IF;
            ELSIF l_status = 'LOAD'
            THEN
                IF p_process != 'LOAD_VALIDATION'
                THEN
                    raise_application_error (
                        -20003,
                           'The batch status of LOAD prevents this '
                        || p_process
                        || ' operation');
                ELSE
                    NULL;
                --lock the record and perform both attribute and geometry validation/generate working geometry etc.
                END IF;
            ELSIF l_status = 'LOAD_VALIDATION'
            THEN
                IF p_process NOT IN ('LOAD_VALIDATION', 'TOPO_GENERATION')
                THEN
                    raise_application_error (
                        -20004,
                           'The batch status of LOAD_VALIDATION prevents this '
                        || p_process
                        || ' operation');
                ELSE
                    IF p_process = 'LOAD_VALIDATION'
                    THEN
                        -- repeat load
                        NULL;
                    ELSE
                        NULL;                                  -- run the topo
                    END IF;
                END IF;
            ELSIF l_status = 'TOPO_GENERATION'
            THEN
                IF p_process = 'TOPO_GENERATION'
                THEN
                    NULL;
                --repeat topo
                ELSIF p_process = 'DATUM_VALIDATION'
                THEN
                    NULL;
                --run datum validation
                END IF;
            ELSIF l_status = 'DATUM_VALIDATION'
            THEN
                --Allow Transfer
                NULL;
            END IF;
        ELSE                                         -- a record based process
            NULL;
        END IF;

        --test if the process is allowed, for example, if the status is NEW not much can be done, if rejected then nothing should be done...

        --if OK to proceed, insert the record and lock the batch record for batch related processing else lock the record for sld releated processing
        NULL;
    END;

    --('NEW', 'ANALYSIS', 'DATUM_VALIDATION', 'LOAD', 'LOAD_VALIDATION', 'REJECT', 'TOPO_GENERATION', 'TRANSFER')

    PROCEDURE log_process_start (p_batch_id          IN NUMBER,
                                 p_process           IN VARCHAR2,
                                 p_buffer            IN NUMBER,
                                 p_match_tolerance   IN NUMBER,
                                 p_tolerance         IN NUMBER,
                                 p_sld_key           IN NUMBER DEFAULT NULL)
    IS
    BEGIN
        check_process (p_batch_id,
                       p_process,
                       p_sld_key,
                       c_start);

        --
        INSERT INTO sdl_process_audit (spa_process,
                                       spa_sfs_id,
                                       spa_sld_key,
                                       spa_started,
                                       spa_buffer,
                                       spa_match_tolerance,
                                       spa_tolerance)
             VALUES (p_process,
                     p_batch_id,
                     p_sld_key,
                     CURRENT_TIMESTAMP (9),
                     p_buffer,
                     p_match_tolerance,
                     p_tolerance);
    END;


    PROCEDURE log_process_end (p_batch_id   IN NUMBER,
                               p_process    IN VARCHAR2,
                               p_sld_key    IN NUMBER DEFAULT NULL)
    IS
    --    pragma autonomous_transaction;
    BEGIN
        check_process (p_batch_id,
                       p_process,
                       p_sld_key,
                       c_end);

        UPDATE sdl_process_audit
           SET spa_ended = CURRENT_TIMESTAMP (9)
         WHERE     spa_process = p_process
               AND spa_sfs_id = p_batch_id
               AND NVL (spa_sld_key, -999) = NVL (p_sld_key, -999);

        UPDATE sdl_file_submissions
           SET sfs_status = SUBSTR (p_process, 1, 10)
         WHERE sfs_id = p_batch_id;
    END;

    PROCEDURE lock_process (p_rowid IN ROWID)
    IS
    BEGIN
        NULL;
    END;
END sdl_audit;
/