# == Schema Information
#
# Table name: words
#
#  id              :bigint           not null, primary key
#  english_meaning :string
#  hiragana        :string
#  kanji           :string
#  romanji         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Word < ApplicationRecord
  has_and_belongs_to_many :word_game_sessions
  has_and_belongs_to_many :word_game_sessions_as_wrong_answer, class_name: "WordGameSession", join_table: "word_game_sessions_wrong_answers"
  has_and_belongs_to_many :word_game_sessions_as_right_answer, class_name: "WordGameSession", join_table: "word_game_sessions_right_answers"

  def self.matched_to_hiraganas
    MatchedWordsService.call
  end
end
