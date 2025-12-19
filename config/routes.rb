Rails.application.routes.draw do
  # 1. ログアウトを完全に独立したURLにする（最優先）
  devise_scope :user do
    get '/exit', to: 'devise/sessions#destroy', as: :logout
  end

  devise_for :users
  
  root "home#index"
  
  # 2. 投稿関連
  resources :posts do
    member do
      get :destroy
    end
  end

  # 3. ユーザー関連（詳細画面などは一番最後に書く）
  resources :users, only: [:index, :show, :edit, :update] do
    # users の中に relationships を入れることで user_relationships_path が使えるようになります
    resource :relationships, only: [:create, :destroy]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end