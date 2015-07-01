require_relative '../../app'
require 'childprocess'

server = ChildProcess.build "ruby", "run.rb"
server.start

at_exit do
  server.stop
  `rm activities.yml`
end
