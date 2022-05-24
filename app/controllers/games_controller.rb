require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = (0...10).map { ('a'..'z').to_a[rand(26)]}
  end

  def valid_word(word, grid)
    error = ''

    # Check word built from grid
    grid = grid.split
    word.split('').each do |letter|
      if grid.include?(letter) == false
        error = "Sorry but #{word} cannot be built out of #{grid}"
        return false, error
      end
    end

    # Check word is english
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = URI.open(url).read
    response = JSON.parse(response)
    if response['found'] == false
      error = "Sorry but #{word} does not seem to be a valid English word."
      return false, error
    end

    # If valid, return true and length
    return true, response['length']
  end

  def score
    @word = params[:word] if params[:word]
    @grid = params[:grid] if params[:grid]
    valid, outcome = valid_word(@word, @grid)

    if valid
      @message = "Congratulations! #{@word.upcase} is a valid English word."
    else
      @message = outcome
    end
  end
end
