class GoalsController < ApplicationController
  def index
    @q = Goal.ransack(params[:q])
    @goals = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(2)
  end

  def show
    if current_user
      @goals = current_user&.goals 
      @goal = current_user.goals.find(params[:id])
      @height = Height.find_by(goal_id: @goal.id)
      @landmarks = Landmark.where(setting_height_level: @height.current_height_level)
      @tasks = @goal.tasks.order(created_at: :desc)
    else
      flash[:danger] = "ログインしてください"
      redirect_to root_path
    end
  end
end
