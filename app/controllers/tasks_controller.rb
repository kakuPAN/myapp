class TasksController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :set_task, only: %i[edit update destroy achieve_task start_task reset_task]

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))
    if @task.save
      redirect_to @task
      flash[:success] = "新しいタスクが作成されました"
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @q = Task.ransack(params[:q])
    @progress_statuses = Task.progress_statuses_i18n
    @tasks = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(6)
    @achievement = Task.calcurate_achievement_rate
    @point = Point.last
    # @display_object = CityObject.joins(:object_locations).distinct
    @object_locations = ObjectLocation.all
  end

  def show
    @task = Task.find_by(id: params[:id])
    if @task && (current_user&.id == @task.user_id || @task.public_access?)
      @task
    else
      flash[:danger] = "タスクが存在しません"
      redirect_to tasks_path
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
    if @task && current_user&.id == @task.user_id
      @task
    else
      flash[:danger] = "タスクが存在しません"
      redirect_to tasks_path
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = "タスクの変更を保存しました"
      redirect_to @task
    else
      flash.now[:danger] = "タスクの変更を保存できません"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "タスクを削除しました"
    redirect_to tasks_path
  end

  def achieve_task
    if current_user&.id != @task.user_id
      flash[:danger] = "このタスクに対するアクセス権限がありません"
      redirect_to tasks_path
    end
    if !@task.done?
      @task.update(progress_status: 2)
      flash[:success] =  "タスクを達成しました！"
      redirect_to request.referer || tasks_path
      get_point
      display_new_object
    end
  end

  def start_task
    if current_user&.id != @task.user_id
      flash[:danger] = "このタスクに対するアクセス権限がありません"
      redirect_to tasks_path
    end
    if !@task.in_progress?
      @task.update(progress_status: 1)
      flash[:success] = "タスクに着手しました！"
      redirect_to request.referer || tasks_path
    end
  end

  def reset_task
    if current_user&.id != @task.user_id
      flash[:danger] = "このタスクに対するアクセス権限がありません"
      redirect_to tasks_path
    end
    if !@task.not_started?
      @task.update(progress_status: 0)
      flash[:success] = "タスクを未着手にしました！"
      redirect_to request.referer || tasks_path
    end
  end

  def get_point
    # achieve_taskメソッド実行時に実行
    # Pointテーブルに初期値を挿入
    point = Point.last.current_point
    delta = 1
    new_point = point + delta
    Point.create!(
      calculation_time: Time.current,
      delta: delta,
      current_point: new_point
    )
    # Pointsテーブル
    # calculation_time　変化した時刻
    # delta　変化の幅　＝＞＞　タスクの条件によって加算されるポイントが異なる
    # current_point　変化した結果のポイント
  end

  # def get_delta
  #   タスクの内容によって加算するポイントを計算する処理
  # end

  def use_point
    point = Point.last.current_point
    delta = 2
    new_point = point - delta
    Point.create!(
      calculation_time: Time.current,
      delta: delta,
      current_point: new_point
    )
  end

  def display_new_object
    if Point.last.current_point >= 2
      used_location_ids = ObjectLocation.pluck(:location_id)
      ## 使用されていない Location を取得
      nonused_locations = Location.where.not(id: used_location_ids)
      ## nonused_locations が空の場合は処理をスキップ
      if nonused_locations.exists?
        ## 使用されていない Location からランダムに1つ選択
        random_location_id = nonused_locations.sample.id
      else
        random_location_id = Location.all.sample.id
        ObjectLocation.find_by(location_id: random_location_id).destroy
      end
      ## 適当な object_id を指定（例: 1 としていますが、実際は動的に設定する必要があります）
      random_object_id = CityObject.all.sample.id
      ## DisplayObject に新しいレコードを作成
      ObjectLocation.create!(
        city_object_id: random_object_id,
        location_id: random_location_id
      )
      use_point
    end
  end

  private

  def set_task
    @task = Task.find_by(user_id: current_user.id, id: params[:id])
  end

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :deadline, :access_level, :progress_status)
  end

  def get_achievement_rate
  end
end
