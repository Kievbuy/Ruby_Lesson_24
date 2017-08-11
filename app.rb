require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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

# === POST ===

post '/visit' do

  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:date_time]
  @barber = params[:barber]

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

  ff = File.open('./public/users.txt', 'a')

  ff.write "#{@username}, #{@phone}, #{@datetime}, #{@barber}\n"

  ff.close

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