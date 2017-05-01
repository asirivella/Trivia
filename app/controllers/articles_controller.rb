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
				if params[:answer] != nil && @article.answer.match(params[:answer]) && params[:answer].match(@article.answer)
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
 
	private
		def article_params
			params.require(:article).permit(:question, :answer, :name, :tag_list).merge(user_id: current_user.id)
		end
end
