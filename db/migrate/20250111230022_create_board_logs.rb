class CreateBoardLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :board_logs do |t|
      t.string :model
      t.references :user, null: false, foreign_key: true
      t.references :board, null: false, foreign_key: true
      t.references :frame, foreign_key: true
      t.integer :action_type, null: false

      t.timestamps
    end
  end
end
