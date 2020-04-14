class UsersController < ApplicationController
  #事前処理でアクション実行者が、ログインユーザーかおづかを判断。
  
  before_action :require_user_logged_in, only: [:show, :followings, :followers, :likes, :writing, :myarea_list, 
  :edit, :update, :destroy, :prev_search]
  before_action :set_user, only: [:show, :edit, :update, :followings, :followers, :likes, :writing, :myarea_list]
  before_action :set_search, only: [:show, :followings, :followers, :likes, :search, :writing, :myarea_list, :prev_search]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_search_by_station,  only: [:search_by_station, :search_by_station_of_show, :search_by_station_of_myarea, :search_by_station_of_writing,
                                                :search_by_station_of_followers, :search_by_station_of_followings, :search_by_station_of_likes]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @articles = @user.feed_articles.order(id: :desc).page(params[:page]).per(4)
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
        redirect_to @user
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
      @favorites = @user.favorites.page(params[:page]).per(4)
   end
   
   def search
   end
  
  
  def writing
    @articles = @user.articles.order(id: :desc).page(params[:page]).per(4)
  end
  
  def user_search
    @search_users = User.search(params[:search]).order(id: :desc).page(params[:page]).per(4)
  end
  
  def prev_search
  end
  

  
  #prevsearchは
  
  #ログインユーザーが登録したマイエリア情報にマッチする記事だけを取得するコード
  
  #今日家帰って検索条件設定の確認
  #Article側のエリア化、最寄りの空欄
  
  #判定nilに問題あり。
  #フォームに何も入れてないのに、nil判定がfalse、""判定にしたら上手くいった。
  
  def myarea_list
    @myarea_articles = [];
    

    if (@user.my_area1 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area1}%", "%#{@user.my_area1}%"]).order(id: :desc).page(params[:page])
    else
      Article.none
    end
    
    
    if (@user.my_area2 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area2}%", "%#{@user.my_area2}%"]).order(id: :desc).page(params[:page])
    else
      Article.none
    end
    
      
    if (@user.my_area3 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area3}%", "%#{@user.my_area3}%"]).order(id: :desc).page(params[:page])
    else
      Article.none
    end  
    
    @search_results = Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(4)
    
  end
  
  
  
  def change
    
    @pref = params[:prefecture]
    @lines =  "http://express.heartrails.com/api/json?method=getLines&prefecture="
    
    @url = URI.encode @lines.concat(@pref)
    
    @json_url = open(@url).read
    @hash = JSON.parse(@json_url)
    
    
    @hash.each do |key, value|
        value.each do |key2, value2|
          @value = value2
        end
    end
    
    render 'change.js.erb'
  end
  
  
  def create_station
    @value = []
    
    @line = params[:lines]
    @stations =  "http://express.heartrails.com/api/json?method=getStations&line="
    
    @url = URI.encode @stations.concat(@line)
    
    @json_url = open(@url).read
    @hash = JSON.parse(@json_url)
    
    
    @hash.each do |key, value|
        value.each do |key2, value2|
          value2.each do |value3|
            value4 = value3["name"]
              @value.push(value4)
          end
        end
    end
    
    render 'create_station.js.erb'
  end
  
  
    
  #-------------------------------------駅名選択で検索ゾーン--------------------------------------------------------------------
  
  def search_by_station
    render 'search'
  end
  
  def search_by_station_of_show
    @articles = @user.feed_articles.order(id: :desc).page(params[:page]).per(4)
    render 'show'
  end
  
  
  
  def search_by_station_of_myarea
    @myarea_articles = [];
    

    if (@user.my_area1 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area1}%", "%#{@user.my_area1}%"]).order(id: :desc).page(params[:page])
    else
      Article.none
    end
    
    
    if (@user.my_area2 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area2}%", "%#{@user.my_area2}%"]).order(id: :desc).page(params[:page])
    else
      Article.none
    end
    
      
    if (@user.my_area3 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area3}%", "%#{@user.my_area3}%"]).order(id: :desc).page(params[:page])
    else
      Article.none
    end  
    
    @search_results = Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(4)
    
    render 'myarea_list'
  end
  
  
  def search_by_station_of_writing
    @articles = @user.articles.order(id: :desc).page(params[:page]).per(4)
    render 'writing'
  end
  
  def search_by_station_of_followers
    @followers = @user.followers.page(params[:page])
    counts(@user)
    render 'followers'
  end
  
  def search_by_station_of_followings
    @followings = @user.followings.page(params[:page])
    counts(@user)
    render 'followings'
  end
  
  def search_by_station_of_likes
    @favorites = @user.favorites.page(params[:page]).per(4)
    render 'likes'
  end
  
  #--------------------------------------------------------------------------------------------------------------------------------
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :job_field, :job_class, :my_area1, :my_area2, :my_area3)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def set_search_by_station
    @user = User.find(params[:user_id])
    @search_articles = Article.search_station(params[:search_by_station]).order(id: :desc).page(params[:page])
  end
  
  def set_search
    @search_articles = Article.search(params[:search]).order(id: :desc).page(params[:page])
  end
  
  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url 
    end
  end
  
end


#Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(4)で直接、ページネートをかけることができる。