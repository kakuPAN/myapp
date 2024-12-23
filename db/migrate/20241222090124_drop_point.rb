class DropPoint < ActiveRecord::Migration[8.0]
  def change
    drop_table :points
  end
end
