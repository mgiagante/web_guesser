require 'bundler'
Bundler.require

require 'sinatra'
require 'sinatra/reloader'

@@remaining_tries = 5

@@number = rand(100)

helpers do
  def check_guess(guess)
    if guess
      if guess.to_i > @@number 
        { message: "Too high!", guessed_right: false }
      elsif guess.to_i < @@number
        { message: "Too low!", guessed_right: false }
      else
        { message: "You got it right!", guessed_right: true }
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

  def won?
    check_guess(@guess)[:guessed_right]
  end

  def lost?
    @@remaining_tries.zero?
  end
end

get '/' do
  puts "#{@@number} generated!"
  @guess = params["guess"]
  message = check_guess(@guess) ? check_guess(@guess)[:message] : nil

  if @guess
    @closeness = closeness_for(@guess.to_i, @@number)

    if won? || lost? 
      @@number = rand(100)
      @@remaining_tries = 5
    else
      @@remaining_tries -= 1
    end

    if lost? 
      message = "You lost. A new secret number has been generated!"
    end
  end

  erb :index, :locals => {
    :number => @@number, 
    :message => message, 
    :closeness => @closeness
  }
end
