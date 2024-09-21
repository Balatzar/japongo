class CreateSkillTrees < ActiveRecord::Migration[7.2]
  def change
    create_table :skill_trees do |t|
      t.string :name

      t.timestamps
    end
  end
end
