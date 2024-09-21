class AddGameStateToCrosswordGameSessions < ActiveRecord::Migration[7.2]
  def change
    add_column :crossword_game_sessions, :game_state, :json
  end
end
