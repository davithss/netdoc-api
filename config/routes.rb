Rails.application.routes.draw do
  get "health_check", to: "application#health_check"
    post '/board', to: 'boards#create'
    get '/board/:id', to: 'boards#show'
    get '/board/:id/next_state', to: 'boards#next_state'
    get '/board/:id/state', to: 'boards#state'
    get '/board/:id/final_state', to: 'boards#final_state'
end
