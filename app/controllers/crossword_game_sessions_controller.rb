class CrosswordGameSessionsController < ApplicationController
  def init
    easy_mode = params[:easy_mode] == "true"
    @crossword_game_session = CrosswordGameSession.create(easy_mode: easy_mode)
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
    @easy_mode = @crossword_game_session.easy_mode
  end

  def toggle_easy_mode
    @crossword_game_session = CrosswordGameSession.find(params[:id])
    @crossword_game_session.update(easy_mode: !@crossword_game_session.easy_mode)
    redirect_to @crossword_game_session
  end
end
