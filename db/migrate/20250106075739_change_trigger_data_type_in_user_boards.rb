class ChangeTriggerDataTypeInUserBoards < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_boards, :trigger
    add_column :user_boards, :trigger, :integer, default: 0, null: false
  end
end
