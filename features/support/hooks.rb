Before do
  db = Sequel.postgres "todo_test"

  db[:activities].delete
  db[:accounts].delete
end
