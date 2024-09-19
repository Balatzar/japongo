class AddCurrentWordIndexToWordGameSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :word_game_sessions, :current_word_index, :integer, default: 0
  end
end
