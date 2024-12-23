class CreateHeights < ActiveRecord::Migration[8.0]
  def change
    create_table :heights do |t|
      t.integer :current_height, null: false
      t.integer :current_height_level, null: false
      t.integer :max_height, null: false
      t.integer :max_height_level, null: false
      t.references :user, null: false, foreign_key: true
      t.references :goal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
