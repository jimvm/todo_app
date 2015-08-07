require "sequel"
require_relative "./app/persistence"
require "cucumber/rake/task"
require "rspec/core/rake_task"

task default: [:setup_database, :spec, :features, :drop_database]

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features)

task :run do
  `ruby webmachine_application.rb`
end

task :setup_database do
  unless ENV["TODO_DATABASE"]
    puts ENV['TODO_DATABASE']
  message = """Make sure to give a database name to the setup_database task.

Example:
  rake setup_database TODO_DATABASE=todo_test
"""
    puts message
    abort
  end

  puts "Setting up database..."
  db = Sequel.postgres ENV["TODO_DATABASE"]

  db.create_table :accounts do
    primary_key :id
    String :name,       unique: true, null: false
    String :url_slug,    unique: true, null: false
    String :password_hash, null: false

    constraint(:min_length_name) { char_length(name) > 3 }
    constraint(:max_length_name) { char_length(name) < 25}

    constraint(:min_length_url_slug) { char_length(url_slug) > 11 }
    constraint(:max_length_url_slug) { char_length(url_slug) < 13}
  end

  db.create_table :activities do
    primary_key :id
    String :description, null: false
    String :url_slug,    unique: true, null: false
    foreign_key :account_id, :accounts, null: false

    constraint(:min_length_description) { char_length(description) > 0 }
    constraint(:max_length_description) { char_length(description) < 81 }

    unique [:description, :account_id]

    constraint(:min_length_url_slug) { char_length(url_slug) > 11 }
    constraint(:max_length_url_slug) { char_length(url_slug) < 13}
  end
end

task :drop_database do
  unless ENV["TODO_DATABASE"]
    message = """Make sure to give a database name to the drop_database task.

Example:
  rake drop_database TODO_DATABASE=todo_test
"""

    puts message
    abort
  end

  puts "Dropping database..."
  db = Sequel.postgres ENV["TODO_DATABASE"]

  db.drop_table :activities
  db.drop_table :accounts
end

task :setup_account do |t, args|
  unless ENV["ACCOUNT_NAME"] && ENV["ACCOUNT_PASSWORD"]
message = """Make sure that you give both an account_name and an account_password to the setup_account task.

Example:
rake setup_account account_name=myname account_password=whatever
"""
    puts message
    abort
  end

  puts "Creating account..."
  Account.create name: ENV["ACCOUNT_NAME"],
    password_hash: Account.create_password_hash(ENV["ACCOUNT_PASSWORD"]),
    url_slug: Account.create_slug

  if Account.find name: ENV["ACCOUNT_NAME"]
    puts "Successfully created account."
  end
end
