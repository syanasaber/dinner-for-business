Rails.application.routes.draw do
    root to: 'toppages#index'
    
    get 'navigation', to: 'toppages#navigation'
    get 'selectpage', to: 'toppages#selectpage'
    post 'change', to: 'toppages#change'
    
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'signup', to: 'users#new'
    resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        member do
            get :followings
            get :followers
            get :writing
            get :myarea_list
        end
        
        member do
            get :likes
        end
        
        collection do
            get :search
            get :user_search
            
        end
    end
    
    resources :articles, only: [:show, :new, :create, :edit, :update, :destroy]  do
        member do
            get :reviewing
        end
    end
    
    resources :relationships, only: [:create, :destroy]
    
    resources :reviews, only: [:show, :new, :create, :edit, :update, :destroy]
    
    resources :likes, only: [:create, :destroy]
end
 
 
 
 
