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
    @q = Task.where("access_level = ? OR user_id = ?", 1, current_user&.id).ransack(params[:q])
    @progress_statuses = Task.progress_statuses_i18n
    @tasks = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(5)
    @achievement = Task.calcurate_achievement_rate
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
