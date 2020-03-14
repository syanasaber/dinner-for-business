class RenameUrlColumnToArticles < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :url, :shop_url
  end
end
