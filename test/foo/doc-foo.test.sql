\echo --q1
SELECT * FROM pgr_foo(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2 FROM edge_table',
    2, 12);