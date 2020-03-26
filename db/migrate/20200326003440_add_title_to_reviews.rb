class AddTitleToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :title, :string
    add_reference :reviews, :user, foreign_key: true
    
    add_index :reviews, [:user_id, :article_id], unique: true
  end
end
