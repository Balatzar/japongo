class CreateCrosswordGameSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :crossword_game_sessions do |t|
      t.json :grid
      t.json :clues

      t.timestamps
    end

    create_join_table :crossword_game_sessions, :words do |t|
      t.index [:crossword_game_session_id, :word_id]
      t.index [:word_id, :crossword_game_session_id]
    end
  end
end
