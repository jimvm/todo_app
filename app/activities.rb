require 'yaml/store'

ActivityStore = YAML::Store.new("activities.yml")

class Activity
  def initialize(name)
    @name = name
  end

  attr_reader :name
end

class Activities
  def self.activities
    roots.inject([]) do |result, name|
      activity = ActivityStore.transaction { ActivityStore[name] }

      result << activity
    end
  end

  def self.delete(name)
    ActivityStore.transaction { ActivityStore.delete name }
  end

  def self.create(name)
    activity = Activity.new(name)

    ActivityStore.transaction { ActivityStore[name] = activity }
  end

  def self.replace(name, new_name)
    new_activity = Activity.new(new_name)

    ActivityStore.transaction do
      ActivityStore.delete name

      ActivityStore[new_name] = new_activity
    end
  end

  def self.find(name)
    ActivityStore.transaction { ActivityStore[name] }
  rescue PStore::Error
    false
  end

  private
    def self.roots
      @roots ||= ActivityStore.transaction { ActivityStore.roots }
    end
end
