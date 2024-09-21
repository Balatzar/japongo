# == Schema Information
#
# Table name: skill_trees
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SkillTree < ApplicationRecord
  has_many :skill_nodes
  has_many :stats
end
