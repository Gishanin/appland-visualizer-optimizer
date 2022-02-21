Rails.application.routes.draw do
  root to: "appmap_jsons#index"

  resources :appmap_jsons, only: %i[new create update show destroy edit]
end
