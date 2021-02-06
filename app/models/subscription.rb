class Subscription < ApplicationRecord
  belongs_to :event
  belongs_to :user

  # Обязательно должно быть событие
  validates :event, presence: true

  # Проверки user_name и user_email выполняются,
  # только если user не задан
  # То есть для анонимных пользователей
  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/, unless: -> { user.present? }

  # Для конкретного event_id один юзер может подписаться только один раз (если юзер задан)
  # Или один email может использоваться только один раз (если анонимная подписка)
  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }
  validates :user_email, uniqueness: { scope: :event_id }, unless: -> { user.present? }
  validate :search_user_by_email, unless: -> { user.present? }
  validate :self_subscription, if: -> { user.present? }

  scope :persisted, -> { where('id IS NOT NULL') }

  # Если есть юзер, выдаем его email,
  # если нет – дергаем исходный метод
  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  def self_subscription
    errors.add(:base, :self_subscription) if event.user == user
  end

  def search_user_by_email
    if User.find_by(email: user_email).present?
        errors.add(:base, :email_used, email: user_email)
    end
  end
end
