init_socket = (options) ->
  if not options
    options = {}

  if 'host' in options
    host = options.host
  else
    host = window.location.hostname

  if 'port' in options
    port = options.port
  else
    port = window.location.port

  if 'protocol' in options
    protocol = options.protocol
  else
    protocol = window.location.protocol

  if port == '80'
    socket_url = protocol + '//' + host
  else
    socket_url = protocol + '//' + host + ':' + port

  socket = io.connect (socket_url)

$(document).ready () ->
  chatroom = new ChatRoom('default', [], ['hello :p'])
  chatview = new ChatView('default')
  chatroom.add_subscriber(chatview)
  socket = init_socket()
  window.chatmanager = new ChatManager([chatroom], [chatview])
  socket.on 'news', (data) ->
    console.log data

  socket.on 'chat', (data) ->
    chatroom.receive_message data
    console.log data
 
  console.log 'initialized chat'
  chatroom.receive_message 'initialized chat'

