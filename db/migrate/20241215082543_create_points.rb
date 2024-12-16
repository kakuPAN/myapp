class CreatePoints < ActiveRecord::Migration[8.0]
  def change
    create_table :points do |t|
      t.datetime :calculation_time, null: false
      t.integer :delta, null: false
      t.integer :current_point, null: false
      t.timestamps
    end
  end
end
