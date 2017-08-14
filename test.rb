require 'sqlite3'

newdb = SQLite3::Database.new 'barbershop.db'

newdb.results_as_hash = true

newdb.execute 'select * from Users' do |row|
  print row['username'] + ' '
  puts row['datestamp']
  puts "================="
end