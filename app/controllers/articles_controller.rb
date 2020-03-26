class ArticlesController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def show
    @articles = Article.all
    @article = @articles.find_by(params[:id])
    @review = Review.new
  end
  
  def new
    @article = Article.new
  end
  
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = '記事を投稿しました。'
      redirect_to user_path(current_user)
    else
      flash.now[:danger] = '記事が投稿できませんでした。'
      render :new
    end
  end
  
  
  def edit
    @articles = Article.all
    @article = @articles.find(params[:id])
  end
  
  def update
    @articles = Article.all
    @article = @articles.find(params[:id])

      if @article.update(article_params)
        flash[:success] = '記事を編集しました。'
        render :edit
      else
        flash.now[:danger] = '記事を編集できませんでした。'
        render :edit
      end
    
  end

  def destroy
    @article.destroy
    flash[:success] = '記事を削除しました。'
    redirect_back(fallback_location: user_path)
  end
  
  def reviewing
     @articles = Article.all
     @article = @articles.find(params[:id])
     @review = Review.new
     @user = current_user.id
     @reviews = @article.reviews
  end
  
 
  
  
  private
  
  def article_params
    params.require(:article).permit(:shop_name, :shop_url, :address, :image1, :image2, :image3, :image4, :image5, :image6, :area, :station, :walk_time,
        :main, :alcohol_type, :food_type, :budget, :situation, :softdrink, :room_type, :smoking, :net_reservation, :review)
  end
  
  
  def correct_user
    @article = current_user.articles.find_by(id: params[:id])
    unless @article
      redirect_to root_url 
    end
  end
end
