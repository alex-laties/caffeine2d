Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

class ChatRoom
  constructor: (@name, @roommates, @messages) ->
    if not @name
      @name = 'totally random room'

    if not @roommates
      @roommates = []

    if not @messages
      @messages = []

    @subscribers = []

    @id = @name #temporary hack until id's aren't tied to names

  roommate_enter: (roommate) ->
    if roommate not in @roommates
      @roommates.push roommate
      @notify_subscribers {rmmt_ent: roommate}

  roommate_leave: (roommate) ->
    if roommate in @roommates
      @roommates.remove roommate
      @notify_subscribers {rmmt_lv: roommate}

  send_message: (message) ->
    @messages.push message
    #send to server
    @notify_subscribers {msg_snt: message}

  receive_message: (message) ->
    @messages.push message
    @notify_subscribers {msg_rcv: message}

  add_subscriber: (subscriber) ->
    if subscriber not in @subscribers
      @subscribers.push subscriber

  remove_subscriber: (subscriber) ->
    if subscriber in @subscribers
      @subscribers.remove subscriber

  notify_subscribers: (notification) ->
    for subscriber in @subscribers
      subscriber.notify notification

class ChatView
  constructor: (@id, div) ->
    #create main chat tab
    $('li.template').clone().appendTo 'ul.nav-tabs'
    $('ul.nav-tabs > li.template > a').attr 'href', "##{@id}"
    $('ul.nav-tabs > li.template > a').text "#{@id}"
    $('ul.nav-tabs > li.template').removeClass 'template'

    #create main chat view
    $('div.template#chat_window_temp').clone().appendTo 'div.tab-content'
    $('div.tab-content > div.template#chat_window_temp').attr 'id', "#{@id}"
    $('div.tab-content > div.template').removeClass 'template'
    
    #add chat entry form
    $('div.templates > div.template#chat_box_temp').clone().appendTo "div##{@id} > .chat-input"
    $("div##{@id} div#chat_box_temp").attr 'id', "#{@id}_chatbox"
    $("##{@id}_chatbox").removeClass 'template'

  notify: (message) ->
    if not message
      return

    if message.msg_rcv
      $("div##{@id} > .chat-display").append "<p>#{message.msg_rcv}</p>"

    if message.msg_snt
      $("div##{@id} > .chat-display").append "<p><b>#{message.msg_snt}</b></p>"

class ChatManager
  constructor: (@rooms, @views, @socket) ->
    if not @rooms?
      @rooms = []
      @currentRoom = null
    else
      @currentRoom = @rooms[0]
      @rooms[0].add_subscriber @

    if not @views?
      @views = []

    @setup_socket @socket

    @setup_rooms @rooms

  setup_socket: (@socket) ->
    a = @rooms
    @socket.on 'chat', (data) ->
      id = data.id
      for room in (r for r in a when r.id is id)
        room.receive_message data.message

    a = @rooms #fuckin closures >:(
    @socket.on 'news', (data) ->
      for room in a
        room.receive_message data.message

  setup_rooms: (@rooms) ->
    for room in @rooms
      id = room.id
      $("##{id}_chatbox a").click () ->
        to_send = $("##{id}_chatbox > textarea").val()
        $("##{id}_chatbox > textarea").val("")
        console.log to_send
        room.send_message to_send

  add_room: (room) ->
    if room not in @rooms
      room.add_subscriber @
      @rooms.push room

  remove_room: (room) ->
    if room in @rooms
      @rooms.remove room
      room.remove_subscriber @

    if room is @currentRoom
      if @rooms.length > 0
        @currentRoom = @rooms[0]
      else
        @currentRoom = null
        console.log "we're out of rooms!?"

  select_room: (id) ->
    if @currentRoom.id is id
      return

    room = (r for r in @rooms when r.id is id)
    if room.length > 0
      @currentRoom = room[0]
      $('div.tab-content > div').removeClass 'active'
      $("div##{@currentRoom.id}").addClass 'active'

  notify: (message) ->
    if message.msg_snt
      @socket.emit 'chat',  message.msg_snt

#########################################
## EXPORTS
exports = this
exports.ChatRoom = ChatRoom
exports.ChatView = ChatView
exports.ChatManager = ChatManager
