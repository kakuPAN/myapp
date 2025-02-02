class AddColumnToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :parent_id, :integer
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
