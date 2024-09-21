# == Schema Information
#
# Table name: skill_nodes
#
#  id            :bigint           not null, primary key
#  description   :text
#  name          :string
#  position_x    :integer
#  position_y    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  skill_tree_id :bigint           not null
#
# Indexes
#
#  index_skill_nodes_on_skill_tree_id  (skill_tree_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_tree_id => skill_trees.id)
#
class SkillNode < ApplicationRecord
  belongs_to :skill_tree
  has_many :quests
  has_many :outgoing_connections, class_name: "Connection", foreign_key: "source_node_id"
  has_many :incoming_connections, class_name: "Connection", foreign_key: "target_node_id"
  has_many :stat_modifiers
  has_many :stats, through: :stat_modifiers
  has_one_attached :icon
end
