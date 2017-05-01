Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"
  resources :articles, :path => "trivia"
  get 'board/', to: 'leaderboard#index', as: :board
  get 'category/:tag', to: 'articles#show', as: :tag
  post 'category/:tag', to: 'articles#answer', as: :answer
  #forcibly render 200 for missing link
  get '/assets/twitter/bootstrap/bootstrap', to: proc { [200, {}, ['']] }
end
