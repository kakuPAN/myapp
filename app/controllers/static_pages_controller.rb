class StaticPagesController < ApplicationController
  def top
    if current_user
      redirect_to home_pages_path
    end
    @users = User.all
  end
end
