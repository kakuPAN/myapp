class ChangeUsersTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :reset_token
    remove_column :users, :reset_sent_at
    remove_column :users, :security_question_id
    remove_column :users, :security_answer_digest
  end
end
