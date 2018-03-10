Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, only: %i[create update destroy] do
      patch :make_best, on: :member
    end
  end

  resources :attachments

  get 'questions/index'

  root 'questions#index'
end
