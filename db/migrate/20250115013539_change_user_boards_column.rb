class ChangeUserBoardsColumn < ActiveRecord::Migration[8.0]
  def change
    change_column_null :user_boards, :user_id, true
  end
end
