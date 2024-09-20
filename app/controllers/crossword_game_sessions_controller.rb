class CrosswordGameSessionsController < ApplicationController
  def init
    @crossword_game_session = CrosswordGameSession.create
    redirect_to @crossword_game_session
  end

  def show
    @crossword_game_session = CrosswordGameSession.find(params[:id])
    @clue_coordinates = {}
    clue_number = 1

    @crossword_game_session.clues.each do |clue|
      row, col = clue["starting_index"]
      @clue_coordinates[[ row, col ]] = clue_number
      clue_number += 1
    end

    @words = @crossword_game_session.words.map(&:hiragana)
    @answers = @crossword_game_session.words.map(&:hiragana)
  end
end
