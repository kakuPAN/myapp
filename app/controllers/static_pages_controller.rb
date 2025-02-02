class StaticPagesController < ApplicationController
  def top
    @boards = Board.order("RANDOM()").limit(80)
  end
end
