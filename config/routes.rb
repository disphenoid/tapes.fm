Tapesfm::Application.routes.draw do
  get "register/index"

  get "register/create"

  get "home/index"

  get "track_comments/show"

  #get "users", :to => "users#index"
  mount Resque::Server, :at => "/resque"

  #devise_for :users
  devise_for :users, :skip => [:sessions]
  
  as :user do
  get 'login' => 'devise/sessions#new', :as => :new_user_session
  post 'login' => 'devise/sessions#create', :as => :user_session
  delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  get 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  scope "admin" do
    get 'users', to: "webapp#admin_users"
  end

  scope "api" do
    resources :tapedeck
    resources :tapes
    resources :tracks
    resources :track_comments
    resources :tape_comments
    resources :versions
    resources :collaborators
    resources :comments
    resources :invites
    resources :follows
    resources :settings
    resources :requests
    resources :register
    resources :users
    resources :feedbacks
    resources :tags, :defaults => {:format => :json}
  end
  match 'signup', to: "webapp#signup"

  match 'dashboard', to: "webapp#dashboard"
  match 'tapes', to: "webapp#tapes"
  match 'explore', to: "webapp#explore"
  match 'user/:id', to: "webapp#user"
  match 'tapedeck/:id', to: "webapp#tapedeck"
  match 'tapedeck', to: "webapp#tapedeck"
  match 'tapedeck/*path', to: "webapp#tapedeck"
  match 'download/:id', to: "webapp#download"
  match 'settings', to: "webapp#settings"

  post 'api/update_cover/:id', to: "tapedeck#update_cover"
  post 'api/update_picture', to: "settings#update_picture"
  get   'api/user_name_unique/:name', to: "users#user_name_unique"
  
  match 'login', to: "webapp#login"

  #match 'upload', to: "webapp#upload"
  post "upload" => "webapp#upload", :defaults => {:format => :json}
  post "upload_track" => "webapp#upload_track", :defaults => {:format => :json}


  root to: "home#index"
  
  get "/:name", to: "webapp#user"



  #match '*path', to: "webapp#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
