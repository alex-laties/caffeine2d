server = require('http').createServer (request, response) ->
  response.writeHead 200, {'Content-Type': 'text/plain'}
  response.end "Hello, coffeescript and nodejs!"

server.listen 8888
console.log 'Server running on localhost:8888'
