class StaticPagesController < ApplicationController
  def top
    @users = User.all
  end
end