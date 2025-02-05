class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :board, foreign_key: true
      t.references :comment, foreign_key: true
      t.string :body, null: false
      t.timestamps
    end
  end
end
