class CreateHiraganas < ActiveRecord::Migration[7.2]
  def change
    create_table :hiraganas do |t|
      t.string :name
      t.text :memo
      t.text :story

      t.timestamps
    end
  end
end
