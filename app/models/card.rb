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
class Card < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :front, presence: true
  validates :back, presence: true
  validates :interval, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ease_factor, presence: true, numericality: { greater_than: 0 }
  validates :repetitions, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
