class DropTableAuthentications < ActiveRecord::Migration[8.0]
  def up
    drop_table :authentications
  end

  def down
  end
end

