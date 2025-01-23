class PasswordResetsController < ApplicationController

  def new
    @security_questions = SecurityQuestion.all
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user && correct_security_answer?(@user, params[:security_question_id], @user.security_answer_digest, params[:security_answer])
      @user.generate_reset_token
      redirect_to edit_password_reset_path(@user.reset_token)
    else
      flash.now[:success] = "秘密の質問または答えが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_token: params[:token])

    if @user.nil? || @user.reset_sent_at < 1.hours.ago
      flash[:alert] = "リセットトークンが無効または有効期限が切れています"
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])

    if @user && @user.update(password_params)
      @user.update(reset_token: nil, reset_sent_at: nil)
      flash[:success] = "パスワードをリセットしました"
      redirect_to login_path
    else
      render :edit, status: :unprocessable_entity
      flash.now[:success] = "パスワードリセットに失敗しました"
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
