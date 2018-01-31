Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true
  end

  get 'questions/index'

  root 'questions#index'
end
