class CreateStatModifiers < ActiveRecord::Migration[7.2]
  def change
    create_table :stat_modifiers do |t|
      t.references :skill_node, null: false, foreign_key: true
      t.references :stat, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
