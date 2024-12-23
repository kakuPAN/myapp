class AddNotNullConstraintToTasksGoalId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tasks, :goal_id, false
  end
end
