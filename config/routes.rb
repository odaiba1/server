Rails.application.routes.draw do

  resources :classrooms, only: %i[new create]
  resources :work_groups, only: %i[new create]
  devise_for :users, controllers: { sessions: 'users/sessions' }

  devise_scope :user do
    root to: 'devise/sessions#new'
  end

  resources :user, only: [:show, :update]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/worksheets', to: 'worksheets#dashboard_index'
      resources :classrooms, defaults: { format: :json } do
        member do
          patch :initiate_all_work_groups
          patch :conclude_all_work_groups
        end
        resources :work_groups, shallow: true do
          member do
            patch :initiate
            patch :conclude
            patch :cancel
          end
          resources :worksheets, except: :destroy, shallow: true do
            resources :worksheet_reviews, only: %i[create update destroy]
          end
        end
      end

      resources :worksheet_templates
    end
  end
end
