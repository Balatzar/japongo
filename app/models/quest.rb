# == Schema Information
#
# Table name: quests
#
#  id            :bigint           not null, primary key
#  completed     :boolean
#  description   :text
#  name          :string
#  stat_reward   :jsonb
#  unlocked      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  skill_node_id :bigint           not null
#
# Indexes
#
#  index_quests_on_skill_node_id  (skill_node_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_node_id => skill_nodes.id)
#
class Quest < ApplicationRecord
  belongs_to :skill_node
end
