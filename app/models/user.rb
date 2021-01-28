class User < ApplicationRecord
  MAXIMUM_NAME_LENGTH = 35

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  validates :name, presence: true, length: { maximum: MAXIMUM_NAME_LENGTH }
end
