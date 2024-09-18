class RemoveImageFromBuildingBlocks < ActiveRecord::Migration[7.2]
  def change
    remove_column :building_blocks, :image, :string
  end
end
