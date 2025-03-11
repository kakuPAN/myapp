require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'バリデーションチェック' do
    let(:board) { create(:board) }
    let(:frame) { create(:frame) }
    context "テキストフレーム" do
      it '全ての値が正しい場合、有効である' do
        expect(frame).to be_valid
        expect(frame.errors).to be_empty
      end
    end
    context "画像フレーム" do
      it '全ての値が正しい場合、有効である' do
        image_frame = Frame.new
        image_frame.frame_type = 1
        image_frame.frame_number = Faker::Number.between(from: 1, to: 10)
        image_frame.board_id = board.id
        image_frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
        image_frame.save
  
        expect(image_frame).to be_valid
        expect(image_frame.errors).to be_empty
      end
      it "アップされた画像がwebp形式に変換されていること" do
        image_frame = Frame.new
        image_frame.frame_type = 1
        image_frame.frame_number = Faker::Number.between(from: 1, to: 10)
        image_frame.board_id = board.id
        image_frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
        image_frame.save

        webp_image = image_frame.image_webp
        expect(webp_image.filename.to_s).to end_with('.webp')
      end
    end
    it 'frame_numberがない場合、無効である' do
      frame.frame_number = nil
      expect(frame).to be_invalid
      expect(frame.errors[:frame_number]).to eq [ "を入力してください" ]
    end
    it 'frame_typeがない場合、無効である' do
      frame.frame_type = nil
      expect(frame).to be_invalid
      expect(frame.errors[:frame_type]).to eq [ "を入力してください" ]
    end
    it "board_idがない場合、無効である" do
      frame.board_id = nil
      expect(frame).to be_invalid
      expect(frame.errors[:board_id]).to eq [ "を入力してください" ]
    end
    it "contentが1000文字を超える場合、無効である" do
      frame.content = Faker::Lorem.paragraph_by_chars(number: 1001)
      expect(frame).to be_invalid
      expect(frame.errors[:content]).to eq [ "本文は1000文字以内で入力してください" ]
    end
    context "image_content_typeのバリデーション" do
      it "ファイル形式が、JPEG, JPG, PNG, WEBP以外の場合、無効である" do
        frame.content = nil
        frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/gif_test.gif')), filename: 'gif_test.gif', content_type: 'image/gif')
        frame.validate
        expect(frame.errors[:base]).to include("ファイル形式が、JPEG, JPG, PNG, WEBP以外になっています")
      end
    end

    context "image_sizeのバリデーション" do
      it "200KBを超えるファイルをアップロードしたとき、無効である" do
        frame.content = nil
        frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/over_size.png')), filename: 'over_size.png', content_type: 'image/png')
        frame.validate
        expect(frame.errors[:base]).to include("200KB以下のファイルをアップロードしてください")
      end
    end

    context 'content_or_image_presenceのバリデーション' do
      it 'frame_type == 0、かつ、bodyが設定されている場合、有効である' do
        frame.frame_type = 0
        frame.image = nil
        frame.content = 'テスト本文'
        expect(frame).to be_valid
      end

      it 'frame_type == 1、かつ、imageが設定されている場合、有効である' do
        frame.content = nil
        frame.frame_type = 1
        frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
        expect(frame).to be_valid
      end
    end
  end

  # describe "#image_webp" do
  #   let(:board) { create(:board) }
  #   let(:frame) { create(:frame) }
  #   before do
  #     frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')), filename: 'sample_image.png', content_type: 'image/png')
  #   end

  # end
end
