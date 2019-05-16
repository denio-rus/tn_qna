Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :questions, except: :edit do 
    delete 'attachment/:attachment_id', on: :member, to: 'questions#delete_attachment'

    resources :answers, only: [:create, :destroy, :update], shallow: true do
      post 'best', on: :member
      delete 'attachment/:attachment_id', on: :member, to: 'answers#delete_attachment'
    end
  end
end
