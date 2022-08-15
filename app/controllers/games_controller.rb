require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    # Generating a grid
    alphabet = ('A'..'Z').to_a
    @grid = []
    10.times do
      @grid << alphabet[rand(26)]
      # @grid << " "
    end
  end


  def score
    # Parsing the dictionary API
    @user_input = params[:user_input]
    url = "https://wagon-dictionary.herokuapp.com/#{@user_input}"
    @word_serialized = URI.open(url).read
    @word = JSON.parse(@word_serialized)

    @grid = params[:grid]

    # Checking if word is an English word
    @found_in_dictionary = @word["found"]

    # Checking if word is in the grid
    @user_input.split("").all? do |letter|
      @grid.include?(letter.upcase) ? @found_in_grid = true : @found_in_grid = false
    end

    # Joining bother conditions
    if @found_in_dictionary && @found_in_grid
      @result = "YOU WIN"
    elsif @found_in_dictionary & !@found_in_grid
      @result = "YOU LOSE - Word is in dictionary but not in grid"
    elsif !@found_in_dictionary & @found_in_grid
      @result = "YOU LOSE - Word is in grid but not in dictionary"
    else
      @result = "YOU LOSE - Word neither in dictionary nor in grid"
    end

    @score

  end
end
