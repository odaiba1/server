Rails.application.routes.draw do

  resources :work_groups, only: %i[new create]
  devise_for :users, controllers: { sessions: 'users/sessions' }

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  resources :user, only: [:show, :update]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :classrooms, defaults: { format: :json } do
        resources :work_groups, shallow: true do
          resources :worksheets, except: :destroy, shallow: true
          resources :messages, only: :create
        end
      end

      resources :worksheet_templates
    end
  end
end
