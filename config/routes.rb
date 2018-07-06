Rails.application.routes.draw do

  resources :spaces, only: [:index] do
    get 'parking_assignments/new', to: 'parking_assignments#new'
  end

  resources :vehicles, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  resources :parking_assignments, only: [:create, :show] do
    post 'archive', to: 'parking_assignments#archive'
  end

  root to: 'dashboard#show'

end
