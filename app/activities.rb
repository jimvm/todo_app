require 'yaml/store'

ActivityStore = YAML::Store.new("activities.yml")

class Activity
  def initialize(name)
    @name = name
  end

  attr_reader :name
end

class Activities
  def activities
    all = roots.inject([]) do |result, name|
      activity = ActivityStore.transaction { ActivityStore[name] }
      result << activity
    end
  end

  private
    def roots
      @roots ||= ActivityStore.transaction { ActivityStore.roots }
    end
end
