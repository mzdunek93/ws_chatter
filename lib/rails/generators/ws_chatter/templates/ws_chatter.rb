WsChatter.setup do |config|
  config.scope = :<%= scope %>
  config.status_column = :<%= status_column %>
  config.messages_model = "<%= messages_model %>"
end
