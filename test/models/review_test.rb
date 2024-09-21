# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  grade           :integer
#  review_duration :integer
#  reviewed_at     :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  card_id         :bigint           not null
#
# Indexes
#
#  index_reviews_on_card_id  (card_id)
#
# Foreign Keys
#
#  fk_rails_...  (card_id => cards.id)
#
require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
