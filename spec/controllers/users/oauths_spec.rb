# require 'rails_helper'

# RSpec.describe Users::OmniauthCallbacksController, type: :controller do
#   before do
#     OmniAuth.config.mock_auth[:google_oauth2] = nil
#     OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
#       provider: "google_oauth2",
#       uid: "123456",
#       info: {
#         name: "Test User",
#         email: "test@example.com"
#       }
#     )
#     @request.env["devise.mapping"] = Devise.mappings[:user]
#     @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
#   end
#   describe "Google OAuth2ログイン" do
#     context "ユーザーの保存が失敗した場合" do
#       before do
#         allow(User).to receive(:from_omniauth).and_return(nil)
#       end
#       it "ルートページにリダイレクトする" do
#         get :google_oauth2
#         expect(response).to redirect_to(root_path)
#       end
#     end
#     context "既存ユーザーの場合" do
#       let!(:existing_user) { create(:user, provider: "google_oauth2", uid: "123456", email: "test@example.com") }
#       it "ログインするが、新たに作成はしない" do
#         expect {
#           get :google_oauth2
#         }.not_to change(User, :count)

#         expect(session["warden.user.user.key"]).not_to be_nil # Deviseのログイン状態チェック
#         expect(response).to redirect_to(visited_boards_user_path(existing_user))
#       end
#     end

#     context "管理者ユーザーの場合" do
#       before do
#         OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
#           provider: "google_oauth2",
#           uid: "123456",
#           info: {
#             name: "Test User",
#             email: Rails.application.credentials.admin[:email]
#           }
#         )
#         @request.env["devise.mapping"] = Devise.mappings[:user]
#         @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
#       end
#       let!(:admin_user) { create(:user, provider: "google_oauth2", uid: "123456", email: Rails.application.credentials.admin[:email], role: 1) }

#       it "管理者ページへリダイレクトする" do
#         puts User.find_by(email: Rails.application.credentials.admin[:email]).admin?
#         expect {
#           get :google_oauth2
#         }.not_to change(User, :count)
        
#         expect(response).to redirect_to(admin_users_path)
#         expect(flash[:success]).to eq("管理者としてログインしました")
#       end
#     end

#     context "新規ユーザーの場合" do
#       it "ユーザーを作成し、ログインする" do
#         expect {
#           get :google_oauth2
#         }.to change(User, :count).by(1)

#         user = User.last
#         expect(user.email).to eq("test@example.com")
#         expect(user.user_name).to eq("Test User")
#         expect(session["warden.user.user.key"]).not_to be_nil # Deviseのログイン状態チェック

#         expect(response).to redirect_to(visited_boards_user_path(user))
#         expect(flash[:notice]).to eq("Google アカウントでログインしました") # Deviseのflashメッセージ
#       end
#     end
#   end
# end