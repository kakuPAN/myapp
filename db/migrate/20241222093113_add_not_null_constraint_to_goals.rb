class AddNotNullConstraintToGoals < ActiveRecord::Migration[8.0]
  def change
    change_column_null :goals, :user_id, false
    change_column_null :goals, :category_id, false
  end
end
