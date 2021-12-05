class AppointmentsDay
    attr_accessor :date , :appointments
    def initialize(dateFormatted, appointment_list)
        @date = dateFormatted #YYYY-MM-DD como string
        @appointments = appointment_list #Objetos appointment
    end

    def appointments_in_hour?(time_range)
        @appointments.select { |appointment| time_range.include?(appointment.date.strftime('%H:%M'))}
    end

    def get_appointments_in_hour(time_range)
        appointments = appointments_in_hour?(time_range)
        string_res = ""
        appointments.each { |appointment| string_res << appointment.to_table }
        return string_res unless string_res.empty?
        return "---"
    end
end