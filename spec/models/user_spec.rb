# require 'rails_helper'

# RSpec.describe User, type: :model do
#   describe 'バリデーションチェック' do
#     let(:security_question) { create(:security_question) }
#     let!(:another_user) { create(:user, email: "another@email.com") }
#     let(:user) { create(:user) }
#     describe "ユーザーの作成が成功する" do
#       it '入力値が正常な場合、有効である' do
#         user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
#         expect(user).to be_valid
#         expect(user.errors).to be_empty
#       end
#     end
#     describe "ユーザーの作成が失敗する" do
#       it 'user_nameがない場合、無効である' do
#         user.user_name = ""
#         expect(user).to be_invalid
#         expect(user.errors[:user_name]).to eq [ "を入力してください" ]
#       end
#       it 'emailがない場合、無効である' do
#         user.email = ""
#         expect(user).to be_invalid
#         expect(user.errors[:email]).to eq [ "を入力してください" ]
#       end
#       it 'passwordがない場合、無効である' do
#         no_pass_user = build(:user, password: "")
#         expect(no_pass_user).to be_invalid
#         expect(no_pass_user.errors[:password]).to eq [ "は3文字以上で入力してください" ]
#       end
#       it 'passwordが50文字以上の場合、無効である' do
#         user.password = Faker::Lorem.paragraph_by_chars(number: 51)
#         expect(user).to be_invalid
#         expect(user.errors[:password]).to eq [ "は50文字以内で入力してください" ]
#       end
#       it 'password_confirmationがない場合、無効である' do
#         no_pass_confirm_user = build(:user, password_confirmation: "")
#         expect(no_pass_confirm_user).to be_invalid
#         expect(no_pass_confirm_user.errors[:password_confirmation]).to eq [ "とパスワードの入力が一致しません", "を入力してください" ]
#       end
#       it 'emailがすでに存在する場合、無効である' do
#         user.email = "another@email.com"
#         expect(user).to be_invalid
#         expect(user.errors[:email]).to eq [ "はすでに存在します" ]
#       end
#       it "profileが250字以上の場合、無効である" do
#         user.profile = Faker::Lorem.paragraph_by_chars(number: 251)
#         expect(user).to be_invalid
#         expect(user.errors[:profile]).to include("は250文字以内で入力してください")
#       end
#       it "security_question_idがない場合、無効である" do
#         user.security_question_id = nil
#         expect(user).to be_invalid
#         expect(user.errors[:security_question_id]).to eq [ "を入力してください" ]
#       end
#       it "security_answer_digestがない場合、無効である" do
#         user.security_answer_digest = ""
#         expect(user).to be_invalid
#         expect(user.errors[:security_answer_digest]).to eq [ "を入力してください" ]
#       end
#       context "image_content_typeのバリデーション" do
#         it "ファイル形式が、JPEG, JPG, PNG以外の場合、無効である" do
#           user = build(:user)
#           user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/webp_test.webp')), filename: 'webp_test.webp', content_type: 'avatar_image/webp')
#           expect(user).to be_invalid
#           expect(user.errors[:base]).to include("ファイル形式が、JPEG, JPG, PNG以外になっています")
#         end
#       end

#       context "image_sizeのバリデーション" do
#         it "200KB以上のファイルをアップロードしたとき、無効である" do
#           user = build(:user)
#           user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/over_size.png')), filename: 'over_size.png', content_type: 'avatar_image/png')
#           expect(user).to be_invalid
#           expect(user.errors[:base]).to include("200KB以下のファイルをアップロードしてください")
#         end
#       end
#     end
#   end
# end
