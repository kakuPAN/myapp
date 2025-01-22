require 'rails_helper'

RSpec.describe UserBoard, type: :model do
  describe 'バリデーションチェック' do
    let(:board) { create(:board) }
    let(:user_board) { create(:user_board) }
    it '全ての値が正しい場合、有効である' do
      expect(user_board).to be_valid
      expect(user_board.errors).to be_empty
    end
    it "board_idがない場合、無効である" do
      user_board.board_id = nil
      expect(user_board).to be_invalid
      expect(user_board.errors[:board_id]).to eq ["を入力してください"]
    end
  end
end
