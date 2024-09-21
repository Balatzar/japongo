class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.text :front
      t.text :back
      t.datetime :next_review
      t.integer :interval
      t.float :ease_factor
      t.integer :repetitions

      t.timestamps
    end
  end
end
