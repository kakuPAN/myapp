class DropCityObjectsTable < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :object_locations, :city_objects
  end
end
