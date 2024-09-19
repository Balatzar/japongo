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
  def self.matched_to_hiraganas
    MatchedWordsService.call
  end
end
