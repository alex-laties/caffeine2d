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
    $('li#template').clone().appendTo 'ul.nav-tabs'
    $('ul.nav-tabs > li#template > a').attr 'href', "##{@id}"
    $('ul.nav-tabs > li#template > a').text "#{@id}"
    $('ul.nav-tabs > li#template').attr 'id', ""

    #create main chat view
    $('div#template').clone().appendTo 'div.tab-content'
    $('div.tab-content > div#template').attr 'id', "#{@id}"

  notify: (message) ->
    if not message
      return

    if message.msg_rcv
      $("div##{@id}").append "<p>#{message.msg_rcv}</p>"

    if message.msg_snt
      $("div##{@id}").append "<p><b>#{message.msg_snt}</b></p>"

exports = this
exports.ChatRoom = ChatRoom
exports.ChatView = ChatView
