require "rails_helper"

RSpec.describe OauthsController, type: :controller do
  let(:provider) { "google" }
  let(:user) { instance_double(User, id: 1, email: "test@example.com", role: 0) }

  before do
    allow(controller).to receive(:auth_params).and_return({ provider: provider })
  end

  describe "GET #oauth" do
    it "calls login_at with provider" do
      expect(controller).to receive(:login_at).with(provider)
      get :oauth, params: { provider: provider }
    end
  end

  describe "GET #callback" do
    context "ユーザーが存在する場合" do
      before do
        allow(controller).to receive(:login_from).with(provider).and_return(user)
      end

      it "ログインが成功する" do
        get :callback, params: { provider: provider }
        expect(response).to redirect_to(visited_boards_user_path(user))
        expect(flash[:notice]).to eq("#{provider.titleize}アカウントでログインしました")
      end
    end

    context "ユーザーが存在しない場合" do
      before do
        allow(controller).to receive(:login_from).with(provider).and_return(nil)
        allow(controller).to receive(:create_from).with(provider).and_return(user)
        allow(controller).to receive(:reset_session)
        allow(controller).to receive(:auto_login).with(user)
      end

      it "ユーザーを作成する" do
        expect(user).to receive(:email).and_return("test@example.com")
        expect(user).not_to receive(:update) # role: 1 にはならない

        get :callback, params: { provider: provider }

        expect(response).to redirect_to(visited_boards_user_path(user))
        expect(flash[:notice]).to eq("#{provider.titleize}アカウントでログインしました")
      end
    end

    context "ユーザーが管理者用メールアドレスを持っている場合" do
      let(:admin_user) { instance_double(User, id: 2, email: Rails.application.credentials.dig(:admin, :email), role: 0) }

      before do
        allow(controller).to receive(:login_from).with(provider).and_return(nil)
        allow(controller).to receive(:create_from).with(provider).and_return(admin_user)
        allow(controller).to receive(:reset_session)
        allow(controller).to receive(:auto_login).with(admin_user)
      end

      it "ユーザーを管理者ユーザーとして作成する" do
        expect(admin_user).to receive(:email).and_return(Rails.application.credentials.dig(:admin, :email))
        expect(admin_user).to receive(:update).with(role: 1)

        get :callback, params: { provider: provider }

        expect(response).to redirect_to(visited_boards_user_path(admin_user))
        expect(flash[:notice]).to eq("#{provider.titleize}アカウントでログインしました")
      end
    end

    context "認証に失敗した場合" do
      before do
        allow(controller).to receive(:login_from).with(provider).and_return(nil)
        allow(controller).to receive(:create_from).with(provider).and_raise(StandardError)
      end

      it "ログインが失敗し、トップページにリダイレクトする" do
        get :callback, params: { provider: provider }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("#{provider.titleize}アカウントでのログインに失敗しました")
      end
    end
  end
end
