class LeaderboardController < ApplicationController
	before_action :authenticate_user!
	def new
		@leaderboard = Leaderboard.new
	end
	
	def index
		@board = Leaderboard.all
		@boardHash = Hash.new()
		maxScores = Hash.new()
		@board.each do |row|
			if @boardHash[row.user_id] == nil
				@boardHash[row.user_id] = row
				maxScores[row.user_id] = row.score
			else
				@boardHash[row.user_id].score += row.score
				if maxScores[row.user_id] < row.score
					@boardHash[row.user_id][:tag] = row.tag 
				end
			end
		end
		@boardHash.sort_by { |k, v| v[:score] }.reverse
		@leaderboard = @boardHash.values
	end
end
