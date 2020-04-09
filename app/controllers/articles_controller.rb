class ArticlesController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def show
    @article = Article.find(params[:id])
    @review = Review.new
    @user = current_user
  end
  
  def new
    @article = current_user.articles.build
  end
  
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = '記事を投稿しました。'
      redirect_to article_url(@article)
    else
      flash.now[:danger] = '記事が投稿できませんでした。'
      render :new
    end
  end
  
  
  def edit
    @article = Article.find(params[:id])
  end
  
  def update
    @article = Article.find(params[:id])

      if @article.update(article_params)
        flash[:success] = '記事を編集しました。'
        redirect_to article_url
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
     @article = Article.find(params[:id])
     @review = Review.new
     @user = current_user
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



#記事投稿できなかったのは、form_with内部にもう一個form_with入れてたから。 -->
#急に今までの機能がえらーになったら冷静に、どの部分をいじってきたか見直して、そこを一旦もとに戻してみる。

