class AppointmentsUtils
    def self.date_range_to_hash(timewithzone, week = false)
        #Genera los dias necesarios -> puede ser 1 día o 7 días, esto depende del parámetro week.
        range = week ? (timewithzone.to_date..(timewithzone + 6.days).to_date) : (timewithzone.to_date..timewithzone.to_date)
        hash = Hash[ range.map{|date| date.to_s}.collect { |date_converted| [date_converted, [] ] } ]
        hash
    end
    def self.get_appointments_associated_with_days(day_range, appointments)
        appointments.each do |appo|
            appointment_date_string = appo.date.to_date.to_s
            if day_range.key?(appointment_date_string)
                day_range[appointment_date_string].append(appo)
            end
        end
    end

    ######################################################################
    def self.create_appointments_object_array(appointments_array)
        #Devuelve un arreglo con los objetos appointment
        appointments = []
        appointments_array.each do |appo|
            appointments.append(appo)
        end
        appointments
    end

    def self.create_appointments_day_array(day_list_hash)
        #Recibe hash con formato fecha:lista de paths a cada appointment
        #Retorna un arreglo de objetos AppointmentsDay
        appointments_day_array = []
        day_list_hash.each do |fecha, appointments|
            appo_day = AppointmentsDay.new(
                fecha, 
                create_appointments_object_array(appointments)
            )
            appointments_day_array.append(appo_day)
        end
        appointments_day_array
    end
    ######################################################################
end