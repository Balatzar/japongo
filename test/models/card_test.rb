# == Schema Information
#
# Table name: cards
#
#  id          :bigint           not null, primary key
#  back        :text
#  ease_factor :float
#  front       :text
#  interval    :integer
#  next_review :datetime
#  repetitions :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class CardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
