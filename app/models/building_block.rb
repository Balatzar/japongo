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
  has_and_belongs_to_many :hiraganas
  validates :name, presence: true
  validates :image, presence: true

  def image_data=(data)
    io = StringIO.new(Base64.decode64(data.split(",").last))
    self.image.attach(io: io, filename: "#{name}_image.png", content_type: "image/png")
  end
end
