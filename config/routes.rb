Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  resources :user, only: [:show, :update]

  resources :images, only: [:new, :create, :destroy]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :classrooms, defaults: { format: :json } do
        resources :work_groups, shallow: true do
          resources :worksheets, except: :destroy, shallow: true
        end
      end

      resources :worksheet_templates
    end
  end
end
