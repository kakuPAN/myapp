class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :title, null: false
      t.integer :total_height, null: false
      t.timestamps
    end
  end
end
