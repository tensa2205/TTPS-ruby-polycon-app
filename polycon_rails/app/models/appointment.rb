class Appointment < ApplicationRecord
  belongs_to :professional
  validates :first_name, :last_name, :phone, :date, presence: true
end
