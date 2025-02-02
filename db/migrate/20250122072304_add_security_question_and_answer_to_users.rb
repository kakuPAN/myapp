class AddSecurityQuestionAndAnswerToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :security_question, null: false, foreign_key: true
    add_column :users, :security_answer_digest, :string, null: false
  end
end
