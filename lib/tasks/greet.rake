namespace :greet do
  desc "Helloを表示するタスク"
  task say_hello: :environment do
    Task.create!(
      user_id: 1,
      goal_id: 1,
      title: "自動生成されたタスク",
      body: "このタスクは Rake タスクから作成されました",
      deadline: 1.week.from_now,
      access_level: 1,
      progress_status: 0
    )
  end
end
