class CreateQuests < ActiveRecord::Migration[7.2]
  def change
    create_table :quests do |t|
      t.string :name
      t.text :description
      t.boolean :unlocked
      t.boolean :completed
      t.references :skill_node, null: false, foreign_key: true
      t.jsonb :stat_reward

      t.timestamps
    end
  end
end
