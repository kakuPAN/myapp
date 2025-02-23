require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    let!(:another_user) { create(:user, :with_google) }
    let(:user) { create(:user, :with_google) }
    describe "ユーザーの作成が成功する" do
      it '入力値が正常な場合、有効である' do
        user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
        expect(user).to be_valid
        expect(user.errors).to be_empty
      end
      it "アップされた画像がwebp形式に変換されていること" do
        user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
        webp_avatar_image = user.avatar_image_webp
        expect(webp_avatar_image.filename.to_s).to end_with('.webp')
      end
    end
    describe "ユーザーの作成が失敗する" do
      it 'user_nameがない場合、無効である' do
        user.user_name = ""
        expect(user).to be_invalid
        expect(user.errors[:user_name]).to eq [ "を入力してください" ]
      end
      it 'emailがない場合、無効である' do
        user.email = ""
        expect(user).to be_invalid
        expect(user.errors[:email]).to eq [ "を入力してください" ]
      end
      it 'emailがすでに存在する場合、無効である' do
        user.email = another_user.email
        expect(user).to be_invalid
        expect(user.errors[:email]).to eq [ "はすでに存在します" ]
      end
      it "profileが250字以上の場合、無効である" do
        user.profile = Faker::Lorem.paragraph_by_chars(number: 251)
        expect(user).to be_invalid
        expect(user.errors[:profile]).to include("は250文字以内で入力してください")
      end
      context "image_content_typeのバリデーション" do
        it "ファイル形式が、JPEG, JPG, PNG, WEBP以外の場合、無効である" do
          user = build(:user)
          user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/gif_test.gif')), filename: 'gif_test.gif', content_type: 'avatar_image/gif')
          expect(user).to be_invalid
          expect(user.errors[:base]).to include("ファイル形式が、JPEG, JPG, PNG, WEBP以外になっています")
        end
      end

      context "image_sizeのバリデーション" do
        it "200KB以上のファイルをアップロードしたとき、無効である" do
          user = build(:user)
          user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/over_size.png')), filename: 'over_size.png', content_type: 'avatar_image/png')
          expect(user).to be_invalid
          expect(user.errors[:base]).to include("200KB以下のファイルをアップロードしてください")
        end
      end
    end
  end
end
