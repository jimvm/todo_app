Before do
  db = Sequel.postgres 'todo_test'

  db.tables.each do |table|
    db[table].delete
  end
end
