class Article < ApplicationRecord
    belongs_to :user
    has_many :reviews, dependent: :destroy
    
    has_many :likes, dependent: :destroy
    has_many :favorite_users, through: :likes, source: :user
    
    
    validates :shop_name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :shop_url, uniqueness: { case_sensitive: false }, if: :form_blank?
    validates :address, uniqueness: { case_sensitive: false }, if: :form_blank?
    validates :area, presence: true, length: { maximum: 50 }, format: { with: /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/ }
    #エリアカラムについては、アルファベット表記を禁止
  
    
    mount_uploader :image1, ImageUploader
    mount_uploader :image2, ImageUploader
    mount_uploader :image3, ImageUploader
    mount_uploader :image4, ImageUploader
    mount_uploader :image5, ImageUploader
    mount_uploader :image6, ImageUploader
    
    
    #検索機能
    def self.search(search)
        if search
          Article.where(['area LIKE? OR station LIKE? OR shop_name LIKE?', "%#{search}%", "%#{search}%", "%#{search}%"])
        else
          Article.none
        end
    end
    
    def self.search_station(search_by_station)
        if search_by_station
          Article.where(['area LIKE? OR station LIKE?', "%#{search_by_station}%", "%#{search_by_station}%"])
        else
          Article.none
        end
    end
    
    
    private
        def form_blank?
            presence == true
        end
end
