require 'rails_helper'

RSpec.describe BoardLog, type: :model do
  describe 'バリデーションチェック' do
    let(:board) { create(:board) }
    let(:user) { create(:user, :with_google) }
    let(:board_log) { create(:board_log) }
    it '全ての値が正しい場合、有効である' do
      expect(board_log).to be_valid
      expect(board_log.errors).to be_empty
    end
    it "action_typeがない場合、無効である" do
      board_log.action_type = nil
      expect(board_log).to be_invalid
      expect(board_log.errors[:action_type]).to eq [ "を入力してください" ]
    end

    it "user_idがない場合、無効である" do
      board_log.user_id = nil
      expect(board_log).to be_invalid
      expect(board_log.errors[:user_id]).to eq [ "を入力してください" ]
    end

    it "board_idがない場合、無効である" do
      board_log.board_id = nil
      expect(board_log).to be_invalid
      expect(board_log.errors[:board_id]).to eq [ "を入力してください" ]
    end
  end
end
