class CreateFrames < ActiveRecord::Migration[8.0]
  def change
    create_table :frames do |t|
      t.string :body, null: true
      t.integer :frame_number, null: false
      t.references :board, null: false, foreign_key: true 
      t.timestamps

      t.index [:board_id, :frame_number], unique: true
    end
  end
end
