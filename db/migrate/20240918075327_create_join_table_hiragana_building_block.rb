class CreateJoinTableHiraganaBuildingBlock < ActiveRecord::Migration[7.2]
  def change
    create_join_table :hiraganas, :building_blocks do |t|
      t.index [:hiragana_id, :building_block_id]
      t.index [:building_block_id, :hiragana_id]
    end
  end
end
