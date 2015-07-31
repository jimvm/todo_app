require "sequel"

task :setup_test_database do
  db = Sequel.postgres "todo_test"

  db.create_table :accounts do
    primary_key :id
    String :name,       unique: true
    String :url_slug,    unique: true, null: false
    String :password_hash,    unique: true

    constraint(:min_length_name) { char_length(name) > 3 }
    constraint(:max_length_name) { char_length(name) < 25}
  end

  db.create_table :activities do
    primary_key :id
    String :description
    String :url_slug,    unique: true, null: false
    foreign_key :account_id, :accounts

    constraint(:min_length_description) { char_length(description) > 0 }
    constraint(:max_length_description) { char_length(description) < 81 }

    unique [:description, :account_id]
  end
end

task :drop_test_database do
  db = Sequel.postgres "todo_test"

  db.drop_table :activities
  db.drop_table :accounts
end
