class CreateHeightHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :height_histories do |t|
      t.integer :reached_height, null: false
      t.integer :all_total_height, null: false

      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
