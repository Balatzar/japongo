# == Schema Information
#
# Table name: stats
#
#  id            :bigint           not null, primary key
#  description   :text
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  skill_tree_id :bigint           not null
#
# Indexes
#
#  index_stats_on_skill_tree_id  (skill_tree_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_tree_id => skill_trees.id)
#
class Stat < ApplicationRecord
  belongs_to :skill_tree
  has_many :stat_modifiers
end
