class UpdateBoardsTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :boards, :body, :string
    remove_column :boards, :image_url, :string

    add_column :boards, :title, :string, null: false
  end
end
