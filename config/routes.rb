Safe::Application.routes.draw do
  devise_for :admins do
    get 'pending', :to => 'admins#pending_shipments', :as => :admin_root
    get 'shipped', :to => 'admins#shipped_subscription', :as => :admin_shipped
    get 'numbers', :to => 'admins#numbers', :as => :admin_numbers

    post 'mark-shipped/:id', :to => 'admins#mark_shipped', :as => :admin_mark
    post 'bulk-mark', :to => 'admins#bulk_mark', :as => :bulk_mark
    get 'labels', :to => 'admins#get_labels', :as => :get_labels
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" } do
    get 'account/settings', :to => 'users/registrations#edit', :as => :edit_user_registration
    get 'account', :to => 'users#account', :as => :user_root
    get 'account/referrals', :to => 'users#referrals', :as => :user_referrals
    get 'account/payment', :to => 'users#payment', :as => :user_payment
    post 'account/payment', :to => 'users#payment', :as => :user_update_payment
    get 'account/history', :to => 'users#history', :as => :user_history
    get 'invoice/:id', :to => 'users#invoice', :as => :show_invoice

    post 'unsubscribe', :to => 'users#unsubscribe', :as => :unsubscribe
    post 'account/update_shipping', :to => 'users#update_shipping', :as => :account_update_shipping
    post 'account/update_payment', :to => 'users#update_payment', :as => :update_payment
    post 'account/change_subscription', :to => 'users#change_subscription', :as => :change_subscription
    post 'account/change_interval', :to => 'users#change_interval', :as => :change_interval
  end

  root :to => "home#index"

  get "select-pack" => "home#select_pack", :as => :select_pack
  get "add/:pack" => "home#add_pack", :as => :add_pack
  get "checkout" => "payments#checkout", :as => :checkout
  post "checkout" => "payments#checkout", :as => :customer_payment

  # static
  get "legal" => "home#legal", :as => :legal
  get "faq" => "home#faq", :as => :faq

  # Stripe Webhook
  post 'stripe-event' => 'events#stripe_event'
end
