class Article < ApplicationRecord
    belongs_to :user
    
    validates :shop_name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :url, uniqueness: { case_sensitive: false }
    validates :address, uniqueness: { case_sensitive: false }
    
    mount_uploader :image1, ImageUploader
    mount_uploader :image2, ImageUploader
    mount_uploader :image3, ImageUploader
    mount_uploader :image4, ImageUploader
    mount_uploader :image5, ImageUploader
    mount_uploader :image6, ImageUploader
    
end
