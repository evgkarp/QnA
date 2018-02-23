Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, only: %i[create update destroy]
  end

  get 'questions/index'

  root 'questions#index'
end
