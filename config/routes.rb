Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do 
    member do
      patch :like
      patch :dislike
      patch :unvote
    end
  end

  concern :commentable do 
    member { post :create_comment }
  end
  
  resources :questions, except: :edit, concerns: [:votable, :commentable] do 
    resources :answers, only: [:create, :destroy, :update], shallow: true, concerns: [:votable, :commentable] do
      post 'best', on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
