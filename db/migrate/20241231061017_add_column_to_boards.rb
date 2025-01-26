class AddColumnToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :access_level, :integer, null: false, default: 0
  end
end
