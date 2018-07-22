Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

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
