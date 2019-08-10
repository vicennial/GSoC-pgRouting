\i setup.sql

SELECT plan(1156);

SET client_min_messages TO ERROR;

-- Compare final row of result (Only final row due to existence of multiple valid paths)

CREATE or REPLACE FUNCTION edward_moore_compare_dijkstra(MAX_LIMIT INTEGER default 17)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
inner_sql TEXT;
dijkstra_sql TEXT;
edward_moore TEXT;
BEGIN

    FOR i IN 1.. MAX_LIMIT LOOP
        FOR j IN 1.. MAX_LIMIT LOOP

            -- DIRECTED
            inner_sql := 'SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true)';

            edward_moore := 'SELECT * FROM pgr_edwardMoore($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true)';
            RETURN query SELECT set_eq(edward_moore, dijkstra_sql, edward_moore);


            inner_sql := 'SELECT id, source, target, road_work as cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true)';

            edward_moore := 'SELECT * FROM pgr_edwardMoore($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', true)';
            RETURN query SELECT set_eq(edward_moore, dijkstra_sql, edward_moore);



            -- UNDIRECTED
            inner_sql := 'SELECT id, source, target, road_work as cost, reverse_road_work as reverse_cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false)';

            edward_moore := 'SELECT * FROM pgr_edwardMoore($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false)';
            RETURN query SELECT set_eq(edward_moore, dijkstra_sql, edward_moore);


            inner_sql := 'SELECT id, source, target, road_work as cost FROM roadworks';
            dijkstra_sql := 'SELECT * FROM pgr_dijkstra($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false)';

            edward_moore := 'SELECT * FROM pgr_edwardMoore($$' || inner_sql || '$$, ' || i || ', ' || j
                || ', false)';
            RETURN query SELECT set_eq(edward_moore, dijkstra_sql, edward_moore);


        END LOOP;
    END LOOP;

    RETURN;
END
$BODY$
language plpgsql;

SELECT * from edward_moore_compare_dijkstra();


SELECT * FROM finish();
ROLLBACK;

