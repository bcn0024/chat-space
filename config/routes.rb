Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'groups#index'
  resources :users, only: [:edit, :update, :index]
  resources :groups, only: [:new, :create, :edit, :update] do
    resources :messages, only: [:index, :create]
    namespace :api do
      resources :messages, only: :index, defaults: { format: 'json' }
    end
    # namespace :ディレクトリ名 do ~ endと囲む形でルーティングを記述すると、そのディレクトリ内のコントローラのアクションを指定できます、しないといけない。
    # rails routesコマンドなどでルーティングを確認すると、
    # /groups/:id/api/messagesというパスでリクエストを受け付け、api/messages_controller.rbのindexアクションが動くようになっている
    # defaultsオプションを利用して、このルーティングが来たらjson形式でレスポンスするよう指定
  end
end