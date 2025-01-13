class RemoveColumnFromBoardLog < ActiveRecord::Migration[8.0]
  def change
    remove_column :board_logs, :model
  end
end
