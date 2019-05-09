Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :questions do 
    resources :answers, only: [:create, :destroy], shallow: true
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
