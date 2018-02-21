Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'event#welcome'

  get '/whatever', to: 'event#whatever'
  get '/itinerary', to: 'event#itinerary'
end
