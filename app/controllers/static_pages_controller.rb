class StaticPagesController < ApplicationController
  def top
    @boards = Board.all.limit(100)
  end
end
