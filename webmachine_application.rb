require "webmachine"
require_relative "app/resources"

unless ENV["TODO_DATABASE"]
  warn "Set ENV[\"TODO_DATABASE\"] before running the app. Use 'todo' for\
 development and 'todo_test' for testing.
  Example: env TODO_DATABASE=todo ruby webmachine_application.rb"
  exit
end

Webmachine.application.routes do
  add [:account_slug],                               AccountResource
  add [:account_slug, "activities"],                 ActivitiesResource
  add [:account_slug, "activities", :activity_slug], ActivityResource
end

Webmachine.application.run
