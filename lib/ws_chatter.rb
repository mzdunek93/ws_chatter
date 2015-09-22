require "configurations"
require "ws_chatter/engine"
require "ws_chatter/ws_chatter_middleware"

module WsChatter
  include Configurations

  class << self
    alias_method :setup, :configure
    alias_method :config, :configuration
  end

  configuration_defaults do |config|
    config.scope = :user
    config.status_column = :online
    config.messages_model = "Messages"
  end
end
