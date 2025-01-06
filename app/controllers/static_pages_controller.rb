class StaticPagesController < ApplicationController
  def top
    if current_user
      redirect_to user_path(current_user)
    end
  end
end
