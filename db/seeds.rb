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
     user_name: "佐藤"
    },
    {
      email: "ishigami@email.com",
      password: "pass",
      password_confirmation: "pass",
      user_name: "中川"
     },
     {
     email: "kasuga@email.com",
     password: "pass",
     password_confirmation: "pass",
     user_name: "春日"
    }
  ]
)

Goal.create!(
  [
    {
      title: "プログラミング",
      user_id: 1
    },
    {
      title: "100m 10秒",
      user_id: 1
    },
    {
      title: "総資産 500万",
      user_id: 1
    }
  ]
)

Task.create!(
  [
    {
      user_id: 1,
      goal_id: 1,
      title: "カリキュラム10　進める",
      body: "まずは１〜３を終わらせる",
      deadline: Time.current.change(sec: 0),
      access_level: 1
    },
    {
      user_id: 1,
      goal_id: 2,
      title: "河川敷",
      body: "河川敷ランニング30分3セット", 
      deadline: Time.current.change(sec: 0),
      access_level: 1
    },
    {
      user_id: 1,
      goal_id: 3,
      title: "NiSA　見直し",
      body: "投資先を検討する",
      deadline: Time.current.change(sec: 0),
      access_level: 1
    }
  ]
)

Landmark.create!(
  [
    {
      name: "ボーリングレーンの幅",
      landmark_image: "landmarks/bowling.jpg",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "45型テレビの画面の横幅",
      landmark_image: "landmarks/45inchTV.png",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "1万円札を1億円分積んだ時の高さ",
      landmark_image: "landmarks/100MillionYen.png",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "ボーリングレーンの幅",
      landmark_image: "landmarks/bowling.jpg",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "45型テレビの画面の横幅",
      landmark_image: "landmarks/45inchTV.png",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "1万円札を1億円分積んだ時の高さ",
      landmark_image: "landmarks/100MillionYen.png",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "ボーリングレーンの幅",
      landmark_image: "landmarks/bowling.jpg",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "45型テレビの画面の横幅",
      landmark_image: "landmarks/45inchTV.png",
      setting_height: 1,
      setting_height_level: 1
    },
    {
      name: "1万円札を1億円分積んだ時の高さ",
      landmark_image: "landmarks/100MillionYen.png",
      setting_height: 1,
      setting_height_level: 1
    }
  ]
)
