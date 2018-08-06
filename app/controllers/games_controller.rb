require "open-uri"
require "json"
class GamesController < ApplicationController
  before_action :attempt_params
  before_action :grid_params
  def new
      @grid=[]
      i = 0
      while i < 8
        @grid << ("A".."Z").to_a.sample
        i += 1
      end
  end

  def score
    url = 'https://wagon-dictionary.herokuapp.com/' + @attempt
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
      #check if the word appears in the grid
      def grid_contains_word (attempt, grid)
        attempt_array = attempt.upcase.chars.to_a
        all_letters_present = true
        same_number_letters = true
        attempt_array.each do |char|
          if !grid.include?(char)
            all_letters_present = false
          end
          if grid.count(char) < attempt_array.count(char)
              same_number_letters = false
          end
        end
        return all_letters_present && same_number_letters
      end

      def dictionary_contains_word (attempt, url)
        #link API
        url = 'https://wagon-dictionary.herokuapp.com/' + attempt.downcase
        word_serialized = open(url).read
        word = JSON.parse(word_serialized)
        return word["found"]
      end
      if grid_contains_word(@attempt, @grid) && dictionary_contains_word(@attempt, url)
        score = word["length"] 
        @message = "well done, score: #{score}"
      elsif !dictionary_contains_word(@attempt, url)
        score = 0
        @message = "not an english word"
      elsif !grid_contains_word(@attempt, @grid)
        score = 0
        @message = "not in the grid"
      else
        score = 0
        @message = "invalid word"
      end
  end

  private
  
  def attempt_params
    @attempt = params[:word] 
  end

  def grid_params
    @grid = params[:grid]
  end


end



