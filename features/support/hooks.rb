Before do
  DB.tables.each do |table|
    DB[table].delete
  end
end
