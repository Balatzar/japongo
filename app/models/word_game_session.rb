# == Schema Information
#
# Table name: word_game_sessions
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class WordGameSession < ApplicationRecord
  has_and_belongs_to_many :words
  has_and_belongs_to_many :wrong_answers, class_name: "Word", join_table: "word_game_sessions_wrong_answers"
  has_and_belongs_to_many :right_answers, class_name: "Word", join_table: "word_game_sessions_right_answers"

  after_create :initialize_words

  private

  def initialize_words
    matched_words = Word.matched_to_hiraganas
    self.words = matched_words.sample(20)
  end
end
