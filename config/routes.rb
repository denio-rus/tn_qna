Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  resources :questions, except: :edit do 
    resources :answers, only: [:create, :destroy, :update], shallow: true do
      post 'best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
