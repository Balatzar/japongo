# == Schema Information
#
# Table name: cards
#
#  id          :bigint           not null, primary key
#  back        :text
#  ease_factor :float            default(2.5)
#  front       :text
#  interval    :integer          default(0)
#  next_review :datetime
#  repetitions :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_cards_on_front  (front) UNIQUE
#
require "test_helper"

class CardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
