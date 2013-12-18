Safe::Application.routes.draw do
  devise_for :users do
    get 'account/settings', :to => 'devise/registrations#edit', :as => :edit_user_registration
    get 'account', :to => 'users#account', :as => :user_root
    get 'account/payment', :to => 'users#payment', :as => :user_payment
    post 'account/payment', :to => 'users#payment', :as => :user_update_payment
    get 'account/history', :to => 'users#history', :as => :user_history
    get 'invoice/:id', :to => 'users#invoice', :as => :show_invoice
    post 'unsubscribe', :to => 'users#unsubscribe', :as => :unsubscribe
    post 'account/update_shipping', :to => 'users#update_shipping', :as => :account_update_shipping
    post 'account/update_payment', :to => 'users#update_payment', :as => :update_payment

  end

  root :to => "home#index"

  get "select-pack" => "home#select_pack", :as => :select_pack
  get "add/:pack" => "home#add_pack", :as => :add_pack
  get "checkout" => "payments#checkout", :as => :checkout
  post "checkout" => "payments#checkout", :as => :customer_payment

  # Stripe Webhook
  post 'stripe-event' => 'events#stripe_event'
end
