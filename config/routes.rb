Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/' => 'index#index'
  resources :index, only: [:index, :show, :edit, :update, :destory] do
    member do
      patch :update_profile_image
      post :update_profile_image
      get :articles
      get :rooms
      get :chat
      post :post_message
    end
    get '/change_sakura/:id', on: :collection, action: :change_sakura
  end

  resources :sakura, only: [:index] do
  end

  resources :article, only: [:index, :new, :create, :show, :edit, :update, :destory]
  resources :room, only: [:index, :show]
end
