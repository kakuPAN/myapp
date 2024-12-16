class StaticPagesController < ApplicationController
  def top
    @users = User.all
    @tasks = Task.all.order(:id)
  end
end
