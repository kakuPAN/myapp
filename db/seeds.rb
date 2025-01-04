# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(
  [
    {
     email: "nanaka@email.com",
     password: "pass",
     password_confirmation: "pass",
     user_name: "志田"
    },
    {
      email: "ishigami@email.com",
      password: "pass",
      password_confirmation: "pass",
      user_name: "石上"
     },
     {
     email: "kasuga@email.com",
     password: "pass",
     password_confirmation: "pass",
     user_name: "春日"
    }
  ]
)

Board.create!(
  [
    {
      title: "桜の花びら見るたびに",
      user_id: 1,
      access_level: 1
    },
    {
      title: "生麦生米生卵",
      user_id: 2,
      access_level: 1
    },
    {
      title: "サザエさんじゃんけん勝った！！！！",
      user_id: 3,
      access_level: 1
    },
    {
      title: "ギザ十ゲット！",
      user_id: 2,
      access_level: 1
    },
    {
      title: "１０kmマラソン新記録！！！",
      user_id: 1,
      access_level: 1
    },
    {
      title: "財布落としたんだけど、後ろ歩いてた外国の方が拾って届けてくれた\n優しい",
      user_id: 1,
      access_level: 1
    },
    {
      title: "正月だ〜",
      user_id: 3,
      access_level: 1
    },
    {
      title: "もう疲れたな",
      user_id: 1,
      access_level: 1
    },
    {
      title: "ケルト音楽にハマってる",
      user_id: 2,
      access_level: 1
    },
    {
      title: "最近腹筋ついてきた...かも？",
      user_id: 1,
      access_level: 1
    },
    {
      title: "ハロワ行かねば",
      user_id: 3,
      access_level: 1
    },
    {
      title: "流石に半袖は寒いか笑",
      user_id: 1,
      access_level: 1
    }
  ]
)

require "active_storage/attached"

# 初期データとしての画像ファイルのパス
# 画像フォルダのパス
image_directory = Rails.root.join("app/assets/images")

# 画像ファイルのリストを取得
image_files = Dir.children(image_directory).select { |file| file.match?(/\.(jpg|jpeg|png)$/i) }

# 初期データを作成
boards = Board.all # Board が存在していることが前提
i = 0
boards.each do |board|
  if i % 2 == 0
    frame = Frame.create!(
      board_id: board.id,
      frame_number: 1,
      body: "サンプルフレーム for board #{board.title}"
    )
  else
    frame = Frame.create!(
      board_id: board.id,
      frame_number: 1,
      body: "あとで画像入れる予定"
    )
  end
#インスタンスを作成しないとattachできないが、bodyを入れないとvalidationで弾かれる。
  # image_file = image_files.sample
  # # 画像をアタッチする
  # frame.image.attach(
  #   io: File.open(image_directory.join(image_file)),
  #   filename: image_file,
  #   content_type: Mime::Type.lookup_by_extension(File.extname(image_file).delete("."))
  # )
  i += 1
end

puts "Frames and images have been seeded successfully!"


Comment.create!(
  [
    {
      body: "かわいい〜",
      user_id: 2,
      board_id: 1
    },
    {
      body: "癒される！",
      user_id: 3,
      board_id: 1
    },
    {
      body: "朝から元気出ますね！！",
      user_id: 3,
      board_id: 1
    },
    {
      body: "私も今朝挨拶もらいました笑",
      user_id: 2,
      board_id: 1
    },
    {
      body: "nice!",
      user_id: 2,
      board_id: 5
    },
    {
      body: "私も頑張らねば",
      user_id: 2,
      board_id: 5
    },
    {
      body: "優しい世界",
      user_id: 2,
      board_id: 6
    },
    {
      body: "優しい人でよかったですね〜",
      user_id: 1,
      board_id: 6
    },

  ]
)
