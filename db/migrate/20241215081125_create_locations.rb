class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.integer :object_type, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
