class Comment < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  # Не может быть комментария без события
  # Пустой комментарий тоже недопустим
  validates :event, presence: true
  validates :body, presence: true

  # Это поле должно быть, только если не выполняется user.present? (у объекта на задан юзер)
  validates :user_name, presence: true, unless: -> { user.present? }

  scope :persisted, -> { where('id IS NOT NULL') }

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end
end
