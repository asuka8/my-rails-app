class ApplicationController < ActionController::Base
  # 1. 全ページでログインを必須にする
  before_action :authenticate_user!

  protected

  # 2. ログインした後の遷移先（自動でホームへ）
  def after_sign_in_path_for(resource)
    root_path
  end

  # 3. ログアウトした後の遷移先（ログイン画面へ）
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end