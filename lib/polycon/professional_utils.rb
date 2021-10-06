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
            Dir.exist?(Dir.home << "/" << ".polycon" << "/" << self.convert_professional_name_to_folder_name(professional_name))
        end

        def self.create_professional_folder(professional_name)
            folder_name = self.convert_professional_name_to_folder_name(professional_name)
            Dir.mkdir(Dir.home << "/" << ".polycon" << "/" << folder_name) 
        end

        def self.path_professional_folder(professional_name)
            folder_name = self.convert_professional_name_to_folder_name(professional_name)
            Dir.home << "/" << ".polycon" << "/" << folder_name
        end

        def self.retrieve_professional_name(folder_name)
            #El formato suele ser -> Nombre_Apellido, la idea es quitar el _
            folder_name.gsub(/_/,' ')
        end
    end
end

#str = "Alma Estevez 1111   2222"
#puts Polycon::ProfessionalUtils.beautify_professional_name(str)
#puts Polycon::ProfessionalUtils.retrieve_professional_name(Polycon::ProfessionalUtils.convert_professional_name_to_folder_name(str))
