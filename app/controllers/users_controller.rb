class UsersController < ApplicationController
  #事前処理でアクション実行者が、ログインユーザーかおづかを判断。
  
  before_action :require_user_logged_in, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :followings, :followers, :likes, :writing, :myarea_list]
  before_action :set_search, only: [:show, :followings, :followers, :likes, :search, :writing, :myarea_list]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @articles = @user.feed_articles.order(id: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
    
  end

  def edit
  end

  def update
    if current_user == @user
      if @user.update(user_params)
        flash[:success] = 'ユーザー情報を編集しました。'
        render :edit
      else
        flash.now[:danger] = 'ユーザー情報の編集に失敗しました。'
      　render :edit
      end
    else
       redirect_to root_url
    end  
  end

  def destroy
  end
  
  def followings
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
   def likes
      @favorites = @user.favorites.page(params[:page])
   end
   
   def search
   end
  
  
  def writing
    @articles = @user.articles.order(id: :desc).page(params[:page])
  end
  
  def user_search
    @search_users = User.search(params[:search]).order(id: :desc).page(params[:page])
  end
  
  
  
  #ログインユーザーが登録したマイエリア情報にマッチする記事だけを取得するコード
  
  #今日家帰って検索条件設定の確認
  def myarea_list
    @myarea_articles = Article.where(['station LIKE?', "%春日野道%"
    ]).order(id: :desc).page(params[:page])
  end
  
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :job_field, :job_class, :my_area1, :my_area2, :my_area3)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_search
    @search_articles = Article.search(params[:search]).order(id: :desc).page(params[:page])
  end
  
  
end
