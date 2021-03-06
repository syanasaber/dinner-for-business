class User < ApplicationRecord
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :articles
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
    
    
    has_many :likes
    has_many :favorites, through: :likes, source: :article
    
    has_many :reviews
    
    def follow(other_user)
        unless self == other_user
            self.relationships.find_or_create_by(follow_id: other_user.id)
        end
    end
    
    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end
    
    def following?(other_user)
      self.followings.include?(other_user)
    end
    
    def feed_articles
        Article.where(user_id: self.following_ids)
    end
    
    
    #以下、お気に入り関連
    def favorite(other_article)
          self.likes.find_or_create_by(article_id: other_article.id)
    end
    
    def unfavorite(other_article)
        like = self.likes.find_by(article_id: other_article.id)
        like.destroy if like
    end
    #if like  存在する（true）なら削除実行、nillなら何もしない
    
    def favoriting?(article)
        self.favorites.include?(article)
    end
    
     #検索機能
    def self.search(search)
        if search
          User.where(['name LIKE?', "%#{search}%"])
        else
          User.none
        end
    end
    
end
