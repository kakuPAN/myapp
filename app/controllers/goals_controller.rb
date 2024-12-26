class GoalsController < ApplicationController
  def index
    @q = Goal.where(user_id: current_user&.id).ransack(params[:q])
    @goals = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(2)
  end

  def show
    return unless current_user # ログインしていない場合は処理をスキップ
  
    @goals = current_user.goals
    @goal = current_user.goals.find_by(id: params[:id]) # 単一のゴールを取得
  
    unless @goal
      flash[:alert] = "指定されたゴールが見つかりません。"
      redirect_to goals_path and return
    end
    @landmarks = Landmark.order(created_at: :desc).page(params[:page]).per(2)
    @tasks = @goal.tasks.order(created_at: :desc)
  end
end
