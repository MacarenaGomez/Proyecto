Rails.application.routes.draw do
  #devise_for :users

  root to: 'site#home'

  get '/f5App/api/tweets/:topic' => 'tweets#index'
  get '/f5App/api/tweets/:topic/:screen_name' => 'tweets#index'
  
  #get '/users/:id', to: 'users#show'

end
