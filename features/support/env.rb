require 'childprocess'
require 'sequel'

DB = Sequel.postgres 'todo_test'

DB.create_table :activities do
  primary_key :id
  String :name
end

server = ChildProcess.build "ruby", "webmachine_application.rb"
server.start

at_exit do
  server.stop
  DB.drop_table :activities
end
