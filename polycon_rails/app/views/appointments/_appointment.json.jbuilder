json.extract! appointment, :id, :first_name, :last_name, :phone, :note, :date, :professional_id, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
