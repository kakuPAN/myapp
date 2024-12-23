class CreateLandmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :landmarks do |t|
      t.string :name, null: false
      t.string :landmark_image, null: false
      t.integer :setting_height, null: false
      t.integer :setting_height_level, null: false

      t.timestamps
    end
  end
end
