module Polycon
    module Models
        class Appointment
            #Todos los campos de turno son modificables
            attr_accessor :date , :professional , :name , :surname , :phone , :notes
            def initialize(dateFormatted, professional, name, surname, phone, notes = nil)
                @date = dateFormatted
                @professional = professional
                @name = name
                @surname = surname
                @phone = phone
                @notes = notes.nil? ? "No se han especificado notas para el turno" : notes #Si notes es nil, asigna el string fijo, sino asigna el parámetro.
            end

            def date_as_string
                @date.strftime("%F %R")
            end

            def hour
                @date.strftime("%H:%M")
            end
            def to_s
                "Datos del turno:\n
                    Fecha : %s \n
                    Profesional : %s \n
                    Nombre : %s \n
                    Apellido : %s \n
                    Telefono : %s \n
                    Notas del turno : %s \n
                " % [date_as_string, @professional, @name, @surname, @phone, @notes]
            end

            def to_table
                "   Profesional : %s ----
                    Nombre del paciente: %s ----
                    Apellido del paciente: %s ----
                    Telefono del paciente: %s ----
                    Notas del turno : %s
                " % [@professional, @name, @surname, @phone, @notes]
            end
            def to_a
                [@surname , @name, @phone, @notes]
            end
        end
    end
end

#Testing purposes.
#a = Polycon::Models::Appointment.new("2021-09-16 13:00", "Alma Estevez","Carlos", "Carlosi" ,2213334567)
#puts a.to_s