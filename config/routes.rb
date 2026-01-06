Rails.application.routes.draw do
  # 1. ログアウトを完全に独立したURLにする（最優先）
  devise_scope :user do
    get '/exit', to: 'devise/sessions#destroy', as: :logout
  end

  devise_for :users
  
  root "home#index"
  # ルーム一覧用のルート
  get 'rooms_index', to: 'rooms_index#index'
  get 'search', to: 'searches#index'
  get 'search/autocomplete', to: 'searches#autocomplete'
  
  # 2. 投稿関連
  resources :posts do
    collection do
      get 'search'
    end
    member do
      get :liked_users
    end
    resource :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy] # これを追記
  end

  resources :users do
    member do
      get :following
      get :followers
    end
  end

  resources :rooms, only: [:index, :show, :create] do
    # メッセージ作成のためのネスト
    resources :messages, only: [:create]
  end

  # 通知一覧用のルート
  resources :notifications, only: :index
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show]

  # 3. ユーザー関連（詳細画面などは一番最後に書く）
  resources :users, only: [:index, :show, :edit, :update] do
    # users の中に relationships を入れることで user_relationships_path が使えるようになります
    resource :relationships, only: [:create, :destroy]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end