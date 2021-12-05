class Appointment < ApplicationRecord
  belongs_to :professional
  validates :first_name, :last_name, :phone, :date, presence: {message: "no puede estar en blanco"}
  validates :phone, format: { with: /\A\d+\z/, message: "solo numeros. No se permiten signos." }
  validate :correct_minutes, :check_availability

  def correct_minutes
    if date.present?
      minute = date.min
      errors.add(:date, "minutes should be 0 or 30") unless [0, 30].include? minute 
    end
  end

  def check_availability
    if date.present?
      pro_appointment = Appointment.where("professional_id = ?", professional_id).where("date BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where("date = ?", date).first
      if !pro_appointment.nil?
        errors.add(:date, "and hour/minutes already occupied") unless id == pro_appointment.id
      end
    end
  end

  def to_table
    "   Profesional : %s  <br>
        Nombre del paciente: %s  <br>
        Apellido del paciente: %s  <br>
        Telefono del paciente: %s  <br>
        Notas del turno : %s <br>
        ------------------------- <br>
    " % [professional.full_name, first_name, last_name, phone, note]
  end
end
