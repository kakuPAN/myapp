class AddColumnToFrames < ActiveRecord::Migration[8.0]
  def change
    add_column :frames, :frame_type, :integer, null: false
  end
end
