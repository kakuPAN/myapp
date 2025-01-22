require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'バリデーションチェック' do
    let(:user) { create(:user) }
    let(:board) { create(:board) }
    let(:comment) { create(:comment) }
    it '全ての値が正しい場合、有効である' do
      expect(comment).to be_valid
      expect(comment.errors).to be_empty
    end
    it 'bodyが100文字以上の場合、無効であること' do
      comment.body = Faker::Lorem.paragraph_by_chars(number: 101)
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to eq [ "は100文字以内で入力してください" ]
    end
    it 'bodyがない場合、無効であること' do
      comment.body = nil
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to eq [ "を入力してください" ]
    end
    it "user_idがない場合、無効であること" do
      comment.user_id = nil
      expect(comment).to be_invalid
      expect(comment.errors[:user_id]).to eq [ "を入力してください" ]
    end
    it "board_idがない場合、無効であること" do
      comment.board_id = nil
      expect(comment).to be_invalid
      expect(comment.errors[:board_id]).to eq [ "を入力してください" ]
    end
  end
end
