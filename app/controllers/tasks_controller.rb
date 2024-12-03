class TasksController < ApplicationController
  before_action :require_login, except: :index
  before_action :set_task, only: %i[edit update destroy achieve_task start_task reset_task]

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))
    if @task.save
      redirect_to tasks_path, notice: "新しいタスクが作成されました"
    else
      flash.now[:danger] = "タスクを作成できませんでした"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @tasks = Task.all
    @achievement = Task.calcurate_achievement_rate
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    unless @task
      redirect_to tasks_path
      flash[:danger] = "このタスクに対するアクセス権限がありません"
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: "タスクを編集しました"
    else
      render :edit
      flash[:danger] = "タスクの変更を保存できません"
    end
  end

  def destroy
    if @task
      @task.destroy
      redirect_to tasks_path
      flash[:notice] = "タスクを削除しました"
    end
  end

  def achieve_task
    if @task
      @task.update(progress_status: 2)
      redirect_to request.referer || tasks_path, notice: "タスクを達成しました！"
    end
  end

  def start_task
    if @task
      @task.update(progress_status: 1)
      redirect_to request.referer || tasks_path, notice: "タスクに着手しました！"
    end
  end

  def reset_task
    if @task
      @task.update(progress_status: 0)
      redirect_to request.referer || tasks_path, notice: "タスクを未着手にました！"
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
