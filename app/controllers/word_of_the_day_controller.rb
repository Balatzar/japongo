class WordOfTheDayController < ApplicationController
  def show
    @word = WordOfTheDayService.select_word
  end
end
