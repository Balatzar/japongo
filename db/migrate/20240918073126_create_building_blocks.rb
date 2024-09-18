class CreateBuildingBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :building_blocks do |t|
      t.string :name
      t.string :image

      t.timestamps
    end
  end
end
