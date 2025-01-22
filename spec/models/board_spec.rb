require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'バリデーションチェック' do
    let(:board) { create(:board) }
    it '入力が正常の場合、有効である' do
      expect(board).to be_valid
      expect(board.errors).to be_empty
    end
    it 'titleがない場合、無効である' do
      board.title = nil
      expect(board).to be_invalid
      expect(board.errors[:title]).to eq [ "を入力してください" ]
    end
    it "titleが100文字以上の場合、無効である" do
      board.title = Faker::Lorem.paragraph_by_chars(number: 101)
      expect(board).to be_invalid
      expect(board.errors[:title]).to eq [ "は100文字以内で入力してください" ]
    end
  end
end

