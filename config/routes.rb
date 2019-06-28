Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', registrations: 'user/registrations' }
  devise_scope :user do
    patch 'users/:id/ask_email_for_oauth/', to: 'user/registrations#ask_email_for_oauth', as: 'user'
  end

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

  default_url_options host: 'localhost:3000'
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end
    end
  end
end
