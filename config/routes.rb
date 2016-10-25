Rails.application.routes.draw do
  get 'documents/index'

  get 'documents/new'

  get 'documents/create'

  get 'documents/destroy'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  resources :groups
  post 'groups/add_users/:id' => 'groups#add_users_to_group', :as => :add_users_to_group
  post 'groups/remove_user/:id' => 'groups#remove_user_from_group', :as => :remove_user_from_group
  post 'groups/remove_user_role/:id'=> 'groups#remove_user_role_from_group', :as => :remove_user_role_from_group

  constraints(Subdomain) do
    resources :clients
    resources :carriers
    resources :transport_orders
    resources :default_values
    resources :carrier_memberships
    resources :invoices do
      collection do
        put 'update_multiple'
        get 'zip_multiple'
      end
    end
    resources :items
    get 'invoices/invoice_name/:kind/:date' => 'invoices#last_invoice_number_for_date'
    get 'spedition/transport_orders/:year/:month/:speditor_id/' => 'transport_orders#speditor_view', :as => :speditor_view
    get 'accounting/transport_orders/' => 'transport_orders#accounting_view', :as => :accounting_view
    put 'accounting/transport_orders/:id/create_name' => 'transport_orders#create_name', :as => :transport_order_create_name
    get 'invoices/new_correction/:id/' => 'invoices#new_correction', :as => :new_correction_invoice
    get 'new_invoice_from_transport_orders/' => 'invoices#new_invoice_from_transport_orders', :as => :new_invoice_from_transport_orders
    root 'pages#group_home', as: :group_root
    get 'mail/loading_transport_order/:id' => 'gmail#loading_transport_order_email', :as => :loading_transport_order_email
    get 'mail/unloading_transport_order/:id' => 'gmail#unloading_transport_order_email', :as => :unloading_transport_order_email
    get 'mail/invoice_email/:id' => 'gmail#invoice_email', :as => :invoice_email
    get 'default_values/:id/edit_mail_templates' => 'default_values#edit_mail_templates', :as => :edit_default_values_mail_templates
    get 'default_values/:id/edit_invoices' => 'default_values#edit_invoices', :as => :edit_default_values_invoices
    get 'default_values/:id/edit_clients' => 'default_values#edit_clients', :as => :edit_default_values_clients
    get 'default_values/:id/edit_transport_orders' => 'default_values#edit_transport_orders', :as => :edit_default_values_transport_orders
    get 'default_values/:id/edit_group_info' => 'default_values#edit_group_info', :as => :edit_default_values_group_info
    get 'gdrivetest' => 'gdrive#test', :as => :gdrive
    resources :documents, only: [:index, :new, :create, :destroy]
  end

  root 'pages#root_home'

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
