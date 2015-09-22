$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ws_chatter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ws_chatter"
  s.version     = WsChatter::VERSION
  s.authors     = ["codebaker95"]
  s.email       = ["codebaker95@gmail.com"]
  s.homepage    = "https://github.com/codebaker95/ws_chatter"
  s.summary     = "Chat gem for Ruby on Rails based on WebSockets"
  s.description = "Chat gem for Ruby on Rails based on WebSockets"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency "rack"
  s.add_dependency "faye-websocket"
  s.add_dependency "configurations"

  s.add_development_dependency "sqlite3"
end
