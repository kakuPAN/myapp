class UsersController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "ユーザーが登録されました"
    else
      flash.now[:danger] = "入力エラーです"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
