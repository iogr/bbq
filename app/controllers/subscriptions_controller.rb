class SubscriptionsController < ApplicationController
  before_action :set_event, only: [:create, :destroy]
  before_action :set_subscription, only: [:destroy]

  helper_method :current_user_can_edit?

  def create
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    message =
      if @new_subscription.save
        EventMailer.subscription(@event, @new_subscription).deliver_now
        # Если сохранилась, редиректим на страницу самого события c этим message
        { notice: I18n.t('controllers.subscriptions.created') }
      else
        { alert: @new_subscription.errors.full_messages }
      end

    redirect_to @event, message
  end

  # DELETE /subscription/1
  def destroy
    message = { notice: I18n.t('controllers.subscriptions.destroyed') }
    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = { alert: I18n.t('controllers.subscriptions.error') }
    end

    redirect_to @event, message
  end

  # Если у модели есть юзер и он залогиненный, пробуем у неё взять .event
  # Если он есть, проверяем его юзера на равенство current_user.
  def current_user_can_edit?(model)
    user_signed_in? && (
    model.user == current_user ||
      (model.try(:event).present? && model.event.user == current_user)
    )
  end

  private

  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  # params.fetch без ключа :subscription
  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end
end
