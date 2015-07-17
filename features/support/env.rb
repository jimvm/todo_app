require 'childprocess'
require 'sequel'

server = ChildProcess.build "ruby", "webmachine_application.rb"
server.start

at_exit do
  server.stop
end
