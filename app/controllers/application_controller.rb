class ApplicationController < ActionController::Base
  # Настройка для работы Девайза, когда юзер правит профиль
  # protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:password, :password_confirmation, :current_password]
    )
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:name, :password, :password_confirmation, :email]
    )
  end

  def current_user_can_edit?(event)
    user_signed_in? && event.user == current_user
  end
end
