class GoalsController < ApplicationController
  def index
    @q = Goal.where(user_id: current_user&.id).ransack(params[:q])
    @goals = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(2)
  end

  def show
    if current_user
      @goals = current_user&.goals
      @goal = current_user.goals.where(id: params[:id])
      if @goal
        @height = Height.find_by(goal_id: @goal&.id)
        @landmarks = Landmark.where(setting_height_level: @height&.current_height_level)
        @tasks = @goal.tasks.order(created_at: :desc)
      end
    else
      flash[:danger] = "ログインしてください"
      redirect_to root_path
    end
  end
end
