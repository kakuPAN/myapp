require "rails_helper"

RSpec.describe Report, type: :model do
  describe "バリデーションチェック" do
    let!(:user) { create(:user, :with_google) }
    let(:board) { create(:board) }
    let(:comment) { create(:comment) }
    let(:report) { create(:report, user_id: user.id) }

    it "全ての値が正しい場合、有効である" do
      expect(report).to be_valid
      expect(report.errors).to be_empty
    end
    it "user_idがない場合、無効である" do
      report.user_id = nil
      expect(report).to be_invalid
      expect(report.errors[:user_id]).to eq [ "を入力してください" ]
    end
    it "board_idがない場合、無効である" do
      report.board_id = nil
      expect(report).to be_invalid
      expect(report.errors[:board_id]).to eq [ "を入力してください" ]
    end
    it "bodyがない場合、無効である" do
      report.body = ""
      expect(report).to be_invalid
      expect(report.errors[:body]).to eq [ "を入力してください" ]
    end
    it "bodyが500文字を超える場合、無効である" do
      report.body = Faker::Lorem.paragraph_by_chars(number: 501)
      expect(report).to be_invalid
      expect(report.errors[:body]).to eq [ "は500文字以内で入力してください" ]
    end
  end
end
