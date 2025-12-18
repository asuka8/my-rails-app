Rails.application.routes.draw do
  get "users/show"
  get "users/edit"
  get "users/update"
  devise_for :users
  root "home#index"
  resources :users, only: [:index, :show, :edit, :update]
  # 開発環境で送信したメールを確認するためのURL
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end