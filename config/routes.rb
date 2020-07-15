Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: :sessions },
                       path_names: { sign_in: :login }
  end

  root to: 'pages#home'


  resources :user, only: [:show, :update]

  resources :classrooms, only: [:show] do
    resources :work_groups, only: [:index, :show, :new, :create] do
      resources :worksheets, only: [:edit, :update]
    end
  end

  resources :worksheets, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
