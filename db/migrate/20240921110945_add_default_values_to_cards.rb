class AddDefaultValuesToCards < ActiveRecord::Migration[7.2]
  def change
    change_column_default :cards, :interval, 0
    change_column_default :cards, :ease_factor, 2.5
    change_column_default :cards, :repetitions, 0
  end
end
