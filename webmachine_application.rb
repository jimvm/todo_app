require 'webmachine'
require_relative 'app/resources'

unless ENV["TODO_DATABASE"]
  warn "Set ENV[\"TODO_DATABASE\"] before running the app. Use 'todo' for\
 development and 'todo_test' for testing.
  Example: env TODO_DATABASE=todo ruby webmachine_application.rb"
  exit
end

Webmachine.application.routes do
  add ["activities", :url_slug], ActivityResource
  add ["activities"], ActivitiesResource
end

Webmachine.application.run
