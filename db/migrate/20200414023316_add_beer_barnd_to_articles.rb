class AddBeerBarndToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :beer_brand, :string
  end
end
