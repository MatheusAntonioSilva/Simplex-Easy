Rails.application.routes.draw do

  root to: "home#home"

  #specifically
  get "specifically/new", to: "specifically#new"

  post "specifically/create", to: "specifically#create"

  get "specifically/create", to: "specifically#redirect_path"


  get "specifically/solution", to: "specifically#solution"

  get "specifically/impracticable_error", to: "specifically#test"
end
