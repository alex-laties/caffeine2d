fs = require('fs')
handler = (request, response) ->
  index = '/home/vagrant/caffeine2d/index.html'
  console.log index
  fs.readFile index, (err, data) ->
    if err
      response.writeHead 500
      return response.end 'Error loading index.html'

    response.writeHead 200
    return response.end(data)

app = require('http').createServer handler

io = require('socket.io').listen(app)
io.sockets.on 'connection', (socket) ->
  socket.emit 'news', {hello: 'world'}
  socket.on 'my other event', (data) ->
    console.log data

app.listen 8888, '0.0.0.0'
console.log 'Server running on 0.0.0.0:8888'
