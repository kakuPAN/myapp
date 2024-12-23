class DropCityObjectsTable2 < ActiveRecord::Migration[8.0]
  def change
    drop_table :city_objects
  end
end
