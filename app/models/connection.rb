# == Schema Information
#
# Table name: connections
#
#  id                 :bigint           not null, primary key
#  required_to_unlock :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  skill_tree_id      :bigint           not null
#  source_node_id     :integer
#  target_node_id     :integer
#
# Indexes
#
#  index_connections_on_skill_tree_id  (skill_tree_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_tree_id => skill_trees.id)
#
class Connection < ApplicationRecord
  belongs_to :skill_tree
  belongs_to :source_node, class_name: "SkillNode"
  belongs_to :target_node, class_name: "SkillNode"
end
