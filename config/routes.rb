Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/' => 'index#index'
  resources :index, only: [:index, :show, :edit, :update, :destory] do
    member do
      patch :update_profile_image
      post :update_profile_image
      get :articles
      get :rooms
    end
  end

  resources :article, only: [:index, :show, :edit, :update, :destory]
end
