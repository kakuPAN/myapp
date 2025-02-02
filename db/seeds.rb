# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
SecurityQuestion.create!([
  { question_text: "好きな言葉は？" },
  { question_text: "お気に入りの映画やドラマのタイトルは？" },
  { question_text: "子供の頃のあだ名は？" },
  { question_text: "一番印象に残っている旅行先は？" }
])

user_data = {
    email: Rails.application.credentials.dig(:admin, :email),
    password: Rails.application.credentials.dig(:admin, :password),
    password_confirmation: Rails.application.credentials.dig(:admin, :password),
    user_name: Rails.application.credentials.dig(:admin, :user_name),
    security_question_id: Rails.application.credentials.dig(:admin, :security_question),
    role: Rails.application.credentials.dig(:admin, :role)
}
user = User.new(user_data)
user.security_answer_digest = BCrypt::Password.create(Rails.application.credentials.dig(:admin, :answer))
user.save!



Board.create!(
  [
    { title: "趣味" },
    { title: "スポーツ" },
    { title: "音楽" },
    { title: "映画" },
    { title: "美術" },
    { title: "旅行" },
    { title: "料理" },
    { title: "ファッション" },
    { title: "ゲーム" },
    { title: "科学" },
    { title: "テクノロジー" },
    { title: "健康" },
    { title: "教育" },
    { title: "歴史" },
    { title: "文学" }
  ]
)

parents = Board.where(parent_id: nil).order(:id)

children = Board.create!(
  [
    { parent_id: parents[0].id, title: "Youtube" },
    { parent_id: parents[0].id, title: "アニメ" },
    { parent_id: parents[0].id, title: "映画レビュー" },
    { parent_id: parents[0].id, title: "写真撮影" },
    { parent_id: parents[0].id, title: "カラオケ" },

    { parent_id: parents[1].id, title: "サッカー" },
    { parent_id: parents[1].id, title: "バスケットボール" },
    { parent_id: parents[1].id, title: "野球" },
    { parent_id: parents[1].id, title: "テニス" },
    { parent_id: parents[1].id, title: "水泳" },

    { parent_id: parents[2].id, title: "ロック" },
    { parent_id: parents[2].id, title: "ジャズ" },
    { parent_id: parents[2].id, title: "クラシック" },
    { parent_id: parents[2].id, title: "K-POP" },
    { parent_id: parents[2].id, title: "J-POP" },

    { parent_id: parents[3].id, title: "アクション映画" },
    { parent_id: parents[3].id, title: "ホラー映画" },
    { parent_id: parents[3].id, title: "コメディ映画" },
    { parent_id: parents[3].id, title: "SF映画" },
    { parent_id: parents[3].id, title: "恋愛映画" },

    { parent_id: parents[4].id, title: "ピカソ" },
    { parent_id: parents[4].id, title: "印象派" },
    { parent_id: parents[4].id, title: "現代アート" },
    { parent_id: parents[4].id, title: "彫刻" },
    { parent_id: parents[4].id, title: "水彩画" },

    { parent_id: parents[5].id, title: "日本国内旅行" },
    { parent_id: parents[5].id, title: "海外旅行" },
    { parent_id: parents[5].id, title: "おすすめスポット" },
    { parent_id: parents[5].id, title: "バックパッキング" },
    { parent_id: parents[5].id, title: "キャンプ" },

    { parent_id: parents[6].id, title: "和食" },
    { parent_id: parents[6].id, title: "フレンチ" },
    { parent_id: parents[6].id, title: "イタリアン" },
    { parent_id: parents[6].id, title: "スイーツ" },
    { parent_id: parents[6].id, title: "ヴィーガン料理" },

    { parent_id: parents[7].id, title: "ストリートファッション" },
    { parent_id: parents[7].id, title: "フォーマル" },
    { parent_id: parents[7].id, title: "ブランド" },
    { parent_id: parents[7].id, title: "アクセサリー" },
    { parent_id: parents[7].id, title: "メンズファッション" },

    { parent_id: parents[8].id, title: "RPG" },
    { parent_id: parents[8].id, title: "FPS" },
    { parent_id: parents[8].id, title: "アクションゲーム" },
    { parent_id: parents[8].id, title: "ボードゲーム" },
    { parent_id: parents[8].id, title: "ソーシャルゲーム" },

    { parent_id: parents[9].id, title: "宇宙" },
    { parent_id: parents[9].id, title: "生物学" },
    { parent_id: parents[9].id, title: "物理学" },
    { parent_id: parents[9].id, title: "化学" },
    { parent_id: parents[9].id, title: "環境科学" },

    { parent_id: parents[10].id, title: "AI" },
    { parent_id: parents[10].id, title: "スマートフォン" },
    { parent_id: parents[10].id, title: "IoT" },
    { parent_id: parents[10].id, title: "VR/AR" },
    { parent_id: parents[10].id, title: "ロボティクス" },

    { parent_id: parents[11].id, title: "フィットネス" },
    { parent_id: parents[11].id, title: "ダイエット" },
    { parent_id: parents[11].id, title: "メンタルヘルス" },
    { parent_id: parents[11].id, title: "ヨガ" },
    { parent_id: parents[11].id, title: "スーパーフード" },

    { parent_id: parents[12].id, title: "学校教育" },
    { parent_id: parents[12].id, title: "オンライン学習" },
    { parent_id: parents[12].id, title: "外国語学習" },
    { parent_id: parents[12].id, title: "教育政策" },
    { parent_id: parents[12].id, title: "資格試験" },

    { parent_id: parents[13].id, title: "日本史" },
    { parent_id: parents[13].id, title: "世界史" },
    { parent_id: parents[13].id, title: "戦争史" },
    { parent_id: parents[13].id, title: "古代文明" },
    { parent_id: parents[13].id, title: "歴史小説" },

    { parent_id: parents[14].id, title: "小説" },
    { parent_id: parents[14].id, title: "詩" },
    { parent_id: parents[14].id, title: "エッセイ" },
    { parent_id: parents[14].id, title: "ミステリー" },
    { parent_id: parents[14].id, title: "ファンタジー" }
  ]
)

Board.create!(
  [
    { parent_id: children[0].id, title: "アルゴリズム" },
    { parent_id: children[5].id, title: "フォーメーション" },
    { parent_id: children[10].id, title: "ロックバンド" },
    { parent_id: children[15].id, title: "ジャッキー・チェン" },
    { parent_id: children[20].id, title: "ゲルニカ" },
    { parent_id: children[25].id, title: "絶景" },
    { parent_id: children[30].id, title: "だし" },
    { parent_id: children[35].id, title: "トレンド" },
    { parent_id: children[40].id, title: "ドラゴンクエスト" },
    { parent_id: children[45].id, title: "火星" },
    { parent_id: children[50].id, title: "画像生成" },
    { parent_id: children[55].id, title: "ダイエット食" },
    { parent_id: children[60].id, title: "英語学習" },
    { parent_id: children[65].id, title: "戦国時代" },
    { parent_id: children[70].id, title: "ミステリー" }
  ]
)