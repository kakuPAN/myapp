class TasksController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :set_task, only: %i[edit update destroy achieve_task start_task reset_task]

  def new
    @goal = Goal.find(params[:goal_id])
    @task = Task.new
  end

  def create
    @goal = Goal.find(params[:goal_id])
    @task = Task.new(task_params.merge(user_id: current_user.id))
    @task.goal_id = @goal.id   
    if @task.save
      redirect_to goal_task_path(@goal, @task)
      flash[:success] = "新しいタスクが作成されました"
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @goal = Goal.find(params[:goal_id])
    @q = Task.where(goal_id: @goal).ransack(params[:q])
    @progress_statuses = Task.progress_statuses_i18n
    @tasks = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page]).per(5)
    @achievement = Task.calcurate_achievement_rate
  end

  def show
    @goal = Goal.find(params[:goal_id])
    @task = Task.find_by(id: params[:id])
    if @task && (current_user&.id == @task.user_id || @task.public_access?)
      @task
    else
      flash[:danger] = "タスクが存在しません"
      redirect_to goal_tasks_path(@goal)
    end
  end

  def edit
    @goal = Goal.find(params[:goal_id])
    @task = Task.find_by(id: params[:id])
    if @task && current_user&.id == @task.user_id
      @task
    else
      flash[:danger] = "タスクが存在しません"
      redirect_to goal_tasks_path(@goal)
    end
  end

  def update
    @goal = Goal.find(params[:goal_id])
    if @task.update(task_params)
      flash[:success] = "タスクの変更を保存しました"
      redirect_to goal_task_path(@goal, @task)
    else
      flash.now[:danger] = "タスクの変更を保存できません"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal = Goal.find(params[:goal_id])
    @task.destroy
    flash[:success] = "タスクを削除しました"
    redirect_to goal_tasks_path(@goal)
  end

  def achieve_task
    if current_user&.id != @task.user_id
      flash[:danger] = "このタスクに対するアクセス権限がありません"
      redirect_to goal_tasks_path(@goal)
    end
    if !@task.done?
      @task.update(progress_status: 2)
      flash[:success] =  "タスクを達成しました！"
      redirect_to request.referer || goal_tasks_path(@goal)
    end
  end

  def start_task
    if current_user&.id != @task.user_id
      flash[:danger] = "このタスクに対するアクセス権限がありません"
      redirect_to goal_tasks_path(@goal)
    end
    if !@task.in_progress?
      @task.update(progress_status: 1)
      flash[:success] = "タスクに着手しました！"
      redirect_to request.referer || goal_tasks_path(@goal)
    end
  end

  def reset_task
    if current_user&.id != @task.user_id
      flash[:danger] = "このタスクに対するアクセス権限がありません"
      redirect_to goal_tasks_path(@goal)
    end
    if !@task.not_started?
      @task.update(progress_status: 0)
      flash[:success] = "タスクを未着手にしました！"
      redirect_to request.referer || goal_tasks_path(@goal)
    end
  end

  private

  def set_task
    @task = Task.find_by(user_id: current_user.id, id: params[:id])
  end

  def task_params
    params.require(:task).permit(:user_id, :title, :body, :deadline, :access_level, :progress_status)
  end
end
