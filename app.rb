require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
  db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
  barbers.each do |barber|
    if !is_barber_exists? db, barber
      db.execute 'insert into Barbers (name) values (?)', [barber]
    end
  end
end

def get_db
  db = SQLite3::Database.new 'barbershop.db'
  db.results_as_hash = true
  return db
end

before do
  db = get_db
  @barbers = db.execute 'select * from Barbers'
end

configure do
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'CREATE TABLE IF NOT EXISTS "Users" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "username" TEXT,
    "phone" TEXT,
    "datestamp" TEXT,
    "barber" TEXT,
    "color" TEXT
)         '
  db.execute 'CREATE TABLE IF NOT EXISTS "Barbers" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT
)         '

  seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut', 'John Doe']
end

get '/' do
	erb "Hello, there! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

get '/showusers' do
  db = get_db

  @results = db.execute 'select * from Users order by id desc'

  erb :showusers
end

# === POST ===

post '/visit' do

  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:date_time]
  @barber = params[:barber]
  @color = params[:color]

  hh = {
      :username => 'Enter you name',
      :phone => 'Enter your phone',
      :date_time => 'Enter Date and Time'}

  #для каждой пары ключ/значение
  # hh.each do |key, value|
  #   if params[key] == ''
  #     @error = hh[key]
  #     return erb :visit
  #   end
  # end

  @error = hh.select{|key, value| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :visit
  end

  db = get_db
  db.execute 'insert into Users (
    username,
    phone,
    datestamp,
    barber,
    color
)
values
(
    ?,?,?,?,?
)', [@username, @phone, @datetime, @barber, @color]

  erb "OK! Username is #{@username}, #{@phone}, #{@datetime}, #{@barber}"
end



post '/contacts' do

  @username = params[:username]
  @phone = params[:phone]
  @message = params[:message]

  hh = {
      :username => 'Enter you name',
      :phone => 'Enter your phone',
      :message => 'Enter your Message'}

  time1 = Time.new

  @error = hh.select{|key, value| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :contacts
  end

  ff = File.open('./public/messages.txt', 'a')

  ff.write "Date/Time: #{time1.inspect}: #{@username}, #{@phone}, #{@message}\n===========\n"

  ff.close

  erb "OK! Username is #{@username}, #{@phone}, #{@message}"
end