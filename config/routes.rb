Rails.application.routes.draw do
  use_doorkeeper
  root 'questions#index'

  devise_for :users, controllers: {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks'}

  devise_scope :user do
    get 'edit_email/:id', to: 'registrations#edit_email', as: 'edit_email'
    patch 'update_email/:id', to: 'registrations#update_email', as: 'update_email'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index create show], shallow: true do
        resources :answers, only: %i[index create show]
      end
    end
  end

  concern :votes do
    post :vote_for, on: :member
    post :vote_against, on: :member
    post :reset_vote, on: :member
  end

  concern :comments do
    resources :comments,  only: [:create]
  end

  resources :questions, shallow: true, concerns: [:votes, :comments] do
    resources :answers, only: %i[create update destroy], concerns: [:votes, :comments] do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy


  mount ActionCable.server => '/cable'
end
