class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.datetime :deadline
      t.integer :access_level, null: false, default: 0
      t.integer :progress_status, null: false, default: 0

      t.timestamps
    end
  end
end
