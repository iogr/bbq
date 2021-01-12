class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  validates :name, presence: true, length: {maximum: 35}

  before_validation :set_name, on: :create
  after_validation :sanitized_username, on: :update

  private

  def set_name
    self.name = "Твой юзер №#{rand(10000)}" if self.name.blank?
  end

  def sanitized_username
    self.name = User.find(self.id).name if !valid?(:name)
  end
end
