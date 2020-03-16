Rails.application.routes.draw do
    root to: 'toppages#index'
    
    get 'navigation', to: 'toppages#navigation'
    
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'signup', to: 'users#new'
    resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
        member do
            get :followings
            get :followers
        end
    end
    
    resources :articles, only: [:show, :new, :create, :destroy]
    resources :relationships, only: [:create, :destroy]
end
 
 
 
 
