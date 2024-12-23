class AddNotNullConstraintToGoalsTitle < ActiveRecord::Migration[8.0]
  def change
    change_column_null :goals, :title, false
  end
end
