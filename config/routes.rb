Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  # Handle nested folder paths
  get '/*path', to: 'dashboard#index', as: :folder_path, constraints: ->(request) { 
    path = request.path.split('/').reject(&:empty?)
    path.all? { |segment| Folder.exists?(name: CGI.unescape(segment)) }
  }

  resources :folders, only: [:new, :create, :edit, :update, :destroy] do
    member do
      post :move
    end
  end

  resources :file_entries, only: [:new, :create, :edit, :update, :destroy] do
    member do
      post :move
    end
  end

  get 'dashboard/*path', to: 'dashboard#index', as: :dashboard
  post 'dashboard/update_view_preference', to: 'dashboard#update_view_preference'
end
