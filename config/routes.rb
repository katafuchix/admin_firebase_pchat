Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/' => 'index#index'
  resources :index, only: [:index, :show, :edit, :update, :destory]
  resources :article, only: [:index]
end
