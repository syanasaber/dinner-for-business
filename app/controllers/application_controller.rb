class ApplicationController < ActionController::Base
    require 'open-uri'
    require 'json'
    
    include SessionsHelper
    
    private
    
    def require_user_logged_in
        unless logged_in?
            redirect_to selectpage_path
        end
    end
    
    def counts(user)
        @count_articles = user.articles.count
        @count_followings = user.followings.count
        @count_followers = user.followers.count
    end
    
end
