class PasswordResetsController < ApplicationController
  def new
    if current_user
      redirect_to visited_boards_user_path(current_user)
      flash[:success] = "すでにログインしています"
      return
    end
    @security_questions = SecurityQuestion.all
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && correct_security_answer?(@user, params[:security_question_id], @user.security_answer_digest, params[:security_answer])
      @user.generate_reset_token
      redirect_to edit_password_reset_path(@user.reset_token)
    else
      flash.now[:success] = "入力内容に誤りがあります"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_token: params[:token])

    if @user.nil? || @user.reset_sent_at < 1.hours.ago
      flash[:alert] = "リセットトークンが無効です"
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]
    if @user
      if password.length < 3
        @user.errors.add(:password, "は3文字以上で入力してください")
      elsif password.length > 50
        @user.errors.add(:password, "は50文字以内で入力してください")
      elsif password != password_confirmation
        @user.errors.add(:password_confirmation, "とパスワードの入力が一致しません")
      end

      if @user.errors.any?
        flash.now[:success] = "パスワードリセットに失敗しました"
        render :edit, status: :unprocessable_entity
      else
        @user.update(password_params)
        @user.update(reset_token: nil, reset_sent_at: nil)
        flash[:success] = "パスワードをリセットしました"
        redirect_to login_path
      end
    else
      flash[:success] = "リセットトークンが無効です"
      redirect_to login_path
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def correct_security_answer?(user, security_question_id, stored_digest, answer)
    user.security_question_id == security_question_id.to_i && BCrypt::Password.new(stored_digest) == answer
  end
end
