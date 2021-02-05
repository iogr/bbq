class User < ApplicationRecord
  MAXIMUM_NAME_LENGTH = 35

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events
  has_many :comments, dependent: :destroy
  has_many :subscriptions

  validates :name, presence: true, length: { maximum: MAXIMUM_NAME_LENGTH }

  after_commit :link_subscriptions, on: :create

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email).update_all(user_id: self.id)
  end
end
