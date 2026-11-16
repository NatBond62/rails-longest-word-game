require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
    session[:score] ||= 0
  end

  def score
    @letters = params[:letters]
    @word = params[:word]
    @attempt_tf = @word.upcase.chars.all? { |char| @word.upcase.chars.count(char) <= @letters.upcase.chars.count(char) }
    if @attempt_tf
      url = "https://dictionary.lewagon.com/#{@word}"
      attempt_value = JSON.parse(URI.parse(url).read)
      if attempt_value["found"] == false
        @message = "Sorry but #{@word} does not seem to be valid word..."
      else
        @message = "Congratualations! #{@word} is a valid word !"
        session[:score] += @word.size * 5
      end
    else
      @message = "Sorry but #{@word} can't be built out of #{@letters.upcase.chars.join(",")}"
    end
  end
end
