class WordGameSessionsController < ApplicationController
  def init
    @word_game_session = WordGameSession.create!
      redirect_to @word_game_session, notice: "Game started!"
  end

  def show
    @word_game_session = WordGameSession.find(params[:id])
    @current_word = @word_game_session.words.where.not(id: @word_game_session.right_answers.pluck(:id) + @word_game_session.wrong_answers.pluck(:id)).first
  end

  def update
    @word_game_session = WordGameSession.find(params[:id])
    word = Word.find(params[:word_id])
    answer = params[:answer].downcase.strip

    if word.romanji.downcase == answer
      @word_game_session.right_answers << word
      correct = true
    else
      @word_game_session.wrong_answers << word
      correct = false
    end

    render json: { correct: correct, correct_answer: word.romanji }
  end
end
