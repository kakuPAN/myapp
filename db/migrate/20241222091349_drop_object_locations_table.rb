class DropObjectLocationsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :object_locations
  end
end
