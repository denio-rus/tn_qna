Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :questions, except: :edit do 
    resources :answers, only: [:create, :destroy, :update], shallow: true do
      post 'best', on: :member
    end
    
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
