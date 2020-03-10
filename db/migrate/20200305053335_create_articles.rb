class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :shop_name
      t.string :url
      t.string :address
      
      t.string :image1
      t.string :image2
      t.string :image3
      t.string :image4
      t.string :image5
      t.string :image6
      
      t.string :area
      t.string :station
      t.integer :walk_time
      
      t.string :main
      t.string :alcohol_type
      t.string :food_type
      t.integer :budget
      t.string :situation
      t.string :softdrink
      t.string :room_type
      t.string :smoking
      t.string :net_reservation
      t.integer :review
      
      t.string :comment
      
    
      t.references :user, forign_key: true

      t.timestamps
    end
  end
end


#★★★後ほど追加させる機能★★★
#入力した店名が、すでにデータベースに登録されている場合、入力フォームに記載した段階でその旨のメッセージを表示させる機能
#入力した店名が、すでに登録済みの場合、コメント欄のみ入力可能機能。
