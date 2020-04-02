class Review < ApplicationRecord
  belongs_to :user
  belongs_to :article
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: {maximum: 300 }
  validates :user_id, :uniqueness => {:scope => :article_id}
end
