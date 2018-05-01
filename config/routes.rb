Rails.application.routes.draw do

  root to: "home#home"

  #specifically
  get "specifically/new", to: "specifically#new"

  post "specifically/create", to: "specifically#create"

  get "specifically/solution", to: "specifically#solution"
end
