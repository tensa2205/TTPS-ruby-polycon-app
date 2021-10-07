module Polycon
    module AppointmentUtils
        require 'fileutils'
        #Me quedé con el create.
        def self.create_appointment_file(folder, file_name, appointment_object)
            new_file = File.new(folder << "/" <<file_name << ".paf", "w")
            iterable_object = appointment_object.to_a
            iterable_object.each { |value| new_file.puts(value) }
            new_file.close
        end

        #Para comprobar existencia de un turno.
        def self.appointment_file_exists?(folder, file_name)
            File.exist?(folder << "/" <<file_name << ".paf")
        end

        def self.assemble_path_file(folder, file_name)
            folder + "/" + file_name + ".paf"
        end

        def self.show_appointment_data(folder, file_name, professional_beautified_name, date_object)
            #initialize -> dateFormatted, professional, name, surname, phone, notes = nil
            #File -> @surname , @name, @phone, @notes
            path = assemble_path_file(folder, file_name)
            content = IO.readlines(path)
            temp_object = Polycon::Models::Appointment.new(date_object, professional_beautified_name, content[1], content[0], content[2], content[3])
            #puts temp_object
            #Imprime doble si saco el comentario de arriba
        end
        def self.cancel_appointment(folder, file_name)
            path_to_file = assemble_path_file(folder, file_name)
            File.delete(path_to_file) if File.exist?(path_to_file)
        end

        def self.cancel_all_appointments_from_professional_with_folder(folder)
            FileUtils.rm Dir.glob(folder << "/" <<"*.paf")
        end

        def self.edit_appointment(folder, file_name, parameters)
            file_path = assemble_path_file(folder, file_name)
            File.open(file_path, "r") do |f|
                f.each_line do |line|
                    puts line
                end
            end
        end

        def self.reschedule(folder, old_filename, new_filename)
            path_old = assemble_path_file(folder, old_filename)
            path_new = assemble_path_file(folder, new_filename)
            File.rename(path_old, path_new)
        end

    end
end