class LikesController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    article = Article.find(params[:article_id])
    current_user.favorite(article)
    article.reload
    flash[:success] = '記事をお気に入りしました'
    redirect_back(fallback_location: user_path(current_user)) 
  end

  def destroy
    article = Article.find(params[:id])
    current_user.unfavorite(article)
    article.reload
    flash[:success] = 'お気に入りを解除しました'
    redirect_back(fallback_location: user_path(current_user))
  end

end
