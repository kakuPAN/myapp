class CreateCityObjects < ActiveRecord::Migration[8.0]
  def change
    create_table :city_objects do |t|
      t.integer :object_type, null: false
      t.string :object_image, null: false
      t.timestamps
    end
  end
end
