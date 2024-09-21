class CreateWordGameSessionAssociations < ActiveRecord::Migration[7.1]
  def change
    create_join_table :word_game_sessions, :words do |t|
      t.index [ :word_game_session_id, :word_id ]
      t.index [ :word_id, :word_game_session_id ]
    end

    create_join_table :word_game_sessions, :words, table_name: "word_game_sessions_wrong_answers" do |t|
      t.index [ :word_game_session_id, :word_id ], name: "index_wgs_wrong_answers"
      t.index [ :word_id, :word_game_session_id ], name: "index_wrong_answers_wgs"
    end

    create_join_table :word_game_sessions, :words, table_name: "word_game_sessions_right_answers" do |t|
      t.index [ :word_game_session_id, :word_id ], name: "index_wgs_right_answers"
      t.index [ :word_id, :word_game_session_id ], name: "index_right_answers_wgs"
    end
  end
end
