class Article < ApplicationRecord
    belongs_to :user
    has_many :reviews, dependent: :destroy
    
    has_many :likes, dependent: :destroy
    has_many :favorite_users, through: :likes, source: :user
    
    
    validates :shop_name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :shop_url, uniqueness: { case_sensitive: false }, if: :form_blank?
    validates :address, uniqueness: { case_sensitive: false }, if: :form_blank?
  
    
    mount_uploader :image1, ImageUploader
    mount_uploader :image2, ImageUploader
    mount_uploader :image3, ImageUploader
    mount_uploader :image4, ImageUploader
    mount_uploader :image5, ImageUploader
    mount_uploader :image6, ImageUploader
    
    
    #検索機能
    def self.search(search)
        if search
          Article.where(['area LIKE? OR station LIKE?', "%#{search}%", "%#{search}%"])
        else
          Article.none
        end
    end
    
    
    private
        def form_blank?
            presence == true
        end
end
