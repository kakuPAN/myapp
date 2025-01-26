class CommentAnalysisService
  def self.call(board)
    new(board).call
  end

  def initialize(board)
    @board = board
  end

  def call
    analyze_comments
  end

  private

  # コメント頻度の分析
  def analyze_comments
    counts = comment_count
    counts
  end

  # コメントの頻度をカウントする
  def comment_count
    board_comments = @board.comments.pluck(:body)
    EXPECTED_COMMENTS.each_with_object(Hash.new(0)) do |expected_comment, counts|
      counts[expected_comment] = board_comments.count { |comment| comment.include?(expected_comment) }
    end
  end

  # 想定コメントのリスト
  EXPECTED_COMMENTS = [
    "素晴らしい",
    "もっと頑張って",
    "面白い",
    "最高だね",
    "素敵なアイデア",
    "次回も期待してる",
    "参考になった"
    # 他の想定コメントを追加
  ]
end


# ###　今後実装
# 呼び出す場合
# board = Board.find(1)
# analysis_result = CommentAnalysisService.call(board)

# puts "コメント分析結果:"
# analysis_result.each do |comment, count|
#   puts "#{comment}: #{count}回"
# end

# rails c 結果
# board14 = Board.find(14)
# analysis_result = CommentAnalysisService.call(board14)
# Comment Pluck (2.6ms)  SELECT "comments"."body" FROM "comments" WHERE "comments"."board_id" = 14 /*application='Myapp'*/
# => {"素晴らしい"=>1, "もっと頑張って"=>0, "面白い"=>1, "最高だね"=>0, "素敵なアイデア"=>0, "次回も期待してる"=>0, "参考になった"=>0}

# データベースに保存する場合
# class CommentAnalysis < ApplicationRecord
#   belongs_to :board
#   serialize :frequencies, Hash
# end

# def analyze_comments
#   counts = comment_count
#   CommentAnalysis.create!(board: @board, frequencies: counts)
#   log_results(counts)
#   counts
# end

# 定期分析ジョブ: Sidekiq。
# ###
