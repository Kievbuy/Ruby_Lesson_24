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

  ff = File.open('./public/users.txt', 'a')

  ff.write "#{@username}, #{@phone}, #{@datetime}, #{@barber}\n"

  ff.close

  erb "OK! Username is #{@username}, #{@phone}, #{@datetime}, #{@barber}"
end