class RemoveUnnecessaryFieldsFromWordGameSessions < ActiveRecord::Migration[7.2]
  def change
    remove_column :word_game_sessions, :right_answer_id, :bigint
    remove_column :word_game_sessions, :wrong_answer_id, :bigint
    remove_column :word_game_sessions, :word_id, :bigint
  end
end
