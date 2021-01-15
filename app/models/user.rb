class User < ApplicationRecord
  MAXIMUM_NAME_LENGTH = 35

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events

  validates :name, presence: true, length: {maximum: MAXIMUM_NAME_LENGTH}

  before_validation :set_name, on: :create

  after_validation :set_default_name

  def set_default_name
    self.name = self.email[/.+(?=@.+)/] if self.name.length > MAXIMUM_NAME_LENGTH
  end

  private

  def set_name
    self.name = self.email[/.+(?=@.+)/] if self.name.blank?
  end
end
