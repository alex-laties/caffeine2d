fs = require('fs')
node_static = require('node-static')
util = require('util')
webroot = './public'
port = 8888
file = new(node_static.Server)(webroot,
  {
    cache: 600,
    headers: { 'X-Powered-By': 'node-static' }
  }
)
handler = (request, response) ->
  request.addListener 'end', () ->
    file.serve request, response, (err, results) ->
      if err
        console.error 'Error serving %s - %s', request.url, err.message
        if err.status == 404 or err.status == 500
          file.serveFile util.format('/%d.html', err.status), err.status, {}, request, response
        else
          response.writeHead err.status, err.headers
          response.end
      else
        console.log '%s - %s', request.url, response.message

app = require('http').createServer handler

io = require('socket.io').listen(app)

io.sockets.on 'connection', (socket) ->
  socket.emit 'news', {hello: 'world'}
  socket.on 'my other event', (data) ->
    console.log data

app.listen port, '0.0.0.0'
console.log 'Server running on 0.0.0.0:8888'
