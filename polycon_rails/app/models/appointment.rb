class Appointment < ApplicationRecord
  belongs_to :professional
  validates :first_name, :last_name, :phone, :date, presence: true
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
      errors.add(:date, "and hour/minutes already occupied") unless pro_appointment.nil?
    end
  end
end
