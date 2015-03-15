Rails.application.routes.draw do
  namespace :v1 do
    resources :users do
      member do
        get 'friends'
      end
    end
    resources :transactions
  end
end
