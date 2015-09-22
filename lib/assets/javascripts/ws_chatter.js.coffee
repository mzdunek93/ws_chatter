class @WsChatter
  constructor: (onmessage, onconnection) ->
    @ws = new WebSocket "ws://#{location.host}"
    @ws.onmessage = (event) ->
      data = JSON.parse(event.data)
      if data.type is "message"
        onmessage data.user_id, data.message, data.time
      else if data.type is "connection"
        onconnection data.user_id, data.online

  send: (user_id, message) ->
    @ws.send JSON.stringify
      type: "message"
      user_id: user_id
      message: message

  read: (user_id) ->
    @ws.send JSON.stringify
      type: "read"
      user_id: user_id

  close: ->
    @ws.close()
