require 'sinatra'
require 'sinatra/reloader'

secret_number = rand(100)
user_won = false

get '/' do
  if params['guess'].to_i > secret_number
    message = "Too high!"
  elsif params['guess'].to_i < secret_number
    message = "Too low!"
  else
    message = "You got it right!"
    user_won = true
  end
  erb :index, :locals => {:number => secret_number, :message => message, :user_won => user_won}
end
