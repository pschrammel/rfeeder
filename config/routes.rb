Rfeeder::Application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :stories, only: [:show, :index, :update]
    end
  end
  resources :docs, only: [:index], path: '/api/swagger'
  get '/auth/openidconnect/callback', to: 'callback#index'
end
