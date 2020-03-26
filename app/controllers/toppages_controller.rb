class ToppagesController < ApplicationController

  def index
  end
  
  def change
    
    
    pref = (paramas[:id])
    url = 'https://express.heartrails.com/api/json?method=getLines&prefecture=' + pref
    
    @json_url = 
    
    
    render 'change.js.erb'
  end
  
  
end


#まず入力フォームに選択した、都道府県をsubmitボタンにて指定のコントローラーへ明け渡す。
#選択した都道府県情報を、paramsで@prefに変数として放り込む
#あらかじめ用意したapiのURL + @prefを結合させて、各都道府県に対応した路線一覧のURLを作成、url変数へ
