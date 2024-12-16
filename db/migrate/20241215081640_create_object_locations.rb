class CreateObjectLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :object_locations do |t|
      t.references :city_object, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
