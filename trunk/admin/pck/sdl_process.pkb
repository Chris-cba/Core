CREATE OR REPLACE PACKAGE BODY sdl_process
AS
    --<PACKAGE>
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_process.pkb-arc   1.2   Oct 14 2019 14:49:12   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_process.pkb  $
    --       Date into PVCS   : $Date:   Oct 14 2019 14:49:12  $
    --       Date fetched Out : $Modtime:   Oct 14 2019 13:35:12  $
    --       PVCS Version     : $Revision:   1.2  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the processes in SDL product
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this package is to provide a single package as an interface to the
    -- various SDL processes

    --</PACKAGE>

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_PROCESS';

    PROCEDURE set_working_parameters;

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



    PROCEDURE load_validate (p_batch_id IN NUMBER, p_tolerance IN NUMBER default g_tolerance)
    IS
    BEGIN
        set_working_parameters;
        SDL_AUDIT.LOG_PROCESS_START(p_batch_id, 'ADJUST', NULL, NULL, NULL);
        sdl_validate.VALIDATE_ADJUSTMENT_RULES(p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'ADJUST');
--        
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id,
                                     'LOAD_VALIDATION',
                                     g_buffer,
                                     g_match_tolerance,
                                     p_tolerance);
        SDL_VALIDATE.VALIDATE_BATCH (p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'LOAD_VALIDATION');
    END;

    --
    PROCEDURE topo_generation (p_batch_id          IN NUMBER,
                               p_match_tolerance   IN NUMBER,
                               p_tolerance         IN NUMBER default g_tolerance)
    IS
    BEGIN
        set_working_parameters;
        SDL_AUDIT.LOG_PROCESS_START (
            p_batch_id,
            'TOPO_GENERATION',
            NULL,
            NVL (p_match_tolerance, g_match_tolerance),
            NVL (p_tolerance, g_tolerance));
        SDL_TOPO.generate_wip_topo_nw (p_batch_id => p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'TOPO_GENERATION');
    END;

    --
    PROCEDURE datum_validation (p_batch_id          IN NUMBER,
                                p_buffer            IN NUMBER,
                                p_match_tolerance   IN NUMBER,
                                p_tolerance         IN NUMBER default g_tolerance)
    IS
    BEGIN
        set_working_parameters;
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id,
                                     'DATUM_VALIDATION',
                                     p_buffer,
                                     p_match_tolerance,
                                     p_tolerance);
        SDL_STATS.match_nodes (p_batch_id, p_match_tolerance, p_tolerance);
        SDL_VALIDATE.validate_datums_in_batch (p_batch_id => p_batch_id);
        SDL_STATS.GENERATE_STATISTICS_ON_SWD (p_batch_id    => p_batch_id,
                                              p_buffer      => p_buffer,
                                              p_tolerance   => p_tolerance);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'DATUM_VALIDATION');
    END;

    --
    PROCEDURE analysis (p_batch_id    IN NUMBER,
                        p_buffer      IN NUMBER default g_buffer,
                        p_tolerance   IN NUMBER default g_tolerance,
                        p_swd_id      IN NUMBER DEFAULT NULL)
    IS
    BEGIN
        set_working_parameters;
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id, 'ANALYSIS', p_buffer, g_match_tolerance, p_tolerance);
        NULL;                     -- further analysis such as pline-stats etc.
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'ANALYSIS');
    END;

    --
    PROCEDURE transfer (p_batch_id IN NUMBER)
    IS
    BEGIN
        set_working_parameters;
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id, 'TRANSFER', NULL, NULL, NULL);
        SDL_TRANSFER.TRANSFER_DATUMS (p_batch_id => p_batch_id);
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'TRANSFER');
    END;

    --
    PROCEDURE reject (p_batch_id IN NUMBER)
    IS
    BEGIN
        SDL_AUDIT.LOG_PROCESS_START (p_batch_id, 'REJECT', NULL, NULL, NULL);
        NULL;                                             -- set reject status
        SDL_AUDIT.LOG_PROCESS_END (p_batch_id, 'REJECT');
    END;

    --
    PROCEDURE set_working_parameters
    IS
    BEGIN
        g_buffer := 2;
        g_tolerance := 0.005;
        g_match_tolerance := 5;
    END;
--main segment to instantiate the default parameters
BEGIN
    set_working_parameters;
END;
/
