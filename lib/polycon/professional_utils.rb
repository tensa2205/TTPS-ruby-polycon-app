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
            Dir.exist?(Dir.home + "/" + ".polycon" + "/" + self.convert_professional_name_to_folder_name(professional_name))
        end

        def self.create_professional_folder(professional_name)
            folder_name = self.convert_professional_name_to_folder_name(professional_name)
            Dir.mkdir(Dir.home + "/" + ".polycon" + "/" + folder_name) 
        end

        def self.path_professional_folder(professional_name)
            folder_name = self.convert_professional_name_to_folder_name(professional_name)
            Dir.home + "/" + ".polycon" + "/" + folder_name
        end

        def self.retrieve_professional_name(folder_name)
            #El formato suele ser -> Nombre_Apellido, la idea es quitar el _
            folder_name.gsub(/_/,' ')
        end

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
            raise StandardError, "Fecha de filtro inválida", caller unless filter_by_date =~ /\d\d\d\d-\d\d-\d\d/
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
    end
end

#str = "Alma Estevez 1111   2222"
#puts Polycon::ProfessionalUtils.beautify_professional_name(str)
#puts Polycon::ProfessionalUtils.retrieve_professional_name(Polycon::ProfessionalUtils.convert_professional_name_to_folder_name(str))
