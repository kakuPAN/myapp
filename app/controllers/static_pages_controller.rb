class StaticPagesController < ApplicationController
  def top
    @boards = Board.all.limit(100)
  end

  def privacy_policy
  end
end
