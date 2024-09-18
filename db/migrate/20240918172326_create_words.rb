class CreateWords < ActiveRecord::Migration[7.2]
  def change
    create_table :words do |t|
      t.string :hiragana
      t.string :romanji
      t.string :kanji
      t.string :english_meaning

      t.timestamps
    end
  end
end
