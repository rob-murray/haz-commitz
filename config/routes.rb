Rails.application.routes.draw do
  resources :repository, path: 'repos', except: [:update, :edit, :destroy], :constraints => { :id => /.*/ }
  get 'root/index'

  root 'root#index'
end
