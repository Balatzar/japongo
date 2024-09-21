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
class Review < ApplicationRecord
  belongs_to :card

  validates :reviewed_at, presence: true
  validates :grade, presence: true, inclusion: { in: 0..3 }
  validates :review_duration, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
