# == Schema Information
#
# Table name: building_blocks
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BuildingBlock < ApplicationRecord
  has_one_attached :image
end
