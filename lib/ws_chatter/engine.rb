module WsChatter
  class Engine < Rails::Engine
    initializer "ws_chatter.add_middleware" do |app|
      app.middleware.use WsChatter::WsChatterMiddleware
    end
  end
end
