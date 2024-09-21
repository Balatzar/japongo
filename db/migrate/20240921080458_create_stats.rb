class CreateStats < ActiveRecord::Migration[7.2]
  def change
    create_table :stats do |t|
      t.string :name
      t.text :description
      t.references :skill_tree, null: false, foreign_key: true

      t.timestamps
    end
  end
end
