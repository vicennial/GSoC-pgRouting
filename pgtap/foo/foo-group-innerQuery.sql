\i setup.sql

SELECT plan(87);


SELECT has_function('pgr_foo',
    ARRAY['text', 'bigint', 'bigint', 'boolean', 'integer', 'double precision', 'double precision']);

SELECT function_returns('pgr_foo',
    ARRAY['text', 'bigint', 'bigint', 'boolean', 'integer', 'double precision', 'double precision'],
    'setof record');



-- ONE TO ONE
SELECT style_astar('pgr_foo', ', 2, 3, true)');


SELECT finish();
ROLLBACK;
