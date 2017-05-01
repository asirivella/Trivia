class ArticlesController < ApplicationController
	before_action :authenticate_user!, excempt: [:index, :show]

	def new
		@article = Article.new
	end
	
	def edit
		@article = Article.find(params[:id])
	end
	
	def show
		if params[:tag]
			if params[:id]
				@article = Article.find(params[:id])
			else
				@article = Article.tagged_with(params[:tag]).where.not(user_id: current_user.id).sample
			end
		else
			if params[:id]
				@article = Article.find(params[:id])
			end
		end
		if @article == nil
			redirect_to articles_path
		end
	end
	
	def answer
		if params[:tag]
			if params[:id]
				scr = 0;
				@article = Article.find(params[:id])
				isValid = compareAnswer(@article.answer, params[:answer])
				if params[:answer] != nil && isValid
					scr = 4;
					params[:match] = true;
				else
					scr = -1;
					params[:match] = false;
					@article.errors.add(:answer, "Invalid");
				end
				
				leaderboard = Leaderboard.find_by(user_id: current_user.id, tag: params[:tag])
				if leaderboard == nil
					Leaderboard.create(:user_id => current_user.id, :email => current_user.email, :tag => params[:tag], :score => scr)
				else
					leaderboard.score = leaderboard.score + scr
					leaderboard.update_attribute(:score, leaderboard.score + scr)
				end
			end
		end
	end
	
	def index
		if params[:tag]
			@articles = Article.tagged_with(params[:tag])
		else
			@articles = Article.all
		end
	end
	
	def create
		@article = Article.new(article_params)
		
		if @article.save
			redirect_to articles_path
		else
			render 'new'
		end
	end
	
	def update
		@article = Article.find(params[:id])
		
		if @article.update(article_params)
			redirect_to articles_path
		else
			render 'edit'
		end
	end
	
	def destroy
		@article = Article.find(params[:id])
		@article.destroy
		
		redirect_to articles_path
	end
	
	def compareAnswer(base, text)
		if text != nil
			dist = distance(base, text)
			if dist < base.length / 2 && dist < 4
				return true
			else
				return false
			end
		else
			return false
		end
	end
	
	def distance(a, b)
		# To filter out obvious words (stop words) just some of them
		remove_words  = ["a" , "the", "his", "her", "at", "of", "to", "on", "or"]
		a = a.downcase.split.delete_if{|x| remove_words.include?(x)}.join(' ')
		b = b.downcase.split.delete_if{|x| remove_words.include?(x)}.join(' ')
		
		costs = Array(0..b.length) # i == 0
		(1..a.length).each do |i|
			costs[0], nw = i, i - 1  # j == 0; nw is lev(i-1, j)
			(1..b.length).each do |j|
				costs[j], nw = [costs[j] + 1, costs[j-1] + 1, a[i-1] == b[j-1] ? nw : nw + 1].min, costs[j]
			end
		end
		return costs[b.length]
	end
 
	private
		def article_params
			params.require(:article).permit(:question, :answer, :name, :tag_list).merge(user_id: current_user.id)
		end
end
