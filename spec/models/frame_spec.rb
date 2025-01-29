# require 'rails_helper'

# RSpec.describe Frame, type: :model do
#   describe 'バリデーションチェック' do
#     let!(:security_question) { create(:security_question) }
#     let(:board) { create(:board) }
#     let(:frame) { create(:frame) }
#     it '全ての値が正しい場合、有効である' do
#       expect(frame).to be_valid
#       expect(frame.errors).to be_empty
#     end
#     it 'frame_numberがない場合、無効である' do
#       frame.frame_number = nil
#       expect(frame).to be_invalid
#       expect(frame.errors[:frame_number]).to eq [ "を入力してください" ]
#     end
#     it 'frame_typeがない場合、無効である' do
#       frame.frame_type = nil
#       expect(frame).to be_invalid
#       expect(frame.errors[:frame_type]).to eq [ "を入力してください" ]
#     end
#     it "board_idがない場合、無効である" do
#       frame.board_id = nil
#       expect(frame).to be_invalid
#       expect(frame.errors[:board_id]).to eq [ "を入力してください" ]
#     end
#     it "bodyが500文字を超える場合、無効である" do
#       frame.body = Faker::Lorem.paragraph_by_chars(number: 501)
#       expect(frame).to be_invalid
#       expect(frame.errors[:body]).to eq [ "は500文字以内で入力してください" ]
#     end
#     context "image_content_typeのバリデーション" do
#       it "ファイル形式が、JPEG, JPG, PNG以外の場合、無効である" do
#         frame.body = nil
#         frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/webp_test.webp')), filename: 'webp_test.webp', content_type: 'image/webp')
#         frame.validate
#         expect(frame.errors[:base]).to include("ファイル形式が、JPEG, JPG, PNG以外になっています")
#       end
#     end

#     context "image_sizeのバリデーション" do
#       it "200KBを超えるファイルをアップロードしたとき、無効である" do
#         frame.body = nil
#         frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/over_size.png')), filename: 'over_size.png', content_type: 'image/png')
#         frame.validate
#         expect(frame.errors[:base]).to include("200KB以下のファイルをアップロードしてください")
#       end
#     end

#     context "frame_type_checkのバリデーション" do
#       it "画像が設定されていて、かつ、frame_type=0である場合、無効である" do
#         frame.body = nil
#         frame.frame_type = 0
#         frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
#         frame.validate
#         expect(frame.errors[:base]).to include("画像ファイルを設定してください")
#       end

#       it "画像が設定されておらず、かつ、frame_type=1である場合、無効である" do
#         frame.body = "テスト本文"
#         frame.frame_type = 1
#         frame.image = nil
#         frame.validate
#         expect(frame.errors[:base]).to include("本文を入力してください")
#       end
#     end

#     context 'body_or_image_presenceのバリデーション' do
#       it 'bodyもimageも設定されていない場合、無効である' do
#         frame.body = nil
#         frame.image = nil
#         frame.frame_type = nil
#         frame.validate
#         expect(frame.errors[:base]).to include("本文または画像のどちらかを入力してください")
#       end

#       it 'bodyが設定され、imageが設定されていない場合、有効である' do
#         frame.frame_type = 0
#         frame.image = nil
#         frame.body = 'テスト本文'
#         expect(frame).to be_valid
#       end

#       it 'imageが設定され、bodyが設定されていない場合、有効である' do
#         frame.body = nil
#         frame.frame_type = 1
#         frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
#         expect(frame).to be_valid
#       end

#       it 'bodyとimageの両方が設定されている場合、無効である' do
#         frame.body = 'テスト本文'
#         frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
#         frame.validate
#         expect(frame.errors[:base]).to include("本文と画像の両方を設定することはできません")
#       end
#     end
#   end
# end
