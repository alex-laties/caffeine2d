class ChatRoom
  constructor: (@name, @roommates, @messages) ->
    if not @name
      @name = 'totally random room'

    if not @roommates
      @roommates = []

    if not @messages
      @messages = []

    @subscribers = []

  roommate_enter: (roommate) ->
    if roommate not in @roommates
      @roommates.push roommate
      @notify_subscribers {rmmt_ent: roommate}

  roommate_leave: (roommate) ->
    if roommate in @roommates
      @roommates.pop roommate
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
      @subscribers.pop subscriber

  notify_subscribers: (notification) ->
    for subscriber in @subscribers
      subscriber.notify notification

class ChatView
  constructor: (@id, div) ->
    #create main chat tab
    $('.nav-tabs').append "<li><a href=\"##{@id}\" data-toggle=\"tab\">#{@id}</a></li>"
    #create main chat view
    if not div
      div = '.tab-content'

    chat_html = "<div class=\"tab-pane\" id=\"#{@id}\">"
    chat_html += '</div>'

    $(div).append chat_html

  notify: (message) ->
    if not message
      return

    if message.msg_rcv
      $("##{@id}").append "<p>#{message.msg_rcv}</p>"

    if message.msg_snt
      $("##{@id}").append "<p><b>#{message.msg_snt}</b></p>"

exports = this
exports.ChatRoom = ChatRoom
exports.ChatView = ChatView
