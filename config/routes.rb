Rails.application.routes.draw do
  # scope :api, defaults: { format: :json } do
  #   devise_for :users, controllers: { sessions: :sessions },
  #                      path_names: { sign_in: :login }
  # end

  devise_for :users

  root to: 'pages#home'

  resources :user, only: [:show, :update]

  resources :classrooms, only: [:show] do
    resources :work_groups, only: [:index, :show, :new, :create]
  end

  resources :worksheets, only: [:show, :edit, :update]

  resources :images, only: [:new, :create, :destroy]
end
