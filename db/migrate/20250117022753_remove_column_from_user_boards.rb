class RemoveColumnFromUserBoards < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_boards, :trigger
  end
end
