require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'バリデーションチェック' do
    let(:board) { create(:board) }
    let(:user) { create(:user)}
    let(:like) { create(:like) }
    it '全ての値が正しい場合、有効である' do
      expect(like).to be_valid
      expect(like.errors).to be_empty
    end
    it "user_idがない場合、無効である" do
      like.user_id = nil
      expect(like).to be_invalid
      expect(like.errors[:user_id]).to eq ["を入力してください"]
    end 
    it "board_idがない場合、無効である" do
      like.board_id = nil
      expect(like).to be_invalid
      expect(like.errors[:board_id]).to eq ["を入力してください"]
    end
  end
end
