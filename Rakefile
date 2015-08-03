require "sequel"
require_relative "./app/persistence"

task :setup_test_database do
  db = Sequel.postgres "todo_test"

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

task :drop_test_database do
  db = Sequel.postgres "todo_test"

  db.drop_table :activities
  db.drop_table :accounts
end

task :setup_account do |t, args|
  unless ENV["account_name"] && ENV["account_password"]
message = """Make sure that you give both an account_name and an account_password to the setup_account task.

Example:
rake setup_account account_name=myname account_password=whatever
"""
    puts message
    abort
  end

  puts "Creating account..."
  Account.create name: ENV["account_name"],
    password_hash: Account.create_password_hash(ENV["account_password"]),
    url_slug: Account.create_slug

  if Account.find name: ENV["account_name"]
    puts "Successfully created account."
  end
end
