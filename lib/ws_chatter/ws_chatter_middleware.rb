require "erb"
require "json"
require "faye/websocket"

module WsChatter
  class WsChatterMiddleware
    KEEPALIVE_TIME = 15

    def initialize(app)
      @app = app
      @clients = []
      @scope = WsChatter.config.scope
      @status_column = WsChatter.config.status_column
      @messages_model = WsChatter.config.messages_model.constantize
      @users_model = @scope.to_s.camelize.constantize
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)

        user = authenticate(env)
        if !user
          ws.close
          return ws.rack_response
        end

        ws.on :open do
          puts "  WsChatter: New connection from user: \e[1m#{user.username}\e[22m"
          add_client(user, ws)
        end

        ws.on :message do |event|
          data = parse_message(event.data)
          case data["type"]
            when "read" then read_messages(data["user_id"], user)
            when "message" then send_message(data, user)
          end
        end

        ws.on :close do |event|
          puts "  WsChatter: Closed connection with user: \e[1m#{user.username}\e[22m (code: #{event.code})"
          remove_client(user, ws)
        end

        ws.rack_response
      else
        @app.call(env)
      end
    end

    private
      def authenticate(env)
        env["warden"].authenticate(scope: @scope) if env["warden"]
      end

      def parse_message(message)
        data = JSON.parse(message)
        data.each {|key, value| data[key] = ERB::Util.html_escape(value)}
        data
      end

      def send_to(user_id, message)
        @clients.each do |client|
          if client.id == user_id
            client.send(message)
          end
        end
      end

      def send_to_all(message)
        @clients.each { |client| client.send(message)}
      end

      def add_client(user, ws)
        @clients << Client.new(user, ws)
        set_status(user, true)
      end

      def remove_client(user, ws)
        @clients.delete_if { |client| client.connection == ws }
        set_status(user, false) if @clients.none? { |client| client.id == user.id }
      end

      def set_status(user, status)
        user.update(@status_column => status)
        send_to_all(type: "connection", user_id: user.id, online: status)
      end

      def send_message(data, user)
        data["user_id"] = data["user_id"].to_i
        msg = @messages_model.create(sender: user, recipient_id: data["user_id"], body: data["message"])
        send_to(data["user_id"], type: "message", user_id: user.id, message: data["message"], time: msg.created_at)
      end

      def read_messages(user_id, user)
        Message.where(recipient: user, sender_id: user_id, unread: true).update_all(unread: false)
      end

      class Client
        attr_reader :id, :user, :connection

        def initialize(user, connection)
          @id = user.id
          @connection = connection
          @user = user
        end

        def send(message)
          @connection.send(message.to_json)
        end
      end
  end
end
