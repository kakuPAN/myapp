class ChangeColumnInGoals < ActiveRecord::Migration[8.0]
  def change
    # 既存の user_id と goal_id を削除
    remove_column :goals, :user_id, :integer
    remove_column :goals, :category_id, :integer

    # 外部キー付きの新しいカラムを追加
    add_reference :goals, :user, null: false, foreign_key: true
    add_reference :goals, :category, null: false, foreign_key: true
  end
end
