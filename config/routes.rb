Rails.application.routes.draw do
  namespace :api do
    get 'users', to: 'users#index'
    get 'users/:id', to: 'users#show'
    post 'users', to: 'users#create'
    delete 'users', to: 'users#destroy'
    put 'users', to: 'users#update'
  end
end
