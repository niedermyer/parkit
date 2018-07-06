Rails.application.routes.draw do

  resources :spaces, only: [:index] do
    get 'parking_assignments/new', to: 'parking_assignments#new'
  end

  resources :vehicles, only: [:new, :create, :show]
  resources :parking_assignments, only: [:create]

  root to: 'dashboard#show'

end
