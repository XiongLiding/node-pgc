module.exports = (pg, connection) ->
  # exe(string text, function callback)
  # exe(object config, function callback)
  # exe(string queryText, array values, function callback)
  exe = (sql, args..., fn) ->
    pg.connect connection, (err, client, done) ->
      return fn err if err
      client.query sql, args[0], (err, result) ->
        done()
        console.log sql, err, result
        fn err, result

  all = (sql, args..., fn) ->
    exe sql, args[0], (err, result) ->
      return fn err, (result.rows if result)

  _akv = (rows, key) ->
    rt = {}
    for row in rows
      rt[row[key]] = row
    rt

  allkvs = (sql, args..., fn) ->
    exe sql, args[0], (err, result) ->
      fn err, (_akv result.row, result.field[0].name if result)

  one = (sql, args..., fn) ->
    exe sql, args[0], (err, result) ->
      fn err, (result.rows[0][result.fields[0].name] if result and result.rows[0])

  row = (sql, args..., fn) ->
    exe sql, args[0], (err, result) ->
      fn err, (result.rows[0] if result)

  col = (sql, args..., fn) ->
    exe sql, args[0], (err, result) ->
      fn err, ((x[result.fileds[0].name] for x in result.rows) if result)

  _kv = (rows, keyfield, valuefield) ->
    x = {}
    for row in rows
      x[row[keyfield]] = row[valuefield]
    x

  kvs = (sql, args..., fn) ->
    exe sql, args[0], (err, result) ->
      fn err, (_kv result.rows, result.fields[0].name, result.fields[1] if result)

  pg: pg
  exe: exe
  one: one
  row: row
  col: col
  kvs: kvs
  all: all
  allkvs: allkvs

