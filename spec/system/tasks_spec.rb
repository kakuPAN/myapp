require "rails_helper"

RSpec.describe "Tasks", type: :system do
  let(:user) { create(:user) }
  let(:public_task) { create(:task) }
  let(:private_task) { create(:task, access_level: 0) }

  describe "ログイン前" do
    describe "ページ遷移確認" do
      context "タスクの作成ページにアクセス" do
        it "作成ページへのアクセスが失敗する" do
          visit new_task_path
          expect(page).to have_content("ログインしてください")
          expect(current_path).to eq login_path
        end
      end

      context "タスクの編集ページにアクセス" do
        it "編集ページへのアクセスが失敗する" do
          visit edit_task_path(public_task)
          expect(page).to have_content("ログインしてください")
          expect(current_path).to eq login_path
        end
      end

      context "タスクの詳細ページにアクセス" do
        it "公開のタスクにアクセスし、詳細情報が表示される" do
          visit task_path(public_task)
          expect(page).to have_content public_task.title
          expect(current_path).to eq task_path(public_task)
        end

        it "非公開のタスクにアクセスし、詳細ページへのアクセスが失敗する" do
          visit task_path(private_task)
          expect(page).to have_content("タスクが存在しません")
          expect(current_path).to eq tasks_path
        end
      end

      context "タスクの一覧ページにアクセス" do
        it "すべてのユーザーのタスクのうち、access_levelが公開に設定されているものの情報が表示される" do
          task_list = create_list(:task, 2)
          private_task = create(:task, access_level: 0)

          visit tasks_path
          expect(page).to have_content task_list[0].title
          expect(page).to have_content task_list[1].title
          expect(page).not_to have_content private_task.title

          expect(current_path).to eq tasks_path
        end
      end
    end
  end

  describe "ログイン後" do
    before { login(user) }

    describe "タスク作成" do
      context "フォームの入力値が正常な場合" do
        it "タスクの作成が成功する" do
          click_link "タスクの作成"

          fill_in "task_title", with: "test_title"
          fill_in "task_body", with: "test_content"
          fill_in "task_deadline", with: DateTime.new(2024, 12, 24, 12, 00)
          choose "task_access_level_public_access"
          click_button "作成"

          expect(page).to have_content "test_title"
          expect(page).to have_content "test_content"
          expect(page).to have_selector("#access-level", text: "公開", exact_text: true)
          expect(page).to have_content "2024/12/24 12:00"
          expect(page).to have_content "未着手"
          last_task_id = Task.last.id
          # ここでtask_count = Task.all.countとすると、task_count = 1となるが、
          # 一方で、Task.id = 6となる。
          # おそらく、ログイン前後ではデータベースのリセットではなくレコードの削除だけが実行されているのではないか
          expect(current_path).to eq "/tasks/#{last_task_id}"
        end
      end

      context "タイトルが未入力の場合" do
        it "タスクの作成が失敗する" do
          click_link "タスクの作成"

          fill_in "task_title", with: ""
          fill_in "task_body", with: "test_content"
          fill_in "task_deadline", with: DateTime.new(2024, 12, 24, 12, 00)
          choose "task_access_level_public_access"
          click_button "作成"

          expect(page).to have_content "入力に不足があります"
          expect(page).to have_content "タイトルを入力してください"

          expect(current_path).to eq new_task_path
        end
      end

      context "内容が未入力の場合" do
        it "タスクの作成が失敗する" do
          click_link "タスクの作成"

          fill_in "task_title", with: "test_title"
          fill_in "task_body", with: ""
          fill_in "task_deadline", with: DateTime.new(2024, 12, 24, 12, 00)
          choose "task_access_level_public_access"
          click_button "作成"

          expect(page).to have_content "入力に不足があります"
          expect(page).to have_content "内容を入力してください"

          expect(current_path).to eq new_task_path
        end
      end

      context "期限が未入力の場合" do
        it "タスクの作成が成功し、期限に「未設定」が設定される" do
          click_link "タスクの作成"

          fill_in "task_title", with: "test_title"
          fill_in "task_body", with: "test_content"
          choose "task_access_level_public_access"
          click_button "作成"

          expect(page).to have_content "test_title"
          expect(page).to have_content "test_content"
          expect(page).to have_selector("#access-level", text: "公開", exact_text: true) # 「公開」「非公開」の完全一致のため
          expect(page).to have_content "未設定"
          expect(page).to have_content "未着手"
          last_task = Task.last

          expect(current_path).to eq task_path(last_task)
        end
      end
    end

    describe "タスク編集" do
      let!(:task) { create(:task, user: user, title: "元のタイトル", body: "元の内容") }
      before { visit edit_task_path(task) }

      context "フォームの入力値が正常な場合" do
        it "タスクの編集が成功する" do
          visit edit_task_path(task)

          fill_in "task_title", with: "updated_title"
          fill_in "task_body", with: "updated_content"
          fill_in "task_deadline", with: DateTime.new(2025, 1, 1, 12, 00)
          choose "task_access_level_private_access"
          click_button "変更を保存"

          expect(page).to have_content "updated_title"
          expect(page).to have_content "updated_content"
          expect(page).to have_content "非公開"
          expect(page).to have_content "2025/01/01 12:00"
          expect(page).to have_content "未着手"
          expect(page).to have_content "タスクの変更を保存しました"

          expect(current_path).to eq task_path(task)
        end
      end

      context "タイトルが未入力の場合" do
        it "タスクの編集が失敗する" do
          visit edit_task_path(task)

          fill_in "task_title", with: nil
          click_button "変更を保存"

          expect(page).to have_content "タスクの変更を保存できません"
          expect(page).to have_content "タイトルを入力してください"

          expect(current_path).to eq edit_task_path(task)
        end
      end

      context "内容が未入力の場合" do
        it "タスクの編集が失敗する" do
          fill_in "task_body", with: nil
          click_button "変更を保存"

          expect(page).to have_content "タスクの変更を保存できません"
          expect(page).to have_content "内容を入力してください"

          expect(current_path).to eq edit_task_path(task)
        end
      end

      context "他ユーザーのタスク編集ページにアクセスした場合" do
        let!(:other_user) { create(:user, email: "other_user@example.com") }
        let!(:other_task) { create(:task, user: other_user) }

        it "編集ページへのアクセスが失敗する" do
          visit edit_task_path(other_task)
          expect(page).to have_content "タスクが存在しません"
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe "タスク削除" do
      let!(:task) { create(:task, user: user) }
      it "タスクの削除が成功する" do
        visit task_path(task)
        click_link "削除"

        expect(page).to have_content "タスクを削除しました"
        expect(current_path).to eq tasks_path
        expect(page).not_to have_content task.title
      end
    end
  end
end
