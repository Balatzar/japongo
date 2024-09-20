class CrosswordGameSessionsController < ApplicationController
  def init
    @crossword_game_session = CrosswordGameSession.create
    redirect_to @crossword_game_session
  end

  def show
    @crossword_game_session = CrosswordGameSession.find(params[:id])
  end
end
