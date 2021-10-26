module Polycon
    module Models
        class AppointmentsDay
            attr_accessor :date , :appointments
            def initialize(dateFormatted, appointment_list)
                @date = dateFormatted #YYYY-MM-DD como string
                @appointments = appointment_list #Objetos appointment
            end

            def appointment_in_hour?(time_range)
                app = @appointments.select { |appointment| time_range.include?(appointment.hour)}.first()
                return app.to_table unless app.nil?
                return "---"
            end
        end
    end
end