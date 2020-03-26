class ReviewsController < ApplicationController
    before_action :require_user_logged_in, only:[:new, :create, :destroy]
    before_action :set_article, only: [:show, :new, :create,  :edit, :update]
    before_action :correct_user, only: [:edit, :update, :destroy]
    
    
    def show
    end
    
    def new
        @review = Review.new
    end
    
    def create
        @review = @article.reviews.build(review_params)
        @review.user = current_user
        if @review.save
          flash[:success] = '口コミを投稿しました。'
          redirect_to reviewing_article_path(@article)
        else
          flash.now[:danger] = '口コミが投稿できませんでした。'
          render :article_path
        end
    end
    
    def destroy
        @review.destroy
        flash[:success] = '口コミを削除しました。'
        redirect_back(fallback_location: user_path)
    end
    
    
    private
    def review_params
      params.require(:review).permit(:title, :content)
    end
    
    def set_article
        @articles = Article.all
        @article = @articles.find_by(params[:id])
    end
    
    def correct_user
        @review = current_user.reviews.find_by(params[:article_id])
            unless @review
                redirect_to  redirect_to user_path(current_user)
            end
    end
    
end
