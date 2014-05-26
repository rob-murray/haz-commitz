Rails.application.routes.draw do
  get '/repos/:user_id/:id', to: 'repository#show', as: :repository
  resources :repository, path: 'repos', except: [:show, :update, :edit, :destroy]
  get 'root/index'

  root 'root#index'
end
