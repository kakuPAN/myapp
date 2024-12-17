require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    it 'ユーザー登録の際、設定したすべてのバリデーションが機能しているか' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end
    it 'user_nameがない場合にバリデーションが機能してinvalidになるか' do
      user_without_user_name = build(:user, user_name: "")
      expect(user_without_user_name).to be_invalid
      expect(user_without_user_name.errors[ :user_name ]).to eq ["を入力してください"]
    end
    it 'emailがない場合にバリデーションが機能してinvalidになるか' do
      user_without_email = build(:user, email: "")
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[ :email ]).to eq ["を入力してください"]
    end
    it 'passwordがない場合にバリデーションが機能してinvalidになるか' do
      user_without_password = build(:user, password: "")
      expect(user_without_password).to be_invalid
      expect(user_without_password.errors[ :password ]).to eq ["は3文字以上で入力してください"]
    end
    it 'password_confirmationがない場合にバリデーションが機能してinvalidになるか' do
      user_without_password_confirmation = build(:user, password_confirmation: "")
      expect(user_without_password_confirmation).to be_invalid
      expect(user_without_password_confirmation.errors[ :password_confirmation ]).to eq ["とパスワードの入力が一致しません", "を入力してください"]
    end
    it 'emailが被った場合にuniqueのバリデーションが機能してinvalidになるか' do
      user = create(:user)
      user_with_duplicated_email= build(:user, email: user.email)
      expect(user_with_duplicated_email).to be_invalid
      expect(user_with_duplicated_email.errors[ :email ]).to eq ["はすでに存在します"]
    end
    it 'titleが被らない場合にバリデーションエラーが起きないか' do
      user = create(:user)
      user_with_another_email= build(:user, email: "another@email.com")
      expect(user_with_another_email).to be_valid
      expect(user_with_another_email.errors).to be_empty
    end
  end
end
