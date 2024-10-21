DO $$
DECLARE
    jid integer;
    scid integer;
BEGIN
    -- Creating a new job
    INSERT INTO pgagent.pga_job(
        jobjclid, jobname, jobdesc, jobhostagent, jobenabled
    ) VALUES (
        1::integer, 'Daily Backup Job'::text, 'Backup database railway'::text, 'kalbe_railway.app'::text, true
    ) RETURNING jobid INTO jid;

    -- Steps
    -- Inserting a step (jobid: NULL)
    INSERT INTO pgagent.pga_jobstep (
        jstjobid, jstname, jstenabled, jstkind,
        jstconnstr, jstdbname, jstonerror,
        jstcode, jstdesc
    ) VALUES (
        jid, 'Backup Railway Database'::text, true, 'b'::character(1),
        'host=kalbe_railway.app dbname=railway user=postgres password=<YOUR_PASSWORD>'::text, 
        'railway'::name, 'f'::character(1),
        'pg_dump -d railway -U postgres -f /user/windi/backup_daily_railway.sql'::text, 
        'Backup job for railway database'::text
    );

    -- Schedules
    -- Inserting a schedule
    INSERT INTO pgagent.pga_schedule(
        jscjobid, jscname, jscdesc, jscenabled,
        jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths
    ) VALUES (
        jid, 'Daily Backup Schedule'::text, 'Schedule to run backup every day at 23:00'::text, true,
        '2023-10-28 23:00:00+07'::timestamp with time zone, NULL,
        -- Minutes
        '{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[],
        -- Hours
        '{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,t}'::bool[]::boolean[],
        -- Week days
        '{t,t,t,t,t,t,t}'::bool[]::boolean[],
        -- Month days
        '{f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f}'::bool[]::boolean[],
        -- Months
        '{t,t,t,t,t,t,t,t,t,t,t,t}'::bool[]::boolean[]
    ) RETURNING jscid INTO scid;
END
$$;