Rails.application.routes.draw do
  get '/repos/:user_id/:id', to: 'repository#show', as: :repository
  resources :repository, path: 'repos', only: [:new, :create]
  root 'root#index'
end
