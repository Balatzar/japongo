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
class Hiragana < ApplicationRecord
  has_one_attached :image
  has_one_attached :story_image
  has_and_belongs_to_many :building_blocks
end
