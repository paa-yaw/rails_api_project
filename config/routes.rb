require "api_constraints"

Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json },
                            constraints: { subdomain: "api" }, path: "/" do

    scope module: :v1,
                  constraints: ApiConstraints.new(version: 1, default: true) do 
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
    end

   #  scope module: :v2, 
   #  				constraints: ApiConstraints.new(version: 2) do
   #    resources :users, only: [:show, :create, :update, :destroy]					
  	# end
    # scope module: :v3,
    #          constraints: ApiConstraints.new(version: 3) do 
    #            resources :users, only: [:show, :create, :update, :destroy]
    #          end
  end
end
