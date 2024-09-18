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
require "test_helper"

class WordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
