class UsersController < ApplicationController
  protect_from_forgery  #このコードを記入することで、invalidtakenエラー解除できた
  #事前処理でアクション実行者が、ログインユーザーかおづかを判断。
  
  before_action :require_user_logged_in, only: [:show, :followings, :followers, :likes, :writing, :myarea_list, 
  :edit, :update, :destroy, :user_search, :prev_search]
  before_action :set_user, only: [:show, :edit, :update, :followings, :followers, :likes, :writing, :myarea_list, :sort_of_myarea, :sort_of_likes]
  before_action :set_search, only: [:show, :followings, :followers, :likes, :writing, :search, :myarea_list, :prev_search, :sort_of_myarea, :sort_of_likes]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :set_search_by_station,  only: [:search_by_station_of_show, :search_by_station_of_myarea, :search_by_station_of_writing,
                                                :search_by_station_of_followers, :search_by_station_of_followings, :search_by_station_of_likes]
  before_action :set_myarea_list_articles, only: [:myarea_list, :search_by_station_of_myarea, :sort_of_myarea]
  before_action :nil_judge, only: [:search_by_station_of_show, :search_by_station_of_myarea, :search_by_station_of_writing,
                                   :search_by_station_of_followers, :search_by_station_of_followings, :search_by_station_of_likes]

  def show
    @key = params[:key]
    @sort = params[:change]
    
    if @key.present? && @sort.present? then
        #タイムライン内の検索機能
        @articles = @user.feed_articles.where(['shop_name LIKE?', "%#{@key}%"]).or(@user.feed_articles.where(['area LIKE?', "%#{@key}%"])).or(@user.feed_articles.where(['station LIKE?', "%#{@key}%"]))
        .or(@user.feed_articles.where(['food_type LIKE?', "%#{@key}%"])).order(id: :desc)
        
        #タイムライン検索結果の並び替え
        if @sort == "安い順(予算金額)"
          @sort_articles = @articles.sort_by { |a| a[:budget] }  
          @articles= Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        elsif @key == "高い順(予算金額)"
          @sort_articles = @articles.sort_by { |a| a[:budget] }.reverse
          @articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        elsif @key == "駅近順（徒歩時間)"
          @sort_articles = @articles.sort_by { |a| a[:walk_time].to_i } 
          @articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        end
        
    elsif @key.present? && !@sort.present? then
        @articles = @user.feed_articles.where(['shop_name LIKE?', "%#{@key}%"]).or(@user.feed_articles.where(['area LIKE?', "%#{@key}%"])).or(@user.feed_articles.where(['station LIKE?', "%#{@key}%"]))
        .or(@user.feed_articles.where(['food_type LIKE?', "%#{@key}%"])).order(id: :desc).page(params[:page]).per(6)
    else
        @articles = @user.feed_articles.order(id: :desc).page(params[:page]).per(6)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザーを登録しました。'
      redirect_to login_url
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
    
  end

  def edit
  end

  def update
      if @user.update(user_params)
        flash[:success] = 'ユーザー情報を編集しました。'
        redirect_to @user
      else
        flash.now[:danger] = 'ユーザー情報の編集に失敗しました。'
      　render :edit
      end
  end

  def destroy
  end

  #ログインユーザーが登録したマイエリア情報にマッチする記事だけを取得するコード
  #判定nilに問題あり。
  #フォームに何も入れてないのに、nil判定がfalse、""判定にしたら上手くいった。
  
  def myarea_list
    @key = params[:key]
    @sort = params[:change]
    
    if @key.present? && @sort.present? then
      
        #まずはマイエリア内で検索
        @myarea_search_articles = @myarea_articles.find_all { |x| x[:shop_name].include?("#{@key}") || x[:area].include?("#{@key}") || 
        x[:station].include?("#{@key}") || x[:food_type].include?("#{@key}") }
        
        #マイエリア内検索結果の並び替え
        if @sort == "安い順(予算金額)"
          @sort_articles = @myarea_search_articles.sort_by { |a| a[:budget] }  
          @search_results= Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        elsif @key == "高い順(予算金額)"
          @sort_articles = @myarea_search_articles.sort_by { |a| a[:budget] }.reverse
          @search_results = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        elsif @key == "駅近順（徒歩時間)"
          @sort_articles = @myarea_search_articles.sort_by { |a| a[:walk_time].to_i } 
          @search_results = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        end
        
    elsif @key.present? && !@sort.present? then
        @myarea_search_articles = @myarea_articles.find_all { |x| x[:shop_name].include?("#{@key}") || x[:area].include?("#{@key}") || 
        x[:station].include?("#{@key}") || x[:food_type].include?("#{@key}") }
        @search_results = Kaminari.paginate_array(@myarea_search_articles).page(params[:page]).per(6)
    end
    
    if (@serch_articles != nil)
      render 'myarea_list'
    else
      @nil = @search_articles.page(params[:page])
      render 'myarea_list'
    end
  end
  
  #マイエリアリストの記事の並び替え機能（全体）
  def sort_of_myarea
    @key = params[:change]
    if @key == "安い順(予算金額)"
      @myarea_articles = @myarea_articles.sort_by! { |a| a[:budget] }  
      
      @search_results = Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(6)
      render 'myarea_list'
    elsif @key == "高い順(予算金額)"
      @myarea_articles = @myarea_articles.sort_by { |a| a[:budget] }.reverse
      
      @search_results = Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(6)
      render 'myarea_list'
    elsif @key == "駅近順（徒歩時間)"
      @myarea_articles = @myarea_articles.sort_by! { |a| a[:walk_time].to_i } 
      
      @search_results = Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(6)
      render 'myarea_list'
    end
  end
  

  def writing
    @articles = @user.articles.order(id: :desc).page(params[:page]).per(6)
  end
  
  def followings
    @followings = @user.followings.page(params[:page])
  end
  
  def followers
    @followers = @user.followers.page(params[:page])
  end
  
  def likes
    @favorites = @user.favorites.page(params[:page]).per(6)
    @key = params[:key]
    @sort = params[:change]
    if @key.present? && @sort.present? then
        #まずはマイエリア内で検索
        @favorites_articles = @favorites.find_all { |x| x[:shop_name].include?("#{@key}") || x[:area].include?("#{@key}") || 
        x[:station].include?("#{@key}") || x[:food_type].include?("#{@key}") }
        
        #マイエリア内検索結果の並び替え
        if @sort == "安い順(予算金額)"
          @sort_articles = @favorites_articles.sort_by { |a| a[:budget] }  
          @favorites = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        elsif @sort == "高い順(予算金額)"
          @sort_articles = @favorites_articles.sort_by { |a| a[:budget] }.reverse
          @favorites = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        elsif @sort == "駅近順（徒歩時間)"
          @sort_articles = @favorites_articles.sort_by { |a| a[:walk_time].to_i } 
          @favorites = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        end
        
    elsif @key.present? && !@sort.present? then
        @favorites_articles = @favorites.find_all { |x| x[:shop_name].include?("#{@key}") || x[:area].include?("#{@key}") || 
        x[:station].include?("#{@key}") || x[:food_type].include?("#{@key}") }
        @favorites = Kaminari.paginate_array(@favorites_articles).page(params[:page]).per(6)
    end
  end
  
  
  #お気に入り記事の並び替え機能
  def sort_of_likes
    @key = params[:change]
    @favorites = @user.favorites
    
    if @key == "安い順(予算金額)"
      @sort = @favorites.sort_by { |a| a[:budget] }  
      @favorites = Kaminari.paginate_array(@sort).page(params[:page]).per(6)
      render 'likes'
    elsif @key == "高い順(予算金額)"
      @sort = @favorites.sort_by { |a| a[:budget] }.reverse
      @favorites = Kaminari.paginate_array(@sort).page(params[:page]).per(6)
      render 'likes'
    elsif @key == "駅近順（徒歩時間)"
      @sort = @favorites.sort_by { |a| a[:walk_time].to_i } 
      @favorites = Kaminari.paginate_array(@sort).page(params[:page]).per(6)
      render 'likes'
    end
  end
   
  def search
  end
  
  
  #都道府県から路線検索
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
    respond_to do |change|
      change.js.erb
    end
  end
  
  #路線から駅名検索
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
    respond_to do |create_station|
      create_station.js.erb
    end
  end

  
  def user_search
    @search = params[:search]
    if (@search != "")
      @search_users = User.search(params[:search]).order(id: :desc).page(params[:page]).per(15)
    else
      @search_users = Article.none
      @search_users = @search_users.page(params[:page])
    end
  end
  
  def prev_search
  end
  
  def sort
    @key = params[:change]
    @search = params[:sort]
    @food_type = params[:food_type]
    if @search.present? && !@food_type.present? then   
      @search_articles = Article.where(['area LIKE? OR station LIKE? OR shop_name LIKE?', "%#{@search}%", "%#{@search}%", "%#{@search}%"])
    elsif @search.present? && @food_type.present? then
      @search_articles = Article.where(['(area LIKE? OR station LIKE? OR shop_name LIKE?) AND (food_type LIKE?)',
      "%#{@search}%", "%#{@search}%", "%#{@search}%", "%#{@food_type}%"])
    elsif !@search.present? && @food_type.present? then
      @search_articles = Article.where(['food_type LIKE?', "%#{@food_type}%"])
    else
      @search_articles = Article.none
      @search_articles = @search_articles.page(params[:page])
    end
    
    if (@search != "" || @food_type != "")
      if @key == "安い順(予算金額)"
        @sort_articles = @search_articles.sort_by { |a| a[:budget] }
        @search_articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        render 'search'
      elsif @key == "高い順(予算金額)"
        @sort_articles = @search_articles.sort_by { |a| a[:budget] }.reverse
        @search_articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        render 'search'
      elsif @key == "駅近順（徒歩時間)"
        @sort_articles = @search_articles.sort_by { |a| a[:walk_time].to_i }
        @search_articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(6)
        render 'search'
      end
    else
      Article.none
    end
  end


    
  #-------------------------------------駅名選��で検索ゾーン--------------------------------------------------------------------
  
  def search_by_station
    @search = params[:search_by_station]
    @search_articles = Article.search_station(params[:search_by_station]).order(id: :desc).page(params[:page]).per(4)
    if (@serch_articles != nil)
      render 'search'
    else
      @nil = @search_articles.page(params[:page])
      render 'search'
    end
  end
  
  def search_by_station_of_show
    @articles = @user.feed_articles.order(id: :desc).page(params[:page]).per(4)
    render 'show'
  end
  
  def search_by_station_of_myarea
      render 'myarea_list'
  end
  
  
  def search_by_station_of_writing
    @articles = @user.articles.order(id: :desc).page(params[:page]).per(6)
     render 'writing'
  end
  
  def search_by_station_of_followers
    @followers = @user.followers.page(params[:page]).per(15)
    render 'followers'
  end
  
  def search_by_station_of_followings
    @followings = @user.followings.page(params[:page]).per(15)
      render 'followings'
  end
  
  def search_by_station_of_likes
    @favorites = @user.favorites.page(params[:page]).per(6)
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
    @search = params[:search_by_station]
    @user = User.find(params[:user_id])
    @search_articles = Article.search_station(params[:search_by_station]).order(id: :desc).page(params[:page]).per(6)
  end
  
  def set_search
    @search = params[:search]
    @food_type = params[:food_type]
    @aside_sort = params[:aside_change]
    
    if @search.present? && !@food_type.present? then   #フリーワードだけの場合
      @search_articles = Article.where(['area LIKE? OR station LIKE? OR shop_name LIKE?', "%#{@search}%", "%#{@search}%", "%#{@search}%"])
    elsif @search.present? && @food_type.present? then #フリワードとジャンルの場合
      @search_articles = Article.where(['(area LIKE? OR station LIKE? OR shop_name LIKE?) AND (food_type LIKE?)',
      "%#{@search}%", "%#{@search}%", "%#{@search}%", "%#{@food_type}%"])
    elsif !@search.present? && @food_type.present? then #ジャンルだけの場合
      @search_articles = Article.where(['food_type LIKE?', "%#{@food_type}%"])
    else
      @search_articles = Article.none
      @search_articles = @search_articles.page(params[:page])
    end
    
    if @aside_sort.present? then
        #アサイドエリアでの検索結果の並び替え
        if @aside_sort == "安い順(予算金額)"
          @sort_articles = @search_articles.sort_by { |a| a[:budget] }  
          @search_articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(4)
        elsif @aside_sort == "高い順(予算金額)"
          @sort_articles = @search_articles.sort_by { |a| a[:budget] }.reverse
          @search_articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(4)
        elsif @aside_sort == "駅近順（徒歩時間)"
          @sort_articles = @search_articles.sort_by { |a| a[:walk_time].to_i } 
          @search_articles = Kaminari.paginate_array(@sort_articles).page(params[:page]).per(4)
        end
    else
        @search_articles = Kaminari.paginate_array(@search_articles).page(params[:page]).per(4)
    end
    
  end
  
  
  def set_myarea_list_articles
    @myarea_articles = [];
    
    if (@user.my_area1 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area1}%", "%#{@user.my_area1}%"]).order(id: :desc)
    else
      Article.none
    end
    
    if (@user.my_area2 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area2}%", "%#{@user.my_area2}%"]).order(id: :desc)
    else
      Article.none
    end
    
    if (@user.my_area3 != "")
      @myarea_articles += Article.where(['area LIKE? OR station LIKE?', "%#{@user.my_area3}%", "%#{@user.my_area3}%"]).order(id: :desc)
    else
      Article.none
    end  
    
    
    @search_results = Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(6)
  end
  
  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to user_path(current_user) 
    end
  end
  
  def nil_judge
    if (@serch_articles != nil)
      return @search_articles
    else
      @nil = @search_articles.page(params[:page])
      return @nil
    end
  end
  
end





#Kaminari.paginate_array(@myarea_articles).page(params[:page]).per(4)で直接、ページネートをかけることができる。


#@hashをeachで分解してjsに明け渡す
#もしくはjs側で配列分解



#JSON.parseはJSON全部大文字にする必要あり！！
#URLに日本語を混ぜる場合は、エンコードが必要、変数とかの結合でURL完成させてからURI.encodeを活用
#フォームでデータを送る場合は、POSTメソッドで！！


#まず入力フォームに選択した、都道府県をsubmitボタンにて指定のコントローラーへ明け渡す。
#選択した都道府県情報を、paramsで@prefに変数として放り込む
#あらかじめ用意したapiのURL + @prefを結合させて、各都道府県に対応した路線一覧のURLを作成、url変数へ
#url変数をopen-uriで展開、json.parseでハッシュに変換、それをインスタンス変数へ代入
#このインスタンス変数をjavascriptへ明け渡して、コンボボックスの作成
