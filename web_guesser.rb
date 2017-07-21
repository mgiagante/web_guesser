require 'sinatra'
require 'sinatra/reloader'

set :number, rand(100)

helpers do
  def check_guess(guess)
    if guess
      if guess.to_i > settings.number
        message = "Too high!"
      elsif guess.to_i < settings.number
        message = "Too low!"
      else
        message = "You got it right!"
      end
    else
      nil
    end
  end
end

get '/' do
  guess = params["guess"]
  message = check_guess(guess)
  erb :index, :locals => {:number => settings.number, :message => message}
end
