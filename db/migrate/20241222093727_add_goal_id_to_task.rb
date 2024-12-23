class AddGoalIdToTask < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :goal_id, :integer
  end
end
