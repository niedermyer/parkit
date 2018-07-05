Rails.application.routes.draw do

  resources :vehicles, only: [:new, :create, :show]

  root to: 'spaces#index'

end
