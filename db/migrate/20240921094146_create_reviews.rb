class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.references :card, null: false, foreign_key: true
      t.datetime :reviewed_at
      t.integer :grade
      t.integer :review_duration

      t.timestamps
    end
  end
end
