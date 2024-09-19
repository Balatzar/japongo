class WordGameSessionsController < ApplicationController
  def init
    @word_game_session = WordGameSession.create!
    redirect_to @word_game_session, notice: "Game started!"
  end

  def show
    @word_game_session = WordGameSession.find(params[:id])
    @current_word = @word_game_session.current_word
  end

  def update
    @word_game_session = WordGameSession.find(params[:id])
    word = @word_game_session.current_word
    answer = params[:answer].downcase.strip

    if word.romanji.downcase == answer
      @word_game_session.right_answers << word
      correct = true
    else
      @word_game_session.wrong_answers << word
      correct = false
    end

    @word_game_session.next_word!

    render json: {
      correct: correct,
      correct_answer: word.romanji,
      english_meaning: word.english_meaning,
      kanji: word.kanji,
      completed: @word_game_session.completed?
    }
  end
end
