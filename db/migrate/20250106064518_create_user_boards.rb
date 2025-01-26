class CreateUserBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :user_boards do |t|
      t.boolean :trigger, null: false, default: false
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
