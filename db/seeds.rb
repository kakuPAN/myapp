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

Task.create!(
  [
    {
      user_id: 1,
      title: "河川敷10分",
      body: "河川敷ランニング10分",
      deadline: Time.current.change(sec: 0),
      access_level: 1
    },
    {
      user_id: 2,
      title: "家の掃除",
      body: "洗濯・皿洗い",
      deadline: Time.current.change(sec: 0),
      access_level: 1
    },
    {
      user_id: 3,
      title: "ハローワークに行く",
      body: "必要書類を提出する",
      deadline: Time.current.change(sec: 0),
      access_level: 0
    }
  ]
)

Point.create!(
  [
    {
      calculation_time: Time.current,
      delta: 0,
      current_point: 0
    }
  ]
)

Location.create!(
  [
    {
      object_type: 0,
      position: 1
    },
    {
      object_type: 0,
      position: 2
    },
    {
      object_type: 0,
      position: 3
    },
    {
      object_type: 0,
      position: 4
    },
    {
      object_type: 0,
      position: 5
    },
    {
      object_type: 0,
      position: 6
    },
    {
      object_type: 0,
      position: 7
    },
    {
      object_type: 0,
      position: 8
    }
  ]
)

CityObject.create!(
  [
    {
      object_type: 0,
      object_image: "city_objects/isome_building_1.png"
    },
    {
      object_type: 0,
      object_image: "city_objects/building_1.jpeg"
    },
    {
      object_type: 1,
      object_image: "city_objects/people_1.png"
    },
    {
      object_type: 1,
      object_image: "city_objects/people_2.png"
    },
    {
      object_type: 1,
      object_image: "city_objects/people_3.png"
    },
    {
      object_type: 1,
      object_image: "city_objects/people_4.png"
    }
  ]
)
