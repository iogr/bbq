class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  validates :name, presence: true, length: {maximum: 35}

  before_validation :set_name, on: :create
  after_validation :sanitized_username, on: :update

  def valid_name
    # pry.binding
    # "123"
    name
  end

  def sanitized_username
    self.name = User.find(self.id).name if !valid?(:name)
  end
end
