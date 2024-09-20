class AddEasyModeToCrosswordGameSessions < ActiveRecord::Migration[7.2]
  def change
    add_column :crossword_game_sessions, :easy_mode, :boolean, default: false
  end
end
