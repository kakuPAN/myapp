class TasksController < ApplicationController
  before_action :require_login, except: :index

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
    @achievement = calcurate_achievement
  end

  def show
    
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find_by(user_id: current_user.id, id: params[:id])
    if @task
      @task.destroy
      redirect_to tasks_path
      flash[:notice] = "タスクを削除しました"
    end
  end

  def achieve_task
    @task = Task.find_by(user_id: current_user.id, id: params[:id])
    if @task
      @task.update(progress_status: 2)
      redirect_to tasks_path
    end
  end

  private

  def task_params
    params.require(:task).permit(:user_id,:title, :body, :deadline, :access_level, :progress_status)
  end

  def calcurate_achievement
    tasks = Task.all
    done_tasks = Task.where(progress_status: "done")
    all_tasks_count = tasks.count
    done_tasks_count = done_tasks.count
    if done_tasks_count == 0
      return 0
    end
    achievement = (done_tasks_count.to_f/all_tasks_count)*100
    achievement.to_i
  end
end
