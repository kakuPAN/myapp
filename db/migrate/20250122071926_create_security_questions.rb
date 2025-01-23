class CreateSecurityQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :security_questions do |t|
      t.string :question_text, null: false
      t.timestamps
    end
  end
end
