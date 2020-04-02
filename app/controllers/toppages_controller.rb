class ToppagesController < ApplicationController
 
  def index
  end
  
  def change
    
     @hello = "hello world"
    
    @pref = params[:prefecture]
    @lines =  "http://express.heartrails.com/api/json?method=getLines&prefecture="
    
    @url = URI.encode @lines.concat(@pref)
    
    @json_url = open(@url).read
    @hash = JSON.parse(@json_url)
    
    
    @value = []
    
    @hash.each do |key, value|
        value.each do |key2, value2|
          @value.push(value2)
        end
    end
  

    
    
    render 'change.js.erb'
  end
  
  
end

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
