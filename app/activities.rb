require 'yaml/store'
require 'ostruct'

class Activity
  def self.all
    roots.inject([]) do |result, name|
      activity = store.transaction { store[name] }

      result << activity
    end
  end

  def self.delete(name)
    store.transaction { store.delete name }
  end

  def self.create(name)
    activity = OpenStruct.new(name: name)

    store.transaction { store[name] = activity }
  end

  def self.replace(name, new_name)
    new_activity = OpenStruct.new(name: name)

    store.transaction do
      store.delete name

      store[new_name] = new_activity
    end
  end

  def self.find(name)
    store.transaction { store[name] }
  rescue PStore::Error
    false
  end

  private
    def self.roots
      @roots ||= store.transaction { store.roots }
    end

    def self.store
      @store ||= YAML::Store.new("activities.yml")
    end
end
