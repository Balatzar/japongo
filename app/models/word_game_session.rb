# == Schema Information
#
# Table name: word_game_sessions
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  current_word_index :integer          default(0)
#
class WordGameSession < ApplicationRecord
  has_and_belongs_to_many :words
  has_and_belongs_to_many :wrong_answers, class_name: "Word", join_table: "word_game_sessions_wrong_answers"
  has_and_belongs_to_many :right_answers, class_name: "Word", join_table: "word_game_sessions_right_answers"

  after_create :initialize_words

  def current_word
    words.order(:id)[current_word_index]
  end

  def next_word!
    update(current_word_index: current_word_index + 1)
  end

  def completed?
    current_word_index >= words.count
  end

  private

  def initialize_words
    matched_words = Word.matched_to_hiraganas
    self.words = matched_words.sample(20)
  end
end
