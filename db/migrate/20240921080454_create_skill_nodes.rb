class CreateSkillNodes < ActiveRecord::Migration[7.2]
  def change
    create_table :skill_nodes do |t|
      t.string :name
      t.text :description
      t.references :skill_tree, null: false, foreign_key: true
      t.integer :position_x
      t.integer :position_y

      t.timestamps
    end
  end
end
