class ApplicationController < ActionController::Base
  # Настройка для работы Девайза, когда юзер правит профиль
  # protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_user_can_edit?
  helper_method :selected_event, :selected_event_link

  def selected_event(event)
    se = Event.where(id: event).map(&:title)
  end

  def selected_event_link(event)
    sel = "/events/#{event}"
  end

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

  # Если у модели есть юзер и он залогиненный, пробуем у неё взять .event
  # Если он есть, проверяем его юзера на равенство current_user.
  def current_user_can_edit?(model)
    user_signed_in? &&
      (
      model.user == current_user ||
        (model.try(:event).present? && model.event.user == current_user)
      )
  end
end
