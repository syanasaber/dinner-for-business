class ReviewsController < ApplicationController
    before_action :require_user_logged_in, only:[:new, :create, :destroy]
    before_action :correct_user, only: [:destroy]
    
    
    def show
    end
    
    def new
        @review = Review.new
    end
    
    def create
        @article = Article.find(params[:article_id])
        @review = @article.reviews.build(review_params)
        @review.user = current_user
       
        if @review.save
          flash[:success] = '口コミを投稿しました。'
          redirect_back(fallback_location: user_path(current_user))
        else
          flash.now[:danger] = '口コミが投稿できませんでした。'
          redirect_back(fallback_location: user_path(current_user))
        end
    end
    
    
    
    def destroy
        @review.destroy
        flash[:success] = '口コミを削除しました。'
        redirect_back(fallback_location: user_path(current_user))
    end
    
    
    private
    def review_params
      params.require(:review).permit(:article_id, :user_id, :title, :content)
    end
    
    def correct_user
        @review = current_user.reviews.find_by(id: params[:id])
            unless @review
                redirect_to user_path(current_user)
            end
    end
    
end


#相互モデルをbelongs_toしているため、両方のカラムidがインスタンスにほりこめてないとエラーになる。
#レビューコントローラーの削除後に、パラメーターidが65を取得してしまう原因
#レビューコントローラーで、find(params[:id]をつかってもうまく作動しない)
#レビューのidを取得してしまうから。
#articleのidパラメーターを取得できるのは、articleコントローラーのみ
#他のモデルのidパラメーターを、当該コントローラーに渡すとき（create）は、hidden_fieldを使ってidを渡す

