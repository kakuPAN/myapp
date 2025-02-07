class RemoveSorceryColumnsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :crypted_password, :string
    remove_column :users, :salt, :string
  end
end
