Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do 
    member do
      patch :like
      patch :dislike
      patch :unvote
    end
  end
  
  resources :questions, except: :edit, concerns: [:votable] do 
    resources :answers, only: [:create, :destroy, :update], shallow: true, concerns: [:votable] do
      post 'best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
