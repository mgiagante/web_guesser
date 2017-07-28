require 'sinatra'
require 'sinatra/reloader'

@@remaining_tries = 5

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

  def closeness_for(current, target)
    case (target - current).abs
    when 0
      "equal"
    when 1..25 
      "close"
    when 26..100
      "far"
    end
  end

  def guessed_right?
    @closeness.downcase.include? 'right'
  end
end

get '/' do
  guess = params["guess"]
  message = check_guess(guess)

  if guess
    @closeness = closeness_for(guess.to_i, settings.number)
    @@remaining_tries -= 1 unless guessed_right? 
  end

  erb :index, :locals => {
    :number => settings.number, 
    :message => message, 
    :closeness => @closeness
  }
end
