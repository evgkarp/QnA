Rails.application.routes.draw do
  root 'questions#index'
  get 'questions/index'

  devise_for :users
  resources :questions do
    resources :answers, only: %i[create update destroy] do
      patch :make_best, on: :member
    end
  end

  resources :attachments, only: :destroy
end
