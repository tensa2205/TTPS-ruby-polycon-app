class User < ApplicationRecord
  belongs_to :role
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true
  has_secure_password
end
