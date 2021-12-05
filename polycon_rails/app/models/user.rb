class User < ApplicationRecord
  belongs_to :role
  validates :name, presence: {message: "no puede estar en blanco"}, uniqueness: {message: "ya está en uso por otra persona"}
  validates :password, presence: {message: "debe ser ingresada"}
  has_secure_password
end
