class ReviewsController < ApplicationController
    before_action :require_user_logged_in
    before_action :set_article, only: [:show, :new, :create,  :edit, :update]
    
    
    def show
    end
    
    def new
        @review = Review.new
    end
    
    def create
        @review = @article.reviews.build(review_params)
        if @review.save
          flash[:success] = '口コミを投稿しました。'
          redirect_to reviewing_article_path(@article)
        else
          flash.now[:danger] = '口コミが投稿できませんでした。'
          render :new
        end
    end
    
    def destroy
        @review = Review.find_by(params[:id])
        @review.destroy
        flash[:success] = '口コミを削除しました。'
        redirect_back(fallback_location: user_path)
    end
    
    
    private
    def review_params
      params.require(:review).permit(:id, :content)
    end
    
    def set_article
        @articles = Article.all
        @article = @articles.find(params[:article_id])
    end
    
end
