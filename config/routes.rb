Rails.application.routes.draw do
  root 'pages#home'
  resources :clients
  resources :carriers
  resources :transport_orders
  resources :invoices do
    collection do
      put 'update_multiple'
      get 'zip_multiple'
    end
  end
  resources :items
  get 'invoices/invoice_name/:kind/:date' => 'invoices#last_invoice_number_for_date'
  get 'spedition/transport_orders/:speditor_id/:date' => 'transport_orders#speditor_view', :as => :speditor_view
  get 'accounting/transport_orders/' => 'transport_orders#accounting_view', :as => :accounting_view
  put 'accounting/transport_orders/:id/create_name' => 'transport_orders#create_name', :as => :transport_order_create_name
  get 'invoices/new_correction/:id/' => 'invoices#new_correction', :as => :new_correction_invoice

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
