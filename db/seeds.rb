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
      title: "趣味"
    },{
      parent_id: 1,
      title: "漫画"
    },{
      parent_id: 2,
      title: "ONE PIECE"
    },{
      parent_id: 2,
      title: "BLEACH"
    },{
      parent_id: 2,
      title: "HUNTER×HUNTER"
    },{
      parent_id: 2,
      title: "NARUTO"
    },{
      parent_id: 2,
      title: "DRAGON BALL"
    },{
      parent_id: 2,
      title: "SAKAMOTO DAYs"
    },{
      parent_id: 2,
      title: "幽遊白書"
    },{
      parent_id: 2,
      title: "呪術廻戦"
    },{
      parent_id: 2,
      title: "Dr.STONE"
    },{
      parent_id: 2,
      title: "７つの大罪"
    },{
      parent_id: 2,
      title: "金色のガッシュ！！" # 13
    },{
      parent_id: 1,
      title: "映画"
    },{ parent_id: 14, title: "アクション映画" },
    { parent_id: 14, title: "コメディ映画" },
    { parent_id: 14, title: "ホラー映画" },
    { parent_id: 14, title: "SF映画" },
    { parent_id: 14, title: "アニメ映画" },
    { parent_id: 14, title: "恋愛映画" },
    { parent_id: 14, title: "サスペンス映画" },
    { parent_id: 14, title: "歴史映画" },
    { parent_id: 14, title: "ドキュメンタリー映画" },
    { parent_id: 14, title: "ファンタジー映画" },{ # 24
      title: "生活"
    },{
      parent_id: 1,
      title: "Youtube"
    },{
      parent_id: 1,
      title: "アニメ"
    },{
      parent_id: 1,
      title: "スポーツ"
    },{
      parent_id: 1,
      title: "テレビ"
    },{
      parent_id: 1,
      title: "ゲーム" # 30
    },{ parent_id: 30, title: "アクションゲーム" },
    { parent_id: 30, title: "ロールプレイングゲーム（RPG）" },
    { parent_id: 30, title: "シューティングゲーム" },
    { parent_id: 30, title: "パズルゲーム" },
    { parent_id: 30, title: "スポーツゲーム" },
    { parent_id: 30, title: "ボードゲーム" },
    { parent_id: 30, title: "シミュレーションゲーム" },
    { parent_id: 30, title: "格闘ゲーム" },
    { parent_id: 30, title: "レースゲーム" },
    { parent_id: 30, title: "ソーシャルゲーム" },{ # 40
      title: "仕事"
    },{
      title: "感情"
    },{
      title: "人"
    },{
      title: "動物"
    },{
      title: "食べ物"
    },{
      title: "飲み物"
    },{
      title: "地域"
    },{
      title: "自然"
    },{
      title: "歴史"
    },{
      title: "科学"
    },{
      title: "夢"
    },{
      title: "季節"
    },{
      title: "スポーツ"
    },{
      title: "健康"
    },{
      title: "技術"
    },{
      title: "遊び"
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
      body: "サンプルフレーム for board #{board.title}",
      frame_type: 0
    )
  else
    frame = Frame.create!(
      board_id: board.id,
      frame_number: 1,
      body: "あとで画像入れる予定",
      frame_type: 0
    )
  end
#インスタンスを作成しないとattachできないが、bodyを入れないとvalidationで弾かれる。 => 一度buildした後でattachしてsaveすることでできる？
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
