Rails.application.routes.draw do
  # scope :api, defaults: { format: :json } do
  #   devise_for :users, controllers: { sessions: :sessions },
  #                      path_names: { sign_in: :login }
  # end

  devise_for :users

  root to: 'pages#home'

  resources :user, only: [:show, :update]

  resources :classrooms, defaults: { format: :json } do
    resources :work_groups, shallow: true do
      resources :worksheets, except: :destroy, shallow: true
    end
  end


  resources :images, only: [:new, :create, :destroy]
end
