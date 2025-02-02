class ChangeBoardsTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :boards, :user_id, :integer
    remove_column :boards, :access_level, :integer
    add_column :boards, :parent_id, :integer
    add_foreign_key :boards, :boards, column: :parent_id
    add_index :boards, [ :parent_id, :title ], unique: true
  end
end
