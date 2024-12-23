class DropLocation < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :object_locations, :locations
  end
end
