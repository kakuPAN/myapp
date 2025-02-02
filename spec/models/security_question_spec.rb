require "rails_helper"

RSpec.describe SecurityQuestion, type: :model do
  describe "バリデーションチェック" do
    let(:security_question) { create(:security_question) }

    it "全ての値が正しい場合、有効である" do
      expect(security_question).to be_valid
      expect(security_question.errors).to be_empty
    end
    it "question_textがない場合、無効である" do
      security_question.question_text = ""
      expect(security_question).to be_invalid
      expect(security_question.errors[:question_text]).to eq [ "を入力してください" ]
    end
    it "question_textが100文字を超える場合、無効である" do
      security_question.question_text = Faker::Lorem.paragraph_by_chars(number: 101)
      expect(security_question).to be_invalid
      expect(security_question.errors[:question_text]).to eq [ "は100文字以内で入力してください" ]
    end
  end
end
