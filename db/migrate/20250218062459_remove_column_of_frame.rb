class RemoveColumnOfFrame < ActiveRecord::Migration[8.0]
  def change
    remove_column :frames, :body, :string
  end
end
