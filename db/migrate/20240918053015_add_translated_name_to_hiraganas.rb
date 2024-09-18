class AddTranslatedNameToHiraganas < ActiveRecord::Migration[7.2]
  def change
    add_column :hiraganas, :translated_name, :string
  end
end
