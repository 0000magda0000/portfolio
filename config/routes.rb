Rails.application.routes.draw do
  root to: "infos#index"
  resources :projects do
    resources :skills, only: [:create, :update, :destroy]
  end
  resources :languages, only: [:index, :show, :create, :update, :destroy]
  resources :contributers, only: [:index, :show, :create, :update, :destroy]
  resources :infos, only: [:show, :index, :create, :update, :destroy]
end
