require "sequel"

task :setup_test_database do
  db = Sequel.postgres "todo_test"

  db.create_table :activities do
    primary_key :id
    String :description, unique: true

    constraint(:min_length_description) { char_length(description) > 0 }
    constraint(:max_length_description) { char_length(description) < 81 }
  end
end

task :drop_test_database do
  db = Sequel.postgres "todo_test"

  db.drop_table :activities
end
