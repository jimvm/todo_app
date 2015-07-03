require 'webmachine'
require_relative 'app/resources'

Webmachine.application.routes do
  add ["activities", :name], ActivityResource
  add ["activities"], ActivitiesResource
end

Webmachine.application.run
