class GoalsController < ApplicationController
  def index
    @goals = current_user&.goals    
  end

  def show
    if current_user
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
