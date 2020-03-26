// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery
//= require jquery_ujs


(function($){
	$(function(){
		//初期設定
		var pref = $('#pref'); //都道府県が入るselect
		var line = $('#line'); //路線が入るselect
		var station = $('#station'); //駅名が入るselect
		
		//最初に都道府県を読み込む
		$.getJSON('http://express.heartrails.com/api/json?method=getPrefectures&callback=?',function(json){
			$.each(json.response.prefecture,function(key,value){
				var txt = String(this); //都道府県名が配列で帰ってきてたので文字列に変換・・・
				pref.append('<option value="'+txt+'">'+txt+"</option>");
			});
		});
		
		//都道府県から路線を検索
		pref.on('change',function(){
			$.getJSON('http://express.heartrails.com/api/json?method=getLines&callback=?',
			{prefecture:pref.val()},
			function(json){
				line.children().not(':first').remove();//一つ目のoption(選択してください）のみ残して削除
				station.children().not(':first').remove();//都道府県が変わるときに駅選択も初期化する
				$.each(json.response.line,function(key,value){
					var txt = String(this);
					line.append('<option value="'+txt+'">'+txt+"</option>");
				});
			});
		});
		
		//路線から駅名を検索
		line.on('change',function(){
			$.getJSON('http://express.heartrails.com/api/json?method=getStations&callback=?',
			{line:line.val()},
			function(json){
				station.children().not(':first').remove();//一つ目のoption(選択してください）のみ残して削除
				$.each(json.response.station,function(key,value){
					if(this.prefecture == pref.val()){ //路線内の駅のうち選択された都道府県内のものだけを絞り込み
						var txt = String(this.name); //駅名の場合郵便番号や経度緯度などが配列として入っているので名称のみ絞り込み
						station.append('<option value="'+txt+'駅">'+txt+"駅</option>");//○○「駅」が入ってないので無理やり付ける
					}
				});
			});
		});
 
 
	});
});




