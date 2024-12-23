class ChangeColumnInTasks < ActiveRecord::Migration[8.0]
  def change
    # 既存の user_id と goal_id を削除
    remove_column :tasks, :user_id, :integer
    remove_column :tasks, :goal_id, :integer

    # 外部キー付きの新しいカラムを追加
    add_reference :tasks, :user, null: false, foreign_key: true
    add_reference :tasks, :goal, null: false, foreign_key: true
  end
end
