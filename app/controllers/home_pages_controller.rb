class HomePagesController < ApplicationController
  def index
    @goals = current_user&.goals    
  end

  def show
    @goal = current_user&.goals.find(params[:id])
    @height = Height.find_by(goal_id: @goal.id)
    #ホーム画面のタグ（設定したゴールタイトル）をクリックすると、そのゴールの高さを取得
    @landmarks = Landmark.where(setting_height_level: @height.current_height_level)
  end
end
