\i setup.sql

SELECT plan(8);

-- testing from an existing starting vertex to an non-existing destination in directed graph
-- expecting results: empty set
PREPARE q1 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions',
    2, 3
);

-- testing from an existing starting vertex to an non-existing destination in undirected graph
-- expecting results: empty set
PREPARE q2 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions',
    2, 3,
    FALSE
);

-- testing from an existing starting vertex to an non-existing destination in directed graph
-- expecting results: empty set
PREPARE q3 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions where id > 10',
    2, 3
);

-- testing from an existing starting vertex to an non-existing destination in undirected graph
-- expecting results: empty set
PREPARE q4 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions where id > 10',
    2, 3,
    FALSE
);

-- testing from an non-existing starting vertex to an existing destination in directed graph
-- expecting results: empty set
PREPARE q5 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions',
    6, 8
);

-- testing from an non-existing starting vertex to an existing destination in undirected graph
-- expecting results: empty set
PREPARE q6 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions',
    6, 8,
    FALSE
);

-- testing from an non-existing starting vertex to an existing destination in directed graph
-- expecting results: empty set
PREPARE q7 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions where id > 10',
    6, 8
);

-- testing from an non-existing starting vertex to an existing destination in undirected graph
-- expecting results: empty set
PREPARE q8 AS
SELECT * FROM pgr_dijkstraTRSP(
    'SELECT id, source, target, cost, reverse_cost FROM edge_table WHERE id = 4 OR id = 7',
    'SELECT * FROM restrictions where id > 10',
    6, 8,
    FALSE
);
SELECT is_empty('q1');
SELECT is_empty('q2');
SELECT is_empty('q3');
SELECT is_empty('q4');
SELECT is_empty('q5');
SELECT is_empty('q6');
SELECT is_empty('q7');
SELECT is_empty('q8');
-- q3
SELECT * FROM finish();
ROLLBACK;
