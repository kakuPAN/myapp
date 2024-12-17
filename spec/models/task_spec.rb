require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーションチェック' do
    it 'タスク作成の際、設定したすべてのバリデーションが機能しているか' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
    it 'titleがない場合にバリデーションが機能してinvalidになるか' do
      task_without_title = build(:task, title: "")
      expect(task_without_title).to be_invalid
      expect(task_without_title.errors[:title]).to eq ["を入力してください"]
    end
    it 'bodyがない場合にバリデーションが機能してinvalidになるか' do
      task_without_body = build(:task, body: "")
      expect(task_without_body).to be_invalid
      expect(task_without_body.errors[:body]).to eq ["を入力してください"]
    end
    it 'deadlineがない場合にバリデーションエラーが起きないか' do
      task_without_deadline = build(:task, deadline: "")
      expect(task_without_deadline).to be_valid
      expect(task_without_deadline .errors[:deadline ]).to be_empty
    end
    it 'access_levelがない場合にバリデーションが機能してinvalidになるか' do
      task_without_access_level = build(:task, access_level: "")
      expect(task_without_access_level).to be_invalid
      expect(task_without_access_level.errors[:access_level]).to eq ["を入力してください"]
    end
  end
end
