class AddUniqueIndexToCardsFront < ActiveRecord::Migration[7.2]
  def change
    add_index :cards, :front, unique: true
  end
end
