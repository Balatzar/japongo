Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # Add routes for Hiragana
  resources :hiraganas

  # Add routes for BuildingBlocks
  resources :building_blocks

  # Add routes for Words
  resources :words

  # Add routes for WordGameSession
  resources :word_game_sessions, only: [ :show, :update ] do
    collection do
      get :init
    end
  end

  # Add routes for CrosswordGameSession
  resources :crossword_game_sessions, only: [ :show ] do
    member do
      patch :toggle_easy_mode
      patch :update_game_state
    end
    collection do
      get :init
    end
  end

  # Add routes for Games
  resources :games, only: [ :index ]

  # Add route for Word of the Day
  get "word_of_the_day", to: "word_of_the_day#show", as: :word_of_the_day

  # Add routes for Cards
  resources :cards do
    collection do
      get :review
      post :answer
    end
  end

  root "games#index"
end
