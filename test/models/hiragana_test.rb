# == Schema Information
#
# Table name: hiraganas
#
#  id              :bigint           not null, primary key
#  memo            :text
#  name            :string
#  story           :text
#  translated_name :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class HiraganaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
