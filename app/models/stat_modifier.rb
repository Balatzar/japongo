# == Schema Information
#
# Table name: stat_modifiers
#
#  id            :bigint           not null, primary key
#  value         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  skill_node_id :bigint           not null
#  stat_id       :bigint           not null
#
# Indexes
#
#  index_stat_modifiers_on_skill_node_id  (skill_node_id)
#  index_stat_modifiers_on_stat_id        (stat_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_node_id => skill_nodes.id)
#  fk_rails_...  (stat_id => stats.id)
#
class StatModifier < ApplicationRecord
  belongs_to :skill_node
  belongs_to :stat
end
