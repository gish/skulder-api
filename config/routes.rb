Rails.application.routes.draw do
  namespace :api do
    resources :transactions
  end
  namespace :v1 do
    resources :users
  end
end
