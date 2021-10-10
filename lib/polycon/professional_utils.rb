module Polycon
    module ProfessionalUtils

        def self.beautify_professional_name(name)
            name.gsub(/[^A-Za-z ]/, '').strip.capitalize.gsub(/(\s+\w)/) { |stuff| stuff.upcase }
        end


        def self.convert_professional_name_to_folder_name(name)
            #Como diria Tapia, no trates de entenderla.
            self.beautify_professional_name(name).gsub(/\s/,'_') #Hermoso, y a la vez, inentendible.
        end


        def self.professional_folder_exists?(professional_name)
            pro_name = convert_professional_name_to_folder_name(professional_name)
            return false unless !pro_name.empty?
            Dir.exist?(Dir.home + "/" + ".polycon" + "/" + pro_name)
        end


        def self.create_professional_folder(professional_name)
            raise StandardError, "Ya existe ese profesional", caller unless !professional_folder_exists?(professional_name)
            folder_name = self.convert_professional_name_to_folder_name(professional_name)
            entire_path = Dir.home + "/" + ".polycon" + "/" + folder_name
            Dir.mkdir(entire_path)
        end


        def self.path_professional_folder(professional_name)
            folder_name = self.convert_professional_name_to_folder_name(professional_name)
            Dir.home + "/" + ".polycon" + "/" + folder_name
        end


        def self.retrieve_professional_name(folder_name)
            #El formato suele ser -> Nombre_Apellido, la idea es quitar el _
            folder_name.gsub(/_/,' ')
        end


        def self.professional_has_appointments?(professional_name)
            path = path_professional_folder(professional_name)
            !Dir.empty?(path)
        end


        def self.fire_professional(professional_name)
            abort("Profesional inexistente") unless professional_folder_exists?(professional_name)
            abort("No se puede despedir un profesional con turnos pendientes") unless !professional_has_appointments?(professional_name)
            Polycon::Utils.delete_folder_using_path(path_professional_folder(professional_name))
        end


        def self.rename_professional(old_name, new_name)
            old_path = path_professional_folder(old_name)
            new_path = path_professional_folder(new_name)
            Polycon::Utils.rename_folder(old_path,new_path)
        end

        def self.convert_paths_to_professional_list(folders_array)
            foldername_startpos = folders_array[0].rindex("/") +1
            folders_array.map {|folder| folder.slice(foldername_startpos, (folder.length - 1)).gsub(/_/,' ') }
        end
        def self.list_all_professionals()
            folders = Polycon::Utils.get_all_folders_from_path(Dir.home << "/" << ".polycon")
            raise StandardError, "No hay profesionales contratados", caller unless !folders.empty?
            puts ".::Profesionales de la policlínica::."
            puts convert_paths_to_professional_list(folders)
        end
        ################################################################## Listar turnos de un profesional
        def self.print_header(pro_name, date = nil)
            initial_header = " " * 10 + "Turnos del profesional %s" % [pro_name] 
            full_header = date.nil? ? initial_header : initial_header + " en la fecha %s" % [date]

            puts full_header 
            puts ""
            puts " NOMBRE || APELLIDO || TELÉFONO || FECHA Y HORA  || NOTAS DEL TURNO "
        end

        def self.print_data(content, date)
            puts "%s || %s || %s  || %s || %s" % [content[1], content[0], content[2], date,content[3]]
        end

        def self.list_all_professional_appointments(professional_name, filter_by_date = nil)
            unless filter_by_date.nil?
                raise StandardError, "Fecha de filtro inválida", caller unless filter_by_date =~ /\d\d\d\d-\d\d-\d\d/
            end
            print_header(professional_name, filter_by_date)
            professional_folder = path_professional_folder(professional_name) + "/"
            filename_startpos = professional_folder.rindex("/") +1

            files = filter_by_date.nil? ? Dir.glob(professional_folder + "*.paf") : Dir.glob(professional_folder + filter_by_date  + "*.paf")
            files.each do |file|
                print_data(
                    IO.readlines(file, chomp: true), 
                    Polycon::Utils.convert_to_string_from_file_convention(file[filename_startpos .. -5])
                )
            end
        end
        ################################################################## Fin listar turnos de un profesional
    end
end