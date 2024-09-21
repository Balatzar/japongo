class CreateConnections < ActiveRecord::Migration[7.2]
  def change
    create_table :connections do |t|
      t.integer :source_node_id
      t.integer :target_node_id
      t.references :skill_tree, null: false, foreign_key: true
      t.boolean :required_to_unlock

      t.timestamps
    end
  end
end
