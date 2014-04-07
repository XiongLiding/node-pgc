# node-pgc

Get some easy to use function too help you work with node-postgres confortable.

## what is pgc ?

pgc stand for postgres-croak

croak for col, row, one, all, kvs

col for first column in table/rows

row for first row in table/rows

one for first cell in table/rows

all for whole table/rows

kvs for key value style which use the first column as key and second column as value

## why pgc ?

When I work with `pg`, Most of the time, I query with callback, and get `error` and `result` object.
When the `error` is null, I tackle `result.rows` and find out what I interested manully.

But with pgc, It give me the `result` only with the data I relly care about, directly.

I''ll show you some contrast, and here is the sample table: mytable

id | word | letter
:--- | :--- |:---
1 | apple | A
2 | boy | B
3 | book | B
4 | cat | C

### Sometimes, I only care first row of rows
Espacially there is only one row in result.rows

    // with pg
    client.row('SELECT * FROM mytable WHERE id = 1', function (err, result) {
        console.log(result.rows) // [{id: 1, word: 'apple', letter: 'A'}]
    });

    // with pgc
    pgc.row('SELECT * FROM mytable WHERE id = 1', function (err, result) {
        console.log(result) // {id: 1, word: 'apple', letter: 'A'}
    });

`row` only do a simple thing, when first row is exists, give you that row

### I only care one value
Aggregation, for example

    // with pg
    client.row('SELECT COUNT(*) FROM mytable', function (err, result) {
        console.log(result.rows) // [{count: 4}]
    });

    // with pgc
    pgc.one('SELECT COUNT(*) FROM mytable', function (err, result) {
        console.log(result) // 4
    });

`one` give you the first value in first row, and dont care what name it is.
So you don''t need to think a name/label for it. name is hard, isn''t it ?

### I only care one column
Find out all distinct value, for example

    // with pg
    client.query('SELECT DISTINC letter FROM mytable', function (err, result) {
        console.log(result.rows) // [{letter: 'A'}, {letter: 'B'}, {letter: 'C'}]
    });

    // with pgc
    pgc.col('SELECT DISTINCT letter FROM mytable', function (err, result) {
        console.log(result) // ['A', 'B', 'C']
    });

`col` loops for you, and give you the values of which column you care about.

### I care the relationship of two column
I have some words, and want find out the ids for them. if I have an key-value map to check, it helps a lot

    // with pg
    client.query('SELECT word, id FROM mytable', function (err, result) {
        console.log(result.rows) // [{word: 'apple', id: 1}, {word: 'boy', id: 2}, {word: 'book', id: 3}, {word: 'cat': id: 4}]
    });

    // with pgc
    pgc.kvs('SELECT word, id FROM mytable', function (err, result) {
        console.log(result) // {'apple': 1, 'boy': 2, 'book': 3, 'cat': 4}
    });

`kvs` loops, and catch the first column as key, second column as value, scratch a key value style map for you.

### Just give you the `result.rows`
`all` is the simplest, just give you the `result.rows` directly

    // with pgc
    pgc.allkvs('SELECT word, id, letter FROM mytable', function (err, result) {
        console.log(result) // [{word: 'apple', id: 1, letter: 'A'}, {word: 'boy', id: 2, letter: 'B'}, {word: 'book', id: 3, letter: 'B'}, {word: 'cat', id: 4, letter: 'C'}]
    });

### Rows have a specified column as index
`allkvs` give you all the rows in result like `all`, but with first column as index.

    // with pgc
    pgc.allkvs('SELECT word, id, letter FROM mytable', function (err, result) {
        console.log(result) // {apple: {word: 'apple', id: 1, letter: 'A'}, boy: {word: 'boy', id: 2, letter: 'B'}, book: {word: 'book', id: 3, letter: 'B'}, cat: {word: 'cat', id: 4, letter: 'C'}}
    });

so, above is the CROAK methods.

pgc is a simple layer above pg, and can''t do everything for you, but the situation shown above, covers 90% requirement in my work.

pgc also have some helper function describe as below:
add them latter ...

## how to use

install

    npm install pg
    npm install pgc

pgc work with pg, but not include pg.
    
use
  
    pg = require('pg');
    pgc = require('pgc')(pg, CONNECTSTRING); // use CONNECTSTRING to build a client pool.

in pg, query have three forms:

    Simple queries
    query(string text, optional function callback)
    
    Parameterized Queries
    query(object config, optional function callback)
    query(string queryText, array values, optional function callback)

pgc also have three forms, very consistent, but with a must have callback:

    Simple queries
    pgc.CROAK(string text, function callback)
    
    Parameterized Queries
    pgc.CROAK(object config, function callback)
    pgc.CROAK(string queryText, array values, function callback)

