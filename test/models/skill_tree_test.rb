# == Schema Information
#
# Table name: skill_trees
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class SkillTreeTest < ActiveSupport::TestCase
  def setup
    StatModifier.delete_all
    Connection.delete_all
    Quest.delete_all
  end

  test "create a full skill tree" do
    # Create a SkillTree
    skill_tree = SkillTree.create!(name: "Programming Skills")

    # Create Stats
    strength = skill_tree.stats.create!(name: "Coding Speed", description: "How fast you can write code")
    intelligence = skill_tree.stats.create!(name: "Problem Solving", description: "Ability to solve complex problems")

    # Create SkillNodes
    basics = skill_tree.skill_nodes.create!(name: "Programming Basics", description: "Learn the fundamentals", position_x: 0, position_y: 0)
    oop = skill_tree.skill_nodes.create!(name: "Object-Oriented Programming", description: "Learn OOP concepts", position_x: 1, position_y: 0)
    algorithms = skill_tree.skill_nodes.create!(name: "Algorithms", description: "Learn basic algorithms", position_x: 1, position_y: 1)

    # Create StatModifiers
    basics.stat_modifiers.create!(stat: strength, value: 5)
    oop.stat_modifiers.create!(stat: intelligence, value: 10)
    algorithms.stat_modifiers.create!(stat: strength, value: 3)
    algorithms.stat_modifiers.create!(stat: intelligence, value: 15)

    # Create Connections
    Connection.create!(skill_tree: skill_tree, source_node: basics, target_node: oop, required_to_unlock: true)
    Connection.create!(skill_tree: skill_tree, source_node: basics, target_node: algorithms, required_to_unlock: true)

    # Create Quests
    basics.quests.create!(name: "Hello World", description: "Write your first program", unlocked: true, completed: false, stat_reward: { coding_speed: 2 })
    oop.quests.create!(name: "Create a Class", description: "Design and implement a class", unlocked: false, completed: false, stat_reward: { problem_solving: 5 })
    algorithms.quests.create!(name: "Implement Bubble Sort", description: "Code the bubble sort algorithm", unlocked: false, completed: false, stat_reward: { coding_speed: 3, problem_solving: 7 })

    # Debug information for StatModifiers
    puts "Total StatModifiers: #{StatModifier.count}"
    StatModifier.all.each do |sm|
      puts "StatModifier ID: #{sm.id}, SkillNode: #{sm.skill_node.name}, Stat: #{sm.stat.name}, Value: #{sm.value}"
    end

    # Debug information for Connections
    puts "Total Connections: #{Connection.count}"
    Connection.all.each do |conn|
      puts "Connection ID: #{conn.id}, Source: #{conn.source_node.name}, Target: #{conn.target_node.name}, Required: #{conn.required_to_unlock}"
    end

    # Debug information for Quests
    puts "Total Quests: #{Quest.count}"
    Quest.all.each do |quest|
      puts "Quest ID: #{quest.id}, Name: #{quest.name}, SkillNode: #{quest.skill_node.name}, Unlocked: #{quest.unlocked}, Completed: #{quest.completed}"
    end

    # Assertions
    assert_equal 3, skill_tree.skill_nodes.count
    assert_equal 2, skill_tree.stats.count
    assert_equal 4, StatModifier.count
    assert_equal 2, Connection.count
    assert_equal 3, Quest.count

    # Test associations
    assert_includes basics.stats, strength
    assert_includes oop.stats, intelligence
    assert_includes algorithms.stats, strength
    assert_includes algorithms.stats, intelligence

    # Test connections
    assert_equal basics, oop.incoming_connections.first.source_node
    assert_equal basics, algorithms.incoming_connections.first.source_node

    # Test quests
    assert basics.quests.first.unlocked
    assert_not oop.quests.first.unlocked
    assert_not algorithms.quests.first.unlocked
  end
end
