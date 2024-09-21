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
class Card < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :front, presence: true, uniqueness: true
  validates :back, presence: true
  validates :interval, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ease_factor, presence: true, numericality: { greater_than: 0 }
  validates :repetitions, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :due_for_review, -> { where("next_review <= ?", Time.current) }

  after_create :set_initial_review_date

  def process_review(grade)
    review = reviews.create(grade: grade, reviewed_at: Time.current, review_duration: 0) # You may want to track actual review duration
    update_sm2_params(grade)
    schedule_next_review
    save
  end

  private

  def set_initial_review_date
    self.next_review = Time.current
    save
  end

  def update_sm2_params(grade)
    self.ease_factor = [1.3, ease_factor + (0.1 - (3 - grade) * (0.08 + (3 - grade) * 0.02))].max
    
    if grade < 3
      self.repetitions = 0
      self.interval = 1
    else
      self.repetitions += 1
      self.interval = calculate_interval
    end
  end

  def calculate_interval
    case repetitions
    when 0 then 1
    when 1 then 6
    else (interval * ease_factor).round
    end
  end

  def schedule_next_review
    self.next_review = interval.days.from_now
  end
end
