module Polycon
    module Models
        class Appointment
            def initialize(dateFormatted, professional, name, surname, phone, notes = nil)
                @date = dateFormatted
                @professional = professional
                @name = name
                @surname = surname
                @phone = phone
                @notes = notes
            end

            def to_s
                "Hola, tengo los siguientes datos:\n
                    Fecha : %s \n
                    Profesional : %s \n
                    Nombre : %s \n
                    Apellido : %s \n
                    Telefono : %s \n
                " % [@date, @professional, @name, @surname, @phone]
            end
        end
    end
end

#Testing purposes.
a = Polycon::Models::Appointment.new("2021-09-16 13:00", "Alma Estevez","Carlos", "Carlosi" ,2213334567)
puts a.to_s