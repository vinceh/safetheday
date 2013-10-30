Safe::Application.routes.draw do
  devise_for :users

  root :to => "home#index"

  get "select-pack" => "home#select_pack", :as => :select_pack
  get "add/:pack" => "home#add_pack", :as => :add_pack
  get "checkout" => "payments#checkout", :as => :checkout
  post "checkout" => "payments#checkout", :as => :customer_payment
end
