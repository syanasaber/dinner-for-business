Rails.application.routes.draw do
    root to: 'toppages#index'
    
    get 'navigation', to: 'toppages#navigation'
    get 'selectpage', to: 'toppages#selectpage'
    post 'change', to: 'users#change'
    
    post 'create_station', to: 'users#create_station'
    get 'search_by_station', to: 'users#search_by_station'
    get 'search_by_station_of_show', to: 'users#search_by_station_of_show'
    get 'search_by_station_of_myarea', to: 'users#search_by_station_of_myarea'
    get 'search_by_station_of_writing', to: 'users#search_by_station_of_writing'
    get 'search_by_station_of_followers', to: 'users#search_by_station_of_followers'
    get 'search_by_station_of_followings', to: 'users#search_by_station_of_followings'
    get 'search_by_station_of_likes', to: 'users#search_by_station_of_likes'
    
    get  'sort', to: 'users#sort'
    post 'sort', to: 'users#sort'
    
    get 'sort_of_myarea', to: 'users#sort_of_myarea'
    post 'sort_of_myarea', to: 'users#sort_of_myarea'
    
    get 'sort_of_likes', to: 'users#sort_of_likes'
    post 'sort_of_likes', to: 'users#sort_of_likes'
    
    
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'signup', to: 'users#new'
    resources :users, only: [:show, :new, :create, :edit, :update, :destroy] do
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
            get :prev_search
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
 
 
 
 
