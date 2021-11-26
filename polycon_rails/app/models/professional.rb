class Professional < ApplicationRecord
    has_many :appointments, dependent: :restrict_with_error #Si se hace un borrado y el profesional tiene turnos no lo permite
    validates :full_name, presence: true, uniqueness: true
end
