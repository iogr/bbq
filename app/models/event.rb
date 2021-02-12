class Event < ApplicationRecord
  # Событие принадлежит юзеру
  belongs_to :user

  has_many :comments, dependent: :destroy
  # has_many :commentators, through: :comments, source: :user
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy
  has_many :photos, dependent: :destroy

  # Валидируем юзера на присутствие. В Rails 5 связи
  # валидируются по умолчанию
  validates :user, presence: true

  # Валидируем заголовок, он не может быть длиннее 255 букв
  validates :title, presence: true, length: {maximum: 255}
  validates :address, presence: true
  validates :datetime, presence: true

  def visitors
    (subscribers + [user]).uniq
  end
end
