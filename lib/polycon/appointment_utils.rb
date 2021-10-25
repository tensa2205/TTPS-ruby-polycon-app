module Polycon
    module AppointmentUtils
        require 'fileutils'

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
            puts temp_object
            #Imprime doble si saco el comentario de arriba
        end
        
        def self.cancel_appointment(folder, file_name)
            path_to_file = assemble_path_file(folder, file_name)
            File.delete(path_to_file) if File.exist?(path_to_file)
        end

        def self.cancel_all_appointments_from_professional_with_folder(folder)
            FileUtils.rm Dir.glob(folder << "/" <<"*.paf")
        end

        def self.edit_appointment(folder, file_name, date_obj, professional_beautified_name, parameters)
            file_path = assemble_path_file(folder, file_name)
            file_content = IO.readlines(file_path) #0 -> apellido, 1 -> nombre, 2 -> Teléfono, 3 -> Notas
            file_content[0] = parameters[:surname] unless !parameters.has_key?(:surname)
            file_content[1] = parameters[:name] unless !parameters.has_key?(:name)
            file_content[2] = parameters[:phone] unless !parameters.has_key?(:phone)
            file_content[3] = parameters[:notes] unless !parameters.has_key?(:notes)
            edited_appointment = Polycon::Models::Appointment.new(date_obj, professional_beautified_name, file_content[1], file_content[0], file_content[2], file_content[3])
            cancel_appointment(folder, file_name)
            create_appointment_file(folder, file_name, edited_appointment)
        end

        def self.reschedule(folder, old_filename, new_filename)
            path_old = assemble_path_file(folder, old_filename)
            path_new = assemble_path_file(folder, new_filename)
            File.rename(path_old, path_new)
        end

        ######################################################## Entrega 2 a partir de acá

        #Obtención de turnos por cada fecha (o una sola):
        #1.Recorrer cada carpeta de profesional -> en cada carpeta buscar los archivos que matcheen la fecha.
        #2.Recorrer carpeta de profesional X y obtener archivos que matcheen la fecha.
        #Podría tener un arreglo de fechas que puede ser -> 1 fecha o 7. Es decir, que funcione sin condicionales.
        #Algo que me tome los turnos que satisfagan que su fecha esté dentro del arreglo.

        def self.remove_paf(file, startpos)
            file[startpos .. -5]
        end

        def self.appointment_hour(file_name)
            #Recibe YYYY-MM-DD Horas:Minutos -> Devuelve horas:minutos
            file_name.split[1]
        end

        def self.appointment_date(file_name)
            #Recibe YYYY-MM-DD Horas:Minutos -> Devuelve YYYY-MM-DD
            file_name.split[0]
        end
        def self.appointment_filename(file)
            #Sin .paf
            filename_startpos = file.rindex("/") +1
            Polycon::Utils.convert_to_string_from_file_convention(remove_paf(file, filename_startpos))
        end

        def self.get_appointments_by_date_range_from_professional(professional_name, day_list_hash)
            folder_full_path = Polycon::ProfessionalUtils.path_professional_folder(professional_name)
            files = Dir.glob(folder_full_path + "/" +"*.paf")
            save_appointments_on_date_range(files, day_list_hash )
            day_list_hash
        end

        def self.get_appointments_by_date_range(day_list_hash)
            professional_folders = Polycon::Utils.get_all_folders_from_path(Dir.home + "/" + ".polycon")
            #puts professional_folders
            professional_folders.each do |folder|
                files = Dir.glob(folder + "/" +"*.paf")
                save_appointments_on_date_range(files, day_list_hash )
            end

            day_list_hash
        end

        def self.save_appointments_on_date_range(files, day_list_hash)
            files.each do |file|
                #puts IO.readlines(file, chomp: true)
                #puts appointment_hour(appointment_filename(file))
                #puts appointment_date(appointment_filename(file))
                string_date = appointment_date(appointment_filename(file))
                if day_list_hash.key?(string_date)
                    day_list_hash[string_date].append(file)
                end
            end
        end

        def self.create_appointments_object_array(appointments_array)
            #Recibe un arreglo que contiene los paths a archivos .paf
            #Devuelve un arreglo con los objetos appointment
            appointments = []
            appointments_array.each do |file|
                #Obtener nombre del profesional usando el path.
                prof_name = Polycon::ProfessionalUtils.retrieve_professional_name(file.split("/")[-2])
                #Obtener la fecha usando el filename
                date_obj = Polycon::Utils.format_string_to_date(appointment_filename(file))
                #Lo demás, IO readlines para los contenidos restantes para rellenar el obj
                content = IO.readlines(file)
                appointment_object = Polycon::Models::Appointment.new(date_obj, prof_name, content[1], content[0], content[2], content[3])
                appointments.append(appointment_object)
            end
            appointments
        end

        def self.create_appointments_day_array(day_list_hash)
            #Recibe hash con formato fecha:lista de paths a cada appointment
            #Retorna un arreglo de objetos AppointmentsDay
            appointments_day_array = []
            day_list_hash.each do |fecha, appointments|
                appo_day = Polycon::Models::AppointmentsDay.new(
                    fecha, 
                    create_appointments_object_array(appointments)
                )
                appointments_day_array.append(appo_day)
            end
            appointments_day_array
        end
    end
end