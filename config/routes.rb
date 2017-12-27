Rfeeder::Application.routes.draw do
#  devise_for :users
  namespace 'api' do

    namespace 'v1' do
      resources :stories, only: [:show, :index]
    end
  end
  resources :docs, only: [:index], path: '/api/swagger'
end
